"""
Metro / Food Basics scraper.

Metro Inc. operates Metro and Food Basics banners in Ontario and Quebec.
Uses Metro's JSON product catalog and store finder API.
"""
import httpx
from typing import Optional

from app.scrapers.base import BaseScraper, StoreData, ProductData, PriceData

_BASE = "https://www.metro.ca"
_STORE_API = f"{_BASE}/api/en/storelocator/getStores"
_PRODUCT_API = f"{_BASE}/api/en/products"

_BANNER_MAP = {
    "metro": "Metro",
    "foodbasics": "Food Basics",
    "metroplus": "Metro Plus",
}

_HEADERS = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
    "Referer": "https://www.metro.ca/",
}


class MetroScraper(BaseScraper):
    chain = "metro"

    async def get_stores(self) -> list[StoreData]:
        stores: list[StoreData] = []
        # Metro operates primarily in Ontario and Quebec
        seed_coords = [
            (43.65, -79.38),   # Toronto
            (45.50, -73.57),   # Montreal
            (45.42, -75.70),   # Ottawa
            (46.81, -71.21),   # Quebec City
            (43.26, -79.87),   # Hamilton
            (43.46, -80.52),   # Waterloo
            (42.98, -81.25),   # London ON
            (46.34, -72.55),   # Trois-Rivières
            (45.40, -71.90),   # Sherbrooke
        ]
        seen_ids: set[str] = set()
        async with httpx.AsyncClient(headers=_HEADERS, timeout=30) as client:
            for lat, lng in seed_coords:
                try:
                    resp = await client.post(
                        _STORE_API,
                        json={"lat": lat, "lng": lng, "radius": 80},
                    )
                    resp.raise_for_status()
                    for s in resp.json().get("stores", []):
                        sid = str(s.get("id", s.get("storeId", "")))
                        if sid in seen_ids:
                            continue
                        seen_ids.add(sid)
                        banner_raw = s.get("banner", "metro").lower().replace(" ", "")
                        stores.append(StoreData(
                            store_id=sid,
                            chain=self.chain,
                            banner=_BANNER_MAP.get(banner_raw, "Metro"),
                            name=s.get("name", ""),
                            address=s.get("address"),
                            city=s.get("city"),
                            province=s.get("province"),
                            postal_code=s.get("postalCode"),
                            lat=s.get("lat", s.get("latitude")),
                            lng=s.get("lng", s.get("longitude")),
                        ))
                except Exception:
                    continue
        return stores

    async def get_product_by_upc(self, upc: str) -> Optional[ProductData]:
        async with httpx.AsyncClient(headers=_HEADERS, timeout=20) as client:
            try:
                resp = await client.get(
                    f"{_PRODUCT_API}/search",
                    params={"filter": upc, "lang": "en"},
                )
                resp.raise_for_status()
                items = resp.json().get("results", [])
                # Find exact UPC match
                for item in items:
                    if item.get("upc") == upc or item.get("code") == upc:
                        return ProductData(
                            upc=upc,
                            name=item.get("name", ""),
                            brand=item.get("brand"),
                            category=item.get("category"),
                            image_url=item.get("imageUrl"),
                        )
                return None
            except Exception:
                return None

    async def get_prices_by_store(self, store_id: str, upcs: list[str]) -> list[PriceData]:
        prices: list[PriceData] = []
        async with httpx.AsyncClient(headers=_HEADERS, timeout=30) as client:
            try:
                resp = await client.post(
                    f"{_PRODUCT_API}/prices",
                    json={"storeId": store_id, "upcs": upcs},
                )
                resp.raise_for_status()
                for item in resp.json().get("prices", []):
                    regular = item.get("regularPrice")
                    sale = item.get("salePrice")
                    if regular is None and sale is None:
                        continue
                    prices.append(PriceData(
                        upc=item.get("upc", ""),
                        store_id=store_id,
                        price_cents=_dollars_to_cents(regular or sale),
                        unit=item.get("unit"),
                        on_sale=sale is not None,
                        sale_price_cents=_dollars_to_cents(sale) if sale else None,
                    ))
            except Exception:
                pass
        return prices


def _dollars_to_cents(value) -> int:
    try:
        return round(float(value) * 100)
    except (TypeError, ValueError):
        return 0
