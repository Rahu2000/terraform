resource "kubernetes_namespace" "this" {
  count = var.helm_release.namespace.create ? 1 : 0
  metadata {
    labels = {
      role = "monitoring"
    }

    name = var.helm_release.namespace.name
  }
}
