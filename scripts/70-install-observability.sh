#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib/common.sh"

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f "${ROOT_DIR}/observability/kube-prometheus-stack-values.yaml"

helm upgrade --install loki grafana/loki \
  --namespace monitoring \
  -f "${ROOT_DIR}/observability/loki-values.yaml"

kubectl wait -n monitoring --for=condition=Available deployment --all --timeout=600s
log "Observability stack installed"
