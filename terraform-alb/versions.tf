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
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
  }

  backend "s3" {}
}
