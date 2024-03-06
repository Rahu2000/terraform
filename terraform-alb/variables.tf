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
  description = "tags for aws elb tagging"
  default     = {}
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

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The VPC ID for the Kubernetes cluster"
}

variable "helm_chart" {
  type = object({
    name           = string
    repository_url = string
  })

  default = {
    name           = "aws-load-balancer-controller"
    repository_url = "https://aws.github.io/eks-charts"
  }

  description = "helm chart"
}

variable "helm_release" {
  type = object({
    name          = string
    chart_version = optional(string, "")

    namespace = optional(object({
      create = optional(bool, false)
      name   = optional(string, "kube-system")
    }), {})

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
