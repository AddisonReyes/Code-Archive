from __future__ import annotations

import os
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent.parent


def _int_env(name: str, default: int) -> int:
    value = os.getenv(name)
    if value is None or value.strip() == "":
        return default
    try:
        return int(value)
    except ValueError as exc:
        raise ValueError(f"{name} debe ser un numero entero") from exc


@dataclass
class Settings:
    app_name: str = "PDF Compressor"
    base_dir: Path = BASE_DIR
    temp_dir: Path = BASE_DIR / "temp"
    max_upload_size_mb: int = 50
    target_size_bytes: int = 716_800
    file_expiration_minutes: int = 30
    ghostscript_timeout_seconds: int = 120
    ghostscript_path: str | None = None

    @property
    def max_upload_size_bytes(self) -> int:
        return self.max_upload_size_mb * 1024 * 1024


@lru_cache
def get_settings() -> Settings:
    temp_dir = Path(os.getenv("TEMP_DIR", str(BASE_DIR / "temp"))).resolve()
    return Settings(
        temp_dir=temp_dir,
        max_upload_size_mb=_int_env("MAX_UPLOAD_SIZE_MB", 50),
        target_size_bytes=_int_env("TARGET_SIZE_BYTES", 716_800),
        file_expiration_minutes=_int_env("FILE_EXPIRATION_MINUTES", 30),
        ghostscript_timeout_seconds=_int_env("GHOSTSCRIPT_TIMEOUT_SECONDS", 120),
        ghostscript_path=os.getenv("GHOSTSCRIPT_PATH") or None,
    )
