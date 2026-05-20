"""
Blog API – application entry point.

Run locally with:
    uv run uvicorn main:app --reload

Interactive API docs are available at:
    http://127.0.0.1:8000/docs   (Swagger UI)
    http://127.0.0.1:8000/redoc  (ReDoc)
"""

from fastapi import FastAPI

from app.core.config import settings
from app.routers import auth, posts, users

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description=settings.DESCRIPTION,
    # Swagger UI will show an "Authorize" button for Bearer JWT.
    openapi_tags=[
        {"name": "Authentication", "description": "Register and obtain JWT tokens."},
        {"name": "Users", "description": "User profile management."},
        {"name": "Posts", "description": "Blog post CRUD operations."},
    ],
)

# Register routers – each carries its own prefix and tags.
app.include_router(auth.router)
app.include_router(users.router)
app.include_router(posts.router)


@app.get("/", tags=["Health"], summary="Health check")
async def root() -> dict:
    """Return a simple liveness signal."""
    return {"status": "ok", "api": settings.PROJECT_NAME, "version": settings.VERSION}
