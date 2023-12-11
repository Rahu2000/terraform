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

variable "cluster_name" {
  type        = string
  default     = ""
  description = "cluster name"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The VPC ID for the Kubernetes cluster"
}

variable "oidc_provider" {
  type = object({
    arn      = string
    url      = string
    provider = optional(string, "aws")
  })

  description = "openid connect provider"
}

variable "helm_chart" {
  type = object({
    name           = string
    repository_url = string
  })
}

variable "helm_release" {
  type = object({
    name          = string
    chart_version = optional(string, "")

    namespace = object({
      create = optional(bool, false)
      name   = optional(string, "kube-system")
    })

    service_account = optional(object({
      create = optional(bool, false)
      name   = optional(string, "alb-controller-sa")
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

    enable_shield               = optional(bool, true)
    enable_waf                  = optional(bool, true)
    enable_wafv2                = optional(bool, true)
    resources                   = optional(string, "")
    replicas                    = optional(number, 2)
    affinity                    = optional(string, "")
    tolerations                 = optional(string, "")
    node_selector               = optional(string, "")
    topology_spread_constraints = optional(string, "")
    service_monitor_enabled     = optional(bool, false)
  })

  description = "helm release"
}
