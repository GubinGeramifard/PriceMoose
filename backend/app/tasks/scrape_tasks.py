"""
Scraping pipeline — works with both SQLite (local dev) and PostgreSQL (production).
Celery task wrapper is only used when a broker is available; call _scrape_chain()
directly for local seeding.
"""
import asyncio
import logging
import uuid
from datetime import datetime, timezone
from sqlalchemy import select

from app.database import AsyncSessionLocal, _is_sqlite
from app.models import Product, Store, Price
from app.scrapers import ALL_SCRAPERS

logger = logging.getLogger(__name__)

_SCRAPER_MAP = {s().chain: s for s in ALL_SCRAPERS}


def _get_upsert(model):
    """Return the dialect-appropriate insert function."""
    if _is_sqlite:
        from sqlalchemy.dialects.sqlite import insert
    else:
        from sqlalchemy.dialects.postgresql import insert
    return insert(model)


# Celery task — only imported when broker is available
try:
    from app.tasks.celery_app import celery

    @celery.task(name="app.tasks.scrape_tasks.run_scraper", bind=True, max_retries=3)
    def run_scraper(self, chain: str):
        try:
            asyncio.run(_scrape_chain(chain))
        except Exception as exc:
            logger.error(f"Scraper '{chain}' failed: {exc}")
            raise self.retry(exc=exc, countdown=300)

except Exception:
    pass  # Celery/Redis not available in local dev — that's fine


async def _scrape_chain(chain: str):
    scraper_cls = _SCRAPER_MAP.get(chain)
    if not scraper_cls:
        raise ValueError(f"Unknown chain: {chain}")
    scraper = scraper_cls()

    # Step 1: sync stores
    logger.info(f"[{chain}] Fetching stores...")
    stores = await scraper.get_stores()
    async with AsyncSessionLocal() as db:
        for s in stores:
            await _upsert_store(db, s)
        await db.commit()
    logger.info(f"[{chain}] Upserted {len(stores)} stores.")

    # Step 2: fetch prices for known products at each store
    async with AsyncSessionLocal() as db:
        result = await db.execute(select(Store).where(Store.chain == chain))
        db_stores = result.scalars().all()

    for db_store in db_stores:
        async with AsyncSessionLocal() as db:
            result = await db.execute(select(Product.upc))
            upcs = [row[0] for row in result.all()]

        if not upcs:
            logger.info(f"[{chain}] No products yet for store {db_store.store_id}. Skipping pricing.")
            continue

        prices = await scraper.get_prices_by_store(db_store.store_id, upcs)
        async with AsyncSessionLocal() as db:
            for p in prices:
                await _upsert_price(db, p, db_store.id)
            await db.commit()
        logger.info(f"[{chain}] Upserted {len(prices)} prices for store {db_store.name}.")


async def _upsert_store(db, s):
    insert_fn = _get_upsert(Store)
    stmt = insert_fn.values(
        id=str(uuid.uuid4()),
        store_id=s.store_id,
        chain=s.chain,
        banner=s.banner,
        name=s.name,
        address=s.address,
        city=s.city,
        province=s.province,
        postal_code=s.postal_code,
        lat=s.lat,
        lng=s.lng,
    ).on_conflict_do_update(
        index_elements=["store_id"],
        set_={
            "name": s.name,
            "address": s.address,
            "city": s.city,
            "lat": s.lat,
            "lng": s.lng,
        },
    )
    await db.execute(stmt)


async def _upsert_price(db, p, store_db_id: str):
    result = await db.execute(select(Product.id).where(Product.upc == p.upc))
    product_row = result.one_or_none()
    if not product_row:
        return
    product_db_id = product_row[0]

    insert_fn = _get_upsert(Price)
    now = datetime.now(timezone.utc).isoformat()
    stmt = insert_fn.values(
        id=str(uuid.uuid4()),
        product_id=product_db_id,
        store_id=store_db_id,
        price_cents=p.price_cents,
        unit=p.unit,
        on_sale=p.on_sale,
        sale_price_cents=p.sale_price_cents,
        scraped_at=now,
    ).on_conflict_do_update(
        index_elements=["product_id", "store_id"],
        set_={
            "price_cents": p.price_cents,
            "unit": p.unit,
            "on_sale": p.on_sale,
            "sale_price_cents": p.sale_price_cents,
            "scraped_at": now,
        },
    )
    await db.execute(stmt)
