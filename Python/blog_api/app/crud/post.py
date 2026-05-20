"""
CRUD operations for the Post model.

All functions accept an ``AsyncSession`` and return ORM objects (or None).
Authorization checks (ownership) are enforced in the routers, not here.
"""

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.post import Post
from app.schemas.post import PostCreate, PostUpdate


# ---------------------------------------------------------------------------
# Read
# ---------------------------------------------------------------------------

async def get_post_by_id(db: AsyncSession, post_id: int) -> Post | None:
    """Return the Post with the given *post_id*, or None if not found."""
    result = await db.execute(select(Post).where(Post.id == post_id))
    return result.scalar_one_or_none()


async def get_posts(
    db: AsyncSession,
    skip: int = 0,
    limit: int = 20,
    published_only: bool = True,
) -> list[Post]:
    """
    Return a paginated list of posts.

    Parameters
    ----------
    skip:
        Number of records to skip (offset).
    limit:
        Maximum number of records to return.
    published_only:
        When True, only return posts where ``published=True``.
    """
    query = select(Post)
    if published_only:
        query = query.where(Post.published.is_(True))
    query = query.order_by(Post.created_at.desc()).offset(skip).limit(limit)
    result = await db.execute(query)
    return list(result.scalars().all())


async def get_posts_by_author(
    db: AsyncSession,
    author_id: int,
    skip: int = 0,
    limit: int = 20,
) -> list[Post]:
    """Return all posts (published or not) written by *author_id*."""
    result = await db.execute(
        select(Post)
        .where(Post.author_id == author_id)
        .order_by(Post.created_at.desc())
        .offset(skip)
        .limit(limit)
    )
    return list(result.scalars().all())


# ---------------------------------------------------------------------------
# Create
# ---------------------------------------------------------------------------

async def create_post(db: AsyncSession, payload: PostCreate, author_id: int) -> Post:
    """Insert a new Post row owned by *author_id*."""
    post = Post(**payload.model_dump(), author_id=author_id)
    db.add(post)
    await db.commit()
    await db.refresh(post)
    return post


# ---------------------------------------------------------------------------
# Update
# ---------------------------------------------------------------------------

async def update_post(db: AsyncSession, post: Post, payload: PostUpdate) -> Post:
    """
    Apply *payload* fields (only those that are not None) to *post*.

    Returns the updated Post instance.
    """
    for field, value in payload.model_dump(exclude_none=True).items():
        setattr(post, field, value)

    await db.commit()
    await db.refresh(post)
    return post


# ---------------------------------------------------------------------------
# Delete
# ---------------------------------------------------------------------------

async def delete_post(db: AsyncSession, post: Post) -> None:
    """Permanently delete *post*."""
    await db.delete(post)
    await db.commit()
