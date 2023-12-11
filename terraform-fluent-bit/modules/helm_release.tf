resource "helm_release" "fluent_bit" {
  name             = var.helm_release.name
  version          = var.helm_release.chart_version == "" ? null : var.helm_release.chart_version
  chart            = var.helm_chart.name
  repository       = var.helm_chart.repository_url
  create_namespace = var.helm_release.namespace.create
  namespace        = var.helm_release.namespace.name

  dynamic "set" {
    for_each = var.helm_release.sets
    content {
      name  = set.value.key
      value = set.value.value
    }
  }

  values = [
    local.daemonset
  ]

  depends_on = [
    aws_iam_role.this
  ]
}
