# ============= Stage 1: Build frontend =============
FROM node:22-slim AS frontend-builder

WORKDIR /frontend
COPY frontend/package.json frontend/yarn.lock* frontend/package-lock.json* ./
RUN if [ -f yarn.lock ]; then yarn install --frozen-lockfile; \
    elif [ -f package-lock.json ]; then npm ci; \
    else npm install; fi

COPY frontend/ ./
# Same-origin build — leave REACT_APP_BACKEND_URL empty so frontend uses relative URLs
ENV REACT_APP_BACKEND_URL=""
RUN npm run build


# ============= Stage 2: Runtime =============
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    xz-utils \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 (needed for openclaw CLI)
RUN curl -fsSL https://nodejs.org/dist/v22.22.0/node-v22.22.0-linux-x64.tar.xz -o /tmp/node.tar.xz \
    && mkdir -p /root/nodejs \
    && tar -xJf /tmp/node.tar.xz -C /root/nodejs --strip-components=1 \
    && rm /tmp/node.tar.xz

ENV PATH="/root/nodejs/bin:/root/.openclaw-bin:$PATH"

# Install OpenClaw
RUN npm install -g openclaw@latest \
    && mkdir -p /root/.openclaw-bin \
    && ln -sf /root/nodejs/bin/openclaw /root/.openclaw-bin/openclaw

# Create workspace
RUN mkdir -p /root/clawd /root/.openclaw

# Backend
WORKDIR /app
COPY backend/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ /app/backend/

# Copy built frontend from stage 1
COPY --from=frontend-builder /frontend/build /app/frontend/build
ENV FRONTEND_BUILD_DIR=/app/frontend/build

# Workspace files
COPY AGENTS.md SOUL.md TOOLS.md IDENTITY.md USER.md HEARTBEAT.md /root/clawd/
COPY memory/ /root/clawd/memory/

# Supervisor config (kept for reference; start.sh is the actual entrypoint)
COPY render-supervisord.conf /etc/supervisor/conf.d/app.conf

# Startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8001

CMD ["/app/start.sh"]
