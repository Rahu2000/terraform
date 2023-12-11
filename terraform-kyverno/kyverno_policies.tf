
module "policies" {
  source = "./modules/helm_release"

  project = var.project
  env     = var.env
  org     = var.org
  region  = var.region

  helm_chart   = merge(var.helm_chart, { name = local.KYVERNO_POLICIES_CHART })
  helm_release = merge(var.policies_release, { namespace = { create = false, name = var.helm_release.namespace.name } })
  common_tags  = local.common_tags

  depends_on = [
    module.kyverno
  ]

  providers = {
    aws = aws.TARGET
  }
}
