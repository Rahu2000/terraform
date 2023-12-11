module "ingress_nginx" {
  source = "./modules"

  region = var.region

  helm_chart   = var.helm_chart
  helm_release = var.helm_release

  nginx_config = var.nginx_config

  common_tags = local.common_tags

  providers = {
    aws = aws.TARGET
  }
}
