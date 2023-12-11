resource "helm_release" "this" {
  name       = var.helm_release.name
  version    = var.helm_release.chart_version == "" ? null : var.helm_release.chart_version
  chart      = var.helm_chart.name
  repository = var.helm_chart.repository_url
  namespace  = var.helm_release.namespace.name

  dynamic "set" {
    for_each = var.helm_release.sets
    content {
      name  = set.value.key
      value = set.value.value
    }
  }

  values = [
    local.values,
  ]

  depends_on = [
    kubernetes_namespace.this,
    kubernetes_manifest.this,
    random_password.grafana
  ]
}

resource "random_password" "grafana" {
  count            = var.grafana.enabled ? 1 : 0
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
