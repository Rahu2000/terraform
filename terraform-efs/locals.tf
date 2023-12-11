locals {

  # remote backend type
  REMOTE_BACKEND_TYPE = ["s3", "remote"]

  # Set cluster name
  cluster_name = (
    var.cluster_name != "" ? var.cluster_name
    : var.remote_backend.type == "s3" ? data.terraform_remote_state.s3_eks[0].outputs.eks_cluster_name
    : var.remote_backend.type == "remote" ? data.terraform_remote_state.remote_eks[0].outputs.eks_cluster_name
    : ""
  )

  # Remote backend search condition values for eks
  remote_state_eks   = contains(local.REMOTE_BACKEND_TYPE, var.remote_backend.type) ? { for i in var.remote_backend.workspaces : i.service => i if i.service == "eks" } : {}
  backend_s3_eks     = length(keys(local.remote_state_eks)) > 0 && var.remote_backend.type == "s3" ? true : false
  backend_remote_eks = length(keys(local.remote_state_eks)) > 0 && var.remote_backend.type == "remote" ? true : false

  # Set cluster informations
  cluster_info = var.remote_backend.type == "s3" ? {
    # Set eks variables from s3.
    endpoint_url               = data.terraform_remote_state.s3_eks[0].outputs.eks_cluster_endpoint
    certificate_authority_data = data.terraform_remote_state.s3_eks[0].outputs.eks_cluster_certificate_authority_data
    oidc_provider_arn          = data.terraform_remote_state.s3_eks[0].outputs.eks_oidc_provider_arn
    oidc_provider_url          = data.terraform_remote_state.s3_eks[0].outputs.eks_oidc_provider_url
    # Set eks variables from terraform cloud.
    } : var.remote_backend.type == "remote" ? {
    endpoint_url               = data.terraform_remote_state.remote_eks[0].outputs.eks_cluster_endpoint
    certificate_authority_data = data.terraform_remote_state.remote_eks[0].outputs.eks_cluster_certificate_authority_data
    oidc_provider_arn          = data.terraform_remote_state.remote_eks[0].outputs.eks_oidc_provider_arn
    oidc_provider_url          = data.terraform_remote_state.remote_eks[0].outputs.eks_oidc_provider_url
    # Set eks variables from aws.
    } : var.cluster_name != "" ? {
    endpoint_url               = data.aws_eks_cluster.this.endpoint
    certificate_authority_data = data.aws_eks_cluster.this.certificate_authority[0].data
    oidc_provider_arn          = data.aws_iam_openid_connect_provider.this.arn
    oidc_provider_url          = data.aws_iam_openid_connect_provider.this.url
    # Cluster name is required. Installation will fail.
    } : {
    endpoint_url               = ""
    certificate_authority_data = ""
    oidc_provider_arn          = ""
    oidc_provider_url          = ""
  }

  # Set cluster auth token
  auth_token = data.aws_eks_cluster_auth.this.token
  # Set tags
  common_tags = merge(var.default_tags, {
    "project"    = var.project
    "region"     = var.region
    "env"        = var.env
    "org"        = var.org
    "managed by" = "terraform"
  })
}
