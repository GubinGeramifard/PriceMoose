from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import select, func, text
from sqlalchemy.ext.asyncio import AsyncSession
from pydantic import BaseModel
from typing import Optional

from app.database import get_db
from app.models import Product, Price, Store
from app.scrapers import ALL_SCRAPERS

router = APIRouter()

_SCRAPER_MAP = {s().chain: s for s in ALL_SCRAPERS}


class ProductOut(BaseModel):
    id: str
    upc: str
    name: str
    brand: Optional[str]
    category: Optional[str]
    image_url: Optional[str]

    class Config:
        from_attributes = True


class DealOut(BaseModel):
    upc: str
    name: str
    brand: Optional[str]
    image_url: Optional[str]
    chain: str
    banner: Optional[str]
    store_name: str
    sale_price_cents: int
    regular_price_cents: int
    sale_price_display: str
    regular_price_display: str
    savings_pct: int


@router.get("/deals", response_model=list[DealOut])
async def get_deals(
    limit: int = Query(20, le=50),
    db: AsyncSession = Depends(get_db),
):
    """Return products currently on sale, sorted by biggest % savings."""
    stmt = (
        select(Product, Price, Store)
        .join(Price, Price.product_id == Product.id)
        .join(Store, Price.store_id == Store.id)
        .where(Price.on_sale == True)
        .where(Price.sale_price_cents != None)
        .where(Price.sale_price_cents < Price.price_cents)
        .order_by(Price.scraped_at.desc())
        .limit(limit * 3)  # over-fetch so we can sort by savings
    )
    result = await db.execute(stmt)
    rows = result.all()

    output: list[DealOut] = []
    for product, price, store in rows:
        savings_pct = int((1 - price.sale_price_cents / price.price_cents) * 100)
        output.append(DealOut(
            upc=product.upc,
            name=product.name,
            brand=product.brand,
            image_url=product.image_url,
            chain=store.chain,
            banner=store.banner,
            store_name=store.name,
            sale_price_cents=price.sale_price_cents,
            regular_price_cents=price.price_cents,
            sale_price_display=f"${price.sale_price_cents / 100:.2f}",
            regular_price_display=f"${price.price_cents / 100:.2f}",
            savings_pct=savings_pct,
        ))

    output.sort(key=lambda d: d.savings_pct, reverse=True)
    return output[:limit]


@router.get("/search", response_model=list[ProductOut])
async def search_products(
    q: str = Query(..., min_length=2),
    limit: int = Query(20, le=50),
    db: AsyncSession = Depends(get_db),
):
    """Full-text search across product names and brands."""
    stmt = (
        select(Product)
        .where(
            Product.name.ilike(f"%{q}%") | Product.brand.ilike(f"%{q}%")
        )
        .limit(limit)
    )
    result = await db.execute(stmt)
    return result.scalars().all()


@router.get("/upc/{upc}", response_model=ProductOut)
async def get_product_by_upc(
    upc: str,
    db: AsyncSession = Depends(get_db),
):
    """Look up a product by barcode. If not in DB, tries all scrapers to seed it."""
    result = await db.execute(select(Product).where(Product.upc == upc))
    product = result.scalar_one_or_none()

    if product is None:
        # Try to seed from scrapers on first miss
        product = await _seed_product_from_scrapers(upc, db)

    if product is None:
        raise HTTPException(status_code=404, detail=f"Product with UPC {upc} not found")

    return product


async def _seed_product_from_scrapers(upc: str, db: AsyncSession) -> Optional[Product]:
    """Try each scraper until one returns product metadata, then persist it."""
    for scraper_cls in ALL_SCRAPERS:
        scraper = scraper_cls()
        data = await scraper.get_product_by_upc(upc)
        if data:
            import uuid
            product = Product(
                id=str(uuid.uuid4()),
                upc=data.upc,
                name=data.name,
                brand=data.brand,
                category=data.category,
                image_url=data.image_url,
            )
            db.add(product)
            await db.commit()
            await db.refresh(product)
            return product
    return None
