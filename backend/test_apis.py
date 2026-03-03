import asyncio, json
from curl_cffi.requests import AsyncSession

async def test():
    async with AsyncSession(impersonate="chrome120") as s:

        # Get Flipp merchant list to find Loblaws/Walmart merchant IDs
        print("=== Flipp Merchants (Toronto M5V) ===")
        r = await s.get(
            "https://backflipp.wishabi.com/flipp/flyers",
            params={"locale": "en-ca", "postal_code": "M5V1A1"}
        )
        print(f"Status: {r.status_code}")
        if r.status_code == 200:
            data = r.json()
            flyers = data.get("flyers", [])
            print(f"Flyers found: {len(flyers)}")
            for f in flyers:
                print(f"  merchant_id={f.get('merchant_id')} | name={f.get('merchant')} | id={f.get('id')}")
        else:
            print(r.text[:300])

        print()
        # Check a milk search with merchant info
        print("=== Milk items with merchant details ===")
        r2 = await s.get(
            "https://backflipp.wishabi.com/flipp/items/search",
            params={"locale": "en-ca", "q": "milk", "postal_code": "M5V1A1"}
        )
        if r2.status_code == 200:
            items = r2.json().get("items", [])
            for i in items[:10]:
                print(f"  {i.get('merchant_name') or i.get('merchant_id')} | {i.get('name')} | ${i.get('current_price')} | sale={i.get('sale_story')}")

asyncio.run(test())
