FROM python:3.11-slim

# Install necessary tools including supervisor and xz-utils
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

# Run the correct server file
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "10000"]
