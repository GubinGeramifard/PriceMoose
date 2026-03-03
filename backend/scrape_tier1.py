"""
Tier 1 scraper — populates the database with real Canadian grocery prices
sourced from Flipp (flyer aggregator) and product metadata from Open Food Facts.

Covers: Loblaws, No Frills, Real Canadian Superstore, Walmart,
        Sobeys, FreshCo, Metro, Food Basics

Run from the backend directory:
    .venv/Scripts/python scrape_tier1.py [--postal M5V1A1]

It is safe to re-run: existing products/prices are updated, not duplicated.
"""
import asyncio
import argparse
import uuid
from datetime import datetime, timezone

from curl_cffi.requests import AsyncSession
from app.scrapers.flipp import TIER1_SEARCH_TERMS, GROCERY_MERCHANTS, search_flipp, upc_from_name

# ── Open Food Facts helpers ───────────────────────────────────────────────────

_OFF_SEARCH = "https://world.openfoodfacts.org/cgi/search.pl"

async def lookup_upc_off(session: AsyncSession, name: str) -> str | None:
    """Try to find a real UPC from Open Food Facts by product name."""
    try:
        resp = await session.get(
            _OFF_SEARCH,
            params={
                "search_terms": name,
                "search_simple": 1,
                "action": "process",
                "json": 1,
                "page_size": 1,
                "countries_tags": "canada",
                "fields": "code,product_name,brands,categories_tags,image_url",
            },
            timeout=10,
        )
        if resp.status_code != 200:
            return None
        products = resp.json().get("products", [])
        if not products:
            return None
        code = products[0].get("code", "")
        # Only use codes that look like real UPCs (8-14 digits)
        if code and code.isdigit() and 8 <= len(code) <= 14:
            return code.zfill(13)  # normalise to 13 digits (EAN-13)
    except Exception:
        pass
    return None


async def get_off_metadata(session: AsyncSession, name: str) -> dict:
    """Return enriched product metadata from Open Food Facts."""
    try:
        resp = await session.get(
            _OFF_SEARCH,
            params={
                "search_terms": name,
                "search_simple": 1,
                "action": "process",
                "json": 1,
                "page_size": 1,
                "countries_tags": "canada",
                "fields": "code,product_name,brands,categories_tags,image_url",
            },
            timeout=10,
        )
        if resp.status_code != 200:
            return {}
        products = resp.json().get("products", [])
        if not products:
            return {}
        p = products[0]
        cats = p.get("categories_tags", [])
        category = None
        for c in cats:
            if c.startswith("en:"):
                category = c[3:].replace("-", " ").title()
                break
        return {
            "off_name": p.get("product_name"),
            "brand": (p.get("brands") or "").split(",")[0].strip() or None,
            "category": category,
            "image_url": p.get("image_url"),
        }
    except Exception:
        return {}


# ── Virtual stores (one per Flipp merchant, located in Toronto) ───────────────
# Flipp prices are chain-wide (same flyer across all stores in the area).
# We create one "virtual" store per banner to represent the chain's current price.

VIRTUAL_STORES = [
    # (store_id,    chain,     banner,                      name,                              lat,     lng)
    ("flp-lob",  "loblaws", "Loblaws",                   "Loblaws (Flyer Price)",           43.6618, -79.3797),
    ("flp-nf",   "loblaws", "No Frills",                 "No Frills (Flyer Price)",          43.6762, -79.3553),
    ("flp-rcss", "loblaws", "Real Canadian Superstore",  "Real Canadian Superstore (Flyer)", 43.7067, -79.5683),
    ("flp-wmt",  "walmart", "Walmart",                   "Walmart (Flyer Price)",            43.7762, -79.2571),
    ("flp-sob",  "sobeys",  "Sobeys",                    "Sobeys (Flyer Price)",             43.7069, -79.3985),
    ("flp-fc",   "sobeys",  "FreshCo",                   "FreshCo (Flyer Price)",            43.7241, -79.5118),
    ("flp-met",  "metro",   "Metro",                     "Metro (Flyer Price)",              43.6508, -79.4836),
    ("flp-fb",   "metro",   "Food Basics",               "Food Basics (Flyer Price)",        43.7762, -79.4000),
    ("flp-for",  "loblaws", "Fortinos",                  "Fortinos (Flyer Price)",           43.2500, -79.8700),
    ("flp-yig",  "loblaws", "Your Independent Grocer",   "YIG (Flyer Price)",                43.8000, -79.3000),
]

# Maps Flipp merchant_id → virtual store_id
MERCHANT_TO_STORE = {
    2018: "flp-lob",
    234:  "flp-wmt",
    2332: "flp-nf",
    2271: "flp-rcss",
    2072: "flp-sob",
    2267: "flp-fc",
    2269: "flp-met",
    2265: "flp-fb",
    2341: "flp-for",
    2337: "flp-yig",
}


# ── Main ──────────────────────────────────────────────────────────────────────

