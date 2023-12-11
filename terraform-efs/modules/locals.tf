locals {
  service_account_policy_name = try(var.helm_release.service_account.iam.policy_name, format("%s-efs-policy", var.cluster_name))
  service_account_role_name   = try(var.helm_release.service_account.iam.role_name, format("%s-efs-role", replace(var.cluster_name, "_", "-")))
  service_account_name        = try(var.helm_release.service_account.name, format("%s-efs-sa", replace(var.cluster_name, "_", "-")))

  controller = templatefile("${path.root}/template/efs_controller.tpl", {
    service_account_name        = local.service_account_name
    service_account_arn         = aws_iam_role.this.arn
    region                      = var.region
    env                         = var.env
    replica_count               = var.helm_release.replicas
    resources                   = var.helm_release.resources
    affinity                    = var.helm_release.affinity
    node_selector               = var.helm_release.node_selector
    tolerations                 = var.helm_release.tolerations
    topology_spread_constraints = var.helm_release.topology_spread_constraints
  })

  node = templatefile("${path.root}/template/efs_node.tpl", {
    resources            = var.helm_release.resources
    service_account_name = local.service_account_name
  })
}
