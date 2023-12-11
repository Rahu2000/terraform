############################################
# version of terraform and providers
############################################
terraform {
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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }

  # Uncomment if you are using s3 as backend.
  # backend "s3" {}

  # Uncomment if you are using terraform cloud as backend.
  # cloud {
  #   organization = "YOUR TERRAFORM CLOUD ORG"
  #   workspaces {
  #     name = "TERRAFORM WORKSPACE FOR PROMETHEUS"
  #   }
  # }
}
