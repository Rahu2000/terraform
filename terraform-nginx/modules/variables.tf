variable "region" {
  type        = string
  default     = ""
  description = "aws region to build network infrastructure"
}

variable "common_tags" {
  type        = map(any)
  default     = {}
  description = "chart version for ebs csi controller"
}

# Helm charts information
variable "helm_chart" {
  type = object({
    name           = string
    repository_url = string
  })
}

# Helm release
variable "helm_release" {
  type = object({
    name          = string
    chart_version = optional(string, "")
    namespace = optional(object({
      create = optional(bool, true)
      name   = optional(string, "ingress-nginx")
    }), {})
    service_account = optional(object({
      create = optional(bool, true)
      name   = optional(string, "ingress-nginx-sa")
      iam = optional(object({
        create      = optional(bool, false)
        role_name   = optional(string, "")
        policy_name = optional(string, "")
      }), {})
    }), {})

    sets = optional(list(object({
      key   = string
      value = string
    })), [])

    resources                   = optional(string, "")
    replicas                    = optional(number, 2)
    affinity                    = optional(string, "")
    tolerations                 = optional(string, "")
    node_selector               = optional(string, "")
    topology_spread_constraints = optional(string, "")
  })

  description = "helm release common values"
}

# Ingress nginx configuration
variable "nginx_config" {
  type = object({
    service = optional(object({
      annotations  = optional(string, "")
      enable_http  = optional(bool, true)
      enable_https = optional(bool, true)
      ports        = optional(string, "")
      target_ports = optional(string, "")
    }), {})

    controller = optional(object({
      ingress_class_name = optional(string, "nginx")
      sysctls            = optional(string, "")
      autoscaling = optional(object({
        enable       = optional(bool, false)
        min_replicas = optional(number, 2)
        max_replicas = optional(number, 6)
      }), {})
      metrics_enabled         = optional(bool, false)
      prometheus_rule_enabled = optional(bool, false)
      service_monitor_enabled = optional(bool, false)
    }), {})

    tcp_services = optional(string, "")
    udp_services = optional(string, "")
  })

  default     = {}
  description = "ingress nginx configuration"
}
