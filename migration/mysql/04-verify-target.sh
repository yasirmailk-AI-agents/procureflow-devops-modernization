#!/usr/bin/env bash
set -Eeuo pipefail
POD="$(kubectl get pod -n procureflow-dev -l app=mysql -o jsonpath='{.items[0].metadata.name}')"
kubectl exec -n procureflow-dev "$POD" -- mysql -uroot -proot-dev-password -Nse \
  'SELECT COUNT(*) FROM legacy_procureflow.purchase_orders;'
