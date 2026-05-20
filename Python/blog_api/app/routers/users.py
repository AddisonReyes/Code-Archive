"""
Users router.

Endpoints
---------
GET    /users/me      – Return the authenticated user's profile.
PUT    /users/me      – Update the authenticated user's profile.
DELETE /users/me      – Delete the authenticated user's account.
GET    /users/{id}    – Return a public profile by ID.
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.dependencies import get_current_user, get_db
from app.crud.user import delete_user, get_user_by_id, update_user
from app.models.user import User
from app.schemas.user import UserPublic, UserUpdate, UserWithPosts

router = APIRouter(prefix="/users", tags=["Users"])


@router.get(
    "/me",
    response_model=UserWithPosts,
    summary="Get my profile",
    description="Return the full profile of the currently authenticated user, including their posts.",
)
async def get_me(current_user: User = Depends(get_current_user)) -> UserWithPosts:
    return current_user  # type: ignore[return-value]


@router.put(
    "/me",
    response_model=UserPublic,
    summary="Update my profile",
    description=(
        "Partially update the authenticated user's email, username, or password. "
        "Only the fields provided in the request body will be changed."
    ),
)
async def update_me(
    payload: UserUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> UserPublic:
    updated = await update_user(db, current_user, payload)
    return updated  # type: ignore[return-value]


@router.delete(
    "/me",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete my account",
    description="Permanently delete the authenticated user's account and all their posts.",
)
async def delete_me(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> None:
    await delete_user(db, current_user)


@router.get(
    "/{user_id}",
    response_model=UserPublic,
    summary="Get a user by ID",
    description="Return the public profile of any user by their numeric ID.",
)
async def get_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
) -> UserPublic:
    user = await get_user_by_id(db, user_id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found.")
    return user  # type: ignore[return-value]
