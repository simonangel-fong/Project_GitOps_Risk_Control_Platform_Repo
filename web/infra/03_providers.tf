# providers.tf

# ########################################
# Terraform & providers
# ########################################
terraform {
  required_version = ">= 1.11" # required for S3 native state locking

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket       = ""
    region       = ""
    key          = ""
    encrypt      = true
    use_lockfile = true # S3-native locking
  }
}

# ########################################
# Providers
# ########################################
provider "aws" {
  region = local.aws_region

  default_tags {
    tags = {
      Project   = local.project
      Env       = local.env
      ManagedBy = "terraform"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
