locals {
  service = <<-EOF
  EOF

  services = [
    { service = "" }
  ]

  enabled_services = [for v in local.services : v if v.service != ""]

  conf_services = length(local.enabled_services) == 0 ? "" : <<-EOF
  %{for v in local.enabled_services}${v.service}%{endfor}
  EOF
}
