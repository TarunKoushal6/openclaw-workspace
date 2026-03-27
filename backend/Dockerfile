FROM python:3.11-slim

# Install necessary tools
RUN apt-get update && apt-get install -y \
    supervisor \
    curl \
    git \
    bash \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# PRE-INSTALL BOT: Download heavy files during build to avoid browser timeout
RUN bash install_moltbot_deps.sh || echo "Installation script finished"

# Configure supervisor to run uvicorn server
RUN echo "[program:uvicorn]" > /etc/supervisor/conf.d/uvicorn.conf && \
    echo "command=uvicorn server:app --host 0.0.0.0 --port 10000" >> /etc/supervisor/conf.d/uvicorn.conf && \
    echo "autostart=true" >> /etc/supervisor/conf.d/uvicorn.conf && \
    echo "autorestart=true" >> /etc/supervisor/conf.d/uvicorn.conf && \
    echo "stderr_logfile=/dev/stderr" >> /etc/supervisor/conf.d/uvicorn.conf && \
    echo "stderr_logfile_maxbytes=0" >> /etc/supervisor/conf.d/uvicorn.conf && \
    echo "stdout_logfile=/dev/stdout" >> /etc/supervisor/conf.d/uvicorn.conf && \
    echo "stdout_logfile_maxbytes=0" >> /etc/supervisor/conf.d/uvicorn.conf

# Start supervisor as the main process
CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
