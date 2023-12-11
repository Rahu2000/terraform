locals {
  PREDEFINED_ROLE = ["ADMIN", "VIEW"]

  role_bindings = setunion([
    for bind in var.rbac_users : lower(format("%s_%s", bind.namespace, bind.usertype)) if bind.namespace != "" && contains(local.PREDEFINED_ROLE, bind.usertype)
  ])

  cluster_role_bindings = setunion([
    for bind in var.rbac_users : lower(bind.usertype) if startswith(bind.usertype, local.CLUSTER_GROUP_PREFIX) && !endswith(bind.usertype, local.ADMIN_SUFFIX)
  ])
}

# Role binding
resource "kubernetes_role_binding" "this" {
  for_each = local.role_bindings

  metadata {
    name      = replace("${each.value}s", "_", "-")
    namespace = split("_", each.value)[0]
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = split("_", each.value)[1]
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = replace("${each.value}s", "_", "-")
    namespace = split("_", each.value)[0]
  }

  depends_on = [
    data.kubernetes_all_namespaces.this
  ]
}

# Cluster role binding
resource "kubernetes_cluster_role_binding" "this" {
  for_each = local.cluster_role_bindings

  metadata {
    name = replace("${each.value}s", "_", "-")
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = split("_", each.value)[1]
  }
  subject {
    kind      = "Group"
    name      = replace("${each.value}s", "_", "-")
    api_group = "rbac.authorization.k8s.io"
  }
}
