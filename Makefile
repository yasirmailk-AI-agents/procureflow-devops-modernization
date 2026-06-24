SHELL := /usr/bin/env bash

.PHONY: preflight registry cluster storage gateway build lint render deploy smoke data observability argocd jenkins clean-app clean-cluster clean-all

preflight:
	./scripts/00-preflight.sh

registry:
	./scripts/10-registry-up.sh

cluster:
	./scripts/20-kind-up.sh

storage:
	./scripts/25-storage-smoke.sh

gateway:
	./scripts/30-install-gateway.sh

build:
	./scripts/40-build-push.sh

lint:
	helm lint platform/helm/procureflow -f platform/helm/procureflow/values.yaml

render:
	mkdir -p rendered
	helm template procureflow platform/helm/procureflow --namespace procureflow-dev -f platform/helm/procureflow/values.yaml > rendered/procureflow.yaml

deploy:
	./scripts/50-deploy-helm.sh

smoke:
	./scripts/60-smoke-test.sh

data:
	./scripts/35-install-data-platform.sh

observability:
	./scripts/70-install-observability.sh

argocd:
	./scripts/72-install-argocd.sh

jenkins:
	docker compose -f ci/jenkins/docker-compose.yaml up -d

clean-app:
	helm uninstall procureflow -n procureflow-dev || true

clean-cluster:
	./scripts/90-cleanup.sh cluster

clean-all:
	./scripts/90-cleanup.sh all
