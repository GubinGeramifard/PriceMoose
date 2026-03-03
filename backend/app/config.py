from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    database_url: str = "postgresql+asyncpg://grocery:grocery_secret@localhost:5432/grocery_db"
    redis_url: str = "redis://localhost:6379/0"
    celery_broker_url: str = "redis://localhost:6379/1"
    api_title: str = "Canadian Grocery Comparator API"
    api_version: str = "0.1.0"
    default_radius_km: float = 25.0

    class Config:
        env_file = ".env"


settings = Settings()
