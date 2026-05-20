"""
User ORM model.

Maps to the ``users`` table in PostgreSQL.
"""

from datetime import datetime, timezone

from sqlalchemy import Boolean, DateTime, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.session import Base


class User(Base):
    """
    Represents an account in the system.

    Columns
    -------
    id              : Primary key.
    email           : Unique email address used for login.
    username        : Unique display name.
    hashed_password : bcrypt hash — never store plain-text passwords.
    is_active       : Soft-disable an account without deleting it.
    created_at      : UTC timestamp set once at insert time.
    """

    __tablename__ = "users"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True, nullable=False)
    username: Mapped[str] = mapped_column(String(50), unique=True, index=True, nullable=False)
    hashed_password: Mapped[str] = mapped_column(String(255), nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False,
    )

    # One user → many posts.  ``back_populates`` links to Post.author.
    posts: Mapped[list["Post"]] = relationship(  # noqa: F821
        "Post", back_populates="author", cascade="all, delete-orphan"
    )

    def __repr__(self) -> str:  # pragma: no cover
        return f"<User id={self.id} username={self.username!r}>"
