#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib/common.sh"

log "Checking StorageClass"
kubectl get storageclass

log "Creating PVC and writer Pod"
kubectl apply -f "${ROOT_DIR}/platform/kubernetes/storage/storage-smoke.yaml"
kubectl wait --for=condition=Ready pod/storage-smoke -n "${NAMESPACE}" --timeout=180s
kubectl logs storage-smoke -n "${NAMESPACE}" | grep -q STORAGE_OK

log "Recreating Pod to prove persistence"
kubectl delete pod storage-smoke -n "${NAMESPACE}" --wait=true
kubectl apply -f "${ROOT_DIR}/platform/kubernetes/storage/storage-reader.yaml"
kubectl wait --for=condition=Ready pod/storage-reader -n "${NAMESPACE}" --timeout=180s
kubectl logs storage-reader -n "${NAMESPACE}" | grep -q STORAGE_OK

kubectl delete pod storage-reader -n "${NAMESPACE}"
kubectl delete pvc storage-smoke -n "${NAMESPACE}"
log "Persistent storage smoke test passed"
