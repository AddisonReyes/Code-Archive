"""
Post ORM model.

Maps to the ``posts`` table in PostgreSQL.
"""

from datetime import datetime, timezone

from sqlalchemy import Boolean, DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.session import Base


class Post(Base):
    """
    Represents a blog post written by a User.

    Columns
    -------
    id         : Primary key.
    title      : Short headline (max 255 chars).
    content    : Full body of the post (unlimited text).
    published  : Whether the post is publicly visible.
    author_id  : FK → users.id.  Deleting a user cascades to their posts.
    created_at : UTC timestamp set at insert time.
    updated_at : UTC timestamp refreshed on every update.
    """

    __tablename__ = "posts"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    title: Mapped[str] = mapped_column(String(255), nullable=False, index=True)
    content: Mapped[str] = mapped_column(Text, nullable=False)
    published: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    author_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False,
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False,
    )

    # Many posts → one author.  ``back_populates`` links to User.posts.
    author: Mapped["User"] = relationship("User", back_populates="posts")  # noqa: F821

    def __repr__(self) -> str:  # pragma: no cover
        return f"<Post id={self.id} title={self.title!r}>"
