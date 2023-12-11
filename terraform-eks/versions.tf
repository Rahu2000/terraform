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
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
  }

  backend "s3" {}
}
