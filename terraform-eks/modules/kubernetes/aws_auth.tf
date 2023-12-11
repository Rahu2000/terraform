locals {
  BOOTSTRAPPER         = ["system:bootstrappers", "system:nodes"]
  FARGATE              = ["system:bootstrappers", "system:nodes", "system:node-proxier"]
  CLUSTER_ADMIN        = ["system:masters"]
  AUTHENTICATED        = ["system:authenticated"]
  NODE_USERNAME        = "system:node:{{EC2PrivateDNSName}}"
  FARGATE_USERNAME     = "system:node:{{SessionName}}"
  ANONYMOUS_USERNAME   = "aws:{{AccountID}}:{{SessionName}}"
  ROLE_GROUP_TYPE      = { BOOTSTRAPPER = local.BOOTSTRAPPER, FARGATE = local.FARGATE, CLUSTER_ADMIN = local.CLUSTER_ADMIN }
  USER_GROUP_TYPE      = { CLUSTER_ADMIN = local.CLUSTER_ADMIN }
  CLUSTER_GROUP_PREFIX = "CLUSTER_"
  ADMIN_SUFFIX         = "_ADMIN"

  # get node role arns (from input node_groups)
  node_group_role_arns = [
    for x in var.eks_node_groups : (try(x.role_name, "") == "" ?
      format("arn:aws:iam::%s:role/%s-%s-nodegroup-role", var.account_id, var.eks_cluster_name, x.name)
    : format("arn:aws:iam::%s:role/%s", var.account_id, x.role_name))
  ]
  # validate node roles between existing node group role and input data
  aws_auth_node_roles = [
    for role in(length(local.node_group_role_arns) > 0 ? yamldecode(data.kubernetes_config_map.aws_auth.data.mapRoles) : []) :
    {
      rolearn  = role.rolearn
      roletype = "BOOTSTRAPPER"
      username = local.NODE_USERNAME
    }
    if contains(local.node_group_role_arns, role.rolearn)
  ]

  # get fargate role arns (from input fargate_profiles)
  fargate_role_arns = [
    for x in var.eks_fargate_profiles : (try(x.role_name, try(x.role_arn, "")) == "" ?
      format("arn:aws:iam::%s:role/%s", var.account_id, x.role_name)
    : x.role_arn)
  ]
  # validate node roles between existing node group role and input data
  aws_auth_fargate_roles = [
    for role in(length(local.fargate_role_arns) > 0 ? yamldecode(data.kubernetes_config_map.aws_auth.data.mapRoles) : []) :
    {
      rolearn  = role.rolearn
      roletype = "BOOTSTRAPPER"
      username = local.FARGATE_USERNAME
    }
    if contains(local.fargate_role_arns, role.rolearn)
  ]

  karpenter_role = var.karpenter.enabled ? [
    {
      rolearn  = format("arn:aws:iam::%s:role/%s", var.account_id, try(var.karpenter.role_name, ""))
      roletype = "FARGATE"
      username = local.NODE_USERNAME
    }
  ] : []

  # Reduce duplicate roles and users
  merged_roles = setunion(local.aws_auth_node_roles, local.aws_auth_fargate_roles, local.karpenter_role, var.rbac_roles)
  map_roles = [
    for i in local.merged_roles :
    {
      rolearn  = i.rolearn
      username = i.username == "" ? local.ANONYMOUS_USERNAME : i.username
      groups   = lookup(local.ROLE_GROUP_TYPE, i.roletype, [])
    }
  ]
  map_users = [
    for i in var.rbac_users :
    {
      userarn  = i.userarn
      username = i.username == "" ? local.ANONYMOUS_USERNAME : i.username
      groups = startswith(i.usertype, local.CLUSTER_GROUP_PREFIX) ? (
        endswith(i.usertype, local.ADMIN_SUFFIX) ? lookup(local.USER_GROUP_TYPE, i.usertype, []) : [format("%ss", replace(lower(i.usertype), "_", "-"))]
        ) : (
        contains(data.kubernetes_all_namespaces.this.namespaces, i.namespace) ?
        [format("%s-%ss", i.namespace, lower(i.usertype))] : local.AUTHENTICATED
      )
    }
  ]
}

# Reconfigure aws auth
resource "kubernetes_config_map_v1_data" "aws_auth" {
  count = length(local.node_group_role_arns) + length(local.fargate_role_arns) > 0 ? 1 : 0

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = length(local.map_roles) > 0 ? yamlencode(local.map_roles) : null
    mapUsers = length(local.map_users) > 0 ? yamlencode(local.map_users) : null
  }

  force = true

  depends_on = [
    kubernetes_role_binding.this,
    kubernetes_cluster_role_binding.this
  ]
}
