import math
from fastapi import APIRouter, Depends, Query
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from pydantic import BaseModel
from typing import Optional

from app.database import get_db
from app.models import Store
from app.config import settings

router = APIRouter()


class StoreOut(BaseModel):
    id: str
    chain: str
    banner: Optional[str]
    name: str
    address: Optional[str]
    city: Optional[str]
    province: Optional[str]
    postal_code: Optional[str]
    lat: Optional[float]
    lng: Optional[float]
    distance_km: Optional[float]

    class Config:
        from_attributes = True


@router.get("/nearby", response_model=list[StoreOut])
async def get_nearby_stores(
    lat: float = Query(...),
    lng: float = Query(...),
    radius_km: float = Query(None),
    chain: Optional[str] = Query(None),
    db: AsyncSession = Depends(get_db),
):
    """Return all stores within radius_km of lat/lng, optionally filtered by chain."""
    if radius_km is None:
        radius_km = settings.default_radius_km

    stmt = select(Store).where(Store.lat.is_not(None), Store.lng.is_not(None))
    if chain:
        stmt = stmt.where(Store.chain == chain)

    result = await db.execute(stmt)
    all_stores = result.scalars().all()

    nearby: list[StoreOut] = []
    for s in all_stores:
        dist = _haversine_km(lat, lng, s.lat, s.lng)
        if dist <= radius_km:
            nearby.append(StoreOut(
                id=s.id,
                chain=s.chain,
                banner=s.banner,
                name=s.name,
                address=s.address,
                city=s.city,
                province=s.province,
                postal_code=s.postal_code,
                lat=s.lat,
                lng=s.lng,
                distance_km=round(dist, 2),
            ))

    nearby.sort(key=lambda s: s.distance_km or 0)
    return nearby


def _haversine_km(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    R = 6371.0
    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    dphi = math.radians(lat2 - lat1)
    dlambda = math.radians(lon2 - lon1)
    a = math.sin(dphi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(dlambda / 2) ** 2
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
