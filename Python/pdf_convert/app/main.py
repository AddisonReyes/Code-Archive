from __future__ import annotations

import logging

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles

from app.config import get_settings
from app.routes import compression, pages


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)

settings = get_settings()

app = FastAPI(title=settings.app_name)
app.mount("/static", StaticFiles(directory=settings.base_dir / "app" / "static"), name="static")
app.include_router(pages.router)
app.include_router(compression.router)


@app.exception_handler(Exception)
async def unexpected_error_handler(request: Request, exc: Exception) -> JSONResponse:
    logging.getLogger(__name__).exception("unexpected_error", extra={"path": request.url.path})
    return JSONResponse(
        status_code=500,
        content={"detail": "Ocurrio un error inesperado. Intentalo nuevamente."},
    )
