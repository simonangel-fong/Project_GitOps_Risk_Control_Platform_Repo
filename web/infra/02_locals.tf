# locals.tf
locals {
  project    = "gitops"
  env        = "web"
  aws_region = "ca-central-1"
  dns_domain = "gitops.arguswatcher.net"
}
