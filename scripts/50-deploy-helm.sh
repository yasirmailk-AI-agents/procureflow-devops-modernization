#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib/common.sh"
CHART="${ROOT_DIR}/platform/helm/procureflow"

log "Linting Helm chart"
helm lint "${CHART}" -f "${CHART}/values.yaml"

log "Rendering and validating manifests"
mkdir -p "${ROOT_DIR}/rendered"
helm template "${HELM_RELEASE}" "${CHART}" \
  --namespace "${NAMESPACE}" \
  --set global.registry="localhost:${REG_PORT}" \
  --set global.imageTag="${IMAGE_TAG}" \
  -f "${CHART}/values.yaml" \
  > "${ROOT_DIR}/rendered/procureflow.yaml"

kubectl apply --dry-run=server -f "${ROOT_DIR}/rendered/procureflow.yaml"

log "Installing or upgrading release"
helm upgrade --install "${HELM_RELEASE}" "${CHART}" \
  --namespace "${NAMESPACE}" \
  --create-namespace \
  --set global.registry="localhost:${REG_PORT}" \
  --set global.imageTag="${IMAGE_TAG}" \
  -f "${CHART}/values.yaml" \
  --wait --timeout 10m

kubectl get deployment,service,httproute -n "${NAMESPACE}"
log "Helm deployment completed"
