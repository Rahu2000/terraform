locals {
  # set eks variables from backend s3
  eks_cluster_name      = var.eks_cluster_name      == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_name : var.eks_cluster_name
  eks_endpoint_url      = var.eks_endpoint_url      == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_endpoint : var.eks_endpoint_url
  eks_cluster_certificate_authority_data = var.eks_cluster_certificate_authority_data == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data : var.eks_cluster_certificate_authority_data
  eks_auth_token        = data.aws_eks_cluster_auth.this.token
  
  eks_oidc_provider_arn	= var.eks_oidc_provider_arn == "" ? data.terraform_remote_state.eks.outputs.eks_oidc_provider_arn : var.eks_oidc_provider_arn
  eks_oidc_provider_url	= var.eks_oidc_provider_url == "" ? data.terraform_remote_state.eks.outputs.eks_oidc_provider_url : var.eks_oidc_provider_url

  common_tags = {
    "project" = var.project
    "env"     = var.env
    "region"  = var.region
    "managed" = "terraform"
  }
}


# locals {
#   eks_cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name
#   eks_endpoint_url = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
#   eks_cluster_certificate_authority_data = data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data
#   eks_auth_token = data.aws_eks_cluster_auth.this.token

#   eks_oidc_provider_arn = data.terraform_remote_state.eks.outputs.eks_oidc_provider_arn
#   eks_oidc_provider_url = data.terraform_remote_state.eks.outputs.eks_oidc_provider_url
  
#   common_tags = {
#     "project" = var.project
#     "env"     = var.env
#     "region"  = var.region
#     "managed" = "terraform"
#   }
# }
