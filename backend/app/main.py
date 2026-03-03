from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.database import engine, Base
from app.api.routes import products, prices, stores, lists


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Create tables on startup (in production, use Alembic migrations)
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield


app = FastAPI(
    title=settings.api_title,
    version=settings.api_version,
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(products.router, prefix="/products", tags=["products"])
app.include_router(prices.router, prefix="/prices", tags=["prices"])
app.include_router(stores.router, prefix="/stores", tags=["stores"])
app.include_router(lists.router, prefix="/lists", tags=["lists"])


@app.get("/health")
async def health():
    return {"status": "ok", "version": settings.api_version}
