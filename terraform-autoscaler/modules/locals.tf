locals {
  # service_account_policy_name = format("%s-ca-policy-%s", var.eks_cluster_name, random_string.random.result)
  # service_account_role_name   = format("%s-ca-role-%s", var.eks_cluster_name, random_string.random.result)
  # service_account_name        = format("cluster-autoscaler-%s", random_string.random.result)

  service_account_policy_name = var.policy_name   #"HAE-DEV-SF-IAMROL-EKS-ADD-AUTOSCALER-AN2"
  service_account_role_name   = var.role_name     #"HAE-DEV-SF-IAMROL-EKS-ADD-AUTOSCALER-AN2"
  service_account_name        = "cluster-autoscaler-sa"

  values = templatefile("${path.module}/template/cluster-autoscaler-values.tpl", {
    namespace = var.namespace
    cluster_name = var.eks_cluster_name
    region = var.region
    replica_count = var.replica_count

    role_arn = aws_iam_role.cluster-autoscaler.arn
    service_account_name = local.service_account_name
    service_monitor_enabled = var.service_monitor_enabled

    resources     = var.resources
    affinity      = var.affinity
    node_selector = var.node_selector
    tolerations   = var.tolerations
    topology_spread_constraints = var.topology_spread_constraints
  })
}

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}


