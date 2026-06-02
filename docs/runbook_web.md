# Runbook - Project website

[Back](../README.md)

---

```sh
terraform -chdir=web/infra init -backend-config=backend.tfvars
terraform -chdir=web/infra fmt && terraform -chdir=web/infra validate

terraform -chdir=web/infra apply -auto-approve
# terraform -chdir=web/infra destroy -auto-approve
```
