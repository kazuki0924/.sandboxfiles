# Configure the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

locals {
  prefix = "${var.project}_${var.environment}"
}

resource "aws_cognito_user_pool" "cognito_user_pool" {
  name = "${local.prefix}_cognito_user_pool"
}

resource "aws_cognito_user_pool_client" "cognito_user_pool_client" {
  name = "${local.prefix}_cognito_user_pool_client"
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

