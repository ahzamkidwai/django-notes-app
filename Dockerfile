# -------- Stage 1: Builder --------
FROM python:3.9-slim as builder

# Set working directory
WORKDIR /app/backend

# Install build dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first (for caching)
COPY requirements.txt .

# Install dependencies in a temporary directory
RUN pip install --upgrade pip && \
    pip install --prefix=/install mysqlclient && \
    pip install --prefix=/install -r requirements.txt

# -------- Stage 2: Final Image --------
FROM python:3.9-slim

WORKDIR /app/backend

# Copy installed packages from builder
COPY --from=builder /install /usr/local

# Copy the rest of the app
COPY . .

# Expose Django port
EXPOSE 8000

# Use CMD or ENTRYPOINT in docker-compose or later in this Dockerfile if needed
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
