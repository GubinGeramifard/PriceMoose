"""
Local dev seeding script — runs scrapers directly without Celery/Redis.
Usage:  python seed.py [chain]
        python seed.py loblaws
        python seed.py all
"""
import asyncio
import sys
import logging

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")

async def main():
    # Must init tables first
    from app.database import engine, Base
    import app.models  # ensure models are registered
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    print("Tables ready.")

    chain = sys.argv[1] if len(sys.argv) > 1 else "loblaws"
    chains = ["loblaws", "walmart", "sobeys", "metro"] if chain == "all" else [chain]

    from app.tasks.scrape_tasks import _scrape_chain
    for c in chains:
        print(f"\n--- Seeding {c} ---")
        try:
            await _scrape_chain(c)
        except Exception as e:
            print(f"  ERROR: {e}")

    print("\nDone! Run: uvicorn app.main:app --reload")

if __name__ == "__main__":
    asyncio.run(main())
