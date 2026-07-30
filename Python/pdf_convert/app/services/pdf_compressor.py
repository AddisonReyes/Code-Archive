from __future__ import annotations

import logging
import shutil
from dataclasses import dataclass
from pathlib import Path

from app.services.file_service import validate_pdf_file
from app.services.ghostscript_service import (
    GhostscriptExecutionError,
    GhostscriptProfile,
    GhostscriptService,
    MissingGhostscriptError,
)


logger = logging.getLogger(__name__)


class CompressionError(RuntimeError):
    """Raised when no valid compressed PDF can be produced."""


@dataclass(frozen=True)
class AttemptResult:
    path: Path
    size: int
    profile_name: str
    target_reached: bool
    quality_rank: int


@dataclass(frozen=True)
class CompressionResult:
    output_path: Path
    compressed_size: int
    original_size: int
    target_reached: bool
    reduction_percentage: float
    attempts: int
    message: str


class PdfCompressor:
    MAX_ATTEMPTS = 14

    def __init__(
        self,
        ghostscript: GhostscriptService,
        target_size_bytes: int,
        timeout_seconds: int,
    ) -> None:
        self.ghostscript = ghostscript
        self.target_size_bytes = target_size_bytes
        self.timeout_seconds = timeout_seconds

    def compress(self, input_path: Path, work_dir: Path, expected_page_count: int) -> CompressionResult:
        original_size = input_path.stat().st_size
        attempts: list[AttemptResult] = []

        for quality_rank, profile in enumerate(self._ghostscript_profiles()):
            if len(attempts) >= self.MAX_ATTEMPTS:
                break
            output_path = work_dir / f"gs_{quality_rank:02d}.pdf"
            try:
                self.ghostscript.compress(input_path, output_path, profile, self.timeout_seconds)
            except MissingGhostscriptError:
                logger.warning("ghostscript_missing_falling_back_to_pymupdf")
                break
            except GhostscriptExecutionError:
                continue

            attempt = self._record_attempt(output_path, profile.name, quality_rank, expected_page_count)
            if attempt is None:
                continue
            attempts.append(attempt)
            if attempt.target_reached:
                return self._finalize(attempt, work_dir, original_size, len(attempts))

        for quality_rank, profile in enumerate(self._raster_profiles(), start=len(attempts)):
            if len(attempts) >= self.MAX_ATTEMPTS:
                break
            output_path = work_dir / f"raster_{quality_rank:02d}.pdf"
            try:
                self._rasterize_with_pymupdf(input_path, output_path, profile)
            except Exception:
                logger.exception("pymupdf_raster_attempt_failed", extra={"profile": profile.name})
                continue

            attempt = self._record_attempt(output_path, profile.name, quality_rank, expected_page_count)
            if attempt is None:
                continue
            attempts.append(attempt)
            if attempt.target_reached:
                return self._finalize(attempt, work_dir, original_size, len(attempts))

        best = self._select_best_result(attempts, self.target_size_bytes)
        if best is None:
            raise CompressionError("No fue posible generar un PDF comprimido valido.")
        return self._finalize(best, work_dir, original_size, len(attempts))

    @staticmethod
    def calculate_reduction_percentage(original_size: int, compressed_size: int) -> float:
        if original_size <= 0:
            return 0.0
        return round(max(0.0, (1 - compressed_size / original_size) * 100), 1)

    @staticmethod
    def _select_best_result(attempts: list[AttemptResult], target_size_bytes: int) -> AttemptResult | None:
        successful = [attempt for attempt in attempts if attempt.size <= target_size_bytes]
        if successful:
            return min(successful, key=lambda attempt: attempt.quality_rank)
        if attempts:
            return min(attempts, key=lambda attempt: attempt.size)
        return None

    def _record_attempt(
        self,
        output_path: Path,
        profile_name: str,
        quality_rank: int,
        expected_page_count: int,
    ) -> AttemptResult | None:
        if not output_path.exists() or output_path.stat().st_size == 0:
            return None
        if not self._validate_output(output_path, expected_page_count):
            return None
        size = output_path.stat().st_size
        return AttemptResult(
            path=output_path,
            size=size,
            profile_name=profile_name,
            target_reached=size <= self.target_size_bytes,
            quality_rank=quality_rank,
        )

    @staticmethod
    def _validate_output(output_path: Path, expected_page_count: int) -> bool:
        try:
            return validate_pdf_file(output_path) == expected_page_count
        except Exception:
            logger.warning("invalid_pdf_attempt", extra={"path": str(output_path)})
            return False

    def _finalize(
        self,
        attempt: AttemptResult,
        work_dir: Path,
        original_size: int,
        attempts_count: int,
    ) -> CompressionResult:
        final_path = work_dir / "result.pdf"
        if attempt.path != final_path:
            shutil.copy2(attempt.path, final_path)
        reduction = self.calculate_reduction_percentage(original_size, attempt.size)
        message = (
            "Objetivo alcanzado."
            if attempt.target_reached
            else "No fue posible alcanzar los 700 KB sin degradar mas la legibilidad."
        )
        return CompressionResult(
            output_path=final_path,
            compressed_size=attempt.size,
            original_size=original_size,
            target_reached=attempt.target_reached,
            reduction_percentage=reduction,
            attempts=attempts_count,
            message=message,
        )

    @staticmethod
    def _ghostscript_profiles() -> list[GhostscriptProfile]:
        return [
            GhostscriptProfile("moderada_150dpi", 150, 82),
            GhostscriptProfile("equilibrada_120dpi", 120, 74),
            GhostscriptProfile("compacta_96dpi", 96, 66),
            GhostscriptProfile("baja_72dpi", 72, 56),
            GhostscriptProfile("muy_baja_60dpi", 60, 46),
            GhostscriptProfile("minima_50dpi", 50, 36),
            GhostscriptProfile("gris_72dpi", 72, 50, grayscale=True),
            GhostscriptProfile("gris_60dpi", 60, 42, grayscale=True),
        ]

    @staticmethod
    def _raster_profiles() -> list[GhostscriptProfile]:
        return [
            GhostscriptProfile("raster_96dpi", 96, 62),
            GhostscriptProfile("raster_72dpi", 72, 52),
            GhostscriptProfile("raster_60dpi", 60, 42, grayscale=True),
            GhostscriptProfile("raster_50dpi", 50, 34, grayscale=True),
        ]

    @staticmethod
    def _rasterize_with_pymupdf(input_path: Path, output_path: Path, profile: GhostscriptProfile) -> None:
        import fitz

        zoom = profile.dpi / 72
        matrix = fitz.Matrix(zoom, zoom)
        colorspace = fitz.csGRAY if profile.grayscale else fitz.csRGB

        with fitz.open(input_path) as source:
            target = fitz.open()
            try:
                for page in source:
                    rect = page.rect
                    new_page = target.new_page(width=rect.width, height=rect.height)
                    pixmap = page.get_pixmap(matrix=matrix, alpha=False, colorspace=colorspace)
                    try:
                        image_bytes = pixmap.tobytes("jpeg", jpg_quality=profile.jpeg_quality)
                    except TypeError:
                        image_bytes = pixmap.tobytes("jpeg")
                    new_page.insert_image(new_page.rect, stream=image_bytes)
                target.save(output_path, garbage=4, deflate=True, clean=True)
            finally:
                target.close()
