locals {
  service_account_role_name = try(var.helm_release.service_account.iam.role_name, format("%s-fluent-bit-role", replace(var.cluster_name, "_", "-")))

  opensearch_policy = {
    enabled = var.helm_release.service_account.iam.create && var.conf.outputs.opensearch.enabled ? true : false
    name    = var.conf.outputs.opensearch.aws.policy_name == "" ? format("%s-%s-fluent-bit-opensearch-policy", var.cluster_name, var.env) : var.conf.outputs.opensearch.aws.policy_name
  }
  cloudwatch_policy = {
    enabled = var.helm_release.service_account.iam.create && var.conf.outputs.cloudwatch.enabled ? true : false
    name    = var.conf.outputs.cloudwatch.aws.policy_name == "" ? format("%s-%s-fluent-bit-cloudwatch-policy", var.cluster_name, var.env) : var.conf.outputs.cloudwatch.aws.policy_name
  }

  # Service account role policy for fluent-bit
  fluent_bit_policies = [
    (local.opensearch_policy.enabled ? format("arn:aws:iam::%s:policy/%s", var.account_id, local.opensearch_policy.name) : ""),
    (local.cloudwatch_policy.enabled ? format("arn:aws:iam::%s:policy/%s", var.account_id, local.cloudwatch_policy.name) : "")
  ]

  daemonset = templatefile("${path.root}/template/daemonset.tpl", {
    test_framework_enabled    = var.helm_release.test_framework_enabled
    service_account_name      = var.helm_release.service_account.name
    service_account_arn       = aws_iam_role.this[0].arn
    service_monitor_enabled   = var.helm_release.service_monitor.enabled
    service_monitor_namespace = var.helm_release.service_monitor.namespace
    prometheus_selector       = var.helm_release.service_monitor.prometheus_selector
    prometheus_rule_enabled   = var.helm_release.prometheus.rule_enabled
    resources                 = var.helm_release.resources
    affinity                  = var.helm_release.affinity
    node_selector             = var.helm_release.node_selector
    tolerations               = var.helm_release.tolerations
    service                   = local.conf_services
    inputs                    = local.conf_inputs
    filters                   = local.conf_filters
    outputs                   = local.conf_outputs
    custom_parsers            = local.conf_parsers
    log_level                 = var.helm_release.log_level
  })
}
