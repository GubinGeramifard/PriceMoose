from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from typing import Optional


@dataclass
class StoreData:
    store_id: str          # retailer's own internal ID
    chain: str             # 'loblaws' | 'walmart' | 'sobeys' | 'metro'
    banner: Optional[str]  # 'No Frills', 'FreshCo', 'Food Basics', etc.
    name: str
    address: Optional[str]
    city: Optional[str]
    province: Optional[str]
    postal_code: Optional[str]
    lat: Optional[float]
    lng: Optional[float]


@dataclass
class ProductData:
    upc: str
    name: str
    brand: Optional[str] = None
    category: Optional[str] = None
    image_url: Optional[str] = None


@dataclass
class PriceData:
    upc: str
    store_id: str          # matches StoreData.store_id
    price_cents: int       # price in cents (e.g. $3.99 → 399)
    unit: Optional[str] = None
    on_sale: bool = False
    sale_price_cents: Optional[int] = None


class BaseScraper(ABC):
    """
    Contract that every chain scraper must implement.
    All methods are async — use httpx or Playwright as needed.
    """

    @property
    @abstractmethod
    def chain(self) -> str:
        """Identifier string: 'loblaws' | 'walmart' | 'sobeys' | 'metro'"""
        ...

    @abstractmethod
    async def get_stores(self) -> list[StoreData]:
        """Return all physical store locations for this chain in Canada."""
        ...

    @abstractmethod
    async def get_product_by_upc(self, upc: str) -> Optional[ProductData]:
        """Look up a product by its barcode / UPC. Return None if not found."""
        ...

    @abstractmethod
    async def get_prices_by_store(self, store_id: str, upcs: list[str]) -> list[PriceData]:
        """
        Fetch current prices for the given UPCs at a specific store.
        `store_id` is the retailer's own internal identifier (StoreData.store_id).
        """
        ...
