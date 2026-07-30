# Compresor de PDF

Aplicacion web en Python para subir un PDF y comprimirlo intentando que el resultado quede por debajo de 700 KB (`716800` bytes). El sistema prioriza conservar texto vectorial y estructura del documento; si no puede alcanzar el objetivo sin degradar demasiado la legibilidad, devuelve el archivo valido mas pequeno generado y muestra una advertencia.

## Caracteristicas

- Backend con FastAPI y Uvicorn.
- Frontend HTML, CSS y JavaScript puro renderizado con Jinja2.
- Carga por selector de archivo o drag and drop.
- Validacion de extension, MIME type, encabezado PDF y apertura con PyMuPDF.
- Limite configurable de carga, por defecto 50 MB.
- Compresion iterativa con Ghostscript.
- Fallback final con PyMuPDF para rasterizar paginas cuando Ghostscript no alcanza.
- Descarga mediante identificador UUID sin exponer rutas internas.
- Limpieza de archivos temporales por expiracion y despues de la descarga.
- Pruebas unitarias con pytest sin depender de Ghostscript instalado.
- Docker y Docker Compose con Ghostscript incluido.

## Requisitos

- Python 3.12.
- Ghostscript.
- Docker y Docker Compose, si prefieres ejecucion containerizada.

## Ejecucion con Docker

```bash
docker compose up --build
```

La aplicacion quedara disponible en:

```text
http://localhost:8000
```

## Instalacion manual en Windows

1. Instala Python 3.12.
2. Instala Ghostscript desde https://www.ghostscript.com/releases/gsdnld.html.
3. Asegurate de que `gswin64c` o `gswin32c` este en el `PATH`, o define `GHOSTSCRIPT_PATH`.
4. Crea y activa un entorno virtual:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Instalacion manual en Linux

```bash
python3.12 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
sudo apt-get update
sudo apt-get install ghostscript
uvicorn app.main:app --reload
```

## Variables de entorno

Copia `.env.example` a `.env` si quieres personalizar valores en ejecucion local.

```env
MAX_UPLOAD_SIZE_MB=50
TARGET_SIZE_BYTES=716800
FILE_EXPIRATION_MINUTES=30
GHOSTSCRIPT_TIMEOUT_SECONDS=120
GHOSTSCRIPT_PATH=gs
```

En Windows puedes usar, por ejemplo:

```env
GHOSTSCRIPT_PATH=gswin64c
```

## Comandos utiles

```bash
uvicorn app.main:app --reload
pytest
```

## Algoritmo de compresion

1. Guarda el PDF en una carpeta temporal unica por operacion.
2. Valida que el archivo tenga encabezado PDF, pueda abrirse con PyMuPDF y tenga paginas.
3. Ejecuta Ghostscript con perfiles progresivos: 150, 120, 96, 72, 60 y 50 DPI, ajustando calidad JPEG y resolucion de imagenes.
4. Valida cada resultado: debe abrirse correctamente y conservar la misma cantidad de paginas.
5. Detiene el proceso en el primer resultado que queda por debajo de `716800` bytes, porque los perfiles estan ordenados de mayor a menor calidad.
6. Si Ghostscript no alcanza el objetivo, aplica rasterizacion con PyMuPDF como ultimo recurso.
7. Si ningun intento cumple el objetivo, selecciona el PDF valido mas pequeno generado y comunica que no se pudo alcanzar la meta.

## Limitaciones tecnicas

No existe una forma honesta de garantizar que cualquier PDF quede por debajo de 700 KB. Documentos con muchas paginas, imagenes de alta densidad o contenido escaneado pueden superar ese limite incluso con baja calidad. La aplicacion no elimina paginas, no trunca el archivo, no falsifica el tamano y no devuelve PDFs corruptos para cumplir el objetivo.

## Seguridad y archivos temporales

- Los nombres internos se generan con UUID.
- El nombre original se sanitiza y nunca se usa como ruta interna.
- Ghostscript se ejecuta con `subprocess.run()` y lista de argumentos, sin `shell=True`.
- Se usan opciones como `-dSAFER`, `-dBATCH`, `-dNOPAUSE`, `pdfwrite`, compresion y subset de fuentes.
- Los archivos intermedios se eliminan al terminar.
- El resultado expira por fecha de modificacion y tambien se elimina despues de descargarlo.
- Para produccion se recomienda mover el procesamiento a Celery/RQ, usar Redis o almacenamiento externo, aplicar rate limiting y configurar antivirus o escaneo adicional si se reciben archivos de usuarios no confiables.
