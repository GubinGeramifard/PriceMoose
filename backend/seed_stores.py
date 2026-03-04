"""
Seed real grocery store locations for major Canadian cities.
Coordinates sourced from publicly known store addresses.
"""
import asyncio, uuid, sys
sys.path.insert(0, '.')

from app.database import AsyncSessionLocal
from app.models import Store
from sqlalchemy import select

STORES = [
    # === TORONTO — Loblaws ===
    dict(chain="loblaws", banner="Loblaws", name="Loblaws Maple Leaf Gardens", address="60 Carlton St", city="Toronto", province="ON", lat=43.6622, lng=-79.3797),
    dict(chain="loblaws", banner="Loblaws", name="Loblaws St. Clair", address="925 St Clair Ave W", city="Toronto", province="ON", lat=43.6820, lng=-79.4296),
    dict(chain="loblaws", banner="Loblaws", name="Loblaws Leslie & Lakeshore", address="3087 Lakeshore Blvd W", city="Toronto", province="ON", lat=43.6085, lng=-79.5074),
    dict(chain="loblaws", banner="No Frills", name="No Frills Broadview", address="357 Broadview Ave", city="Toronto", province="ON", lat=43.6680, lng=-79.3527),
    dict(chain="loblaws", banner="No Frills", name="No Frills Rexdale", address="2267 Islington Ave", city="Toronto", province="ON", lat=43.7273, lng=-79.5574),
    dict(chain="loblaws", banner="No Frills", name="No Frills Kipling", address="5095 Dundas St W", city="Toronto", province="ON", lat=43.6488, lng=-79.5359),
    dict(chain="loblaws", banner="Real Canadian Superstore", name="RCSS Etobicoke", address="900 Dixon Rd", city="Toronto", province="ON", lat=43.6920, lng=-79.5660),
    dict(chain="loblaws", banner="Real Canadian Superstore", name="RCSS Scarborough", address="1900 Eglinton Ave E", city="Scarborough", province="ON", lat=43.7305, lng=-79.2621),
    dict(chain="loblaws", banner="Fortinos", name="Fortinos Brampton", address="30 Peel Centre Dr", city="Brampton", province="ON", lat=43.6876, lng=-79.7600),
    dict(chain="loblaws", banner="Zehrs", name="Zehrs Kitchener", address="350 Fairway Rd S", city="Kitchener", province="ON", lat=43.4163, lng=-80.4570),

    # === TORONTO — Walmart ===
    dict(chain="walmart", banner="Walmart", name="Walmart Scarborough Town Centre", address="300 Borough Dr", city="Scarborough", province="ON", lat=43.7756, lng=-79.2571),
    dict(chain="walmart", banner="Walmart", name="Walmart Mississauga", address="5800 McLaughlin Rd", city="Mississauga", province="ON", lat=43.6009, lng=-79.6661),
    dict(chain="walmart", banner="Walmart", name="Walmart Etobicoke", address="411 The East Mall", city="Toronto", province="ON", lat=43.6422, lng=-79.5527),
    dict(chain="walmart", banner="Walmart", name="Walmart Brampton", address="40 Worthington Ave", city="Brampton", province="ON", lat=43.6742, lng=-79.7903),
    dict(chain="walmart", banner="Walmart", name="Walmart North York", address="1900 Sheppard Ave E", city="North York", province="ON", lat=43.7734, lng=-79.3348),

    # === TORONTO — Sobeys / FreshCo ===
    dict(chain="sobeys", banner="Sobeys", name="Sobeys Yonge & Eg", address="2221 Yonge St", city="Toronto", province="ON", lat=43.7047, lng=-79.3986),
    dict(chain="sobeys", banner="Sobeys", name="Sobeys Bayview Village", address="2901 Bayview Ave", city="Toronto", province="ON", lat=43.7654, lng=-79.3860),
    dict(chain="sobeys", banner="FreshCo", name="FreshCo Weston", address="2100 Weston Rd", city="York", province="ON", lat=43.7048, lng=-79.5133),
    dict(chain="sobeys", banner="FreshCo", name="FreshCo Jane & Sheppard", address="3455 Sheppard Ave W", city="Toronto", province="ON", lat=43.7545, lng=-79.5059),
    dict(chain="sobeys", banner="FreshCo", name="FreshCo Kingston Rd", address="4261 Kingston Rd", city="Scarborough", province="ON", lat=43.7733, lng=-79.1859),

    # === TORONTO — Metro / Food Basics ===
    dict(chain="metro", banner="Metro", name="Metro Bloor West", address="800 Bloor St W", city="Toronto", province="ON", lat=43.6622, lng=-79.4216),
    dict(chain="metro", banner="Metro", name="Metro Dufferin Mall", address="900 Dufferin St", city="Toronto", province="ON", lat=43.6515, lng=-79.4338),
    dict(chain="metro", banner="Metro", name="Metro Yonge & Sheppard", address="4899 Yonge St", city="North York", province="ON", lat=43.7613, lng=-79.4122),
    dict(chain="metro", banner="Food Basics", name="Food Basics Warden", address="2267 Warden Ave", city="Scarborough", province="ON", lat=43.7868, lng=-79.3022),
    dict(chain="metro", banner="Food Basics", name="Food Basics Jane St", address="3372 Jane St", city="North York", province="ON", lat=43.7527, lng=-79.5122),

    # === VANCOUVER ===
    dict(chain="loblaws", banner="Real Canadian Superstore", name="RCSS Grandview Hwy", address="2929 Grandview Hwy", city="Vancouver", province="BC", lat=49.2408, lng=-123.0313),
    dict(chain="walmart", banner="Walmart", name="Walmart Grandview", address="3585 Grandview Hwy", city="Vancouver", province="BC", lat=49.2386, lng=-123.0192),
    dict(chain="sobeys", banner="Safeway", name="Safeway Broadway", address="3456 Cambie St", city="Vancouver", province="BC", lat=49.2432, lng=-123.1163),
    dict(chain="metro", banner="Metro", name="Save-On-Foods Davie", address="1025 Davie St", city="Vancouver", province="BC", lat=49.2777, lng=-123.1295),

    # === CALGARY ===
    dict(chain="loblaws", banner="Real Canadian Superstore", name="RCSS NE Calgary", address="4155 126 Ave SE", city="Calgary", province="AB", lat=50.9889, lng=-113.9779),
    dict(chain="walmart", banner="Walmart", name="Walmart Sunridge", address="2525 36 St NE", city="Calgary", province="AB", lat=51.0726, lng=-113.9778),
    dict(chain="sobeys", banner="Sobeys", name="Sobeys Dalhousie", address="5075 Dalhousie Dr NW", city="Calgary", province="AB", lat=51.1268, lng=-114.1836),

    # === OTTAWA ===
    dict(chain="loblaws", banner="Loblaws", name="Loblaws Westboro", address="230 Richmond Rd", city="Ottawa", province="ON", lat=45.3940, lng=-75.7534),
    dict(chain="walmart", banner="Walmart", name="Walmart Baseline", address="1900 Baseline Rd", city="Ottawa", province="ON", lat=45.3610, lng=-75.7556),
    dict(chain="sobeys", banner="Sobeys", name="Sobeys Hunt Club", address="3330 McCarthy Rd", city="Ottawa", province="ON", lat=45.3434, lng=-75.6651),
]

async def main():
    async with AsyncSessionLocal() as db:
        added = 0
        for s in STORES:
            # Skip if a real store with same name already exists
            result = await db.execute(select(Store).where(Store.name == s["name"]))
            if result.scalar_one_or_none():
                continue
            store = Store(
                id=str(uuid.uuid4()),
                store_id=f"seed_{s['name'].lower().replace(' ', '_')}",
                **s,
            )
            db.add(store)
            added += 1
        await db.commit()
        print(f"Seeded {added} new store locations")

asyncio.run(main())
