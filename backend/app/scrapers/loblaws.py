"""
Loblaws / No Frills / Real Canadian Superstore scraper.

Uses the unofficial PC Express REST API (api.pcexpress.ca) which is the
same API backing the PC Optimum app and pcexpress.ca website. Headers
mimic a standard browser session — no auth required for public catalog.
"""
import math
from typing import Optional
from curl_cffi.requests import AsyncSession as _Session

from app.scrapers.base import BaseScraper, StoreData, ProductData, PriceData

_BASE = "https://api.pcexpress.ca/product-facade/v3"
_STORE_API = "https://api.pcexpress.ca/pcx-bff/api/v2/storelocator/location"

_BANNER_MAP = {
    "loblaw": "Loblaws",
    "nofrills": "No Frills",
    "rcss": "Real Canadian Superstore",
    "zehrs": "Zehrs",
    "independent": "Independent",
    "valumart": "Valu-mart",
    "dominion": "Dominion",
    "fortinos": "Fortinos",
}

_HEADERS = {
    "Accept": "application/json",
    "x-apikey": "1im1hL52q9xvta16GlSdYDsTsG0dmyhF",  # public key from pcexpress.ca JS bundle
    "x-application-type": "Web",
    "x-channel-id": "PC_EXPRESS",
    "Site-Banner": "superstore",
    "Content-Type": "application/json",
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Origin": "https://www.pcexpress.ca",
    "Referer": "https://www.pcexpress.ca/",
}


class LoblawsScraper(BaseScraper):
    chain = "loblaws"

    async def get_stores(self) -> list[StoreData]:
        stores: list[StoreData] = []
        # Fetch stores by iterating over provinces
        provinces = ["ON", "BC", "AB", "QC", "MB", "SK", "NS", "NB", "NL", "PE"]
        async with _Session(impersonate="chrome120", headers=_HEADERS, timeout=30) as client:
            for province in provinces:
                try:
                    resp = await client.post(
                        _STORE_API,
                        json={"pickupType": "STORE", "lang": "en", "banner": "superstore", "province": province},
                    )
                    resp.raise_for_status()
                    data = resp.json()
                    for s in data.get("storeList", data.get("results", [])):
                        banner_key = s.get("banner", "").lower().replace(" ", "").replace("-", "")
                        stores.append(StoreData(
                            store_id=str(s.get("storeId", s.get("id", ""))),
                            chain=self.chain,
                            banner=_BANNER_MAP.get(banner_key, s.get("banner")),
                            name=s.get("name", ""),
                            address=s.get("address", {}).get("line1"),
                            city=s.get("address", {}).get("city"),
                            province=province,
                            postal_code=s.get("address", {}).get("postalCode"),
                            lat=s.get("geoPoint", {}).get("latitude"),
                            lng=s.get("geoPoint", {}).get("longitude"),
                        ))
                except Exception:
                    continue
        return stores

    async def get_product_by_upc(self, upc: str) -> Optional[ProductData]:
        async with _Session(impersonate="chrome120", headers=_HEADERS, timeout=20) as client:
            try:
                resp = await client.post(
                    f"{_BASE}/products/search",
                    json={"term": upc, "storeId": "1012", "banner": "superstore",
                          "lang": "en", "cartId": "", "pagination": {"from": 0, "size": 1},
                          "pickupType": "STORE", "userData": {}},
                )
                resp.raise_for_status()
                items = resp.json().get("results", [])
                if not items:
                    return None
                item = items[0]
                return ProductData(
                    upc=upc,
                    name=item.get("name", ""),
                    brand=item.get("brand"),
                    category=item.get("topCategory"),
                    image_url=item.get("imageAssets", [{}])[0].get("largeUrl"),
                )
            except Exception:
                return None

    async def get_prices_by_store(self, store_id: str, upcs: list[str]) -> list[PriceData]:
        if not upcs:
            return []
        prices: list[PriceData] = []
        # PC Express returns prices in chunks of 50
        chunk_size = 50
        async with _Session(impersonate="chrome120", headers=_HEADERS, timeout=30) as client:
            for i in range(0, len(upcs), chunk_size):
                chunk = upcs[i : i + chunk_size]
                try:
                    resp = await client.post(
                        f"{_BASE}/products/prices",
                        json={
                            "storeId": store_id,
                            "skus": chunk,
                            "lang": "en",
                        },
                    )
                    resp.raise_for_status()
                    for item in resp.json().get("results", []):
                        raw_price = item.get("prices", {})
                        regular = raw_price.get("wasPrice") or raw_price.get("price")
                        sale = raw_price.get("price") if raw_price.get("wasPrice") else None
                        if regular is None:
                            continue
                        prices.append(PriceData(
                            upc=item.get("sku", ""),
                            store_id=store_id,
                            price_cents=_dollars_to_cents(regular),
                            unit=item.get("unit"),
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
