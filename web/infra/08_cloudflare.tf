# ########################################
# Cloudflare DNS — DNS-only (grey cloud)
# ########################################
resource "cloudflare_dns_record" "site" {
  zone_id = var.cloudflare_zone_id
  name    = local.dns_domain
  content = aws_cloudfront_distribution.web_host.domain_name
  type    = "CNAME"
  ttl     = 1     # "Automatic"
  proxied = false # DNS-only — no Cloudflare proxy in front of CloudFront
  comment = "Managed by Terraform — points to CloudFront distribution"
}