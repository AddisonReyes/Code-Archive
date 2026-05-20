# Blog API

A RESTful blog API built with **FastAPI**, **SQLAlchemy (async)**, and **PostgreSQL**.

---

## Features

- JWT authentication (register, login, protected routes)
- User accounts with profile management
- Blog post CRUD (create, read, update, delete)
- Ownership enforcement — only the post author can edit or delete
- Async database access via `asyncpg` + SQLAlchemy 2.0
- Database migrations via Alembic
- Auto-generated interactive docs (Swagger UI & ReDoc)

---

## Project Structure

```
blog_api/
├── main.py                     # FastAPI application entry point
├── alembic.ini                 # Alembic configuration
├── alembic/
│   ├── env.py                  # Migration environment setup
│   └── versions/               # Auto-generated migration files
└── app/
    ├── core/
    │   ├── config.py           # Settings loaded from .env
    │   ├── security.py         # Password hashing & JWT utilities
    │   └── dependencies.py     # Shared FastAPI dependencies
    ├── database/
    │   └── session.py          # Async engine, session factory, Base
    ├── models/
    │   ├── user.py             # User ORM model
    │   └── post.py             # Post ORM model
    ├── schemas/
    │   ├── token.py            # Token response schema
    │   ├── user.py             # User Pydantic schemas
    │   └── post.py             # Post Pydantic schemas
    ├── crud/
    │   ├── user.py             # DB operations for users
    │   └── post.py             # DB operations for posts
    └── routers/
        ├── auth.py             # /auth/register, /auth/login
        ├── users.py            # /users/me, /users/{id}
        └── posts.py            # /posts CRUD
```

---

## Setup

### Prerequisites

- Python 3.12+
- PostgreSQL running locally (or via Docker)
- [`uv`](https://github.com/astral-sh/uv) package manager

### 1. Clone & install dependencies

```bash
git clone <repo-url>
cd blog_api
uv sync
```

### 2. Configure environment

```bash
cp .env.example .env
```

Edit `.env` and set your `DATABASE_URL` and `SECRET_KEY`:

```
DATABASE_URL=postgresql+asyncpg://postgres:password@localhost:5432/blog_db
SECRET_KEY=<output of: openssl rand -hex 32>
```

### 3. Create the database

```bash
psql -U postgres -c "CREATE DATABASE blog_db;"
```

### 4. Run migrations

> Alembic uses `psycopg2` for migrations. Install it if you haven't:
> `uv add psycopg2-binary --dev`

```bash
# Generate the initial migration from your models
uv run alembic revision --autogenerate -m "initial tables"

# Apply migrations
uv run alembic upgrade head
```

### 5. Start the server

```bash
uv run uvicorn main:app --reload
```

The API is now running at `http://127.0.0.1:8000`.

---

## Run With Docker

### 1. Configure environment

Use `.env` for both local and Docker. When running via Docker Compose, the `DATABASE_URL` host must be `db` (the compose service name). If your `.env` currently uses `localhost`, either change it or rely on the override baked into `docker-compose.yml`.

Example `.env` for Docker:

```
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=blog_db

# Compose overrides the host to `db` automatically for the API container
DATABASE_URL=postgresql+asyncpg://postgres:postgres@db:5432/blog_db
SECRET_KEY=<output of: openssl rand -hex 32>
```

### 2. Build and run

```bash
docker compose build
docker compose up
```

The API will be available at `http://127.0.0.1:8000` and Postgres at `localhost:5432`.

On startup the container applies Alembic migrations automatically, then launches Uvicorn.

### Common Docker Tasks

```bash
# Run migrations manually (if ever needed)

# Create a new migration
docker compose run --rm api uv run alembic revision --autogenerate -m "change"

# Stop and remove containers
docker compose down

# Remove containers and volumes
docker compose down -v
```

---

## API Reference

Interactive documentation is auto-generated and available at:

| URL | Description |
|-----|-------------|
| `http://127.0.0.1:8000/docs` | Swagger UI |
| `http://127.0.0.1:8000/redoc` | ReDoc |

### Endpoints

#### Authentication

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/auth/register` | No | Create a new account |
| POST | `/auth/login` | No | Obtain a JWT access token |

#### Users

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/users/me` | Yes | Get my profile (with posts) |
| PUT | `/users/me` | Yes | Update my profile |
| DELETE | `/users/me` | Yes | Delete my account |
| GET | `/users/{id}` | No | Get a user's public profile |

#### Posts

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/posts` | No | List published posts |
| POST | `/posts` | Yes | Create a post |
| GET | `/posts/{id}` | No | Get a single post |
| PUT | `/posts/{id}` | Yes (owner) | Update a post |
| DELETE | `/posts/{id}` | Yes (owner) | Delete a post |

---

## Authentication Flow

1. **Register**: `POST /auth/register` with `email`, `username`, `password`.
2. **Login**: `POST /auth/login` with `username` (email) and `password` as form data. Receive a `Bearer` token.
3. **Use token**: Add `Authorization: Bearer <token>` header to protected requests.

---

## Database Migrations Workflow

```bash
# After changing a model, generate a new migration:
uv run alembic revision --autogenerate -m "describe your change"

# Apply pending migrations:
uv run alembic upgrade head

# Roll back one migration:
uv run alembic downgrade -1
```
