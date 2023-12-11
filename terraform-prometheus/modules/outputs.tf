output "helm_release" {
  value = {
    name      = helm_release.this.name
    version   = helm_release.this.version
    namespace = helm_release.this.namespace
  }
}
