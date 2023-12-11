############################################
# version of terraform and providers
############################################
terraform {
  # This code is written for terraform 1.3.x version.
  required_version = ">= 1.3.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.55.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
  }
  backend "s3" {}
}