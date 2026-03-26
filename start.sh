#!/bin/bash
set -e

echo "=== Starting OpenClaw Render Deployment ==="

# Setup OpenClaw config from environment variables
mkdir -p /root/.openclaw /root/clawd

# Create OpenClaw config
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
      "streaming": "partial"
    }
  }
}
CONF

echo "OpenClaw config created"

# Start OpenClaw gateway in background
echo "Starting OpenClaw gateway..."
openclaw gateway run &
GATEWAY_PID=$!

# Wait for gateway to be ready
echo "Waiting for gateway to start..."
for i in $(seq 1 60); do
    if curl -s http://127.0.0.1:18789/ > /dev/null 2>&1; then
        echo "Gateway is ready!"
        break
    fi
    sleep 2
done

# Start the FastAPI backend
echo "Starting backend..."
cd /app
exec uvicorn backend.server:app --host 0.0.0.0 --port ${PORT:-8001} --workers 1
