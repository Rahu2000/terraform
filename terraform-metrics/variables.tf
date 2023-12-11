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
  description = "aws region to build network infrastructure"
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
variable "bucket_key" {
  type        = string
  default     = ""
  description = "bucket_key" 
}

variable "eks_cluster_name" {
  type        = string
  default     = ""
  description = "eks cluster name"
}

variable "eks_endpoint_url" {
  type        = string
  default     = ""
  description = "url of eks master."
}

variable "eks_cluster_certificate_authority_data" {
  type        = string
  default     = ""
  description = "PEM-encoded root certificates bundle for TLS authentication."
}

variable "eks_auth_token" {
  type        = string
  default     = ""
  description = "eks cluster auth token"
}
variable "auth_token" {
  type        = string
  default     = ""
  description = "eks cluster auth token"
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

variable "metrics_resolution" {
  type        = string
  default     = "15s"
  description = "metrics collection period"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "namespace to install"
}

variable "replica_count" {
  type        = number
  default     = 1
  description = "ingress class name"
}

variable "service_monitor_enabled" {
  type    = bool
  default = false
  description = "configure whether to create service monitor"
}

variable "default_args" {
  type        = string
  default     = ""
  description = "container's parameters"
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

######
variable "abbr_region" {
  type        = string
  default     = ""
  description = "abbreviation of aws region. e.g. AN2"
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

variable "cluster_name" {
  type        = string
  default     = ""
  description = "kubernetes cluster name" 
}

variable "image_repo" {
  type = string
  default = ""
}
variable "image_tag" {
  type = string 
  default = "" 
}

variable "bucket_region" {
  type        = string
  default     = ""
  description = "bucket region" 
}

