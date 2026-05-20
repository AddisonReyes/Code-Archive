"""
CRUD operations for the User model.

All functions accept an ``AsyncSession`` and return ORM objects (or None).
Business logic (HTTP status codes, etc.) stays in the routers.
"""

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import hash_password
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate


# ---------------------------------------------------------------------------
# Read
# ---------------------------------------------------------------------------

async def get_user_by_id(db: AsyncSession, user_id: int) -> User | None:
    """Return the User with the given *user_id*, or None if not found."""
    result = await db.execute(select(User).where(User.id == user_id))
    return result.scalar_one_or_none()


async def get_user_by_email(db: AsyncSession, email: str) -> User | None:
    """Return the User with the given *email*, or None if not found."""
    result = await db.execute(select(User).where(User.email == email))
    return result.scalar_one_or_none()


async def get_user_by_username(db: AsyncSession, username: str) -> User | None:
    """Return the User with the given *username*, or None if not found."""
    result = await db.execute(select(User).where(User.username == username))
    return result.scalar_one_or_none()


async def get_users(db: AsyncSession, skip: int = 0, limit: int = 20) -> list[User]:
    """Return a paginated list of all users."""
    result = await db.execute(select(User).offset(skip).limit(limit))
    return list(result.scalars().all())


# ---------------------------------------------------------------------------
# Create
# ---------------------------------------------------------------------------

async def create_user(db: AsyncSession, payload: UserCreate) -> User:
    """
    Insert a new User row.

    The plain-text password in *payload* is hashed before storage.
    """
    user = User(
        email=payload.email,
        username=payload.username,
        hashed_password=hash_password(payload.password),
    )
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user


# ---------------------------------------------------------------------------
# Update
# ---------------------------------------------------------------------------

async def update_user(db: AsyncSession, user: User, payload: UserUpdate) -> User:
    """
    Apply *payload* fields (only those that are not None) to *user*.

    Returns the updated User instance.
    """
    update_data = payload.model_dump(exclude_none=True)

    if "password" in update_data:
        update_data["hashed_password"] = hash_password(update_data.pop("password"))

    for field, value in update_data.items():
        setattr(user, field, value)

    await db.commit()
    await db.refresh(user)
    return user


# ---------------------------------------------------------------------------
# Delete
# ---------------------------------------------------------------------------

async def delete_user(db: AsyncSession, user: User) -> None:
    """Permanently delete *user* and all their posts (via cascade)."""
    await db.delete(user)
    await db.commit()
