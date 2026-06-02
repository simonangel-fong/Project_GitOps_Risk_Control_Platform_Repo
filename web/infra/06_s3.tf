# ########################################
# Bucket name suffix
# ########################################
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# ########################################
# AWS S3 bucket for static web host
# ########################################
resource "aws_s3_bucket" "web_host_bucket" {
  bucket        = "${local.project}-${local.env}-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

# Server-side encryption (SSE-S3 / AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "web_host_bucket" {
  bucket = aws_s3_bucket.web_host_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "web_host_bucket" {
  bucket = aws_s3_bucket.web_host_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Expire noncurrent versions so they don't accumulate forever
resource "aws_s3_bucket_lifecycle_configuration" "web_host_bucket" {
  bucket = aws_s3_bucket.web_host_bucket.id

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
# Static website hosting configuration
# ########################################
resource "aws_s3_bucket_website_configuration" "web_host_bucket" {
  bucket = aws_s3_bucket.web_host_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# ########################################
# Public access (S3 website-endpoint hosting)
#
# NOTE: This is acceptable for a demo. Once CloudFront + OAC is
# enabled in 07_cloudfront.tf, flip all four block_public_* to true
# and replace the bucket policy below with an OAC-scoped policy.
# ########################################
resource "aws_s3_bucket_public_access_block" "web_host_bucket" {
  bucket = aws_s3_bucket.web_host_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "web_host_bucket" {
  bucket = aws_s3_bucket.web_host_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.web_host_bucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.web_host_bucket]
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

  bucket       = aws_s3_bucket.web_host_bucket.id
  key          = each.key
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  etag = each.value.digests.md5
}
