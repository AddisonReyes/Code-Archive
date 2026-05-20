"""
SQLAlchemy async engine and session factory.

All database interaction in this project goes through ``AsyncSession``
instances produced by ``AsyncSessionLocal``.
"""

from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.orm import DeclarativeBase

from app.core.config import settings

# ``echo=False`` in production; set to True temporarily for SQL debug output.
engine = create_async_engine(settings.DATABASE_URL, echo=False, future=True)

# ``expire_on_commit=False`` keeps ORM objects usable after a commit without
# triggering lazy loads (important in async context).
AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
)


class Base(DeclarativeBase):
    """
    Declarative base class shared by all ORM models.

    Import this in every model module so that Alembic's ``autogenerate``
    can detect all tables from a single metadata object.
    """
