# Incident: Gateway BackendNotFound

Change an HTTPRoute backend Service name to a nonexistent value. Observe `Accepted=True`, `ResolvedRefs=False`, `Reason=BackendNotFound`, and a Gateway 404. Restore the correct Service name and wait for `ResolvedRefs=True`.
