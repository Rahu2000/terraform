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
  type         = string
  default      = ""
  description = "PEM-encoded root certificates bundle for TLS authentication."
}

variable "eks_auth_token" {
  type        = string
  default     = ""
  description = "eks cluster auth token"
}

variable "helm_release_name" {
  default     = ""
  description = "helm release name"
}

variable "helm_chart_name" {
  description = "helm chart name"
  default     = ""
}

variable "helm_chart_version" {
  description = "helm chart version"
  default     = ""
}

variable "helm_repository_url" {
  description = "helm chart repository url"
  default     = ""
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "create the namespace if it does not yet exist"
}

variable "namespace" {
  type        = string
  default     = "argo-cd"
  description = "namespace to install"
}

variable "controller_values" {
  default = {}
}

variable "dex_values" {
  default = {}
}

variable "redis_values" {
  default = {}
}

variable "redis_ha_values" {
  default = {}
}

variable "server_values" {
  default = {}
}

variable "repoServer_values" {
  default = {}
}

variable "configs_values" {
  default = {}
}

variable "applicationset_values" {
  default = {}
}

variable "notifications_values" {
  default = {}
}

variable "global_values" {
  default = {}
}