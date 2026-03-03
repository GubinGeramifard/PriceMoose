from celery import Celery
from celery.schedules import crontab
from app.config import settings

celery = Celery(
    "grocery_tasks",
    broker=settings.celery_broker_url,
    backend=settings.celery_broker_url.replace("/1", "/2"),
    include=["app.tasks.scrape_tasks"],
)

celery.conf.beat_schedule = {
    "scrape-loblaws-every-6h": {
        "task": "app.tasks.scrape_tasks.run_scraper",
        "schedule": crontab(minute=0, hour="*/6"),
        "args": ("loblaws",),
    },
    "scrape-walmart-every-6h": {
        "task": "app.tasks.scrape_tasks.run_scraper",
        "schedule": crontab(minute=15, hour="*/6"),
        "args": ("walmart",),
    },
    "scrape-sobeys-every-6h": {
        "task": "app.tasks.scrape_tasks.run_scraper",
        "schedule": crontab(minute=30, hour="*/6"),
        "args": ("sobeys",),
    },
    "scrape-metro-every-6h": {
        "task": "app.tasks.scrape_tasks.run_scraper",
        "schedule": crontab(minute=45, hour="*/6"),
        "args": ("metro",),
    },
}

celery.conf.timezone = "America/Toronto"
