module "aws_efs_csi_driver" {
  source = "./modules"

  project      = var.project
  env          = var.env
  region       = var.region
  cluster_name = local.cluster_name

  oidc_provider = {
    arn = local.cluster_info.oidc_provider_arn
    url = local.cluster_info.oidc_provider_url
  }

  helm_chart   = var.helm_chart
  helm_release = var.helm_release

  common_tags = local.common_tags

  file_systems = var.file_systems

  providers = {
    aws = aws.TARGET
  }
}
