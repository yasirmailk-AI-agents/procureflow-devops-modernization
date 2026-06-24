# Troubleshooting decision map

## ImagePullBackOff

```bash
kubectl describe pod <pod> -n procureflow-dev
curl -fsS http://localhost:5001/v2/_catalog | jq .
docker exec <kind-node> cat /etc/containerd/certs.d/localhost:5001/hosts.toml
```

## Gateway 404

```bash
kubectl describe httproute -n procureflow-dev
kubectl get endpoints -n procureflow-dev
kubectl run curl-debug --rm -i --restart=Never --image=curlimages/curl:8.12.1 -n procureflow-dev -- curl -v http://<service>/<path>
```

## Pod not Ready

```bash
kubectl get pod -n procureflow-dev
kubectl describe pod <pod> -n procureflow-dev
kubectl logs <pod> -n procureflow-dev --previous
```

## PVC Pending

```bash
kubectl get storageclass
kubectl describe pvc <pvc> -n procureflow-dev
kubectl get events -n procureflow-dev --sort-by=.lastTimestamp
```

## Quota rejected

```bash
kubectl describe resourcequota environment-budget -n procureflow-dev
kubectl describe limitrange container-defaults -n procureflow-dev
```
