locals {
  # set eks variables from backend s3
  eks_cluster_name                  = var.eks_cluster_name == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_name : var.eks_cluster_name
  endpoint_url                      = var.eks_endpoint_url == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_endpoint : var.eks_endpoint_url
  certificate_authority_data        = var.eks_cluster_certificate_authority_data == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data : var.eks_cluster_certificate_authority_data
  auth_token                        = data.aws_eks_cluster_auth.this.token

  common_tags = {
    "project" = var.project
    "env"     = var.env
    "region"  = var.region
    "org"     = var.org 
    "managed" = "terraform"
  }
}