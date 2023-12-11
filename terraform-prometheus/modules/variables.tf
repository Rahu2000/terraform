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

# default tags
variable "common_tags" {
  type        = map(any)
  default     = {}
  description = "resource tags"
}

# Cluster name
variable "cluster_name" {
  type        = string
  default     = ""
  description = "cluster name"
}

# Cluster version
variable "cluster_version" {
  type        = string
  default     = ""
  description = "cluster version"
}

# AWS account id
variable "account_id" {
  type        = string
  default     = ""
  description = "account id"
}

# oidc provider
variable "oidc_provider" {
  type = object({
    arn      = string
    url      = string
    provider = optional(string, "aws")
  })

  description = "openid connect provider"
}

# Vpc cidr block list
variable "vpc_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "vpc cidr block list"
}

# Kubernetes api endpoint
variable "k8s_api_endpoint" {
  type        = string
  default     = ""
  description = "kubernetes api endpoint"
}

# Helm chart information
variable "helm_chart" {
  type = object({
    name           = string
    repository_url = string
  })

  default = {
    name           = "kube-prometheus-stack"
    repository_url = "https://prometheus-community.github.io/helm-charts"
  }

  description = "helm chart"
}

# Helm release common options
variable "helm_release" {
  type = object({
    name          = string
    chart_version = optional(string, "")
    namespace = optional(object({
      create = optional(bool, true)
      name   = optional(string, "monitoring")
    }), {})
    service_account = object({
      create = optional(bool, false)
      name   = optional(string, "")
      iam = optional(object({
        create      = optional(bool, false)
        role_name   = optional(string, "")
        policy_name = optional(string, "")
      }), {})
    })

    sets = optional(list(object({
      key   = string
      value = string
    })), [])

    resources                   = optional(string, "")
    replicas                    = optional(number, 1)
    affinity                    = optional(string, "")
    tolerations                 = optional(string, "")
    node_selector               = optional(string, "")
    topology_spread_constraints = optional(string, "")
  })

  description = "helm release"
}

# Prometheus options
variable "prometheus" {
  type = object({
    enabled         = optional(bool, true)
    scrape_interval = optional(string, "30s")
    retention       = optional(string, "10d")
    ingress = optional(object({
      enabled     = optional(bool, false)
      class_name  = optional(string, "")
      annotations = optional(string, "")
      hosts       = optional(list(string), [])
      tls = optional(list(object({
        secret_name = optional(string, "")
        hosts       = optional(list(string), [])
      })), [])
    }), {})
    volume = optional(object({
      enabled = optional(bool, true)
      size    = optional(string, "50Gi")
    }), {})
    resources                   = optional(string, "")
    replica_external_label_name = optional(string, "__replica__")
    external_labels             = optional(string, "")
    remote_write                = optional(string, "")
    remote_write_dashboards     = optional(bool, false)
  })
  default     = {}
  description = "prometheus helm chart options"
}

# Alert manager options
variable "alert_manager" {
  type = object({
    enabled = optional(bool, true)
    ingress = optional(object({
      enabled     = optional(bool, false)
      class_name  = optional(string, "")
      annotations = optional(string, "")
      hosts       = optional(list(string), [])
      tls = optional(list(object({
        secret_name = optional(string, "")
        hosts       = optional(list(string), [])
      })), [])
    }), {})
    volume = optional(object({
      enabled = optional(bool, true)
      size    = optional(string, "10Gi")
    }), {})
    resources = optional(string, "")
  })
  default     = {}
  description = "alertmanager helm chart options"
}

# Grafana options
variable "grafana" {
  type = object({
    enabled = optional(bool, true)
    ingress = optional(object({
      enabled     = optional(bool, false)
      class_name  = optional(string, "")
      annotations = optional(string, "")
      hosts       = optional(list(string), [])
      tls = optional(list(object({
        secret_name = optional(string, "")
        hosts       = optional(list(string), [])
      })), [])
    }), {})
    volume = optional(object({
      enabled = optional(bool, true)
      size    = optional(string, "10Gi")
    }), {})
    resources = optional(string, "")
    timezone  = optional(string, "utc")
    ini       = optional(string, "")
    sidecar = optional(object({
      resources = optional(string, "")
    }), {})
  })
  default     = {}
  description = "grafana helm chart options"
}

variable "kube_state_metrics" {
  type = object({
    resources = optional(string, "")
    monitor = optional(object({
      enabled           = optional(bool, true)
      metric_relabeling = optional(string, "")
      relabeling        = optional(string, "")
    }), {})
  })
  default     = {}
  description = "kube_state_metrics helm chart options"
}

variable "node_exporter" {
  type = object({
    resources = optional(string, "")
    monitor = optional(object({
      enabled    = optional(bool, true)
      relabeling = optional(string, "")
    }), {})
  })
  default     = {}
  description = "prometheus_node_exporter helm chart options"
}

variable "prometheus_operator" {
  type = object({
    resources    = optional(string, "")
    host_network = optional(bool, false)
    reloader = optional(object({
      resources = optional(string, "")
    }), {})
  })
  default     = {}
  description = "prometheus_operator helm chart options"
}

variable "network_policy_enabled" {
  type        = bool
  default     = false
  description = "Set to true if NetworkPolicy is required"
}

variable "additional_prometheus_rules" {
  type        = string
  default     = ""
  description = "additional prometheus rules(map)"
}
