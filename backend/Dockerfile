FROM python:3.11-slim

# Install necessary tools and create supervisor folders
RUN apt-get update && apt-get install -y \
    supervisor \
    curl \
    git \
    bash \
    xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/log/supervisor /var/run

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Run supervisor in background, wait 2 seconds, THEN start server
CMD ["bash", "-c", "supervisord -c /etc/supervisor/supervisord.conf & sleep 2 && uvicorn server:app --host 0.0.0.0 --port 10000"]
