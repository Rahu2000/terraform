variable "project" {
  type        = string
  default     = ""
  description = "project code which used to compose the resource name"
}

variable "env" {
  type        = string
  default     = ""
  description = "environment: dev, stg, qa, prod "
}

variable "region" {
  type        = string
  default     = ""
  description = "aws region"
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

    namespace = optional(object({
      create = optional(bool, false)
      name   = optional(string, "kube-system")
    }))

    service_account = object({
      create = optional(bool, false)
      name   = optional(string, "efs-csi-controller-sa")
      iam = object({
        create      = optional(bool, false)
        role_name   = optional(string, "")
        policy_name = optional(string, "")
      })
    })

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

  description = "helm release"
}

variable "file_systems" {
  type = list(object({
    manifest = object({
      name                  = string
      dynamic_storage_class = optional(bool, false)
      storage_class_name    = optional(string, "")
      storage_capacity      = optional(string, "10Gi")
      access_mode           = optional(list(string), ["ReadWriteMany"])
      reclaim_policy        = optional(string, "Retain")
      directory_perms       = optional(string, "700")
      gid_start             = optional(string, "")
      gid_end               = optional(string, "")
      base_path             = optional(string, "")
      volume_handle         = string
    })
  }))

  default = []

  description = "file systems to create"
}
