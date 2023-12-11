output "helm_release" {
  value = {
    name      = helm_release.this.name
    version   = helm_release.this.version
    namespace = helm_release.this.namespace
  }
}

output "namespace" {
  value = {
    name        = try(kubernetes_namespace.this[0].metadata[0].name, "")
    labels      = try(kubernetes_namespace.this[0].metadata[0].labels, {})
    annotations = try(kubernetes_namespace.this[0].metadata[0].annotations, {})
  }
}
