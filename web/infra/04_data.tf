# data.tf

# AWS-managed CloudFront cache policy "CachingOptimized"
data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}
