module "kubernetes" {
  source = "./modules/kubernetes"

  eks_cluster_name = local.eks_cluster_name
  eks_node_groups = [
    for node_group in var.eks_node_groups : {
      name      = node_group.name
      role_name = node_group.role_name
    }
  ]

  account_id = data.aws_caller_identity.current.id
  karpenter  = var.karpenter
  rbac_roles = var.rbac_roles
  rbac_users = var.rbac_users

  custom_network = {
    enable = var.custom_network.enable
    eniconfigs = [
      for eniconfig in var.custom_network.eniconfigs : merge(
        eniconfig, { security_group_ids = module.eks_cluster.eks_cluster_security_group_ids }
      )
    ]
  }

  depends_on = [
    module.addon_daemonset_type,
    module.nodegroup
  ]
}
