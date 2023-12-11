module "argo_cd" {
  source = "./modules"

  project = var.project
  env     = var.env
  region  = var.region

  eks_cluster_name                       = local.eks_cluster_name
  eks_endpoint_url                       = local.eks_endpoint_url
  eks_cluster_certificate_authority_data = local.eks_cluster_certificate_authority_data
  eks_auth_token                         = local.eks_auth_token

  helm_release_name   = var.helm_release_name
  helm_chart_name     = var.helm_chart_name
  helm_chart_version  = var.helm_chart_version
  helm_repository_url = var.helm_repository_url

  create_namespace = var.create_namespace
  namespace        = var.namespace

  controller_values     = local.controller_values
  dex_values            = local.dex_values
  redis_values          = local.redis_values
  redis_ha_values       = var.redis_ha_values
  server_values         = local.server_values
  repoServer_values     = local.repoServer_values
  configs_values        = var.configs_values
  applicationset_values = local.applicationset_values
  notifications_values  = local.notifications_values
  global_values = local.global_values

  common_tags = local.common_tags

  providers = {
    aws = aws.TARGET
  }
}