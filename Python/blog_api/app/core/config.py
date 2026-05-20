"""
Application configuration loaded from environment variables.

All settings are read from a `.env` file (or the real environment).
Pydantic-settings validates and coerces the values automatically.
"""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    # --- Project ---
    PROJECT_NAME: str = "Blog API"
    VERSION: str = "0.1.0"
    DESCRIPTION: str = "A RESTful blog API built with FastAPI and PostgreSQL."

    # --- Database ---
    DATABASE_URL: str  # e.g. postgresql+asyncpg://user:pass@localhost/blog_db

    # --- JWT ---
    SECRET_KEY: str          # openssl rand -hex 32
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24  # 1 day

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")


# Single shared instance — import this everywhere.
settings = Settings()  # type: ignore[call-arg]
