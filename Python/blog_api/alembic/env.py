"""
Alembic environment configuration.

Key design decisions
--------------------
- The database URL is read from the application's ``Settings`` object, so
  there is a single source of truth (the ``.env`` file).
- Because asyncpg uses an async driver, we run migrations **synchronously**
  by replacing ``+asyncpg`` with ``+psycopg2`` at runtime.  This avoids the
  need for an extra async migration harness while still sharing the same URL.
- Both ORM models are imported so that ``autogenerate`` can detect all tables.
"""

import re
from logging.config import fileConfig

from alembic import context
from sqlalchemy import engine_from_config, pool

# -- Application imports -----------------------------------------------------
from app.core.config import settings
from app.database.session import Base

# Register all models so their tables are visible to autogenerate.
import app.models.user  # noqa: F401
import app.models.post  # noqa: F401
# ----------------------------------------------------------------------------

config = context.config

# Wire Python logging from the alembic.ini [loggers] section.
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata


def _sync_url(url: str) -> str:
    """Replace asyncpg driver with psycopg2 for synchronous Alembic runs."""
    return re.sub(r"\+asyncpg", "+psycopg2", url)


def run_migrations_offline() -> None:
    """
    Run migrations in 'offline' mode (no live DB connection).

    Alembic generates SQL scripts that can be reviewed and applied manually.
    """
    context.configure(
        url=_sync_url(settings.DATABASE_URL),
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    """
    Run migrations in 'online' mode (direct DB connection).

    A synchronous engine is created from the application's DATABASE_URL.
    """
    cfg = config.get_section(config.config_ini_section, {})
    cfg["sqlalchemy.url"] = _sync_url(settings.DATABASE_URL)

    connectable = engine_from_config(
        cfg,
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(connection=connection, target_metadata=target_metadata)
        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
