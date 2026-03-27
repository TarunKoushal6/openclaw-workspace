FROM python:3.11-slim

# 1. Install necessary tools
RUN apt-get update && apt-get install -y \
    supervisor \
    curl \
    git \
    bash \
    xz-utils \
    tar \
    wget \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. Python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3. Code
COPY . .

# 4. Folders
RUN mkdir -p /var/log/supervisor /var/run/supervisor /etc/supervisor/conf.d ~/.openclaw ~/clawd \
    && chmod -R 777 /var/run /var/log

# 5. Pre-install Bot
RUN chmod +x install_moltbot_deps.sh && bash install_moltbot_deps.sh || echo "Pre-install done"

# 6. Master Supervisor config
RUN echo "[unix_http_server]" > /etc/supervisor/supervisord.conf && \
    echo "file=/var/run/supervisor.sock" >> /etc/supervisor/supervisord.conf && \
    echo "chmod=0777" >> /etc/supervisor/supervisord.conf && \
    echo "" >> /etc/supervisor/supervisord.conf && \
    echo "[supervisord]" >> /etc/supervisor/supervisord.conf && \
    echo "nodaemon=true" >> /etc/supervisor/supervisord.conf && \
    echo "user=root" >> /etc/supervisor/supervisord.conf && \
    echo "logfile=/var/log/supervisor/supervisord.log" >> /etc/supervisor/supervisord.conf && \
    echo "pidfile=/var/run/supervisord.pid" >> /etc/supervisor/supervisord.conf && \
    echo "" >> /etc/supervisor/supervisord.conf && \
    echo "[rpcinterface:supervisor]" >> /etc/supervisor/supervisord.conf && \
    echo "supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface" >> /etc/supervisor/supervisord.conf && \
    echo "" >> /etc/supervisor/supervisord.conf && \
    echo "[supervisorctl]" >> /etc/supervisor/supervisord.conf && \
    echo "serverurl=unix:///var/run/supervisor.sock" >> /etc/supervisor/supervisord.conf && \
    echo "" >> /etc/supervisor/supervisord.conf && \
    echo "[include]" >> /etc/supervisor/supervisord.conf && \
    echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf

# 7. ADD THE MISSING 'gateway' COMMAND HERE
RUN echo "[program:openclaw-gateway]" > /etc/supervisor/conf.d/openclaw-gateway.conf && \
    echo "command=bash /root/run_openclaw.sh gateway" >> /etc/supervisor/conf.d/openclaw-gateway.conf && \
    echo "autostart=false" >> /etc/supervisor/conf.d/openclaw-gateway.conf && \
    echo "autorestart=true" >> /etc/supervisor/conf.d/openclaw-gateway.conf && \
    echo "user=root" >> /etc/supervisor/conf.d/openclaw-gateway.conf && \
    echo "stdout_logfile=/dev/stdout" >> /etc/supervisor/conf.d/openclaw-gateway.conf && \
    echo "stdout_logfile_maxbytes=0" >> /etc/supervisor/conf.d/openclaw-gateway.conf && \
    echo "stderr_logfile=/dev/stderr" >> /etc/supervisor/conf.d/openclaw-gateway.conf && \
    echo "stderr_logfile_maxbytes=0" >> /etc/supervisor/conf.d/openclaw-gateway.conf

# 8. Add FastAPI backend to Supervisor
RUN echo "[program:backend]" > /etc/supervisor/conf.d/backend.conf && \
    echo "command=uvicorn server:app --host 0.0.0.0 --port 10000" >> /etc/supervisor/conf.d/backend.conf && \
    echo "autostart=true" >> /etc/supervisor/conf.d/backend.conf && \
    echo "autorestart=true" >> /etc/supervisor/conf.d/backend.conf && \
    echo "stdout_logfile=/dev/stdout" >> /etc/supervisor/conf.d/backend.conf && \
    echo "stdout_logfile_maxbytes=0" >> /etc/supervisor/conf.d/backend.conf && \
    echo "stderr_logfile=/dev/stderr" >> /etc/supervisor/conf.d/backend.conf && \
    echo "stderr_logfile_maxbytes=0" >> /etc/supervisor/conf.d/backend.conf

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
