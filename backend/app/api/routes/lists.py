"""
Shopping list basket comparison endpoint.

Given a list of {upc, quantity} and user location, returns a breakdown
of total basket cost at each nearby store, sorted cheapest first.
"""
import math
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from pydantic import BaseModel
from typing import Optional

from app.database import get_db
from app.models import Product, Store, Price
from app.config import settings

router = APIRouter()


class ListItem(BaseModel):
    upc: str
    quantity: int = 1


class CompareRequest(BaseModel):
    items: list[ListItem]
    lat: float
    lng: float
    radius_km: Optional[float] = None


class ItemPrice(BaseModel):
    upc: str
    product_name: str
    quantity: int
    unit_price_cents: int
    unit_price_display: str
    subtotal_cents: int
    subtotal_display: str
    on_sale: bool


class StoreBasket(BaseModel):
    store_id: str
    chain: str
    banner: Optional[str]
    store_name: str
    city: Optional[str]
    province: Optional[str]
    distance_km: float
    total_cents: int
    total_display: str
    items_found: int
    items_missing: int
    item_prices: list[ItemPrice]


class CompareResponse(BaseModel):
    stores: list[StoreBasket]     # sorted cheapest first (complete baskets first)
    cheapest_store_id: Optional[str]
    total_items_requested: int


@router.post("/compare", response_model=CompareResponse)
async def compare_basket(
    req: CompareRequest,
    db: AsyncSession = Depends(get_db),
):
    radius_km = req.radius_km or settings.default_radius_km

    if not req.items:
        raise HTTPException(status_code=400, detail="Items list cannot be empty")

    upcs = [item.upc for item in req.items]
    qty_map = {item.upc: item.quantity for item in req.items}

    # Fetch all prices for all requested UPCs at stores within radius
    stmt = (
        select(Price, Store, Product)
        .join(Product, Price.product_id == Product.id)
        .join(Store, Price.store_id == Store.id)
        .where(Product.upc.in_(upcs))
    )
    result = await db.execute(stmt)
    rows = result.all()

    # Group prices by store, filtering by radius
    store_data: dict[str, dict] = {}
    store_objects: dict[str, Store] = {}

    for price, store, product in rows:
        if not store.lat or not store.lng:
            continue
        dist = _haversine_km(req.lat, req.lng, store.lat, store.lng)
        if dist > radius_km:
            continue

        if store.id not in store_data:
            store_data[store.id] = {}
            store_objects[store.id] = store

        effective_cents = (
            price.sale_price_cents if price.on_sale and price.sale_price_cents
            else price.price_cents
        )
        store_data[store.id][product.upc] = {
            "product_name": product.name,
            "unit_price_cents": effective_cents,
            "on_sale": price.on_sale,
        }

    baskets: list[StoreBasket] = []
    for store_id, prices_by_upc in store_data.items():
        store = store_objects[store_id]
        dist = _haversine_km(req.lat, req.lng, store.lat, store.lng)
        item_prices: list[ItemPrice] = []
        total = 0
        found = 0

        for upc in upcs:
            qty = qty_map[upc]
            if upc in prices_by_upc:
                p = prices_by_upc[upc]
                subtotal = p["unit_price_cents"] * qty
                total += subtotal
                found += 1
                item_prices.append(ItemPrice(
                    upc=upc,
                    product_name=p["product_name"],
                    quantity=qty,
                    unit_price_cents=p["unit_price_cents"],
                    unit_price_display=_cents_display(p["unit_price_cents"]),
                    subtotal_cents=subtotal,
                    subtotal_display=_cents_display(subtotal),
                    on_sale=p["on_sale"],
                ))

        baskets.append(StoreBasket(
            store_id=store_id,
            chain=store.chain,
            banner=store.banner,
            store_name=store.name,
            city=store.city,
            province=store.province,
            distance_km=round(dist, 2),
            total_cents=total,
            total_display=_cents_display(total),
            items_found=found,
            items_missing=len(upcs) - found,
            item_prices=item_prices,
        ))

    # Sort: complete baskets first, then by total price
    baskets.sort(key=lambda b: (b.items_missing, b.total_cents))

    cheapest = baskets[0].store_id if baskets else None
    return CompareResponse(
        stores=baskets,
        cheapest_store_id=cheapest,
        total_items_requested=len(upcs),
    )


def _haversine_km(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    R = 6371.0
    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    dphi = math.radians(lat2 - lat1)
    dlambda = math.radians(lon2 - lon1)
    a = math.sin(dphi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(dlambda / 2) ** 2
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))


def _cents_display(cents: int) -> str:
    return f"${cents / 100:.2f}"
