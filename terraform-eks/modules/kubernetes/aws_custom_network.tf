locals {
  # Constants
  CRD_API_VERSION = "crd.k8s.amazonaws.com/v1alpha1"

  # Get eniconfigs crd yaml
  eniconfigs = { for x in var.custom_network.eniconfigs : x.name => (
    templatefile("${path.root}/templates/eniconfig.tpl", {
      api_version        = local.CRD_API_VERSION
      name               = x.name
      security_group_ids = x.security_group_ids
      subnet_id          = x.subnet_id
    }))
  }
}

# Set custom network env
resource "kubernetes_env" "aws_node" {
  api_version = "apps/v1"
  kind        = "DaemonSet"

  container = "aws-node"
  metadata {
    name      = "aws-node"
    namespace = "kube-system"
  }

  env {
    name  = "AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG"
    value = var.custom_network.enable
  }

  env {
    name  = "ENI_CONFIG_LABEL_DEF"
    value = "topology.kubernetes.io/zone"
  }

  force = true
}

# Create eniconfig crd
resource "kubernetes_manifest" "eniconfig" {
  for_each = var.custom_network.enable ? local.eniconfigs : {}

  manifest = yamldecode(each.value)
}
