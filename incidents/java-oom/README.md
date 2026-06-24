# Incident: Java OutOfMemory / OOMKilled

1. Lower `order-service` memory limit to `160Mi`.
2. Generate repeated large requests or add a controlled allocation endpoint in a test branch.
3. Observe `kubectl get pod`, `kubectl describe pod`, and restart count.
4. Confirm `Reason: OOMKilled` and exit code 137.
5. Roll back the values change.
6. Record cause, evidence, mitigation, and prevention.

Decision chain:

```text
Pod restarts -> describe shows OOMKilled -> compare heap and container limit -> rollback/right-size -> verify stable rollout
```
