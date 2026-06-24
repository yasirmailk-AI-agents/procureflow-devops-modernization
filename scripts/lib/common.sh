#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [[ -f "${ROOT_DIR}/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "${ROOT_DIR}/.env"
  set +a
fi

CLUSTER_NAME="${CLUSTER_NAME:-procureflow}"
REG_NAME="${REG_NAME:-procureflow-registry}"
REG_PORT="${REG_PORT:-5001}"
NAMESPACE="${NAMESPACE:-procureflow-dev}"
IMAGE_TAG="${IMAGE_TAG:-1.0.0}"
HELM_RELEASE="${HELM_RELEASE:-procureflow}"

log() { printf '\n[%s] %s\n' "$(date +'%H:%M:%S')" "$*"; }
fail() { printf '\nERROR: %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"; }
