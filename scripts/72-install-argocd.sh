#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib/common.sh"

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd --create-namespace \
  -f "${ROOT_DIR}/platform/argocd/values.yaml"

kubectl wait -n argocd --for=condition=Available deployment --all --timeout=600s
cat <<INFO
Argo CD installed. Update platform/argocd/application.yaml repoURL before applying it.
INFO
