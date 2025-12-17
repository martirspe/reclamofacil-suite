# Complaints Book — Docker Dev Setup

This repo is now Dockerized for local development and testing on Windows.

## Prerequisites
- Docker Desktop (WSL2 backend recommended)
- Node not required locally; containers provide toolchains

## Services
- Client (Angular 16) → http://localhost:4200
- Server (Express + Sequelize) → http://localhost:3000
- MySQL 8 → localhost:3306
- Redis 7 → localhost:6379

## Quick Start
```bash
# From the repository root
docker-compose build
docker-compose up
```

## Notes
- Hot reload is enabled via bind mounts; edits in `complaints-book-client` and `complaints-book-server` reflect live.
- CORS allows `http://localhost:4200` by default; adjust `ALLOWED_ORIGINS` in `complaints-book-server/.env` or via compose.
- MySQL uses an empty root password for local dev (`MYSQL_ALLOW_EMPTY_PASSWORD=yes`) and creates `marrso_store`.
- Redis URL is configurable by `REDIS_URL` (defaults to `redis://localhost:6379`); compose sets it to `redis://redis:6379`.
- Uploads persist to the host via the `complaints-book-server/uploads` bind mount.

## Common Commands
```bash
# Rebuild after dependency changes
docker-compose build --no-cache

# Restart only one service
docker-compose up -d server

# Stop and remove containers
docker-compose down
```

## Seeding Sample Data
Run a dev seed to populate baseline data (document types, consumption types, claim types, and an admin user).

```bash
# Seed inside the server container
docker compose exec server npm run seed

# Override default admin credentials via env (optional)
# Example: set environment variables before running compose
# ADMIN_EMAIL=admin@local.test ADMIN_PASSWORD=changeme docker compose up -d
```

API checks after seeding:
```bash
curl http://localhost:3000/api/document_types
curl http://localhost:3000/api/consumption_types
curl http://localhost:3000/api/claim_types
```
