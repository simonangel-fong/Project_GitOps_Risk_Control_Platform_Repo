# providers.tf

# ########################################
# Terraform providers
# ########################################
terraform {

  required_version = ">= 1.9.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket  = ""
    region  = ""
    key     = ""
    encrypt = true
  }
}

# ########################################
# Providers
# ########################################
provider "aws" {
  region = local.aws_region

  default_tags {
    tags = merge(
      local.tags,
      {
        Project   = local.project
        Env       = local.env
        ManagedBy = "terraform"
      }
    )
  }
}

# cloudflare configuration
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
