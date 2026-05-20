"""
Pydantic schemas for the User resource.

Schema hierarchy
----------------
UserBase         – shared fields (email, username).
UserCreate       – input for registration (adds plain-text password).
UserUpdate       – optional fields for partial updates.
UserPublic       – safe response shape (never includes the password hash).
UserWithPosts    – extended response that embeds the user's posts.
"""

from datetime import datetime

from pydantic import BaseModel, ConfigDict, EmailStr, Field

from app.schemas.post import PostPublic  # noqa: F401  (re-exported for convenience)


class UserBase(BaseModel):
    email: EmailStr = Field(..., description="Unique email address.")
    username: str = Field(..., min_length=3, max_length=50, description="Unique display name.")


class UserCreate(UserBase):
    """Payload expected when a new account is created."""

    password: str = Field(..., min_length=8, description="Plain-text password (min 8 chars).")


class UserUpdate(BaseModel):
    """All fields are optional — only provided fields will be changed."""

    email: EmailStr | None = None
    username: str | None = Field(default=None, min_length=3, max_length=50)
    password: str | None = Field(default=None, min_length=8)


class UserPublic(UserBase):
    """
    Safe user representation returned to API consumers.
    The hashed_password field is intentionally excluded.
    """

    id: int
    is_active: bool
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class UserWithPosts(UserPublic):
    """Extended user response that includes the user's blog posts."""

    posts: list["PostPublic"] = []

    model_config = ConfigDict(from_attributes=True)