async def main(postal_code: str):
    from app.database import engine, Base, AsyncSessionLocal
    import app.models  # register ORM models

    print("Creating tables if needed...")
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    from app.models import Product, Store, Price
    from sqlalchemy import select

    async with AsyncSessionLocal() as db:

        # ── 1. Upsert virtual stores ──────────────────────────────────────────
        print("\nUpserting virtual stores...")
        store_id_map: dict[str, str] = {}  # flipp store_id → db UUID
        for sid, chain, banner, name, lat, lng in VIRTUAL_STORES:
            result = await db.execute(select(Store).where(Store.store_id == sid))
            existing = result.scalar_one_or_none()
            if existing:
                store_id_map[sid] = existing.id
            else:
                obj = Store(
                    id=str(uuid.uuid4()), store_id=sid, chain=chain, banner=banner,
                    name=name, city="Toronto", province="ON",
                    lat=lat, lng=lng,
                )
                db.add(obj)
                await db.flush()
                store_id_map[sid] = obj.id
        await db.commit()
        print(f"  {len(store_id_map)} virtual stores ready.")

        # ── 2. Scrape Flipp for each search term ──────────────────────────────
        print(f"\nScraping Flipp for {len(TIER1_SEARCH_TERMS)} search terms...")
        print(f"  Postal code: {postal_code}")

        all_items: dict[str, dict] = {}  # upc → best item dict

        for i, term in enumerate(TIER1_SEARCH_TERMS, 1):
            print(f"  [{i}/{len(TIER1_SEARCH_TERMS)}] Searching: {term}...", end=" ")
            items = await search_flipp(term, postal_code=postal_code)
            new = 0
            for item in items:
                upc = item["upc"]
                if upc not in all_items:
                    all_items[upc] = item
                    new += 1
                # If we already have this UPC from a different merchant, keep both
                # by using upc+merchant as key
                key = f"{upc}_{item['merchant_id']}"
                all_items[key] = item
            print(f"{len(items)} items ({new} new products)")
            await asyncio.sleep(0.3)  # polite rate limiting

        # Collapse back to unique products + per-merchant prices
        products_map: dict[str, dict] = {}  # upc → item (for product metadata)
        prices_list: list[dict] = []        # all price records

        for key, item in all_items.items():
            upc = item["upc"]
            if upc not in products_map:
                products_map[upc] = item
            prices_list.append(item)

        print(f"\n  Total unique products from Flipp: {len(products_map)}")
        print(f"  Total price records: {len(prices_list)}")

        # ── 3. Enrich product metadata from Open Food Facts (concurrent) ─────
        print("\nEnriching product metadata from Open Food Facts...")
        sem = asyncio.Semaphore(15)  # max 15 concurrent requests

        async def enrich_one(off_session, upc, item):
            async with sem:
                meta = await get_off_metadata(off_session, item["name"])
                if meta:
                    if meta.get("brand"):
                        item["brand"] = meta["brand"]
                    if meta.get("category"):
                        item["category"] = meta["category"]
                    if meta.get("image_url") and not item.get("image_url"):
                        item["image_url"] = meta["image_url"]
                    real_code = await lookup_upc_off(off_session, item["name"])
                    if real_code:
                        item["real_upc"] = real_code
                await asyncio.sleep(0.05)

        async with AsyncSession(impersonate="chrome120") as off_session:
            tasks = [enrich_one(off_session, upc, item) for upc, item in products_map.items()]
            await asyncio.gather(*tasks)

        enriched = sum(1 for item in products_map.values() if item.get("brand") or item.get("category"))
        print(f"  Enriched {enriched} products from Open Food Facts.")

        # ── 4. Upsert products ────────────────────────────────────────────────
        print("\nUpserting products into database...")
        product_id_map: dict[str, str] = {}  # upc → db UUID

        for upc, item in products_map.items():
            # Prefer real UPC from OFF if available
            canonical_upc = item.get("real_upc", upc)

            result = await db.execute(select(Product).where(Product.upc == canonical_upc))
            existing = result.scalar_one_or_none()

            if existing:
                # Update image if we now have one
                if item.get("image_url") and not existing.image_url:
                    existing.image_url = item["image_url"]
                if item.get("category") and not existing.category:
                    existing.category = item.get("category")
                product_id_map[upc] = existing.id
            else:
                obj = Product(
                    id=str(uuid.uuid4()),
                    upc=canonical_upc,
                    name=item["name"],
                    brand=item.get("brand"),
                    category=item.get("category"),
                    image_url=item.get("image_url"),
                )
                db.add(obj)
                await db.flush()
                product_id_map[upc] = obj.id

        await db.commit()
        print(f"  {len(product_id_map)} products upserted.")

        # ── 5. Upsert prices ──────────────────────────────────────────────────
        print("\nUpserting prices...")
        inserted = 0
        updated = 0

        for item in prices_list:
            upc = item["upc"]
            product_db_id = product_id_map.get(upc)
            if not product_db_id:
                continue

            flipp_store_id = MERCHANT_TO_STORE.get(item["merchant_id"])
            if not flipp_store_id:
                continue
            store_db_id = store_id_map.get(flipp_store_id)
            if not store_db_id:
                continue

            result = await db.execute(
                select(Price).where(
                    Price.product_id == product_db_id,
                    Price.store_id == store_db_id,
                )
            )
            existing_price = result.scalar_one_or_none()

            if existing_price:
                existing_price.price_cents = item["price_cents"]
                existing_price.on_sale = item["on_sale"]
                existing_price.sale_price_cents = item["sale_price_cents"]
                existing_price.scraped_at = datetime.now(timezone.utc)
                updated += 1
            else:
                db.add(Price(
                    id=str(uuid.uuid4()),
                    product_id=product_db_id,
                    store_id=store_db_id,
                    price_cents=item["price_cents"],
                    unit="each",
                    on_sale=item["on_sale"],
                    sale_price_cents=item["sale_price_cents"],
                    scraped_at=datetime.now(timezone.utc),
                ))
                inserted += 1

        await db.commit()
        print(f"  {inserted} prices inserted, {updated} updated.")

    print("\nDone! Tier 1 scrape complete.")
    print(f"  Products in DB: {len(product_id_map)}")
    print(f"  Prices in DB: {inserted + updated}")
    print("\nTest it:")
    print("  curl 'http://localhost:8000/products/search?q=apple'")
    print("  curl 'http://localhost:8000/products/search?q=chicken'")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--postal", default="M5V1A1", help="Canadian postal code for Flipp geo-filtering")
    args = parser.parse_args()
    asyncio.run(main(args.postal))
