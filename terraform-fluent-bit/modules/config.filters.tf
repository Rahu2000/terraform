locals {
  kubernetes = <<-EOT
  [FILTER]
      Name                  kubernetes
      Match                 kube.*
      Merge_Log             On
      Keep_Log              Off
      K8S-Logging.Parser    ${var.conf.filters.kubernetes.logging.parser}
      K8S-Logging.Exclude   ${var.conf.filters.kubernetes.logging.exclude}
      Labels                ${var.conf.filters.kubernetes.labels}
      Buffer_Size           ${var.conf.filters.kubernetes.buffer_size}
  EOT

  multiline = <<-EOF
  [FILTER]
      name                  multiline
      match                 *
      multiline.key_content log
      multiline.parser      ${var.conf.filters.multiline.parser}
      buffer                off
  EOF

  filters = [
    { filter = (var.conf.filters.kubernetes.enabled ? local.kubernetes : "") },
    { filter = (var.conf.filters.multiline.enabled ? local.multiline : "") }
  ]

  enabled_filters = [for v in local.filters : v if v.filter != ""]

  conf_filters = length(local.enabled_filters) == 0 ? "" : <<-EOF
  %{for v in local.enabled_filters}${v.filter}%{endfor}
  EOF
}
