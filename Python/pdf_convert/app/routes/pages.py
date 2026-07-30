from __future__ import annotations

from fastapi import APIRouter, Request
from fastapi.templating import Jinja2Templates

from app.config import get_settings


settings = get_settings()
templates = Jinja2Templates(directory=settings.base_dir / "app" / "templates")
router = APIRouter()


@router.get("/")
async def index(request: Request):
    return templates.TemplateResponse(
        "index.html",
        {
            "request": request,
            "max_upload_size_mb": settings.max_upload_size_mb,
            "target_size_kb": settings.target_size_bytes // 1024,
        },
    )
