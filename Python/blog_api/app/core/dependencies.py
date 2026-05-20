"""
Shared FastAPI dependencies.

- ``get_db``          – yields an async database session per request.
- ``get_current_user``– resolves the Bearer JWT to a User ORM object.
"""

from typing import AsyncGenerator

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.security import decode_access_token
from app.database.session import AsyncSessionLocal

# The tokenUrl must match the login endpoint defined in the auth router.
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


# ---------------------------------------------------------------------------
# Database session
# ---------------------------------------------------------------------------

async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """
    Yield an ``AsyncSession`` for the duration of a single request, then
    close it automatically.
    """
    async with AsyncSessionLocal() as session:
        yield session


# ---------------------------------------------------------------------------
# Current user
# ---------------------------------------------------------------------------

async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: AsyncSession = Depends(get_db),
):
    """
    Validate the Bearer JWT and return the matching ``User`` ORM instance.

    Raises ``401 Unauthorized`` when the token is missing, expired, or the
    referenced user no longer exists.
    """
    # Import here to avoid circular imports at module load time.
    from app.crud.user import get_user_by_id

    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials.",
        headers={"WWW-Authenticate": "Bearer"},
    )

    user_id = decode_access_token(token)
    if user_id is None:
        raise credentials_exception

    user = await get_user_by_id(db, int(user_id))
    if user is None:
        raise credentials_exception

    return user
