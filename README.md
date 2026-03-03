# Price Check Canada

A Flutter app for comparing grocery prices across major Canadian retailers:
**Loblaws · Walmart Canada · Sobeys · Metro**

## Architecture

```
backend/     — Python FastAPI + PostgreSQL + Celery scrapers
mobile/      — Flutter app (iOS & Android)
```

---

## Quick Start

### Backend

**Requirements**: Docker + Docker Compose

```bash
cd backend
docker compose up --build
```

API available at `http://localhost:8000`
Swagger docs at `http://localhost:8000/docs`

Health check: `curl http://localhost:8000/health`

**Run scrapers manually** (first-time seed):
```bash
docker compose exec worker python -c "
from app.tasks.scrape_tasks import _scrape_chain
import asyncio
asyncio.run(_scrape_chain('loblaws'))
"
```

### Flutter App

**Requirements**: Flutter 3.22+ with Dart 3.3+

```bash
cd mobile
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs   # generate freezed/retrofit files
flutter run   # iOS simulator or Android emulator
```

> For device testing: update `lib/core/constants.dart` → `ApiConstants.baseUrl`
> to your machine's LAN IP (e.g. `http://192.168.1.100:8000`)

---

## Features

| Feature | Description |
|---------|-------------|
| Barcode Scan | Scan any grocery barcode → instant price comparison across nearby stores |
| Search | Full-text product search with debounced results |
| Price Ranking | Prices sorted cheapest-first with distance and sale badges |
| Shopping List | Build a cart, set quantities, persisted locally |
| Basket Compare | See total cost of your whole list at each nearby store |
| Store Map | OpenStreetMap view of all nearby stores with chain colour coding |

## Supported Chains

| Chain | Banners | Data Source |
|-------|---------|-------------|
| Loblaws | Loblaws, No Frills, RCSS, Zehrs, Fortinos | PC Express API |
| Walmart | Walmart Canada | grocery.walmart.ca GraphQL |
| Sobeys | Sobeys, FreshCo, Safeway, IGA | sobeys.com API |
| Metro | Metro, Food Basics | metro.ca API |

## Scraping Schedule

Prices are refreshed every 6 hours via Celery beat:
- 00:00 / 06:00 / 12:00 / 18:00 — Loblaws
- 00:15 / 06:15 / 12:15 / 18:15 — Walmart
- 00:30 / 06:30 / 12:30 / 18:30 — Sobeys
- 00:45 / 06:45 / 12:45 / 18:45 — Metro

## API Reference

| Endpoint | Description |
|----------|-------------|
| `GET /products/search?q=&limit=` | Search products by name |
| `GET /products/upc/{upc}` | Look up by barcode (auto-seeds from scrapers) |
| `GET /prices/{upc}?lat=&lng=&radius_km=` | Prices sorted cheapest first |
| `GET /stores/nearby?lat=&lng=&radius_km=&chain=` | Stores near a location |
| `POST /lists/compare` | Compare basket cost across stores |

## Project Structure

```
backend/app/
├── main.py              FastAPI app
├── config.py            Environment settings
├── database.py          SQLAlchemy async engine
├── models/              ORM models (Product, Store, Price)
├── api/routes/          FastAPI route handlers
├── scrapers/            One file per chain + base class
└── tasks/               Celery app + scheduled scrape tasks

mobile/lib/
├── main.dart
├── app/                 App root + go_router config
├── core/                API client, theme, constants
├── shared/              Freezed models + reusable widgets
└── features/            search/ barcode/ product_detail/ shopping_list/ stores/
```

## Legal Note

This app uses unofficial APIs to retrieve publicly available pricing information.
Always review a retailer's Terms of Service before scraping. Consider rate-limiting
scrapers and caching aggressively to minimize load on retailer infrastructure.
