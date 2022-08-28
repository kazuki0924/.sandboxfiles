variable "environment" {
  description = "Environment name. (dev, prod, etc.)"
  default = "dev"
}

variable "project" {
  description = "Project name for all resources."
  default = "sandbox"
}

variable "aws_region" {
  description = "AWS region for all resources."
  type    = string
  default = "us-east-1"
}
