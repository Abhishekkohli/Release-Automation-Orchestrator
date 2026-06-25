FROM python:3.8-slim-bullseye

# Keep Python output unbuffered and skip .pyc files in the container.
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /splitit

# Build deps for psycopg2 (no arm64 wheel exists for the pinned version, so it
# is compiled from source). libpq-dev also provides the runtime libpq library.
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies first so this layer is cached across code changes.
COPY requirements.txt /splitit/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Django project source.
COPY ./splitit /splitit
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Hosts (Render/Railway/etc.) set $PORT; default to 8000 for local runs.
ENV PORT=8000
EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
