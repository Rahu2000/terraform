variable "region" {
  description = "aws region to build network infrastructure"
  default     = ""
}

variable "account_id" {
  description = "aws account id"
  default     = ""
}

variable "eks_cluster_name" {
  description = "aws eks cluster name"
  default     = ""
}

variable "common_tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "eks_addons_info" {
  description = "eks cluster addons options"

  type = object({
    name              = string
    install           = bool
    version           = optional(string, "")
    apply_manifest    = optional(bool, false)
    preserve          = optional(bool, false)
    enable_encryption = optional(bool, false)
    use_custom_kms    = optional(bool, false)
    resolve_conflicts = optional(string, "OVERWRITE")

    iam_role = object({
      create          = optional(bool, false)
      role_name       = optional(string, "")
      namespace       = optional(string, "kube-system")
      policy_arns     = optional(list(string), [])
      policy_file     = optional(string, "")
      policy_name     = optional(string, "")
      service_account = optional(string, "")
    })
  })
}

variable "iam_oidc_provider" {
  description = "IAM oidc provider information for EKS"
  type = object({
    url = string
    arn = string
  })
  default = {
    arn = ""
    url = ""
  }
}
