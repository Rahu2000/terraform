locals {
  IAM_POLICY_URL = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
  CRDS_URL       = "https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/crds/crds.yaml"

  service_account_policy_name = try(var.helm_release.service_account.iam.policy_name, format("%s-alb-controller-policy", var.cluster_name))
  service_account_role_name   = try(var.helm_release.service_account.iam.role_name, format("%s-alb-controller-role", var.cluster_name))
  service_account_name        = try(var.helm_release.service_account.name, format("%s-alb-controller-sa", var.cluster_name))

  values = templatefile("${path.root}/template/alb_values.tpl", {
    clusterName = var.cluster_name
    region      = var.region
    vpcId       = var.vpc_id

    role_arn             = aws_iam_role.this.arn
    service_account_name = local.service_account_name

    enable_shield               = var.helm_release.enable_shield
    enable_waf                  = var.helm_release.enable_waf
    enable_wafv2                = var.helm_release.enable_wafv2
    replicaCount                = var.helm_release.replicas
    resources                   = var.helm_release.resources
    affinity                    = var.helm_release.affinity
    node_selector               = var.helm_release.node_selector
    tolerations                 = var.helm_release.tolerations
    topology_spread_constraints = var.helm_release.topology_spread_constraints
    service_monitor_enabled     = var.helm_release.service_monitor_enabled
  })
}
