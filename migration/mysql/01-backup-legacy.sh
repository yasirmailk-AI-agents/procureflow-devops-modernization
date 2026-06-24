#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
mkdir -p "${ROOT}/backups"
docker compose -f "${ROOT}/legacy-platform/docker-compose.yaml" exec -T mysql \
  mysqldump -uroot -proot-dev-password --single-transaction legacy_procureflow \
  > "${ROOT}/backups/legacy_procureflow.sql"
sha256sum "${ROOT}/backups/legacy_procureflow.sql" | tee "${ROOT}/backups/legacy_procureflow.sql.sha256"
