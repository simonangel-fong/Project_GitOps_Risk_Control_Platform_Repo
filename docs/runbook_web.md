# Runbook - Project website

[Back](../README.md)

---

```sh
terraform -chdir=web/infra init -backend-config=backend.tfvars -migrate-state
terraform -chdir=web/infra fmt && terraform -chdir=web/infra validate
terraform -chdir=web/infra plan

terraform -chdir=web/infra apply -auto-approve
# terraform -chdir=web/infra destroy -auto-approve

dig gitops.arguswatcher.net
curl -I https://gitops.arguswatcher.net
# HTTP/2 200
curl -I https://gitops.arguswatcher.net/does-not-exist
# HTTP/2 404
```
