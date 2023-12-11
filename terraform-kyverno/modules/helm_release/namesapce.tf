resource "kubernetes_namespace" "this" {
  count = var.helm_release.namespace.create ? 1 : 0
  metadata {
    labels = {
      purpose                              = "security"
      "pod-security.kubernetes.io/enforce" = "restricted"
    }

    name = var.helm_release.namespace.name
  }
}
