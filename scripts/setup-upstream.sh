#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_REPO="https://github.com/GuDong2003/xianyu-auto-reply-fix.git"
TARGET_DIR="vendor/xianyu-auto-reply-fix"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required. Please install git first."
  exit 1
fi

mkdir -p vendor data logs backups

if [ -d "$TARGET_DIR/.git" ]; then
  echo "Updating upstream project in $TARGET_DIR"
  git -C "$TARGET_DIR" pull --ff-only
else
  echo "Cloning upstream project into $TARGET_DIR"
  rm -rf "$TARGET_DIR"
  git clone --depth 1 "$UPSTREAM_REPO" "$TARGET_DIR"
fi

if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from .env.example. Edit ADMIN_PASSWORD and JWT_SECRET_KEY before starting."
fi

echo "Done. Next steps:"
echo "  1. edit .env"
echo "  2. docker compose up -d --build"
echo "  3. open http://localhost:${APP_PORT:-9000}"
