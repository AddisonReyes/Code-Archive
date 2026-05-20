import os
import socket
import time
from urllib.parse import urlparse

from app.core.config import settings


def _database_host_port() -> tuple[str, int]:
    parsed = urlparse(settings.DATABASE_URL)
    return parsed.hostname or "localhost", parsed.port or 5432


def main() -> None:
    host, port = _database_host_port()
    timeout = int(os.getenv("DB_CONNECT_TIMEOUT", "60"))
    deadline = time.monotonic() + timeout
    last_error: OSError | None = None

    while time.monotonic() < deadline:
        try:
            with socket.create_connection((host, port), timeout=2):
                print(f"Database is reachable at {host}:{port}")
                return
        except OSError as exc:
            last_error = exc
            print(f"Waiting for database at {host}:{port}: {exc}", flush=True)
            time.sleep(2)

    raise SystemExit(
        f"Database was not reachable at {host}:{port} within {timeout}s: {last_error}"
    )


if __name__ == "__main__":
    main()
