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

variable "vpc_id" {
  type        = string
  default     = ""
  description = "vpc id"
}

variable "vpc_cidr" {
  type        = string
  default     = ""
  description = "vpc cidr"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "subnets to create mount target"
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

variable "helm_chart" {
  type = object({
    name           = string
    repository_url = string
  })

  default = {
    name           = "aws-efs-csi-driver"
    repository_url = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
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

variable "shared_account" {
  type = object({
    region          = string
    profile         = optional(string, "")
    assume_role_arn = optional(string, "")
  })

  description = "default account"
}

variable "target_account" {
  type = object({
    region          = string
    profile         = optional(string, "")
    assume_role_arn = optional(string, "")
  })
  description = "target account"
}
