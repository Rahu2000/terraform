variable "project" {
  type        = string
  default     = ""
  description = "project code or corporate code"
}

variable "region" {
  type        = string
  default     = ""
  description = "aws region e.g. ap-northeast-2"
}

variable "abbr_region" {
  type        = string
  default     = ""
  description = "abbreviation of aws region. e.g. AN2"
}

variable "env" {
  type        = string
  default     = ""
  description = "environment: dev, stg, qa, prod "
}

variable "org" {
  type        = string
  default     = ""
  description = "organization name"
}

variable "default_tags" {
  type        = map(any)
  default     = {}
  description = "resource tags for ebs csi controller"
}

variable "remote_backend" {
  type = object({
    type = optional(string, "")
    workspaces = optional(list(object({
      service        = optional(string, "")
      bucket         = optional(string, "")
      key            = optional(string, "")
      region         = optional(string, "")
      org            = optional(string, "")
      workspace_name = optional(string, "")
    })), [])
  })
  default     = {}
  description = "remote backend information"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "kubernetes cluster name"
}

# Helm charts information
variable "helm_chart" {
  type = object({
    name           = string
    repository_url = string
  })

  default = {
    name           = "ingress-nginx"
    repository_url = "https://kubernetes.github.io/ingress-nginx"
  }

  description = "helm chart"
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

variable "shared_account" {
  type = object({
    region          = optional(string, "")
    profile         = optional(string, "")
    assume_role_arn = optional(string, "")
  })
  default     = {}
  description = "default account"
}

variable "target_account" {
  type = object({
    region          = optional(string, "")
    profile         = optional(string, "")
    assume_role_arn = optional(string, "")
  })
  default     = {}
  description = "target account"
}
