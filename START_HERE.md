# Start here

Run the project in this order:

```bash
cd procureflow-devops-modernization
cp .env.example .env
make preflight
make registry
make cluster
make storage
make gateway
make build
make deploy
make smoke
```

Then add optional layers one at a time:

```bash
make data
make observability
make argocd
make jenkins
```

Read these files before the interview:

1. `docs/IMPLEMENTATION_FLOW.md`
2. `docs/INTERVIEW_PITCH.md`
3. `docs/TROUBLESHOOTING.md`
4. `docs/manual/ProcureFlow_Implementation_Manual.pdf`

Important: `platform/argocd/application.yaml` contains `REPLACE_ME`; update it with your GitHub repository URL before applying the Argo CD Application.
