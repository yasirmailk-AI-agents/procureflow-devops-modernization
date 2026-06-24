#!/usr/bin/env bash
set -Eeuo pipefail
source "$(dirname "$0")/lib/common.sh"

log "Adding Bitnami Helm repository"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

log "Installing PostgreSQL"
helm upgrade --install procureflow-postgresql bitnami/postgresql \
  --namespace "${NAMESPACE}" \
  --set auth.username=procureflow \
  --set auth.password=procureflow-dev-password \
  --set auth.database=procureflow \
  --set primary.persistence.size=1Gi \
  --set primary.resourcesPreset=none \
  --set primary.resources.requests.cpu=100m \
  --set primary.resources.requests.memory=256Mi \
  --set primary.resources.limits.cpu=500m \
  --set primary.resources.limits.memory=512Mi

log "Installing RabbitMQ"
helm upgrade --install procureflow-rabbitmq bitnami/rabbitmq \
  --namespace "${NAMESPACE}" \
  --set auth.username=procureflow \
  --set auth.password=procureflow-dev-password \
  --set persistence.size=1Gi \
  --set resourcesPreset=none \
  --set resources.requests.cpu=100m \
  --set resources.requests.memory=256Mi \
  --set resources.limits.cpu=500m \
  --set resources.limits.memory=768Mi

cat <<INFO
Optional heavy components are available through Docker Compose profiles:
  docker compose -f legacy-platform/docker-compose.yaml --profile messaging up -d kafka
  docker compose -f legacy-platform/docker-compose.yaml --profile search up -d elasticsearch
INFO
