"""
Security utilities: password hashing and JWT creation / verification.
"""

from datetime import datetime, timedelta, timezone
from typing import Any

from jose import JWTError, jwt
from passlib.context import CryptContext

from app.core.config import settings

# bcrypt is the hashing algorithm; auto-upgrade deprecated hashes on verify.
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


# ---------------------------------------------------------------------------
# Password helpers
# ---------------------------------------------------------------------------

def hash_password(plain: str) -> str:
    """Return the bcrypt hash of *plain*."""
    return pwd_context.hash(plain)


def verify_password(plain: str, hashed: str) -> bool:
    """Return True if *plain* matches the stored *hashed* password."""
    return pwd_context.verify(plain, hashed)


# ---------------------------------------------------------------------------
# JWT helpers
# ---------------------------------------------------------------------------

def create_access_token(subject: Any, expires_delta: timedelta | None = None) -> str:
    """
    Create a signed JWT access token.

    Parameters
    ----------
    subject:
        The value to encode as the ``sub`` claim (typically the user's ID).
    expires_delta:
        Optional custom lifetime.  Defaults to ``ACCESS_TOKEN_EXPIRE_MINUTES``.

    Returns
    -------
    str
        A signed JWT string.
    """
    expire = datetime.now(timezone.utc) + (
        expires_delta or timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    payload = {"sub": str(subject), "exp": expire}
    return jwt.encode(payload, settings.SECRET_KEY, algorithm=settings.ALGORITHM)


def decode_access_token(token: str) -> str | None:
    """
    Decode and verify *token*.

    Returns the ``sub`` claim on success, or *None* if the token is invalid
    or expired.
    """
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        return payload.get("sub")
    except JWTError:
        return None
