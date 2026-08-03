# PDF Compressor

Publish-ready FastAPI app for uploading a PDF and compressing it toward a 700 KB target (`716800` bytes). The compressor preserves vector text whenever possible, validates every generated result, and returns the smallest valid PDF when the target cannot be reached honestly.

The web UI supports English and Spanish. English is the default language.

## Features

- FastAPI backend with Uvicorn.
- HTML, CSS and vanilla JavaScript frontend rendered with Jinja2.
- Drag and drop or file picker upload.
- PDF-only validation by extension, MIME type, PDF header and PyMuPDF parsing.
- Configurable 50 MB upload limit.
- Iterative Ghostscript compression profiles.
- PyMuPDF rasterization fallback as a last resort.
- UUID-based download IDs with no internal paths exposed.
- Temporary files cleaned after download and by expiration.
- Railway-ready Docker deployment with `/health`.
- Unit tests that mock compression behavior and do not require Ghostscript.

## Local Run With Docker

```bash
docker compose up --build
```

Open the app at:

```text
http://localhost:8000
```

Do not open `http://0.0.0.0:8000` in a browser. `0.0.0.0` is a bind address used by the server/container, not a browser destination.

## Railway Deployment

Railway deploys this repository from the `Dockerfile`. The `railway.json` file sets the Dockerfile builder and configures `/health` as the deployment healthcheck.

1. Push this repository to GitHub.
2. In Railway, create a new project from the GitHub repository.
3. Railway should detect the `Dockerfile` automatically.
4. Keep `PORT` unset in Railway unless you explicitly want to override it; Railway injects `PORT` and the container listens on `0.0.0.0:$PORT`.
5. Configure optional variables if needed:

```env
MAX_UPLOAD_SIZE_MB=50
TARGET_SIZE_BYTES=716800
FILE_EXPIRATION_MINUTES=30
GHOSTSCRIPT_TIMEOUT_SECONDS=120
GHOSTSCRIPT_PATH=gs
```

6. Deploy and verify:

```text
https://your-service.up.railway.app/health
```

7. Open the Railway public domain in the browser.

Railway does not run `docker-compose.yml` directly. Compose is included for local development only.

## Manual Installation On Windows

1. Install Python 3.12.
2. Install Ghostscript from https://www.ghostscript.com/releases/gsdnld.html.
3. Ensure `gswin64c` or `gswin32c` is available in `PATH`, or set `GHOSTSCRIPT_PATH`.
4. Create and run the environment:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

Open:

```text
http://localhost:8000
```

## Manual Installation On Linux

```bash
python3.12 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
sudo apt-get update
sudo apt-get install ghostscript
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

## Environment Variables

```env
PORT=8000
MAX_UPLOAD_SIZE_MB=50
TARGET_SIZE_BYTES=716800
FILE_EXPIRATION_MINUTES=30
GHOSTSCRIPT_TIMEOUT_SECONDS=120
GHOSTSCRIPT_PATH=gs
```

- `PORT`: local server port. Railway provides this automatically.
- `MAX_UPLOAD_SIZE_MB`: maximum upload size.
- `TARGET_SIZE_BYTES`: compression goal in bytes.
- `FILE_EXPIRATION_MINUTES`: how long result files remain available.
- `GHOSTSCRIPT_TIMEOUT_SECONDS`: max time allowed for each Ghostscript process.
- `GHOSTSCRIPT_PATH`: override Ghostscript executable path.

Windows example:

```env
GHOSTSCRIPT_PATH=gswin64c
```

## API

- `GET /`: renders the web UI.
- `GET /health`: returns `{"status":"ok"}` for deployment healthchecks.
- `POST /api/compress`: accepts one PDF file as multipart form data.
- `GET /api/download/{download_id}`: downloads the compressed PDF.

`POST /api/compress` accepts `X-App-Language: en` or `X-App-Language: es`. Missing or invalid values fall back to English.

## Compression Algorithm

1. Store the upload in a unique temporary operation directory.
2. Validate PDF structure with PyMuPDF.
3. Run Ghostscript with progressively smaller image resolutions and JPEG quality.
4. Validate each output PDF and confirm the page count is unchanged.
5. Stop at the first valid result under `716800` bytes.
6. If Ghostscript cannot reach the target, rasterize pages with PyMuPDF as a last resort.
7. If no attempt reaches the target, return the smallest valid generated PDF and show a warning.

The app never deletes pages, truncates files, fakes sizes, adds watermarks or returns knowingly corrupt PDFs.

## Tests

```bash
pytest
```

Useful Docker checks:

```bash
docker compose config
docker build .
```

## Security Notes

- Internal paths are generated from UUIDs.
- Original filenames are sanitized and used only for download naming.
- Ghostscript runs with argument lists and never with `shell=True`.
- `-dSAFER`, `-dBATCH` and `-dNOPAUSE` are used.
- Temporary files are removed after download or expiration.
- File contents are not logged.

For production at larger scale, consider queue workers, object storage, rate limiting, antivirus scanning and external cleanup jobs. This MVP intentionally avoids Celery, Redis and persistent storage.

## Technical Limits

Not every PDF can be compressed below 700 KB while remaining readable. Large scanned documents, many-page files or image-heavy PDFs may stay above the target even at low quality. In those cases the app returns the smallest valid output and clearly reports that the target was not reached.
