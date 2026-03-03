"""
Walmart Canada scraper.

Uses Walmart Canada's internal GraphQL API at grocery.walmart.ca.
Store lookup uses the store-finder REST endpoint.
"""
from typing import Optional
from curl_cffi.requests import AsyncSession as _Session

from app.scrapers.base import BaseScraper, StoreData, ProductData, PriceData

_GQL_URL = "https://grocery.walmart.ca/api/graphql"
_STORE_URL = "https://www.walmart.ca/api/product-page/v2/store-finder"

_HEADERS = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
    "Origin": "https://www.walmart.ca",
    "Referer": "https://www.walmart.ca/",
}

_PRODUCT_QUERY = """
query GetProduct($upc: String!, $storeId: String!) {
  product(upc: $upc, storeId: $storeId) {
    upc
    name
    brand
    category
    imageUrl
    pricing {
      currentPrice
      wasPrice
      unit
    }
  }
}
"""

_SEARCH_QUERY = """
query SearchProducts($query: String!, $storeId: String!, $first: Int) {
  searchV2(query: $query, storeId: $storeId, first: $first) {
    edges {
      node {
        upc
        name
        brand
        category
        imageUrl
        pricing {
          currentPrice
          wasPrice
          unit
        }
      }
    }
  }
}
"""


class WalmartScraper(BaseScraper):
    chain = "walmart"

    async def get_stores(self) -> list[StoreData]:
        stores: list[StoreData] = []
        # Walmart Canada has ~400 stores; paginate by lat/lng grid over Canada
        # Simplified: use major city coordinates to seed store discovery
        seed_coords = [
            (43.65, -79.38),   # Toronto
            (45.50, -73.57),   # Montreal
            (49.28, -123.12),  # Vancouver
            (51.05, -114.07),  # Calgary
            (53.55, -113.49),  # Edmonton
            (49.90, -97.14),   # Winnipeg
            (44.65, -63.58),   # Halifax
            (46.81, -71.21),   # Quebec City
            (43.26, -79.87),   # Hamilton
            (45.42, -75.70),   # Ottawa
        ]
        seen_ids: set[str] = set()
        async with _Session(impersonate="chrome120", headers=_HEADERS, timeout=30) as client:
            for lat, lng in seed_coords:
                try:
                    resp = await client.get(
                        _STORE_URL,
                        params={"lat": lat, "lng": lng, "distance": 100},
                    )
                    resp.raise_for_status()
                    for s in resp.json().get("stores", []):
                        sid = str(s.get("id", ""))
                        if sid in seen_ids:
                            continue
                        seen_ids.add(sid)
                        addr = s.get("address", {})
                        geo = s.get("geoPoint", {})
                        stores.append(StoreData(
                            store_id=sid,
                            chain=self.chain,
                            banner="Walmart",
                            name=s.get("displayName", "Walmart"),
                            address=addr.get("line1"),
                            city=addr.get("city"),
                            province=addr.get("region"),
                            postal_code=addr.get("postalCode"),
                            lat=geo.get("latitude"),
                            lng=geo.get("longitude"),
                        ))
                except Exception:
                    continue
        return stores

    async def get_product_by_upc(self, upc: str) -> Optional[ProductData]:
        # Use a default Toronto store for product lookup metadata
        default_store = "3124"
        async with _Session(impersonate="chrome120", headers=_HEADERS, timeout=20) as client:
            try:
                resp = await client.post(
                    _GQL_URL,
                    json={"query": _PRODUCT_QUERY, "variables": {"upc": upc, "storeId": default_store}},
                )
                resp.raise_for_status()
                product = resp.json().get("data", {}).get("product")
                if not product:
                    return None
                return ProductData(
                    upc=upc,
                    name=product.get("name", ""),
                    brand=product.get("brand"),
                    category=product.get("category"),
                    image_url=product.get("imageUrl"),
                )
            except Exception:
                return None

    async def get_prices_by_store(self, store_id: str, upcs: list[str]) -> list[PriceData]:
        prices: list[PriceData] = []
        async with _Session(impersonate="chrome120", headers=_HEADERS, timeout=30) as client:
            for upc in upcs:
                try:
                    resp = await client.post(
                        _GQL_URL,
                        json={"query": _PRODUCT_QUERY, "variables": {"upc": upc, "storeId": store_id}},
                    )
                    resp.raise_for_status()
                    product = resp.json().get("data", {}).get("product")
                    if not product:
                        continue
                    pricing = product.get("pricing", {})
                    current = pricing.get("currentPrice")
                    was = pricing.get("wasPrice")
                    if current is None:
                        continue
                    prices.append(PriceData(
                        upc=upc,
                        store_id=store_id,
                        price_cents=_dollars_to_cents(was or current),
                        unit=pricing.get("unit"),
                        on_sale=was is not None,
                        sale_price_cents=_dollars_to_cents(current) if was else None,
                    ))
                except Exception:
                    continue
        return prices


def _dollars_to_cents(value) -> int:
    try:
        return round(float(value) * 100)
    except (TypeError, ValueError):
        return 0
