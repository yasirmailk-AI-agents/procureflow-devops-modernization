#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib/common.sh"

log "Starting local registry ${REG_NAME} on localhost:${REG_PORT}"
if docker inspect "${REG_NAME}" >/dev/null 2>&1; then
  docker start "${REG_NAME}" >/dev/null || true
else
  docker run -d \
    --restart=always \
    -p "127.0.0.1:${REG_PORT}:5000" \
    --name "${REG_NAME}" \
    registry:2
fi

curl -fsS "http://127.0.0.1:${REG_PORT}/v2/" >/dev/null
log "Registry is reachable"
