import math
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

from app.database import get_db
from app.models import Product, Store, Price
from app.config import settings

router = APIRouter()


class PriceOut(BaseModel):
    store_id: str
    chain: str
    banner: Optional[str]
    store_name: str
    city: Optional[str]
    province: Optional[str]
    lat: Optional[float]
    lng: Optional[float]
    distance_km: Optional[float]
    price_cents: int
    price_display: str    # "$3.99"
    unit: Optional[str]
    on_sale: bool
    sale_price_cents: Optional[int]
    sale_price_display: Optional[str]
    scraped_at: datetime


@router.get("/{upc}", response_model=list[PriceOut])
async def get_prices_for_product(
    upc: str,
    lat: Optional[float] = Query(None),
    lng: Optional[float] = Query(None),
    radius_km: float = Query(None),
    db: AsyncSession = Depends(get_db),
):
    """
    Return all available prices for a product, sorted by price (cheapest first).
    If lat/lng provided, filters to stores within radius_km and includes distance.
    """
    if radius_km is None:
        radius_km = settings.default_radius_km

    # Join prices → products → stores
    stmt = (
        select(Price, Store)
        .join(Product, Price.product_id == Product.id)
        .join(Store, Price.store_id == Store.id)
        .where(Product.upc == upc)
    )
    result = await db.execute(stmt)
    rows = result.all()

    if not rows:
        raise HTTPException(status_code=404, detail=f"No prices found for UPC {upc}")

    output: list[PriceOut] = []
    for price, store in rows:
        distance = None
        if lat is not None and lng is not None and store.lat and store.lng:
            distance = _haversine_km(lat, lng, store.lat, store.lng)
            if distance > radius_km:
                continue

        effective_price = price.sale_price_cents if price.on_sale and price.sale_price_cents else price.price_cents
        output.append(PriceOut(
            store_id=store.id,
            chain=store.chain,
            banner=store.banner,
            store_name=store.name,
            city=store.city,
            province=store.province,
            lat=store.lat,
            lng=store.lng,
            distance_km=round(distance, 2) if distance is not None else None,
            price_cents=price.price_cents,
            price_display=_cents_display(price.price_cents),
            unit=price.unit,
            on_sale=price.on_sale,
            sale_price_cents=price.sale_price_cents,
            sale_price_display=_cents_display(price.sale_price_cents) if price.sale_price_cents else None,
            scraped_at=price.scraped_at,
        ))

    # Sort by effective price (cheapest first)
    output.sort(key=lambda p: p.sale_price_cents if p.on_sale and p.sale_price_cents else p.price_cents)
    return output


def _haversine_km(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    R = 6371.0
    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    dphi = math.radians(lat2 - lat1)
    dlambda = math.radians(lon2 - lon1)
    a = math.sin(dphi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(dlambda / 2) ** 2
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))


def _cents_display(cents: Optional[int]) -> str:
    if cents is None:
        return ""
    return f"${cents / 100:.2f}"
