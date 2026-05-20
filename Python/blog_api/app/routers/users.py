from typing import cast

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.dependencies import get_current_user, get_db
from app.crud.user import delete_user, get_user_by_id, get_user_with_posts, update_user
from app.models.user import User
from app.schemas.user import UserPublic, UserUpdate, UserWithPosts

router = APIRouter(prefix="/users", tags=["Users"])


@router.get(
    "/me",
    response_model=UserWithPosts,
)
async def get_me(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> UserWithPosts:
    user = await get_user_with_posts(db, current_user.id)
    return cast(UserWithPosts, user)


@router.put(
    "/me",
    response_model=UserPublic,
)
async def update_me(
    payload: UserUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> UserPublic:
    updated = await update_user(db, current_user, payload)
    return cast(UserPublic, updated)


@router.delete(
    "/me",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_me(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> None:
    await delete_user(db, current_user)


@router.get(
    "/{user_id}",
    response_model=UserPublic,
)
async def get_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
) -> UserPublic:
    user = await get_user_by_id(db, user_id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found.")
    return cast(UserPublic, user)
