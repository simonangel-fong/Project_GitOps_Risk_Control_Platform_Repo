# ########################################
# CloudFront Origin Access Control (OAC)
# ########################################
resource "aws_cloudfront_origin_access_control" "web_host" {
  name                              = "${local.project}-${local.env}-oac"
  description                       = "OAC for ${aws_s3_bucket.web_host.id}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ########################################
# CloudFront distribution
# ########################################
resource "aws_cloudfront_distribution" "web_host" {
  enabled = true
  aliases = [local.dns_domain]
  comment = "${local.project}-${local.env} static site"

  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  origin {
    origin_id                = "s3-${aws_s3_bucket.web_host.id}"
    domain_name              = aws_s3_bucket.web_host.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.web_host.id
  }

  default_cache_behavior {
    target_origin_id       = "s3-${aws_s3_bucket.web_host.id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id
  }

  # Map S3 403/404 to /404.html
  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 60
  }

  # S3 returns 403 (not 404) for missing objects when using OAC + REST endpoint
  custom_error_response {
    error_code            = 403
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 60
  }

  viewer_certificate {
    acm_certificate_arn      = var.aws_acm_cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
