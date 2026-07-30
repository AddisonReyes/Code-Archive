from __future__ import annotations

import json
import logging
from fastapi import APIRouter, File, HTTPException, UploadFile
from fastapi.responses import FileResponse
from starlette.background import BackgroundTask

from app.config import get_settings
from app.services.file_service import (
    FileTooLargeError,
    PDFValidationError,
    cleanup_expired_files,
    cleanup_path,
    create_operation_dir,
    generate_download_id,
    is_allowed_pdf_upload,
    safe_output_filename,
    save_upload_file,
    sanitize_filename,
    validate_download_id,
    validate_pdf_file,
)
from app.services.ghostscript_service import GhostscriptService
from app.services.pdf_compressor import CompressionError, PdfCompressor


logger = logging.getLogger(__name__)
router = APIRouter(prefix="/api", tags=["compression"])
settings = get_settings()


@router.post("/compress")
async def compress_pdf(file: UploadFile = File(...)):
    cleanup_expired_files(settings.temp_dir, settings.file_expiration_minutes)

    original_filename = sanitize_filename(file.filename or "documento.pdf")
    if not is_allowed_pdf_upload(original_filename, file.content_type):
        raise HTTPException(
            status_code=400,
            detail="Solo se aceptan archivos PDF validos.",
        )

    download_id = generate_download_id()
    operation_dir = create_operation_dir(settings.temp_dir, download_id)
    input_path = operation_dir / "input.pdf"

    try:
        original_size = await save_upload_file(file, input_path, settings.max_upload_size_bytes)
        page_count = validate_pdf_file(input_path)

        compressor = PdfCompressor(
            ghostscript=GhostscriptService(settings.ghostscript_path),
            target_size_bytes=settings.target_size_bytes,
            timeout_seconds=settings.ghostscript_timeout_seconds,
        )
        result = compressor.compress(input_path, operation_dir, page_count)

        output_filename = safe_output_filename(original_filename)
        metadata = {
            "original_filename": original_filename,
            "output_filename": output_filename,
            "compressed_size": result.compressed_size,
            "target_reached": result.target_reached,
        }
        (operation_dir / "metadata.json").write_text(json.dumps(metadata), encoding="utf-8")

        for path in operation_dir.iterdir():
            if path.name not in {"result.pdf", "metadata.json"}:
                cleanup_path(path)

        return {
            "success": True,
            "target_reached": result.target_reached,
            "original_filename": original_filename,
            "output_filename": output_filename,
            "original_size": original_size,
            "compressed_size": result.compressed_size,
            "reduction_percentage": result.reduction_percentage,
            "download_id": download_id,
            "message": result.message,
        }
    except FileTooLargeError as exc:
        cleanup_path(operation_dir)
        raise HTTPException(status_code=413, detail=str(exc)) from exc
    except PDFValidationError as exc:
        cleanup_path(operation_dir)
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except CompressionError as exc:
        cleanup_path(operation_dir)
        logger.warning("compression_failed", extra={"download_id": download_id, "error": str(exc)})
        raise HTTPException(status_code=422, detail=str(exc)) from exc
    except Exception:
        cleanup_path(operation_dir)
        raise


@router.get("/download/{download_id}")
async def download_pdf(download_id: str):
    if not validate_download_id(download_id):
        raise HTTPException(status_code=404, detail="Archivo no encontrado.")

    cleanup_expired_files(settings.temp_dir, settings.file_expiration_minutes)
    operation_dir = (settings.temp_dir / download_id).resolve()
    result_path = operation_dir / "result.pdf"
    metadata_path = operation_dir / "metadata.json"

    if not result_path.exists() or not metadata_path.exists():
        raise HTTPException(status_code=404, detail="Archivo no encontrado o expirado.")

    try:
        metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        cleanup_path(operation_dir)
        raise HTTPException(status_code=404, detail="Archivo no encontrado.") from exc

    return FileResponse(
        result_path,
        media_type="application/pdf",
        filename=metadata.get("output_filename", "documento_comprimido.pdf"),
        background=BackgroundTask(cleanup_path, operation_dir),
    )
