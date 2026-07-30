from __future__ import annotations

import re
import shutil
import time
import uuid
from pathlib import Path

from fastapi import UploadFile


ALLOWED_MIME_TYPES = {"application/pdf", "application/x-pdf"}
DOWNLOAD_ID_PATTERN = re.compile(r"^[0-9a-f]{32}$")


class FileTooLargeError(ValueError):
    """Raised when an upload exceeds the configured limit."""


class PDFValidationError(ValueError):
    """Raised when a file cannot be treated as a valid PDF."""


def sanitize_filename(filename: str) -> str:
    name = Path(filename).name.strip() or "documento.pdf"
    name = re.sub(r"[^A-Za-z0-9._ -]", "_", name)
    name = re.sub(r"\s+", " ", name).strip(" .")
    if not name:
        name = "documento.pdf"
    return name[:160]


def safe_output_filename(original_filename: str) -> str:
    sanitized = sanitize_filename(original_filename)
    stem = Path(sanitized).stem or "documento"
    return f"{stem}_comprimido.pdf"


def generate_download_id() -> str:
    return uuid.uuid4().hex


def validate_download_id(download_id: str) -> bool:
    return bool(DOWNLOAD_ID_PATTERN.fullmatch(download_id))


def is_allowed_pdf_upload(filename: str, content_type: str | None) -> bool:
    return Path(filename).suffix.lower() == ".pdf" and content_type in ALLOWED_MIME_TYPES


def create_operation_dir(temp_dir: Path, download_id: str) -> Path:
    temp_dir.mkdir(parents=True, exist_ok=True)
    operation_dir = (temp_dir / download_id).resolve()
    operation_dir.mkdir(parents=False, exist_ok=False)
    return operation_dir


async def save_upload_file(upload_file: UploadFile, destination: Path, max_size_bytes: int) -> int:
    total = 0
    destination.parent.mkdir(parents=True, exist_ok=True)
    with destination.open("wb") as output:
        while True:
            chunk = await upload_file.read(1024 * 1024)
            if not chunk:
                break
            total += len(chunk)
            if total > max_size_bytes:
                output.close()
                cleanup_path(destination)
                max_mb = max_size_bytes // (1024 * 1024)
                raise FileTooLargeError(f"El archivo supera el limite de {max_mb} MB.")
            output.write(chunk)
    if total == 0:
        cleanup_path(destination)
        raise PDFValidationError("El archivo esta vacio.")
    return total


def validate_pdf_file(path: Path) -> int:
    with path.open("rb") as pdf_file:
        header = pdf_file.read(5)
    if header != b"%PDF-":
        raise PDFValidationError("El archivo no parece ser un PDF real.")

    try:
        import fitz

        with fitz.open(path) as document:
            if document.needs_pass:
                raise PDFValidationError("No se aceptan PDFs protegidos con contrasena.")
            page_count = document.page_count
            if page_count <= 0:
                raise PDFValidationError("El PDF no contiene paginas.")
            document.load_page(0)
            return page_count
    except PDFValidationError:
        raise
    except Exception as exc:
        raise PDFValidationError("El PDF esta corrupto o no se puede abrir.") from exc


def cleanup_path(path: Path) -> None:
    try:
        if path.is_dir():
            shutil.rmtree(path)
        elif path.exists():
            path.unlink()
    except FileNotFoundError:
        return


def cleanup_expired_files(temp_dir: Path, expiration_minutes: int) -> None:
    if not temp_dir.exists():
        return
    cutoff = time.time() - expiration_minutes * 60
    for path in temp_dir.iterdir():
        if path.name == ".gitkeep":
            continue
        try:
            if path.stat().st_mtime < cutoff:
                cleanup_path(path)
        except FileNotFoundError:
            continue
