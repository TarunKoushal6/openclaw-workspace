#!/bin/bash
# Note: no `set -e` — gateway is best-effort; backend must always start.

echo "=== Starting OpenClaw Deployment ==="

mkdir -p /root/.openclaw /root/clawd

EMERGENT_API_BASE="${EMERGENT_BASE_URL:-https://api.freemodel.dev}"
case "${EMERGENT_API_BASE%/}" in
  */v1) ;;
  *) EMERGENT_API_BASE="${EMERGENT_API_BASE%/}/v1" ;;
esac

cat > /root/.openclaw/openclaw.json << CONF
{
  "gateway": {
    "mode": "local",
    "port": 18789,
    "bind": "loopback",
    "auth": {
      "mode": "token",
      "token": "${GATEWAY_TOKEN:-$(openssl rand -hex 32)}"
    },
    "controlUi": {
      "enabled": true,
      "allowInsecureAuth": true
    }
  },
  "models": {
    "mode": "merge",
    "providers": {
      "emergent-gpt": {
        "baseUrl": "${EMERGENT_API_BASE%/}/",
        "apiKey": "${LLM_KEY}",
        "api": "openai-completions",
        "models": [
          {
            "id": "gpt-5.5",
            "name": "GPT-5.5",
            "reasoning": true,
            "input": ["text"],
            "contextWindow": 400000,
            "maxTokens": 128000
          },
          {
            "id": "gpt-5.4",
            "name": "GPT-5.4",
            "reasoning": true,
            "input": ["text"],
            "contextWindow": 400000,
            "maxTokens": 128000
          },
          {
            "id": "gpt-5.4-mini",
            "name": "GPT-5.4 Mini",
            "input": ["text"],
            "contextWindow": 400000,
            "maxTokens": 128000
          },
          {
            "id": "gpt-5.3-codex",
            "name": "GPT-5.3 Codex",
            "input": ["text"],
            "contextWindow": 400000,
            "maxTokens": 128000
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "workspace": "/root/clawd",
      "model": {
        "primary": "emergent-gpt/gpt-5.5"
      },
      "models": {
        "emergent-gpt/gpt-5.5": {"alias": "gpt-5.5"},
        "emergent-gpt/gpt-5.4": {"alias": "gpt-5.4"},
        "emergent-gpt/gpt-5.4-mini": {"alias": "mini"},
        "emergent-gpt/gpt-5.3-codex": {"alias": "codex"}
      }
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "${TELEGRAM_BOT_TOKEN}",
      "dmPolicy": "pairing",
      "streaming": {
        "mode": "partial"
      }
    }
  }
}
CONF

echo "OpenClaw config written."

# Best-effort gateway start (don't block backend if it fails)
if command -v openclaw >/dev/null 2>&1; then
  echo "Starting OpenClaw gateway in background..."
  (openclaw gateway run >/tmp/openclaw-gateway.log 2>&1 &) || echo "gateway launch failed (non-fatal)"
  for i in $(seq 1 20); do
    if curl -fs http://127.0.0.1:18789/ >/dev/null 2>&1; then
      echo "Gateway ready."
      break
    fi
    sleep 1
  done
else
  echo "openclaw binary not found; skipping gateway."
fi

echo "Starting FastAPI backend on port ${PORT:-8001}..."
cd /app/backend
exec uvicorn server:app --host 0.0.0.0 --port ${PORT:-8001} --workers 1
