#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [[ ! -f "package.json" ]]; then
  echo "[ERROR] package.json not found in this folder."
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "[ERROR] Node.js is not installed or not in PATH."
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "[ERROR] npm is not installed or not in PATH."
  exit 1
fi

if [[ ! -d "node_modules" ]]; then
  echo "Dependencies are missing. Running install..."
  npm install --no-fund --no-audit
fi

if [[ ! -f "shared/dist/index.js" ]]; then
  echo "Building shared package..."
  npm run build:shared
fi

kill_port() {
  local port="$1"
  local pids
  pids=$(lsof -ti "tcp:${port}" 2>/dev/null || true)
  if [[ -n "$pids" ]]; then
    echo "Stopping processes on port ${port}..."
    echo "$pids" | xargs kill -9 2>/dev/null || true
  fi
}

kill_port 3000
kill_port 5173

echo "Starting backend..."
osascript \
  -e 'tell application "Terminal"' \
  -e '  activate' \
  -e "  do script \"cd '$SCRIPT_DIR' && npm run dev:backend\"" \
  -e 'end tell'

sleep 5

echo "Starting frontend..."
osascript \
  -e 'tell application "Terminal"' \
  -e '  activate' \
  -e "  do script \"cd '$SCRIPT_DIR' && npm run dev:frontend\"" \
  -e 'end tell'

echo ""
echo "Project started successfully."
echo "Backend: http://localhost:3000"
echo "Swagger: http://localhost:3000/api/docs"
echo "Frontend: http://localhost:5173"
