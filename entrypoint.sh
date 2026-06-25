#!/usr/bin/env sh
set -e

# Collect static assets (admin/browsable API) for WhiteNoise to serve.
python manage.py collectstatic --noinput

# Apply database migrations on every boot (safe + idempotent).
python manage.py migrate --noinput

# Start the production WSGI server. $PORT is provided by the host platform.
exec gunicorn splitit.wsgi:application \
    --bind "0.0.0.0:${PORT:-8000}" \
    --workers "${WEB_CONCURRENCY:-3}" \
    --timeout 120
