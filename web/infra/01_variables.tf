# variables.tf

variable "cloudflare_api_token" {
  description = "Cloudflare API token with Zone:DNS:Edit on the arguswatcher.net zone"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for arguswatcher.net"
  type        = string
}

variable "aws_acm_cert_arn" {
  description = "ACM certificate ARN in us-east-1 covering *.arguswatcher.net (CloudFront requires us-east-1)"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm:us-east-1:[0-9]{12}:certificate/", var.aws_acm_cert_arn))
    error_message = "aws_acm_cert_arn must be an ACM certificate ARN in us-east-1 (CloudFront requirement)."
  }
}
