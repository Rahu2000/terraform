module "fluent_bit" {
  source = "./modules"

  project      = var.project
  env          = var.env
  region       = var.region
  cluster_name = local.cluster_name
  account_id   = data.aws_caller_identity.current.account_id

  oidc_provider = {
    arn = local.cluster_info.oidc_provider_arn
    url = local.cluster_info.oidc_provider_url
  }

  helm_chart   = var.helm_chart
  helm_release = var.helm_release
  conf         = var.conf

  common_tags = local.common_tags

  providers = {
    aws = aws.TARGET
  }
}
