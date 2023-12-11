module "kyverno" {
  source = "./modules/helm_release"

  project = var.project
  env     = var.env
  org     = var.org
  region  = var.region

  helm_chart   = merge(var.helm_chart, { name = local.KYVERNO_CHART })
  helm_release = var.helm_release
  common_tags  = local.common_tags

  providers = {
    aws = aws.TARGET
  }
}
