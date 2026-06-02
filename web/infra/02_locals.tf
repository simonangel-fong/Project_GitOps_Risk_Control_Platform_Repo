# locals.tf
locals {
  project        = "gitops"
  env            = "web"
  aws_region     = "ca-central-1"
  aws_acm_region = "us-east-1"
  dns_domain     = "arguswatcher.net"

  tags = {}
}
