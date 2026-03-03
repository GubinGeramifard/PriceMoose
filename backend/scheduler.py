"""
Auto-refresh scheduler — re-runs the Flipp scraper on a schedule.
Keeps grocery prices up to date without manual intervention.

Usage:
    python scheduler.py                # scrape every 12 hours (default)
    python scheduler.py --interval 6   # scrape every 6 hours
    python scheduler.py --once         # run once and exit
"""
import asyncio
import argparse
import time
import logging
from datetime import datetime

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
)
log = logging.getLogger(__name__)


async def run_scrape(postal_code: str = 'M5V1A1') -> bool:
    try:
        import scrape_tier1
        log.info(f"Starting scrape for postal code {postal_code}...")
        await scrape_tier1.main(postal_code=postal_code)
        log.info("Scrape completed successfully.")
        return True
    except Exception as e:
        log.error(f"Scrape failed: {e}")
        return False


def main() -> None:
    parser = argparse.ArgumentParser(description='Auto-refresh grocery price data')
    parser.add_argument('--interval', type=float, default=12.0,
                        help='Hours between scrapes (default: 12)')
    parser.add_argument('--postal', default='M5V1A1',
                        help='Postal code to scrape (default: M5V1A1 — Toronto)')
    parser.add_argument('--once', action='store_true',
                        help='Run once and exit instead of looping')
    args = parser.parse_args()

    if args.once:
        asyncio.run(run_scrape(args.postal))
        return

    interval_seconds = args.interval * 3600
    log.info(f"Scheduler started. Scraping every {args.interval}h for {args.postal}.")

    while True:
        asyncio.run(run_scrape(args.postal))
        next_time = datetime.now().strftime('%H:%M')
        log.info(f"Next scrape in {args.interval}h (around {next_time})")
        time.sleep(interval_seconds)


if __name__ == '__main__':
    main()
