#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib/common.sh"
CONFIG="${ROOT_DIR}/platform/kind/kind-config.yaml"

"${ROOT_DIR}/scripts/00-preflight.sh"
"${ROOT_DIR}/scripts/10-registry-up.sh"

if kind get clusters | grep -qx "${CLUSTER_NAME}"; then
  log "kind cluster ${CLUSTER_NAME} already exists"
else
  log "Creating kind cluster ${CLUSTER_NAME}"
  kind create cluster --name "${CLUSTER_NAME}" --config "${CONFIG}"
fi

if ! docker network inspect kind --format '{{json .Containers}}' | grep -q "${REG_NAME}"; then
  docker network connect kind "${REG_NAME}"
fi

for node in $(kind get nodes --name "${CLUSTER_NAME}"); do
  REGISTRY_DIR="/etc/containerd/certs.d/localhost:${REG_PORT}"
  docker exec "$node" mkdir -p "$REGISTRY_DIR"
  cat <<HOSTS | docker exec -i "$node" tee "$REGISTRY_DIR/hosts.toml" >/dev/null
server = "http://${REG_NAME}:5000"

[host."http://${REG_NAME}:5000"]
  capabilities = ["pull", "resolve", "push"]
HOSTS
done

kubectl apply -f "${ROOT_DIR}/platform/kubernetes/base/namespaces.yaml"
kubectl apply -f "${ROOT_DIR}/platform/kubernetes/base/resource-quotas.yaml"

kubectl wait --for=condition=Ready nodes --all --timeout=180s
kubectl get nodes -o wide
log "Cluster foundation is ready"
