#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_REPO="https://github.com/GuDong2003/xianyu-auto-reply-fix.git"
TARGET_DIR="vendor/xianyu-auto-reply-fix"

random_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -base64 32 | tr -d '\n'
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import secrets; print(secrets.token_urlsafe(32), end="")'
  else
    dd if=/dev/urandom bs=32 count=1 2>/dev/null | base64 | tr -d '\n'
  fi
}

replace_env_value() {
  local key="$1"
  local value="$2"
  if grep -q "^${key}=" .env; then
    sed -i.bak "s|^${key}=.*|${key}=${value}|" .env
    rm -f .env.bak
  else
    printf '\n%s=%s\n' "$key" "$value" >> .env
  fi
}

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
  replace_env_value "ADMIN_PASSWORD" "$(random_secret)"
  replace_env_value "JWT_SECRET_KEY" "$(random_secret)$(random_secret)"
  echo "Created .env with a random ADMIN_PASSWORD and JWT_SECRET_KEY."
  echo "Open .env to view or change the admin password before signing in."
fi

APP_PORT_VALUE="$(grep -E '^APP_PORT=' .env | head -n 1 | cut -d '=' -f2- || true)"
APP_PORT_VALUE="${APP_PORT_VALUE:-9000}"

echo "Done. Next steps:"
echo "  1. review .env"
echo "  2. docker compose up -d --build"
echo "  3. open http://localhost:${APP_PORT_VALUE}"
