#!/usr/bin/env bash
set -euo pipefail

IMAGE="${IMAGE:-nginx:alpine}"
HOST_PORT="${HOST_PORT:-8080}"

NAME="nginx-smoke-${GITHUB_RUN_ID:-local}-${RANDOM}"

cleanup() {
  docker stop "$NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "Pulling image: $IMAGE"
docker pull "$IMAGE" >/dev/null

echo "Starting nginx container '$NAME' on http://localhost:${HOST_PORT}"
docker run -d --name "$NAME" --rm -p "${HOST_PORT}:80" "$IMAGE" >/dev/null

echo "Waiting for nginx to respond..."
for i in {1..30}; do
  if curl -fsS "http://localhost:${HOST_PORT}/" >/dev/null; then
    code="$(curl -sS -o /dev/null -w "%{http_code}" "http://localhost:${HOST_PORT}/")"
    echo "OK: nginx responded with HTTP $code"
    exit 0
  fi
  sleep 1
done

echo "ERROR: nginx did not become ready in time"
docker ps -a || true
docker logs "$NAME" || true
exit 1

