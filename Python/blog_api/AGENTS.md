AGENTS

Purpose
- Document guidance and rules for anyone (human or agent) collaborating on this FastAPI blog API.

Context
- Tech stack: FastAPI, SQLAlchemy (async) with asyncpg, PostgreSQL.
- Auth: JWT (Bearer) using python-jose and passlib[bcrypt].
- Migrations: Alembic (sync engine during migrations).
- Tooling: uv for dependency management and running commands.
- Containerization: Dockerfile and docker-compose (api + db) with automatic migrations on start.

Core Rules
- Follow best software engineering practices, write clean and maintainable code.
- Prefer minimal, targeted changes that solve the problem.
- Keep business logic separate from transport (routers) and persistence (CRUD/ORM).
- Validate input via Pydantic schemas; never expose sensitive fields (e.g., hashed passwords).
- Enforce authorization in routers; CRUD remains persistence-focused.
- Use async SQLAlchemy sessions for app runtime; let Alembic handle migrations synchronously.
- Keep configuration in `.env` and load via `pydantic-settings`.
- Write brief, useful comments only where code is not self-explanatory.
- Maintain consistent project structure (core, database, models, schemas, crud, routers).

Operational Guidance
- Before adding dependencies, consider if the standard library or existing packages suffice.
- For DB schema changes: update ORM models, generate Alembic revision with `--autogenerate`, review, then apply.
- For API changes: add/adjust Pydantic schemas, update routers, and wire them in `main.py`.
- For security-sensitive changes: prefer small diffs and add targeted tests if a test suite exists.

Commit Hygiene
- Keep commits focused and descriptive.
- Never commit secrets; `.env` stays local. Use `.env.example` to document required variables.

Local Development
- Run app: `uv run uvicorn main:app --reload`.
- Docker: `docker compose up` (migrations auto-apply).
