module "kube_prometheus_stack" {
  source = "./modules"

  project          = var.project
  env              = var.env
  org              = var.org
  region           = var.region
  cluster_name     = local.cluster_name
  cluster_version  = local.cluster_info.version
  account_id       = data.aws_caller_identity.current.account_id
  vpc_cidr_blocks  = data.aws_vpc.this.cidr_block_associations[*].cidr_block
  k8s_api_endpoint = format("%s/32", cidrhost(data.aws_eks_cluster.this.kubernetes_network_config[0].service_ipv4_cidr, 1))

  oidc_provider = {
    arn = local.cluster_info.oidc_provider_arn
    url = local.cluster_info.oidc_provider_url
  }

  helm_chart                  = var.helm_chart
  helm_release                = var.helm_release
  prometheus                  = var.prometheus
  alert_manager               = var.alert_manager
  grafana                     = var.grafana
  kube_state_metrics          = var.kube_state_metrics
  node_exporter               = var.node_exporter
  prometheus_operator         = var.prometheus_operator
  additional_prometheus_rules = var.additional_prometheus_rules
  network_policy_enabled      = var.network_policy_enabled
  common_tags                 = local.common_tags

  providers = {
    aws = aws.TARGET
  }
}
