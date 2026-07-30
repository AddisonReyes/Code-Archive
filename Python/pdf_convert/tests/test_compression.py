from __future__ import annotations

import shutil
from pathlib import Path

import pytest

from app.services.ghostscript_service import (
    GhostscriptProfile,
    GhostscriptService,
    MissingGhostscriptError,
)
from app.services.pdf_compressor import AttemptResult, PdfCompressor


def test_reduction_percentage() -> None:
    assert PdfCompressor.calculate_reduction_percentage(2_000, 500) == 75.0
    assert PdfCompressor.calculate_reduction_percentage(0, 500) == 0.0


def test_selects_highest_quality_result_under_target(tmp_path: Path) -> None:
    attempts = [
        AttemptResult(tmp_path / "a.pdf", 800, "a", False, 0),
        AttemptResult(tmp_path / "b.pdf", 690, "b", True, 1),
        AttemptResult(tmp_path / "c.pdf", 600, "c", True, 2),
    ]
    selected = PdfCompressor._select_best_result(attempts, 700)
    assert selected is attempts[1]


def test_selects_smallest_when_target_is_not_reached(tmp_path: Path) -> None:
    attempts = [
        AttemptResult(tmp_path / "a.pdf", 900, "a", False, 0),
        AttemptResult(tmp_path / "b.pdf", 760, "b", False, 1),
        AttemptResult(tmp_path / "c.pdf", 820, "c", False, 2),
    ]
    selected = PdfCompressor._select_best_result(attempts, 700)
    assert selected is attempts[1]


def test_stops_when_target_is_reached(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    class FakeGhostscript:
        calls = 0

        def compress(self, input_path, output_path, profile, timeout_seconds):  # noqa: ANN001
            self.calls += 1
            output_path.write_bytes(b"x" * ([900, 640][self.calls - 1]))

    source = tmp_path / "source.pdf"
    source.write_bytes(b"x" * 1200)
    compressor = PdfCompressor(FakeGhostscript(), target_size_bytes=700, timeout_seconds=1)  # type: ignore[arg-type]
    monkeypatch.setattr(compressor, "_validate_output", lambda output_path, expected_page_count: True)
    monkeypatch.setattr(
        compressor,
        "_ghostscript_profiles",
        lambda: [
            GhostscriptProfile("first", 150, 80),
            GhostscriptProfile("second", 120, 70),
            GhostscriptProfile("third", 96, 60),
        ],
    )

    result = compressor.compress(source, tmp_path, expected_page_count=1)

    assert result.target_reached
    assert result.attempts == 2
    assert result.compressed_size == 640


def test_returns_smallest_when_target_is_not_reached(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    class FakeGhostscript:
        calls = 0

        def compress(self, input_path, output_path, profile, timeout_seconds):  # noqa: ANN001
            self.calls += 1
            output_path.write_bytes(b"x" * ([950, 820, 880][self.calls - 1]))

    source = tmp_path / "source.pdf"
    source.write_bytes(b"x" * 1200)
    compressor = PdfCompressor(FakeGhostscript(), target_size_bytes=700, timeout_seconds=1)  # type: ignore[arg-type]
    monkeypatch.setattr(compressor, "_validate_output", lambda output_path, expected_page_count: True)
    monkeypatch.setattr(compressor, "_raster_profiles", lambda: [])
    monkeypatch.setattr(
        compressor,
        "_ghostscript_profiles",
        lambda: [
            GhostscriptProfile("first", 150, 80),
            GhostscriptProfile("second", 120, 70),
            GhostscriptProfile("third", 96, 60),
        ],
    )

    result = compressor.compress(source, tmp_path, expected_page_count=1)

    assert not result.target_reached
    assert result.compressed_size == 820


def test_missing_ghostscript_error(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> None:
    monkeypatch.setattr(shutil, "which", lambda executable: None)
    service = GhostscriptService("gs-nope")

    with pytest.raises(MissingGhostscriptError):
        service.compress(
            tmp_path / "input.pdf",
            tmp_path / "output.pdf",
            GhostscriptProfile("test", 72, 50),
            timeout_seconds=1,
        )
