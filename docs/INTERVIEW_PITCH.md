# Interview presentation

## Two-minute overview

I built ProcureFlow as a local modernization lab for a business-critical procurement platform. The baseline represents manually operated services and a stateful MySQL workload. I moved the delivery model to Docker, a local registry, multi-node kind Kubernetes, Helm, Envoy Gateway, Jenkins CI, and Argo CD GitOps. The platform includes Node.js and Java services, stateful migration, Kafka/RabbitMQ/Elasticsearch profiles, Prometheus-based observability, security controls, quotas, autoscaling, incident runbooks, and a controlled backup/restore flow.

## Senior design decisions

- Jenkins builds artifacts; Argo CD deploys approved Git state.
- Stateful workloads are assessed before migration rather than blindly moved.
- Backends are tested internally before Gateway routing.
- Resource controls and probes are part of the default chart.
- Failures are injected only after monitoring exists.
- Heavy local components are installed in profiles to protect workstation capacity.

## Live demo sequence

1. `kubectl get nodes`
2. `curl localhost:5001/v2/_catalog`
3. `helm list -n procureflow-dev`
4. `kubectl get deploy,po,svc,httproute -n procureflow-dev`
5. Show `Accepted=True` and `ResolvedRefs=True`
6. Port-forward Envoy and call application routes
7. Show Grafana or Prometheus metrics
8. Trigger one controlled incident and recover it
9. Show migration backup checksum and row-count validation
