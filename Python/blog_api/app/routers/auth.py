"""
Authentication router.

Endpoints
---------
POST /auth/register  – Create a new user account.
POST /auth/login     – Exchange credentials for a JWT access token.
"""

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.dependencies import get_db
from app.core.security import create_access_token, verify_password
from app.crud.user import create_user, get_user_by_email, get_user_by_username
from app.schemas.token import Token
from app.schemas.user import UserCreate, UserPublic

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post(
    "/register",
    response_model=UserPublic,
    status_code=status.HTTP_201_CREATED,
    summary="Register a new account",
    description=(
        "Create a new user account with a unique email and username. "
        "The password is hashed with bcrypt before storage."
    ),
)
async def register(payload: UserCreate, db: AsyncSession = Depends(get_db)) -> UserPublic:
    # Reject duplicate email or username before trying to insert.
    if await get_user_by_email(db, payload.email):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="An account with this email already exists.",
        )
    if await get_user_by_username(db, payload.username):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="This username is already taken.",
        )

    user = await create_user(db, payload)
    return user  # type: ignore[return-value]


@router.post(
    "/login",
    response_model=Token,
    summary="Obtain a JWT access token",
    description=(
        "Exchange a valid email + password for a Bearer JWT access token. "
        "Include the token in the ``Authorization: Bearer <token>`` header "
        "to access protected endpoints."
    ),
)
async def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: AsyncSession = Depends(get_db),
) -> Token:
    # ``username`` field of the OAuth2 form is used as the email.
    user = await get_user_by_email(db, form_data.username)

    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This account is disabled.",
        )

    token = create_access_token(subject=user.id)
    return Token(access_token=token)
