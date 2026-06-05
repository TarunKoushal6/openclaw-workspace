#!/bin/bash
# Note: no `set -e` — gateway is best-effort; backend must always start.

echo "=== Starting OpenClaw Deployment ==="

mkdir -p /root/.openclaw /root/clawd

EMERGENT_API_BASE="${EMERGENT_BASE_URL:-https://api.bluesminds.com/v1}"
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
      "bluesminds": {
        "baseUrl": "${EMERGENT_API_BASE%/}/",
        "apiKey": "${LLM_KEY}",
        "api": "openai-completions",
        "models": [
                    {
                              "id": "minimax-m2",
                              "name": "Minimax M2",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "minimax-m2.1",
                              "name": "Minimax M2.1",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "qwen3.6-27b",
                              "name": "Qwen3.6 27B",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "grok-4.20-0309-non-reasoning",
                              "name": "Grok 4.20 0309 Non Reasoning",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "MiniMax-M2.7",
                              "name": "Minimax M2.7",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "grok-4.20-fast",
                              "name": "Grok 4.20 Fast",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "gpt-4o-mini",
                              "name": "Gpt 4O Mini",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "accounts/fireworks/models/deepseek-v4-pro",
                              "name": "Accounts / Fireworks / Models / Deepseek V4 Pro",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "vllm-current",
                              "name": "Vllm Current",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "qwen/qwen3.5-397b-a17b",
                              "name": "Qwen / Qwen3.5 397B A17B",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "blackbox",
                              "name": "Blackbox",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "z-ai/glm-5.1",
                              "name": "Z Ai / Glm 5.1",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "fallback",
                              "name": "Fallback",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "gpt-5-chat",
                              "name": "Gpt 5 Chat",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "MiniMax-M2.1",
                              "name": "Minimax M2.1",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "openai/gpt-oss-120b",
                              "name": "Openai / Gpt Oss 120B",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "gemini-3.1-pro",
                              "name": "Gemini 3.1 Pro",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "stepfun-ai/step-3.5-flash",
                              "name": "Stepfun Ai / Step 3.5 Flash",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "MiniMax-M2",
                              "name": "Minimax M2",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "gpt-3.5-turbo-0613",
                              "name": "Gpt 3.5 Turbo 0613",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "gemini-3-flash-preview",
                              "name": "Gemini 3 Flash Preview",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "race:moonshotai/kimi-k2.5|qwen/qwen3.5-397b-a17b",
                              "name": "Race:Moonshotai / Kimi K2.5|Qwen / Qwen3.5 397B A17B",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "gpt-4o",
                              "name": "Gpt 4O",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "gemini-3.1-pro-preview",
                              "name": "Gemini 3.1 Pro Preview",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "qwen3.6-max-preview",
                              "name": "Qwen3.6 Max Preview",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "kimi-k2.5",
                              "name": "Kimi K2.5",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "minimaxai/minimax-m2.7",
                              "name": "Minimaxai / Minimax M2.7",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "MiniMax-M2.1-lightning",
                              "name": "Minimax M2.1 Lightning",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "multi-model",
                              "name": "Multi Model",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "qwen3.6-plus",
                              "name": "Qwen3.6 Plus",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "gemini-3.1-flash-lite-preview",
                              "name": "Gemini 3.1 Flash Lite Preview",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "glm-4.6",
                              "name": "Glm 4.6",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "gemini-3.5-flash",
                              "name": "Gemini 3.5 Flash",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000
                    },
                    {
                              "id": "moonshotai/kimi-k2.6",
                              "name": "Moonshotai / Kimi K2.6",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "gpt-5-nano",
                              "name": "Gpt 5 Nano",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    },
                    {
                              "id": "openai/zai-org/GLM-4.7",
                              "name": "Openai / Zai Org / Glm 4.7",
                              "input": [
                                        "text"
                              ],
                              "contextWindow": 128000,
                              "maxTokens": 32000,
                              "reasoning": true
                    }
          ]
      }
    }
  },
  "agents": {
    "defaults": {
      "workspace": "/root/clawd",
      "model": {
        "primary": "bluesminds/accounts/fireworks/models/deepseek-v4-pro"
      },
      "models": {
                "bluesminds/minimax-m2": {
                        "alias": "minimax-m2"
                },
                "bluesminds/minimax-m2.1": {
                        "alias": "minimax-m2-1"
                },
                "bluesminds/qwen3.6-27b": {
                        "alias": "qwen3-6-27b"
                },
                "bluesminds/grok-4.20-0309-non-reasoning": {
                        "alias": "grok-4-20-0309-non-reasoning"
                },
                "bluesminds/MiniMax-M2.7": {
                        "alias": "MiniMax-M2-7"
                },
                "bluesminds/grok-4.20-fast": {
                        "alias": "grok-4-20-fast"
                },
                "bluesminds/gpt-4o-mini": {
                        "alias": "gpt-4o-mini"
                },
                "bluesminds/accounts/fireworks/models/deepseek-v4-pro": {
                        "alias": "deepseek-v4-pro"
                },
                "bluesminds/vllm-current": {
                        "alias": "vllm-current"
                },
                "bluesminds/qwen/qwen3.5-397b-a17b": {
                        "alias": "qwen3-5-397b-a17b"
                },
                "bluesminds/blackbox": {
                        "alias": "blackbox"
                },
                "bluesminds/z-ai/glm-5.1": {
                        "alias": "glm-5-1"
                },
                "bluesminds/fallback": {
                        "alias": "fallback"
                },
                "bluesminds/gpt-5-chat": {
                        "alias": "gpt-5-chat"
                },
                "bluesminds/MiniMax-M2.1": {
                        "alias": "MiniMax-M2-1"
                },
                "bluesminds/openai/gpt-oss-120b": {
                        "alias": "gpt-oss-120b"
                },
                "bluesminds/accounts/fireworks/models/deepseek-v4-pro": {
                        "alias": "gemini-3-1-pro"
                },
                "bluesminds/stepfun-ai/step-3.5-flash": {
                        "alias": "step-3-5-flash"
                },
                "bluesminds/MiniMax-M2": {
                        "alias": "MiniMax-M2"
                },
                "bluesminds/gpt-3.5-turbo-0613": {
                        "alias": "gpt-3-5-turbo-0613"
                },
                "bluesminds/gemini-3-flash-preview": {
                        "alias": "gemini-3-flash-preview"
                },
                "bluesminds/race:moonshotai/kimi-k2.5|qwen/qwen3.5-397b-a17b": {
                        "alias": "qwen3-5-397b-a17b"
                },
                "bluesminds/gpt-4o": {
                        "alias": "gpt-4o"
                },
                "bluesminds/accounts/fireworks/models/deepseek-v4-pro-preview": {
                        "alias": "gemini-3-1-pro-preview"
                },
                "bluesminds/qwen3.6-max-preview": {
                        "alias": "qwen3-6-max-preview"
                },
                "bluesminds/kimi-k2.5": {
                        "alias": "kimi-k2-5"
                },
                "bluesminds/minimaxai/minimax-m2.7": {
                        "alias": "minimax-m2-7"
                },
                "bluesminds/MiniMax-M2.1-lightning": {
                        "alias": "MiniMax-M2-1-lightning"
                },
                "bluesminds/multi-model": {
                        "alias": "multi-model"
                },
                "bluesminds/qwen3.6-plus": {
                        "alias": "qwen3-6-plus"
                },
                "bluesminds/gemini-3.1-flash-lite-preview": {
                        "alias": "gemini-3-1-flash-lite-preview"
                },
                "bluesminds/glm-4.6": {
                        "alias": "glm-4-6"
                },
                "bluesminds/gemini-3.5-flash": {
                        "alias": "gemini-3-5-flash"
                },
                "bluesminds/moonshotai/kimi-k2.6": {
                        "alias": "kimi-k2-6"
                },
                "bluesminds/gpt-5-nano": {
                        "alias": "gpt-5-nano"
                },
                "bluesminds/openai/zai-org/GLM-4.7": {
                        "alias": "GLM-4-7"
                }
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
