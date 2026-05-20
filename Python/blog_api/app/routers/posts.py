from typing import cast

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.dependencies import get_current_user, get_db
from app.crud.post import create_post, delete_post, get_post_by_id, get_posts, update_post
from app.models.user import User
from app.schemas.post import PostCreate, PostPublic, PostUpdate

router = APIRouter(prefix="/posts", tags=["Posts"])


@router.get(
    "",
    response_model=list[PostPublic],
)
async def list_posts(
    skip: int = Query(default=0, ge=0),
    limit: int = Query(default=20, ge=1, le=100),
    db: AsyncSession = Depends(get_db),
) -> list[PostPublic]:
    posts = await get_posts(db, skip=skip, limit=limit, published_only=True)
    return cast(list[PostPublic], posts)


@router.post(
    "",
    response_model=PostPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create(
    payload: PostCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> PostPublic:
    post = await create_post(db, payload, author_id=current_user.id)
    return cast(PostPublic, post)


@router.get(
    "/{post_id}",
    response_model=PostPublic,
)
async def get_post(
    post_id: int,
    db: AsyncSession = Depends(get_db),
) -> PostPublic:
    post = await get_post_by_id(db, post_id)
    if not post:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Post not found.")
    return cast(PostPublic, post)


@router.put(
    "/{post_id}",
    response_model=PostPublic,
)
async def update(
    post_id: int,
    payload: PostUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> PostPublic:
    post = await get_post_by_id(db, post_id)
    if not post:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Post not found.")
    if post.author_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not allowed to edit this post.",
        )
    updated = await update_post(db, post, payload)
    return cast(PostPublic, updated)


@router.delete(
    "/{post_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete(
    post_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> None:
    post = await get_post_by_id(db, post_id)
    if not post:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Post not found.")
    if post.author_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not allowed to delete this post.",
        )
    await delete_post(db, post)
