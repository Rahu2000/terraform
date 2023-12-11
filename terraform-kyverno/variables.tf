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
variable "default_tags" {
  type        = map(any)
  default     = {}
  description = "resource tags"
}

# Remote backend options
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

# Cluster name
variable "cluster_name" {
  type        = string
  default     = ""
  description = "cluster name"
}

# Helm chart information
variable "helm_chart" {
  type = object({
    name           = string
    repository_url = string
  })

  default = {
    name           = ""
    repository_url = "https://kyverno.github.io/kyverno/"
  }

  description = "helm chart"
}

# Kyverno helm release common options
variable "helm_release" {
  type = object({
    name          = string
    chart_version = optional(string, "")
    namespace = optional(object({
      create = optional(bool, true)
      name   = optional(string, "kyverno")
    }), {})
    service_account = optional(object({
      create = optional(bool, false)
      name   = optional(string, "")
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
    replicas                    = optional(number, 1)
    affinity                    = optional(string, "")
    tolerations                 = optional(string, "")
    node_selector               = optional(string, "")
    topology_spread_constraints = optional(string, "")
  })

  description = "helm release for kyverno"
}

# Kyverno policies helm release common options
variable "policies_release" {
  type = object({
    name          = string
    chart_version = optional(string, "")
    sets = optional(list(object({
      key   = string
      value = string
    })), [])
  })

  description = "helm release for kyverno policies"
}

variable "default_policies" {
  type = object({
    engine_enabled = optional(bool, false)
  })

  default     = {}
  description = "policies to apply by default"
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
