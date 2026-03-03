import uuid
from datetime import datetime
from sqlalchemy import String, Integer, Boolean, DateTime, ForeignKey, UniqueConstraint, func
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base


class Price(Base):
    __tablename__ = "prices"
    __table_args__ = (UniqueConstraint("product_id", "store_id", name="uq_product_store"),)

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    product_id: Mapped[str] = mapped_column(String(36), ForeignKey("products.id"), nullable=False, index=True)
    store_id: Mapped[str] = mapped_column(String(36), ForeignKey("stores.id"), nullable=False, index=True)
    price_cents: Mapped[int] = mapped_column(Integer, nullable=False)   # stored as cents to avoid float issues
    unit: Mapped[str | None] = mapped_column(String(50))                # 'each', '100g', '1L', etc.
    on_sale: Mapped[bool] = mapped_column(Boolean, default=False)
    sale_price_cents: Mapped[int | None] = mapped_column(Integer)
    scraped_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    product: Mapped["Product"] = relationship("Product", back_populates="prices")
    store: Mapped["Store"] = relationship("Store", back_populates="prices")
