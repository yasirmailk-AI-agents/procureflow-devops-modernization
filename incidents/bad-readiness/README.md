# Incident: Incorrect readiness path

Change a service readiness path to `/wrong-health`, deploy, and observe that the Pod runs but never becomes Ready. Validate with `kubectl describe pod`, test the endpoint directly, correct the path, and verify zero traffic was sent to the unready Pod.
