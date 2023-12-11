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
  default = {}
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

variable "vpc_id" {
  type        = string
  default     = ""
  description = "vpc id"
}

variable "private_subnet_ids" {
  type        = list(any)
  default     = []
  description = "private subnet id list"
}

variable "public_subnet_ids" {
  type        = list(any)
  default     = []
  description = "public subnet id list"
}

variable "additional_cluster_security_group_ids" {
  type        = list(any)
  default     = []
  description = "security group id to be attached for cluster"
}

variable "additional_nodegroup_security_group_ids" {
  type        = list(any)
  default     = []
  description = "security group id to be attached for node group"
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

variable "eks_cluster_role_name" {
  type        = string
  default     = ""
  description = "(Optional) eks cluster role name"
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

variable "endpoint_public_access" {
  type        = bool
  default     = true
  description = "If set to true. The eks cluster is accessible through the public network."
}

variable "endpoint_private_access" {
  type        = bool
  default     = true
  description = "If set to true. The eks cluster is accessible through the private network."
}

variable "key_pair_name" {
  description = "key pair name to connect bastion"
  default     = ""
}

variable "public_access_cidrs" {
  type        = list(string)
  default     = []
  description = "white list to access eks cluster"
}

variable "cluster_sg_name" {
  type        = string
  default     = ""
  description = ""
}

variable "node_sg_name" {
  type        = string
  default     = ""
  description = ""
}

variable "shared_sg_name" {
  type        = string
  default     = ""
  description = ""
}

variable "eks_node_groups" {
  type = list(object({
    name                 = string
    private_networking   = optional(bool, true)
    use_spot             = optional(bool, false)
    instance_type        = optional(string, "")
    spot_instance_types  = optional(list(string), [])
    instance_volume      = optional(number, 30)
    desired_size         = optional(number, 2)
    min_size             = optional(number, 1)
    max_size             = optional(number, 2)
    description          = optional(string, "")
    ami_id               = optional(string, "")
    labels               = optional(map(any), {})
    taints               = optional(list(map(any)), [])
    kubelet_version      = optional(string, "")
    user_data_script     = optional(string, "")
    role_name            = optional(string, "")
    launch_template_name = optional(string, "")
    enable_ssm           = optional(bool, false)
    max_pods             = optional(number, 0)
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

variable "eks_addons" {
  type = list(object({
    name              = string
    install           = optional(bool, false)
    version           = optional(string, "")
    apply_manifest    = optional(bool, true)
    enable_encryption = optional(bool, true)
    use_custom_kms    = optional(bool, false)
    role_name         = optional(string, "")
    policy_name       = optional(string, "")
    policy_arns       = optional(list(string), [])
    policy_file       = optional(string, "")
    resolve_conflicts = optional(string, "OVERWRITE")
  }))
  default = [
    { name = "vpc-cni" },
    { name = "coredns" },
    { name = "kube-proxy" },
    { name = "aws-ebs-csi-driver" }
  ]
  description = "eks cluster addons options"
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

  validation {
    condition     = length([for i in var.rbac_roles : i if contains(["BOOTSTRAPPER", "CLUSTER_ADMIN", ""], i.roletype)]) == length(var.rbac_roles)
    error_message = "Err: roletype is not valid. valid role types are BOOTSTRAPPER|CLUSTER_ADMIN|\"\" "
  }
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

  validation {
    condition     = length([for i in var.rbac_users : i if contains(["CLUSTER_ADMIN", "CLUSTER_VIEW", "ADMIN", "VIEW", ""], i.usertype)]) == length(var.rbac_users)
    error_message = "Err: roletype is not valid. valid role types are CLUSTER_ADMIN|CLUSTER_VIEW|ADMIN|VIEW\"\" "
  }
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
