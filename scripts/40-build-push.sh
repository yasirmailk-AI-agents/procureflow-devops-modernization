#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib/common.sh"

services=(
  "frontend-nodejs:procureflow-frontend"
  "supplier-service-nodejs:supplier-service"
  "notification-worker-nodejs:notification-worker"
  "order-service-java:order-service"
  "approval-service-java:approval-service"
  "integration-runtime-java:integration-runtime"
)

for item in "${services[@]}"; do
  dir="${item%%:*}"
  image="${item##*:}"
  full="localhost:${REG_PORT}/${image}:${IMAGE_TAG}"
  log "Building ${full}"
  docker build -t "${full}" "${ROOT_DIR}/applications/${dir}"
  docker push "${full}"
done

curl -fsS "http://127.0.0.1:${REG_PORT}/v2/_catalog" | jq .
log "All images built and pushed"
