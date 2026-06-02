# 
output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the static site"
  value       = aws_s3_bucket.web_host_bucket.id
}

output "s3_website_url" {
  description = "Public URL of the S3 website endpoint (HTTP only)"
  value       = "http://${aws_s3_bucket_website_configuration.web_host_bucket.website_endpoint}"
}
