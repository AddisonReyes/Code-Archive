"""
Pydantic schemas for the Post resource.

Schema hierarchy
----------------
PostBase    – shared fields (title, content, published).
PostCreate  – input for creating a new post.
PostUpdate  – optional fields for partial updates.
PostPublic  – response shape returned to API consumers.
"""

from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class PostBase(BaseModel):
    title: str = Field(..., min_length=1, max_length=255, description="Post headline.")
    content: str = Field(..., min_length=1, description="Full body of the post.")
    published: bool = Field(default=True, description="Whether the post is publicly visible.")


class PostCreate(PostBase):
    """Payload expected when creating a new post."""


class PostUpdate(BaseModel):
    """All fields are optional — only provided fields will be changed."""

    title: str | None = Field(default=None, min_length=1, max_length=255)
    content: str | None = Field(default=None, min_length=1)
    published: bool | None = None


class PostPublic(PostBase):
    """
    Post representation returned to API consumers.
    Includes server-generated fields (id, author_id, timestamps).
    """

    id: int
    author_id: int
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
