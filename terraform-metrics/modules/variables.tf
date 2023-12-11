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

variable "image_repo" {
  type = string
  default = ""
}
variable "image_tag" {
  type = string
  default = ""
}