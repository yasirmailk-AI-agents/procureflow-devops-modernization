#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
kubectl apply -f "${ROOT}/platform/kubernetes/stateful/mysql.yaml"
kubectl rollout status statefulset/mysql -n procureflow-dev --timeout=600s
