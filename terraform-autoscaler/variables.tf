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

variable "org" {
  type        = string
  default     = ""
  description = "organization name"
}

variable "region" {
  type        = string
  default     = ""
  description = "aws region to build network infrastructure"
}

variable "abbr_region" {
  type        = string
  default     = ""
  description = "abbreviation of aws region. e.g. AN2"
}

variable "common_tags" {
  type        = map
  default     = {}
  description = "chart version for ebs csi controller"
}

variable "backend_s3_bucket_name" {
  default     = ""
  description = "s3 bucket name for terraform backend"
}

variable "eks_s3_key" {

  default     = ""
  description = "s3 key path/key for eks"
}

variable "bucket_region" {
  type        = string
  default     = ""
  description = "s3 bucket region" 
}

variable "eks_cluster_name" {
  type        = string
  default     = ""
  description = "eks cluster name"
}

variable "eks_endpoint_url" {
  type        = string
  default     = ""
  description = "eks endpoint url"
}

variable "eks_cluster_certificate_authority_data" {
  type        = string
  default     = ""
  description = "eks cluster ca certificate"
}

variable "eks_oidc_provider_arn" {
  type        = string
  default     = ""
  description = "openid connect provider arn"
}

variable "eks_oidc_provider_url" {
  type        = string
  default     = ""
  description = "openid connect provider url"
}

variable "helm_release_name" {
  type        = string
  default     = ""
  description = "helm release name"
}

variable "helm_chart_name" {
  type        = string
  default     = ""
  description = "helm chart name"
}

variable "helm_chart_version" {
  type        = string
  default     = ""
  description = "helm chart version"
}

variable "helm_repository_url" {
  type        = string
  default     = ""
  description = "helm chart repository url"
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "create the namespace if it does not yet exist"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "namespace to install"
}

variable "replica_count" {
  type        = number
  default     = 2
  description = "replica count"
}

variable "service_monitor_enabled" {
  type    = bool
  default = false
  description = "configure whether to create service monitor"
}

variable "resources" {
  type    = string
  default = ""
}

variable "affinity" {
  type    = string
  default = ""
}

variable "tolerations" {
  type    = string
  default = ""
}

variable "node_selector" {
  type    = string
  default = ""
}

variable "topology_spread_constraints" {
  type    = string
  default = ""
}


# variable "remote_backend" {
#   type = object({
#     type           = string
#     bucket         = optional(string, "")
#     key            = optional(string, "")
#     region         = optional(string, "")
#     org            = optional(string, "")
#     workspace_name = optional(string, "")
#   })

#   description = "remote backend information"
# }

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


variable "image_repo" {
  type = string
  default = ""
  description = "image repository"
}
variable "image_tag" {
  type = string
  default = ""
  description = "image tag"
}

variable "policy_name" {
  type = string 
  default = ""

}
variable "role_name" {
  type = string 
  default = "" 
}