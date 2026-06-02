# # ########################################
# # Cloudflare
# # ########################################
# resource "cloudflare_record" "cf_record" {
#   zone_id = var.cloudflare_zone_id
#   name    = local.dns_domain
#   content = aws_cloudfront_distribution.cloudfront_distribution.domain_name # cloudfront domain
#   type    = "CNAME"

#   ttl     = 1
#   proxied = true
# }
