"""
Migrate all data from local SQLite grocery.db to production PostgreSQL.
Usage: DATABASE_URL=postgresql+asyncpg://... python migrate_to_postgres.py
       or: python migrate_to_postgres.py <postgres_url>
"""
import asyncio
import sqlite3
import sys
import os
from datetime import datetime

import asyncpg

PROD_URL = sys.argv[1] if len(sys.argv) > 1 else os.environ.get("PG_URL", "")

def pg_url(url: str) -> str:
    """Strip asyncpg/psycopg prefix for raw asyncpg connect."""
    for prefix in ("postgresql+asyncpg://", "postgres+asyncpg://"):
        if url.startswith(prefix):
            return "postgresql://" + url[len(prefix):]
    return url


async def main():
    if not PROD_URL:
        print("Usage: python migrate_to_postgres.py <postgres_url>")
        sys.exit(1)

    print(f"Connecting to PostgreSQL...")
    conn = await asyncpg.connect(pg_url(PROD_URL))

    # Create tables
    print("Creating tables if not exist...")
    await conn.execute("""
        CREATE TABLE IF NOT EXISTS stores (
            id TEXT PRIMARY KEY,
            chain TEXT NOT NULL,
            banner TEXT,
            name TEXT NOT NULL,
            address TEXT,
            city TEXT,
            province CHAR(2),
            postal_code TEXT,
            lat DOUBLE PRECISION,
            lng DOUBLE PRECISION,
            store_id TEXT UNIQUE
        )
    """)
    await conn.execute("""
        CREATE TABLE IF NOT EXISTS products (
            id TEXT PRIMARY KEY,
            upc TEXT UNIQUE NOT NULL,
            name TEXT NOT NULL,
            brand TEXT,
            category TEXT,
            image_url TEXT
        )
    """)
    await conn.execute("""
        CREATE TABLE IF NOT EXISTS prices (
            id TEXT PRIMARY KEY,
            product_id TEXT REFERENCES products(id),
            store_id TEXT REFERENCES stores(id),
            price_cents INTEGER NOT NULL,
            unit TEXT,
            on_sale BOOLEAN DEFAULT false,
            sale_price_cents INTEGER,
            scraped_at TIMESTAMPTZ NOT NULL DEFAULT now(),
            UNIQUE (product_id, store_id)
        )
    """)
    print("Tables ready.")

    # Read from SQLite
    src = sqlite3.connect("grocery.db")
    src.row_factory = sqlite3.Row

    # --- Stores ---
    stores = src.execute("SELECT * FROM stores").fetchall()
    print(f"Migrating {len(stores)} stores...")
    for row in stores:
        await conn.execute("""
            INSERT INTO stores (id, chain, banner, name, address, city, province, postal_code, lat, lng, store_id)
            VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)
            ON CONFLICT (id) DO NOTHING
        """, row["id"], row["chain"], row["banner"], row["name"], row["address"],
            row["city"], row["province"], row["postal_code"], row["lat"], row["lng"], row["store_id"])

    # --- Products ---
    products = src.execute("SELECT * FROM products").fetchall()
    print(f"Migrating {len(products)} products...")
    for row in products:
        await conn.execute("""
            INSERT INTO products (id, upc, name, brand, category, image_url)
            VALUES ($1,$2,$3,$4,$5,$6)
            ON CONFLICT (id) DO NOTHING
        """, row["id"], row["upc"], row["name"], row["brand"], row["category"], row["image_url"])

    # --- Prices ---
    prices = src.execute("SELECT * FROM prices").fetchall()
    print(f"Migrating {len(prices)} prices...")
    for row in prices:
        await conn.execute("""
            INSERT INTO prices (id, product_id, store_id, price_cents, unit, on_sale, sale_price_cents, scraped_at)
            VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
            ON CONFLICT (id) DO NOTHING
        """, row["id"], row["product_id"], row["store_id"], row["price_cents"],
            row["unit"], bool(row["on_sale"]), row["sale_price_cents"],
            datetime.fromisoformat(row["scraped_at"]) if row["scraped_at"] else datetime.utcnow())

    src.close()
    await conn.close()
    print("Migration complete!")

asyncio.run(main())
