FROM python:3.14-slim AS base

# Prevent Python from writing .pyc files and enable unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# System deps: build essentials for some wheels and postgres client libs (psycopg2)
RUN apt-get update \
  && apt-get install -y --no-install-recommends curl build-essential libpq-dev \
  && rm -rf /var/lib/apt/lists/*

# Install uv (fast Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

# Copy only dependency files first to leverage Docker layer caching
COPY pyproject.toml uv.lock ./

# Create a virtualenv and install dependencies
RUN uv sync --no-dev

# Copy the application code
COPY . .

# Expose FastAPI default port
EXPOSE 8000

# Ensure alembic uses psycopg2 for sync migrations at runtime (already handled in env.py)

# Entrypoint: run migrations, then start the server
CMD ["bash", "-lc", "uv run alembic upgrade head && uv run uvicorn main:app --host 0.0.0.0 --port 8000"]
