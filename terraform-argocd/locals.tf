locals {
  # set eks variables from backend s3
  eks_cluster_name                       = var.eks_cluster_name == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_name : var.eks_cluster_name
  eks_endpoint_url                       = var.eks_endpoint_url == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_endpoint : var.eks_endpoint_url
  eks_cluster_certificate_authority_data = var.eks_cluster_certificate_authority_data == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data : var.eks_cluster_certificate_authority_data
  eks_auth_token                         = data.aws_eks_cluster_auth.this.token

  common_tags = {
    "project"    = var.project
    "region"     = var.region
    "env"        = var.env
    "org"        = var.org
    "managed by" = "terraform"
  }

  controller_values     = merge(var.controller_values, { nodeSelector = var.node_selector }, { affinity = var.affinity }, { tolerations = var.tolerations })
  dex_values            = merge(var.dex_values, { nodeSelector = var.node_selector }, { affinity = var.affinity }, { tolerations = var.tolerations })
  redis_values          = merge(var.redis_values, { nodeSelector = var.node_selector }, { affinity = var.affinity }, { tolerations = var.tolerations })
  server_values         = merge(var.server_values, { nodeSelector = var.node_selector }, { affinity = var.affinity }, { tolerations = var.tolerations })
  repoServer_values     = merge(var.repoServer_values, { nodeSelector = var.node_selector }, { affinity = var.affinity }, { tolerations = var.tolerations })
  applicationset_values = merge(var.applicationset_values, { nodeSelector = var.node_selector }, { affinity = var.affinity }, { tolerations = var.tolerations })
  notifications_values  = merge(var.notifications_values, { nodeSelector = var.node_selector }, { affinity = var.affinity }, { tolerations = var.tolerations })
  global_values         = merge(var.global_values, { nodeSelector = var.node_selector }, { affinity = var.affinity }, { tolerations = var.tolerations })

}
