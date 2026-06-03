# ########################################
# Bucket name suffix
# ########################################
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# ########################################
# AWS S3 bucket for static web host
# ########################################
resource "aws_s3_bucket" "web_host" {
  bucket        = "${local.project}-${local.env}-${random_id.bucket_suffix.hex}"
  force_destroy = true # demo only — remove for production
}

# Server-side encryption (SSE-S3 / AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "web_host" {
  bucket = aws_s3_bucket.web_host.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "web_host" {
  bucket = aws_s3_bucket.web_host.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "web_host" {
  bucket = aws_s3_bucket.web_host.id

  rule {
    id     = "expire-noncurrent-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# ########################################
# Bucket access — fully private, served via CloudFront + OAC
# ########################################
resource "aws_s3_bucket_public_access_block" "web_host" {
  bucket = aws_s3_bucket.web_host.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Allow only this CloudFront distribution to read objects (via OAC)
resource "aws_s3_bucket_policy" "web_host" {
  bucket = aws_s3_bucket.web_host.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipalReadOnly"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.web_host.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.web_host.arn
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.web_host]
}

# ########################################
# Upload web files
# ########################################
module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/../html"
}

resource "aws_s3_object" "web_file" {
  for_each = module.template_files.files

  bucket       = aws_s3_bucket.web_host.id
  key          = each.key
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  etag = each.value.digests.md5
}
