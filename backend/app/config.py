import os
from pydantic_settings import BaseSettings


def _fix_db_url(url: str) -> str:
    """Railway provides postgres:// or postgresql://, asyncpg needs postgresql+asyncpg://"""
    if url.startswith("postgres://"):
        url = url.replace("postgres://", "postgresql+asyncpg://", 1)
    elif url.startswith("postgresql://") and "+asyncpg" not in url:
        url = url.replace("postgresql://", "postgresql+asyncpg://", 1)
    return url


class Settings(BaseSettings):
    database_url: str = "sqlite+aiosqlite:///./grocery.db"
    api_title: str = "PriceMoose API"
    api_version: str = "0.1.0"
    default_radius_km: float = 25.0

    class Config:
        env_file = ".env"

    def model_post_init(self, __context):
        object.__setattr__(self, "database_url", _fix_db_url(self.database_url))


settings = Settings()
