from __future__ import annotations


DEFAULT_LANGUAGE = "en"
SUPPORTED_LANGUAGES = {"en", "es"}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": {
        "error.empty_file": "The file is empty.",
        "error.file_too_large": "The file exceeds the {max_mb} MB limit.",
        "error.invalid_download": "File not found.",
        "error.invalid_json": "File not found.",
        "error.invalid_pdf": "The file does not appear to be a real PDF.",
        "error.invalid_upload": "Only valid PDF files are accepted.",
        "error.no_valid_compressed_pdf": "A valid compressed PDF could not be generated.",
        "error.not_found_or_expired": "File not found or expired.",
        "error.pdf_corrupt": "The PDF is corrupt or cannot be opened.",
        "error.pdf_no_pages": "The PDF does not contain pages.",
        "error.pdf_password": "Password-protected PDFs are not accepted.",
        "error.unexpected": "An unexpected error occurred. Please try again.",
        "result.target_not_reached": "It was not possible to reach 700 KB without degrading readability further.",
        "result.target_reached": "Target reached.",
    },
    "es": {
        "error.empty_file": "El archivo esta vacio.",
        "error.file_too_large": "El archivo supera el limite de {max_mb} MB.",
        "error.invalid_download": "Archivo no encontrado.",
        "error.invalid_json": "Archivo no encontrado.",
        "error.invalid_pdf": "El archivo no parece ser un PDF real.",
        "error.invalid_upload": "Solo se aceptan archivos PDF validos.",
        "error.no_valid_compressed_pdf": "No fue posible generar un PDF comprimido valido.",
        "error.not_found_or_expired": "Archivo no encontrado o expirado.",
        "error.pdf_corrupt": "El PDF esta corrupto o no se puede abrir.",
        "error.pdf_no_pages": "El PDF no contiene paginas.",
        "error.pdf_password": "No se aceptan PDFs protegidos con contrasena.",
        "error.unexpected": "Ocurrio un error inesperado. Intentalo nuevamente.",
        "result.target_not_reached": "No fue posible alcanzar los 700 KB sin degradar mas la legibilidad.",
        "result.target_reached": "Objetivo alcanzado.",
    },
}

PDF_VALIDATION_MESSAGE_KEYS = {
    "El archivo esta vacio.": "error.empty_file",
    "El archivo no parece ser un PDF real.": "error.invalid_pdf",
    "No se aceptan PDFs protegidos con contrasena.": "error.pdf_password",
    "El PDF no contiene paginas.": "error.pdf_no_pages",
    "El PDF esta corrupto o no se puede abrir.": "error.pdf_corrupt",
}


def normalize_language(language: str | None) -> str:
    if not language:
        return DEFAULT_LANGUAGE
    normalized = language.strip().lower().split(",", maxsplit=1)[0]
    return normalized if normalized in SUPPORTED_LANGUAGES else DEFAULT_LANGUAGE


def translate(key: str, language: str | None = None, **values: object) -> str:
    lang = normalize_language(language)
    template = TRANSLATIONS.get(lang, TRANSLATIONS[DEFAULT_LANGUAGE]).get(key, key)
    return template.format(**values)


def pdf_validation_key(message: str) -> str:
    return PDF_VALIDATION_MESSAGE_KEYS.get(message, "error.pdf_corrupt")
