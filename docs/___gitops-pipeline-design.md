# GitOps Canary Promotion

> Dev to Prod. Auto-Promoted. Canary-Released

GitOps → signals ArgoCD, k8s, declarative
Canary → progressive delivery strategy, the differentiating skill
Promotion: multi-env pipeline; multi-repo

## Repo

### Infra Repo

- Repo Url: https://github.com/simonangel-fong/Project_GitOps_Infra_Repo.git
- Description: underlying AWS infrastructure (Terraform)
- Branches:
  - main
  - feature-\*
  - dev: dev environment
  - stage: stage environment
  - prod: prod environment
- Key Pipelines:
  - CI pipeline:
    - Cloud engineer commit feature-\* branch -> lint check, security scan -> notify
  - CD pipeline dev:
    - merge pr -> lint check, security scan -> provision dev/stage/prod environment -> notify app, infra, platform team

---

### Application Repo

- Repo Url: https://github.com/simonangel-fong/Project_GitOps_App_Repo.git
- Description: what to build (source code, Dockerfile, CI pipeline)
- Branches:
  - main
  - feature-\*
- Key Pipelines: trunk-based development
  - CI pipeline:
    - Developer commit to feature-\* branch -> run lint check, security scan, integration test, docker push
  - CD pipeline:
    - manual approval -> tag image -> commit to Platform repo -> notify app team and platform team

---

### Platform Repo

- Repo Url: https://github.com/simonangel-fong/Project_GitOps_Platform_Repo.git
- Description: how and where to deploy (kustomize overlays per env, ArgoCD Applications); manages dev / stage / prod manifests
- Branches:
  - main
  - feature-\*
  - dev: dev environment
  - stage: stage environment
  - prod: prod environment
- Pipelines:
  - CD pipeline dev: merge pr -> GitOps sync -> smoke test -> promote to stage
  - CD pipeline stage: merge pr -> GitOps sync -> smoke test -> load test -> promote to prod
  - CD pipeline prod: manual approval -> GitOps sync

---

## Pipeline Overview

### App Repo

```
feature-* branch
    │
    ▼ PR + code review
main branch
    │
    ├── CI pipeline: on every merge to main ─────────────────────────────────────────────┐
    │   lint → security scan → build (local) → integration test → push ECR               │
    │   tag: main-<n>-<sha>                                                              │
    │   → PR to platform overlays/dev/ (auto-merge recommended, no human gate)           │
    │                                                                                    │
    └── Release pipeline: on version tag v*.*.* ─────────────────────────────────────────┘
        → manual approval gate
        → push ECR (tag: v3.2.1, only the changed service)
        → PR to platform overlays/stage/ + overlays/prod/
```

### Platform Repo

```
commit from app repo CI (release pipeline): overlays/dev/
    ← ArgoCD auto-syncs dev cluster
    ← Canary deployment
    ← Post-sync smoke test
       pass → dev gate green (logged, notified) → opens stage PR
       fail → notification → #platform-alerts, git revert + re-sync

midnight cron job: overlays/stage/
    ← Auto Merge last stage PR
    ← ArgoCD syncs stage cluster
    ← Canary deployment
    ← Post-sync smoke test + load test
       pass → Platform CI opens prod PR
       fail → notification → #platform-alerts, morning summary to team
               git revert stage commit + re-sync

prod PR
    ← Human reviews & approves
    ← ArgoCD syncs prod cluster
    ← Argo Rollouts canary → AnalysisTemplate validates Prometheus metrics
       pass → full promotion to stable
       fail → automatic traffic revert to stable, notification → #platform-alerts
```
