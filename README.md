# ProcureFlow DevOps Modernization — Local Enterprise Lab

A complete local DevOps/SRE portfolio project for modernizing a procurement platform from a legacy VM-style deployment to Kubernetes.

## What this repository demonstrates

- Node.js and Java 21 microservices
- Docker image build and local registry
- Multi-node Kubernetes using kind
- Helm packaging and environment values
- Gateway API with Envoy Gateway
- Jenkins CI and Argo CD GitOps separation
- PostgreSQL/MySQL stateful workload patterns
- Kafka, RabbitMQ, and Elasticsearch integration profiles
- Prometheus, Grafana, Loki, and Alertmanager installation paths
- Terraform and Ansible usage in a local environment
- ResourceQuota, LimitRange, NetworkPolicy, HPA, PDB, probes, and security contexts
- Backup, restore, migration, load testing, incidents, and runbooks

## Architecture flow

```text
Source code
    |
    v
Jenkins CI -> tests -> images -> localhost:5001 registry
    |
    v
Git values update
    |
    v
Argo CD -> Helm -> kind Kubernetes
    |
    +--> Envoy Gateway -> Node.js/Java services
    +--> PostgreSQL/MySQL
    +--> Kafka/RabbitMQ/Elasticsearch
    +--> Prometheus/Grafana/Loki
```

## Minimum local requirements

- WSL 2 Ubuntu or Linux
- Docker Engine or Docker Desktop with WSL integration
- kind
- kubectl
- Helm 3
- Git, curl, jq, make
- Recommended: 16 GB RAM for the core profile; 24–32 GB for all optional data and observability components

## Fast start

```bash
cp .env.example .env
make preflight
make registry
make cluster
make gateway
make build
make deploy
make smoke
```

The first build downloads Maven and npm dependencies, so internet access is required.

## Profiles

### Core profile

Runs the microservices, Gateway API, Helm release, quotas, and smoke tests.

### Data profile

Adds PostgreSQL, MySQL migration lab, RabbitMQ, Kafka, and Elasticsearch.

### Observability profile

Adds Prometheus, Grafana, Loki, and Alertmanager.

### GitOps profile

Adds Jenkins and Argo CD.

## Important directories

```text
applications/              application source and Dockerfiles
platform/kind/             kind cluster configuration
platform/kubernetes/       cluster foundations and optional workloads
platform/helm/             ProcureFlow application Helm chart
ci/                        Jenkins pipeline and helper scripts
platform/argocd/            Argo CD Application manifests
observability/             monitoring values, dashboards, and alerts
legacy-platform/           VM-style Docker Compose baseline
migration/                 backup/restore/cutover scripts
incidents/                 failure simulations and runbooks
scripts/                   ordered implementation scripts
docs/                      architecture and interview presentation notes
```

## Validation order

```text
Preflight passes
    -> local registry reachable
    -> kind cluster Ready
    -> storage smoke passes
    -> GatewayClass Accepted
    -> Gateway Programmed
    -> images available in registry
    -> Helm lint/render passes
    -> Kubernetes rollout succeeds
    -> service DNS passes
    -> Gateway routes pass
    -> observability and incident tests follow
```

## Cleanup

```bash
make clean-app
make clean-cluster
make clean-all
```

Read `docs/IMPLEMENTATION_FLOW.md` before executing the full lab.
