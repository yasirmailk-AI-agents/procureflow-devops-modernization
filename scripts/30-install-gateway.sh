#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib/common.sh"

log "Installing Envoy Gateway with Helm"
if [[ -n "${ENVOY_GATEWAY_VERSION:-}" ]]; then
  helm upgrade --install eg oci://docker.io/envoyproxy/gateway-helm \
    --version "${ENVOY_GATEWAY_VERSION}" \
    --namespace envoy-gateway-system --create-namespace
else
  helm upgrade --install eg oci://docker.io/envoyproxy/gateway-helm \
    --namespace envoy-gateway-system --create-namespace
fi

kubectl wait -n envoy-gateway-system \
  --for=condition=Available deployment/envoy-gateway --timeout=300s

kubectl apply -f "${ROOT_DIR}/platform/kubernetes/gateway/gatewayclass.yaml"
kubectl apply -f "${ROOT_DIR}/platform/kubernetes/gateway/gateway.yaml"

kubectl wait gatewayclass/envoy-gateway --for=condition=Accepted --timeout=180s
kubectl wait gateway/procureflow-gateway -n "${NAMESPACE}" \
  --for=condition=Programmed --timeout=300s

kubectl get gatewayclass envoy-gateway
kubectl get gateway procureflow-gateway -n "${NAMESPACE}" -o wide
log "Gateway control plane is ready"
