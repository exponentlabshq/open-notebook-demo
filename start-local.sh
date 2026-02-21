#!/usr/bin/env bash
# start-local.sh — Launch Open Notebook locally (no Docker required)
# Starts: SurrealDB → API → Worker → Frontend

set -e

REPO="$(cd "$(dirname "$0")" && pwd)"
SURREAL="$HOME/.surrealdb/surreal-v2"
LOG_DIR="$REPO/data/logs"
mkdir -p "$LOG_DIR"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Open Notebook — Local Startup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── 1. SurrealDB ──────────────────────────────────────────
if lsof -i :8000 -t >/dev/null 2>&1; then
  echo "✅ SurrealDB already running on :8000"
else
  echo "📦 Starting SurrealDB..."
  "$SURREAL" start \
    --log info \
    --user root \
    --pass root \
    "rocksdb:$REPO/surreal_data/mydatabase.db" \
    > "$LOG_DIR/surrealdb.log" 2>&1 &
  echo $! > "$LOG_DIR/surrealdb.pid"
  echo "   Waiting for SurrealDB to be ready..."
  for i in $(seq 1 20); do
    if curl -sf http://127.0.0.1:8000/health >/dev/null 2>&1; then
      echo "✅ SurrealDB ready"
      break
    fi
    sleep 1
  done
fi

# ── 2. API ────────────────────────────────────────────────
if lsof -i :5055 -t >/dev/null 2>&1; then
  echo "✅ API already running on :5055"
else
  echo "🔧 Starting FastAPI backend..."
  cd "$REPO"
  uv run --env-file .env run_api.py \
    > "$LOG_DIR/api.log" 2>&1 &
  echo $! > "$LOG_DIR/api.pid"
  echo "   Waiting for API to be ready..."
  for i in $(seq 1 30); do
    if curl -sf http://127.0.0.1:5055/health >/dev/null 2>&1; then
      echo "✅ API ready"
      break
    fi
    sleep 1
  done
fi

# ── 3. Worker ─────────────────────────────────────────────
if pgrep -f "surreal-commands-worker" >/dev/null 2>&1; then
  echo "✅ Worker already running"
else
  echo "⚙️  Starting background worker..."
  cd "$REPO"
  uv run --env-file .env surreal-commands-worker --import-modules commands \
    > "$LOG_DIR/worker.log" 2>&1 &
  echo $! > "$LOG_DIR/worker.pid"
  sleep 2
  echo "✅ Worker started"
fi

# ── 4. Frontend ───────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  All backend services running."
echo ""
echo "  Frontend:  http://localhost:3000"
echo "  API:       http://localhost:5055"
echo "  API Docs:  http://localhost:5055/docs"
echo ""
echo "  Logs:      $LOG_DIR/"
echo "  Stop:      ./stop-local.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 Starting Next.js frontend (Ctrl+C to stop all)..."
cd "$REPO/frontend"
npm run dev
