#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib/common.sh"

log "Waiting for deployments"
kubectl wait -n "${NAMESPACE}" --for=condition=Available deployment --all --timeout=300s

log "Testing Services from inside the cluster"
for url in \
  http://procureflow-frontend/health \
  http://supplier-service/api/suppliers/health \
  http://order-service/api/orders/health \
  http://approval-service/api/approvals/health \
  http://integration-runtime/api/integration/health \
  http://notification-worker/api/notifications/health; do
  kubectl run "curl-$(date +%s%N | tail -c 7)" \
    --rm -i --restart=Never \
    --image=curlimages/curl:8.12.1 \
    -n "${NAMESPACE}" -- curl -fsS "$url"
done

log "Finding Envoy data-plane service"
ENV_NS="$(kubectl get svc -A -o json | jq -r '.items[] | select((.metadata.name | test("envoy")) and any(.spec.ports[]?; .port == 80)) | .metadata.namespace' | head -n1)"
ENV_SVC="$(kubectl get svc -A -o json | jq -r '.items[] | select((.metadata.name | test("envoy")) and any(.spec.ports[]?; .port == 80)) | .metadata.name' | head -n1)"
[[ -n "$ENV_NS" && -n "$ENV_SVC" ]] || fail "Could not find Envoy data-plane Service"

log "Port-forwarding ${ENV_NS}/${ENV_SVC}"
kubectl port-forward -n "$ENV_NS" "service/${ENV_SVC}" 18080:80 > /tmp/procureflow-port-forward.log 2>&1 &
PF_PID=$!
trap 'kill ${PF_PID} 2>/dev/null || true' EXIT
sleep 5

for path in / /api/suppliers /api/orders /api/approvals /api/integration /api/notifications; do
  printf 'Testing %-24s ' "$path"
  curl -fsS "http://127.0.0.1:18080${path}" >/dev/null
  echo OK
done

log "Gateway and service smoke tests passed"
