#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib/common.sh"

log "Checking required commands"
for cmd in docker kind kubectl helm curl jq git; do
  need "$cmd"
done

log "Checking Docker daemon"
docker info >/dev/null

log "Versions"
docker --version
kind version
kubectl version --client
helm version --short

log "Checking available memory"
awk '/MemTotal/ {printf "Memory: %.1f GiB\n", $2/1024/1024}' /proc/meminfo

log "Preflight passed"
