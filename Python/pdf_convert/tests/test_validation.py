from __future__ import annotations

import asyncio
from io import BytesIO

import pytest
from starlette.datastructures import UploadFile

from app.services.file_service import (
    FileTooLargeError,
    generate_download_id,
    is_allowed_pdf_upload,
    safe_output_filename,
    save_upload_file,
    sanitize_filename,
    validate_download_id,
)


def test_rejects_non_pdf_extension_and_mime() -> None:
    assert not is_allowed_pdf_upload("nota.txt", "text/plain")
    assert not is_allowed_pdf_upload("nota.pdf", "text/plain")
    assert is_allowed_pdf_upload("nota.pdf", "application/pdf")


def test_sanitizes_filename_and_output_name() -> None:
    assert sanitize_filename("../mi archivo?.pdf") == "mi archivo_.pdf"
    assert safe_output_filename("../mi archivo?.pdf") == "mi archivo__comprimido.pdf"


def test_generates_unique_safe_download_ids() -> None:
    first = generate_download_id()
    second = generate_download_id()
    assert first != second
    assert validate_download_id(first)
    assert validate_download_id(second)
    assert not validate_download_id("../malicioso")


def test_rejects_file_larger_than_limit(tmp_path) -> None:  # noqa: ANN001
    upload = UploadFile(filename="grande.pdf", file=BytesIO(b"x" * 11))

    with pytest.raises(FileTooLargeError):
        asyncio.run(save_upload_file(upload, tmp_path / "grande.pdf", max_size_bytes=10))
