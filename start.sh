#!/bin/bash
# Note: no `set -e` — gateway is best-effort; backend must always start.

echo "=== Starting OpenClaw Deployment ==="

mkdir -p /root/.openclaw /root/clawd

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
        "baseUrl": "${EMERGENT_BASE_URL:-https://integrations.emergentagent.com/llm}/",
        "apiKey": "${LLM_KEY}",
        "api": "openai-completions",
        "models": [
          {
            "id": "gpt-5.2",
            "name": "GPT-5.2",
            "reasoning": true,
            "input": ["text"],
            "contextWindow": 400000,
            "maxTokens": 128000
          }
        ]
      },
      "emergent-claude": {
        "baseUrl": "${EMERGENT_BASE_URL:-https://integrations.emergentagent.com/llm}",
        "apiKey": "${LLM_KEY}",
        "api": "anthropic-messages",
        "authHeader": true,
        "models": [
          {
            "id": "claude-sonnet-4-6",
            "name": "Claude Sonnet 4.6",
            "input": ["text"],
            "contextWindow": 200000,
            "maxTokens": 64000
          },
          {
            "id": "claude-opus-4-6",
            "name": "Claude Opus 4.6",
            "input": ["text"],
            "contextWindow": 200000,
            "maxTokens": 64000
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "workspace": "/root/clawd",
      "model": {
        "primary": "emergent-claude/claude-opus-4-6"
      },
      "models": {
        "emergent-gpt/gpt-5.2": {"alias": "gpt-5.2"},
        "emergent-claude/claude-sonnet-4-6": {"alias": "sonnet"},
        "emergent-claude/claude-opus-4-6": {"alias": "opus"}
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

