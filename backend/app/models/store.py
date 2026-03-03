import uuid
from sqlalchemy import String, Double, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base


class Store(Base):
    __tablename__ = "stores"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    chain: Mapped[str] = mapped_column(String(50), nullable=False)   # 'loblaws', 'walmart', 'sobeys', 'metro'
    banner: Mapped[str | None] = mapped_column(String(100))           # 'No Frills', 'FreshCo', etc.
    name: Mapped[str] = mapped_column(Text, nullable=False)
    address: Mapped[str | None] = mapped_column(Text)
    city: Mapped[str | None] = mapped_column(String(100))
    province: Mapped[str | None] = mapped_column(String(2))
    postal_code: Mapped[str | None] = mapped_column(String(10))
    lat: Mapped[float | None] = mapped_column(Double)
    lng: Mapped[float | None] = mapped_column(Double)
    store_id: Mapped[str | None] = mapped_column(String(100), unique=True)  # retailer's own ID

    prices: Mapped[list["Price"]] = relationship("Price", back_populates="store")
