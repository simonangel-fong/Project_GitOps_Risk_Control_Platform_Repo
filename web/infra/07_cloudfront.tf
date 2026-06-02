

# # ########################################
# # AWS Cloudfront
# # ########################################
# resource "aws_cloudfront_distribution" "cloudfront_distribution" {

#   # distribution origins
#   origin {
#     domain_name = aws_s3_bucket_website_configuration.website_config.website_endpoint
#     # identifier for the origin
#     origin_id = "cloudfront-s3-${local.project}"

#     custom_origin_config {
#       http_port              = 80
#       https_port             = 443
#       origin_protocol_policy = "http-only" # S3 static hosting only supports HTTP
#       origin_ssl_protocols   = ["TLSv1.2"]
#     }
#   }

#   # Default cache behavior 
#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = "cloudfront-s3-${local.project}"

#     viewer_protocol_policy = "redirect-to-https"

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#   }

#   # SSL configuration
#   viewer_certificate {
#     acm_certificate_arn      = var.aws_acm_cert_arn # refer imported certification
#     ssl_support_method       = "sni-only"
#     minimum_protocol_version = "TLSv1.2_2021"
#   }

#   # restriction configuration 
#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   price_class         = "PriceClass_100"
#   aliases             = [local.dns_domain]
#   default_root_object = "index.html"

#   # enabled to accept end user requests
#   enabled = true

#   tags = {
#     Name = "Project-${local.project}-${local.env}"
#   }
# }

