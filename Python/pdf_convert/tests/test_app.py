from __future__ import annotations

from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_health_check() -> None:
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_homepage_defaults_to_english() -> None:
    response = client.get("/")

    assert response.status_code == 200
    assert '<html lang="en">' in response.text
    assert "PDF Compressor" in response.text
    assert "Made by" in response.text


def test_compress_invalid_upload_defaults_to_english() -> None:
    response = client.post(
        "/api/compress",
        files={"file": ("note.txt", b"not a pdf", "text/plain")},
    )

    assert response.status_code == 400
    assert response.json()["detail"] == "Only valid PDF files are accepted."


def test_compress_invalid_upload_supports_spanish() -> None:
    response = client.post(
        "/api/compress",
        headers={"X-App-Language": "es"},
        files={"file": ("note.txt", b"not a pdf", "text/plain")},
    )

    assert response.status_code == 400
    assert response.json()["detail"] == "Solo se aceptan archivos PDF validos."


def test_invalid_language_falls_back_to_english() -> None:
    response = client.post(
        "/api/compress",
        headers={"X-App-Language": "fr"},
        files={"file": ("note.txt", b"not a pdf", "text/plain")},
    )

    assert response.status_code == 400
    assert response.json()["detail"] == "Only valid PDF files are accepted."
