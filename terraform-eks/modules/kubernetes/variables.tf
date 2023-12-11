variable "eks_cluster_name" {
  type        = string
  default     = ""
  description = "eks cluster name"
}

variable "eks_node_groups" {
  type = list(object({
    name                 = string
    role_name            = optional(string, "")
  }))
  default     = []
  description = "Nodegroup specs"
}

variable "eks_fargate_profiles" {
  type = list(object({
    name      = string
    role_name = optional(string, "")
    role_arn  = optional(string, "")
    selector = object({
      namespace = string
      labels    = optional(map(any), {})
    })
  }))
  default     = []
  description = "Fargate profiles"
}

variable "account_id" {
  type        = string
  default     = ""
  description = "aws account id"
}

variable "karpenter" {
  type = object({
    enabled   = bool
    role_name = string
  })
  description = "karpenter role information for setting configmap/aws-auth"
  default = {
    enabled   = false
    role_name = ""
  }
}

variable "rbac_roles" {
  type = list(object({
    roletype = string
    username = string
    rolearn  = string
  }))
  default     = []
  description = "additional roles for setting configmap/aws-auth"
}

variable "rbac_users" {
  type = list(object({
    usertype  = string
    username  = string
    userarn   = string
    namespace = optional(string, "")
  }))
  default     = []
  description = "additional users for setting configmap/aws-auth"
}

variable "custom_network" {
  type = object({
    enable = bool
    eniconfigs = optional(list(object({
      name               = string
      security_group_ids = list(string)
      subnet_id          = string
    })), [])
  })

  default = {
    enable     = false
    eniconfigs = []
  }

  description = "If set to true. The AWS CNI(aws-node DaemonSet) uses a custom network."
}
