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
  default     = "ap-northeast-2"
  description = "aws region to build network infrastructure"
}

variable "common_tags" {
  type        = map(any)
  default     = {}
  description = "A map of tags to add to all resources"
}

variable "eks_cluster_name" {
  type        = string
  default     = ""
  description = "eks cluster name"
}

variable "eks_cluster_version" {
  type        = string
  default     = ""
  description = "(Optional) if is not set, eks version will be applied latest version"
}

variable "eks_cluster_endpoint" {
  type        = string
  default     = ""
  description = "eks cluster endpoint"
}

variable "eks_cluster_certificate_authority_data" {
  type        = string
  default     = ""
  description = "eks cluster ca"
}

variable "eks_kubernetes_network_config" {
  type        = map(any)
  default     = {}
  description = "kubernetes network config"
}

variable "key_pair_name" {
  type        = string
  default     = ""
  description = "key pair for ssh"
}

variable "subnet_id_list" {
  type        = list(string)
  default     = []
  description = "subnet id's list to create eks cluster"
}

variable "security_group_list" {
  type        = list(string)
  default     = []
  description = "security group id's list to create eks cluster"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  default     = []
  description = "security group id's list to create eks cluster"
}

variable "eks_node_group_info" {
  type = object({
    name                 = optional(string, "")
    capacity_type        = optional(string, "")
    instance_type        = optional(string, "")
    instance_types       = optional(list(string), [])
    instance_volume      = optional(number, 0)
    desired_size         = optional(number, 0)
    min_size             = optional(number, 0)
    max_size             = optional(number, 0)
    ami_id               = optional(string, "")
    description          = optional(string, "")
    labels               = optional(map(any), {})
    taints               = optional(list(map(any)), [])
    kubelet_version      = optional(string, "")
    user_data            = optional(string, "")
    role_name            = optional(string, "")
    launch_template_name = optional(string, "")
    enable_ssm           = optional(bool, false)
    max_pods             = optional(number, 0)
  })
  default     = {}
  description = "Settings for creating node groups"
}

variable "eks_addons" {
  default     = {}
  description = "Settings for eks addons"
}

variable "custom_network" {
  type = object({
    enable = bool
    eniconfigs = optional(list(object({
      name      = string
      subnet_id = string
    })), [])
    prefix_delegation = optional(object({
      enable = optional(bool, false)
    }), {})
  })

  default = {
    enable            = false
    eniconfigs        = []
    prefix_delegation = {}
  }

  description = "If set to true. The AWS CNI(aws-node DaemonSet) uses a custom network."
}