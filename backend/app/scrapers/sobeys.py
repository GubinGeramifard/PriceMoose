"""
Sobeys / FreshCo / Safeway Canada scraper.

Sobeys operates multiple banners under Empire Company Ltd.
Uses the Sobeys/IGA/Safeway website's REST catalog API.
Store selection is cookie-based; we pass store ID as a header.
"""
import httpx
from typing import Optional

from app.scrapers.base import BaseScraper, StoreData, ProductData, PriceData

_BASE = "https://www.sobeys.com"
_STORE_API = f"{_BASE}/api/v1/store-finder/stores"
_PRODUCT_API = f"{_BASE}/api/v1/product"
_SEARCH_API = f"{_BASE}/api/v1/product/search"

_BANNER_MAP = {
    "sobeys": "Sobeys",
    "safeway": "Safeway",
    "freshco": "FreshCo",
    "iga": "IGA",
    "thriftys": "Thrifty Foods",
    "foodland": "Foodland",
    "sobeysliquor": "Sobeys Liquor",
}

_HEADERS = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
}


class SobeysScraper(BaseScraper):
    chain = "sobeys"

    async def get_stores(self) -> list[StoreData]:
        stores: list[StoreData] = []
        seed_coords = [
            (43.65, -79.38, "ON"),
            (45.50, -73.57, "QC"),
            (49.28, -123.12, "BC"),
            (51.05, -114.07, "AB"),
            (53.55, -113.49, "AB"),
            (49.90, -97.14, "MB"),
            (44.65, -63.58, "NS"),
            (46.10, -64.79, "NB"),
            (47.56, -52.71, "NL"),
        ]
        seen_ids: set[str] = set()
        async with httpx.AsyncClient(headers=_HEADERS, timeout=30) as client:
            for lat, lng, province in seed_coords:
                try:
                    resp = await client.get(
                        _STORE_API,
                        params={"lat": lat, "lng": lng, "radius": 100, "limit": 50},
                    )
                    resp.raise_for_status()
                    for s in resp.json().get("stores", []):
                        sid = str(s.get("storeId", s.get("id", "")))
                        if sid in seen_ids:
                            continue
                        seen_ids.add(sid)
                        banner_raw = s.get("banner", "sobeys").lower().replace(" ", "")
                        stores.append(StoreData(
                            store_id=sid,
                            chain=self.chain,
                            banner=_BANNER_MAP.get(banner_raw, s.get("banner")),
                            name=s.get("name", ""),
                            address=s.get("address"),
                            city=s.get("city"),
                            province=s.get("province", province),
                            postal_code=s.get("postalCode"),
                            lat=s.get("latitude"),
                            lng=s.get("longitude"),
                        ))
                except Exception:
                    continue
        return stores

    async def get_product_by_upc(self, upc: str) -> Optional[ProductData]:
        async with httpx.AsyncClient(headers=_HEADERS, timeout=20) as client:
            try:
                resp = await client.get(
                    f"{_PRODUCT_API}/{upc}",
                    params={"lang": "en"},
                )
                resp.raise_for_status()
                item = resp.json()
                if not item:
                    return None
                return ProductData(
                    upc=upc,
                    name=item.get("name", ""),
                    brand=item.get("brand"),
                    category=item.get("category"),
                    image_url=item.get("imageUrl"),
                )
            except Exception:
                return None

    async def get_prices_by_store(self, store_id: str, upcs: list[str]) -> list[PriceData]:
        prices: list[PriceData] = []
        store_headers = {**_HEADERS, "x-store-id": store_id}
        async with httpx.AsyncClient(headers=store_headers, timeout=30) as client:
            chunk_size = 30
            for i in range(0, len(upcs), chunk_size):
                chunk = upcs[i : i + chunk_size]
                try:
                    resp = await client.post(
                        f"{_PRODUCT_API}/prices",
                        json={"upcs": chunk, "storeId": store_id},
                    )
                    resp.raise_for_status()
                    for item in resp.json().get("items", []):
                        regular = item.get("regularPrice")
                        sale = item.get("salePrice")
                        if regular is None and sale is None:
                            continue
                        prices.append(PriceData(
                            upc=item.get("upc", ""),
                            store_id=store_id,
                            price_cents=_dollars_to_cents(regular or sale),
                            unit=item.get("unitPriceDescription"),
                            on_sale=sale is not None,
                            sale_price_cents=_dollars_to_cents(sale) if sale else None,
                        ))
                except Exception:
                    continue
        return prices


def _dollars_to_cents(value) -> int:
    try:
        return round(float(value) * 100)
    except (TypeError, ValueError):
        return 0
