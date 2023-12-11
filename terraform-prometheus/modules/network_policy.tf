resource "kubernetes_manifest" "this" {
  count = var.network_policy_enabled ? 1 : 0

  manifest = yamldecode(local.network_policy_yaml)

  depends_on = [
    kubernetes_namespace.this
  ]
}
