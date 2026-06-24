#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib/common.sh"
MODE="${1:-cluster}"

helm uninstall "${HELM_RELEASE}" -n "${NAMESPACE}" 2>/dev/null || true

if [[ "$MODE" == "cluster" || "$MODE" == "all" ]]; then
  kind delete cluster --name "${CLUSTER_NAME}" || true
fi

if [[ "$MODE" == "all" ]]; then
  docker rm -f "${REG_NAME}" 2>/dev/null || true
  docker compose -f "${ROOT_DIR}/legacy-platform/docker-compose.yaml" down -v --remove-orphans || true
  docker compose -f "${ROOT_DIR}/ci/jenkins/docker-compose.yaml" down -v --remove-orphans || true
fi

log "Cleanup mode ${MODE} completed"
