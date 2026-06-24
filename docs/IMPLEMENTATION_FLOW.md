# Connected implementation flow

## 1. Prove the workstation foundation

Run `make preflight` first because every later step depends on Docker, kind, kubectl, Helm, Git, curl, and jq. A failed prerequisite would create misleading downstream errors.

## 2. Start the registry before the cluster

The cluster nodes require containerd trust configuration pointing to the registry container. Therefore the registry must exist first, then the kind nodes can be connected and configured.

## 3. Create the cluster before deploying applications

The cluster creates the API server, scheduler, nodes, default StorageClass, and namespaces. Without these, Helm can render YAML but cannot perform server-side validation or deployment.

## 4. Prove storage before stateful workloads

The smoke PVC writes data, deletes the writer Pod, mounts the same claim in a reader Pod, and reads the old data. This proves data is independent from a Pod lifecycle before MySQL/PostgreSQL are introduced.

## 5. Install the Gateway controller before the GatewayClass

Gateway API CRDs only define resource schemas. Envoy Gateway provides the reconciliation controller. The controller accepts `GatewayClass`, programs `Gateway`, creates a data-plane Service, and processes `HTTPRoute` objects.

## 6. Build and push images before Helm deployment

The Deployment manifests only contain image references. If the registry does not contain those tags, Kubernetes produces `ImagePullBackOff`. Therefore build and registry verification must precede deployment.

## 7. Validate Helm in layers

```text
helm lint -> helm template -> kubectl dry-run=server -> helm upgrade --install
```

Each step validates a deeper layer: template syntax, rendered YAML, Kubernetes API compatibility, then actual rollout.

## 8. Test Service DNS before Gateway routing

A Gateway cannot fix a broken application or Service. Internal Service tests isolate the backend layer first. Once those pass, Gateway tests only validate route matching and Envoy forwarding.

## 9. Add stateful and messaging components after the stateless slice works

This keeps the first failure domain small. PostgreSQL, RabbitMQ, Kafka, Elasticsearch, backups, and migration introduce storage, credentials, readiness, and resource pressure. They should be added after the basic delivery path is stable.

## 10. Separate CI and CD

Jenkins tests, scans, builds, and publishes artifacts. Argo CD watches Git and reconciles deployment state. This creates an auditable handoff and prevents a CI server from becoming an uncontrolled production operator.

## 11. Add observability before failure simulations

Metrics, logs, alerts, and dashboards must exist before injecting failures. Otherwise incidents cannot demonstrate detection, evidence collection, or recovery time.

## 12. Finish with documented incidents

The portfolio becomes senior-level when it includes controlled failure, evidence, decisions, rollback, and preventive engineering—not only a successful deployment screenshot.
