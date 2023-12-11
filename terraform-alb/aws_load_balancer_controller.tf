module "aws_load_balancer_controller" {
  source = "./modules"

  region       = var.region
  cluster_name = local.cluster_name

  oidc_provider = {
    arn = local.cluster_info.oidc_provider_arn
    url = local.cluster_info.oidc_provider_url
  }

  helm_chart   = var.helm_chart
  helm_release = var.helm_release
  vpc_id       = local.network.vpc_id
  common_tags  = local.common_tags

  providers = {
    aws = aws.TARGET
  }
}
