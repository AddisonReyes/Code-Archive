from __future__ import annotations

import logging
import platform
import shutil
import subprocess
from dataclasses import dataclass
from pathlib import Path


logger = logging.getLogger(__name__)


class GhostscriptError(RuntimeError):
    """Base error for Ghostscript failures."""


class MissingGhostscriptError(GhostscriptError):
    """Raised when Ghostscript cannot be found."""


class GhostscriptExecutionError(GhostscriptError):
    """Raised when Ghostscript exits with an error."""


@dataclass(frozen=True)
class GhostscriptProfile:
    name: str
    dpi: int
    jpeg_quality: int
    grayscale: bool = False


class GhostscriptService:
    def __init__(self, executable: str | None = None) -> None:
        self.executable = executable or self._detect_executable()

    def compress(
        self,
        input_path: Path,
        output_path: Path,
        profile: GhostscriptProfile,
        timeout_seconds: int,
    ) -> None:
        executable = self._resolve_executable()
        args = self._build_args(executable, input_path, output_path, profile)
        logger.info("ghostscript_attempt", extra={"profile": profile.name, "dpi": profile.dpi})
        try:
            completed = subprocess.run(
                args,
                check=False,
                capture_output=True,
                text=True,
                timeout=timeout_seconds,
            )
        except FileNotFoundError as exc:
            raise MissingGhostscriptError("Ghostscript no esta instalado o no esta en el PATH.") from exc
        except subprocess.TimeoutExpired as exc:
            raise GhostscriptExecutionError("Ghostscript excedio el tiempo maximo permitido.") from exc

        if completed.returncode != 0:
            stderr = (completed.stderr or "").strip()
            logger.warning(
                "ghostscript_error",
                extra={"profile": profile.name, "returncode": completed.returncode, "stderr": stderr[:500]},
            )
            raise GhostscriptExecutionError("Ghostscript no pudo comprimir el archivo con esta configuracion.")

    def _resolve_executable(self) -> str:
        if shutil.which(self.executable):
            return self.executable
        raise MissingGhostscriptError("Ghostscript no esta instalado o no esta en el PATH.")

    @staticmethod
    def _detect_executable() -> str:
        if platform.system().lower().startswith("win"):
            for candidate in ("gswin64c", "gswin32c", "gs"):
                if shutil.which(candidate):
                    return candidate
            return "gswin64c"
        return "gs"

    @staticmethod
    def _build_args(
        executable: str,
        input_path: Path,
        output_path: Path,
        profile: GhostscriptProfile,
    ) -> list[str]:
        args = [
            executable,
            "-dSAFER",
            "-dBATCH",
            "-dNOPAUSE",
            "-sDEVICE=pdfwrite",
            "-dCompatibilityLevel=1.4",
            "-dDetectDuplicateImages=true",
            "-dCompressFonts=true",
            "-dSubsetFonts=true",
            "-dEmbedAllFonts=true",
            "-dAutoRotatePages=/None",
            "-dColorImageDownsampleType=/Bicubic",
            "-dGrayImageDownsampleType=/Bicubic",
            "-dMonoImageDownsampleType=/Subsample",
            "-dDownsampleColorImages=true",
            "-dDownsampleGrayImages=true",
            "-dDownsampleMonoImages=true",
            f"-dColorImageResolution={profile.dpi}",
            f"-dGrayImageResolution={profile.dpi}",
            f"-dMonoImageResolution={profile.dpi}",
            f"-dJPEGQ={profile.jpeg_quality}",
            f"-sOutputFile={output_path}",
        ]
        if profile.grayscale:
            args.extend(["-sColorConversionStrategy=Gray", "-dProcessColorModel=/DeviceGray"])
        args.append(str(input_path))
        return args
