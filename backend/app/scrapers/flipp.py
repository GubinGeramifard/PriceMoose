"""
Flipp scraper — Canadian flyer aggregator.

Flipp aggregates weekly flyer/sale prices from all major Canadian grocery chains.
It does NOT require API keys or authentication.

Merchant IDs for major Canadian grocery chains:
  Loblaws:                2018
  Walmart:                234
  No Frills:              2332
  Real Canadian Superstore: 2271
  Sobeys:                 2072
  FreshCo:                2267
  Metro:                  2269
  Food Basics:            2265
  Fortinos:               2341
  Your Independent Grocer: 2337
"""
import hashlib
from curl_cffi.requests import AsyncSession

_SEARCH_URL = "https://backflipp.wishabi.com/flipp/items/search"
_FLYERS_URL = "https://backflipp.wishabi.com/flipp/flyers"

# Maps Flipp merchant_id → (our chain name, banner name)
GROCERY_MERCHANTS = {
    2018: ("loblaws", "Loblaws"),
    234:  ("walmart", "Walmart"),
    2332: ("loblaws", "No Frills"),
    2271: ("loblaws", "Real Canadian Superstore"),
    2072: ("sobeys",  "Sobeys"),
    2267: ("sobeys",  "FreshCo"),
    2269: ("metro",   "Metro"),
    2265: ("metro",   "Food Basics"),
    2341: ("loblaws", "Fortinos"),
    2337: ("loblaws", "Your Independent Grocer"),
}

# Common grocery search terms to cover Tier 1 catalog
TIER1_SEARCH_TERMS = [
    # Dairy
    "milk", "butter", "cheese", "yogurt", "cream", "eggs",
    # Bread & Bakery
    "bread", "bagel", "muffin", "tortilla", "bun",
    # Meat
    "chicken breast", "ground beef", "pork", "bacon", "salmon", "shrimp",
    # Produce
    "apple", "banana", "orange", "strawberry", "grapes", "blueberry",
    "potato", "onion", "carrot", "broccoli", "tomato", "cucumber", "lettuce",
    # Frozen
    "frozen pizza", "frozen vegetables", "ice cream",
    # Pantry
    "pasta", "rice", "flour", "sugar", "oats", "cereal",
    "canned tomatoes", "canned beans", "soup", "peanut butter", "jam",
    # Beverages
    "juice", "coffee", "tea", "sparkling water", "pop",
    # Snacks
    "chips", "crackers", "cookies", "granola bar", "chocolate",
    # Condiments
    "ketchup", "mustard", "mayo", "olive oil", "salad dressing", "hot sauce",
    # Household
    "paper towel", "toilet paper", "dish soap", "laundry detergent",
    "shampoo", "body wash",
]


def upc_from_name(name: str) -> str:
    """Generate a deterministic 12-digit UPC-A from a product name hash."""
    digest = hashlib.md5(name.lower().strip().encode()).hexdigest()
    # Use first 11 hex digits → 11 decimal digits, prefix with 8 (private-use range)
    numeric = str(int(digest[:11], 16))[:11].zfill(11)
    # Calculate UPC-A check digit
    odd  = sum(int(numeric[i]) for i in range(0, 11, 2))
    even = sum(int(numeric[i]) for i in range(1, 11, 2))
    check = (10 - ((odd * 3 + even) % 10)) % 10
    return "8" + numeric + str(check)


async def search_flipp(
    query: str,
    postal_code: str = "M5V1A1",
) -> list[dict]:
    """
    Search Flipp for a query term and return items from grocery merchants only.
    Each item dict has: upc, name, merchant_id, chain, banner, price_cents,
    on_sale, sale_price_cents, image_url, valid_from, valid_to.
    """
    headers = {
        "Accept": "application/json",
        "Accept-Language": "en-CA,en;q=0.9",
        "Referer": "https://flipp.com/",
        "Origin": "https://flipp.com",
    }
    results = []
    async with AsyncSession(impersonate="chrome120") as s:
        resp = await s.get(
            _SEARCH_URL,
            headers=headers,
            params={"locale": "en-ca", "q": query, "postal_code": postal_code},
        )
        if resp.status_code != 200:
            return results

        for item in resp.json().get("items", []):
            mid = item.get("merchant_id")
            if mid not in GROCERY_MERCHANTS:
                continue
            chain, banner = GROCERY_MERCHANTS[mid]

            name = item.get("name") or ""
            if not name:
                continue

            current = item.get("current_price")
            original = item.get("original_price")
            if current is None:
                continue

            on_sale = original is not None and original > current
            price_cents = round(float(original if on_sale else current) * 100)
            sale_price_cents = round(float(current) * 100) if on_sale else None

            results.append({
                "upc": upc_from_name(name),
                "name": name,
                "merchant_id": mid,
                "chain": chain,
                "banner": banner,
                "price_cents": price_cents,
                "on_sale": on_sale,
                "sale_price_cents": sale_price_cents,
                "image_url": item.get("clean_image_url"),
                "valid_from": item.get("valid_from"),
                "valid_to": item.get("valid_to"),
                "sale_story": item.get("sale_story"),
            })

    return results


async def get_flipp_merchants(postal_code: str = "M5V1A1") -> list[dict]:
    """Return active flyer info for all grocery merchants in the area."""
    headers = {"Accept": "application/json", "Referer": "https://flipp.com/"}
    async with AsyncSession(impersonate="chrome120") as s:
        resp = await s.get(
            _FLYERS_URL,
            headers=headers,
            params={"locale": "en-ca", "postal_code": postal_code},
        )
        if resp.status_code != 200:
            return []
        return [
            f for f in resp.json().get("flyers", [])
            if f.get("merchant_id") in GROCERY_MERCHANTS
        ]
