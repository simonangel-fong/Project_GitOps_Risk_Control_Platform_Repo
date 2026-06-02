output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the static site"
  value       = aws_s3_bucket.web_host.id
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (use for cache invalidations)"
  value       = aws_cloudfront_distribution.web_host.id
}

output "cloudfront_domain_name" {
  description = "Default CloudFront domain (point your Cloudflare CNAME here)"
  value       = aws_cloudfront_distribution.web_host.domain_name
}

output "site_url" {
  description = "Public site URL"
  value       = "https://${local.dns_domain}"
}
