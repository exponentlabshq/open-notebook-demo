#!/usr/bin/env bash
# stop-local.sh — Stop all Open Notebook local processes

REPO="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$REPO/data/logs"

echo "🛑 Stopping Open Notebook services..."

stop_pid() {
  local name="$1"
  local pidfile="$LOG_DIR/$2.pid"
  if [ -f "$pidfile" ]; then
    local pid=$(cat "$pidfile")
    if kill -0 "$pid" 2>/dev/null; then
      kill "$pid" && echo "  ✅ Stopped $name (pid $pid)"
    fi
    rm -f "$pidfile"
  fi
}

pkill -f "next dev"              2>/dev/null && echo "  ✅ Stopped Frontend" || true
pkill -f "surreal-commands-worker" 2>/dev/null && echo "  ✅ Stopped Worker"   || true
pkill -f "run_api.py"            2>/dev/null && echo "  ✅ Stopped API"      || true
pkill -f "uvicorn api.main:app"  2>/dev/null                                  || true
stop_pid "SurrealDB" "surrealdb"

echo "✅ All services stopped."
