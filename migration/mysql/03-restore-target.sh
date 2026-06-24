#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
sha256sum -c "${ROOT}/backups/legacy_procureflow.sql.sha256"
POD="$(kubectl get pod -n procureflow-dev -l app=mysql -o jsonpath='{.items[0].metadata.name}')"
kubectl exec -i -n procureflow-dev "$POD" -- mysql -uroot -proot-dev-password legacy_procureflow \
  < "${ROOT}/backups/legacy_procureflow.sql"
