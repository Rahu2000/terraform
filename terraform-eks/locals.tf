locals {
  # Set network block
  network = var.remote_backend.type == "s3" ? {
    # Set eks variables from s3.
    vpc_id                 = data.terraform_remote_state.s3_network[0].outputs.vpc_id
    k8s_private_subnet_ids = data.terraform_remote_state.s3_network[0].outputs.eks_private_subnet_ids
    k8s_public_subnet_ids  = try(data.terraform_remote_state.s3_network[0].outputs.eks_public_subnet_ids, [])
    bastion_private_ip     = try(data.terraform_remote_state.s3_network[0].outputs.bastion_private_ip, "")
    key_pair_name          = try(data.terraform_remote_state.s3_network[0].outputs.key_pair_name, var.key_pair_name)
    # Set eks variables from terraform cloud.
    } : var.remote_backend.type == "remote" ? {
    vpc_id                 = data.terraform_remote_state.remote_network[0].outputs.vpc_id
    k8s_private_subnet_ids = data.terraform_remote_state.remote_network[0].outputs.eks_private_subnet_ids
    k8s_public_subnet_ids  = try(data.terraform_remote_state.remote_network[0].outputs.eks_public_subnet_ids, [])
    bastion_private_ip     = try(data.terraform_remote_state.remote_network[0].outputs.bastion_private_ip, "")
    key_pair_name          = try(data.terraform_remote_state.remote_network[0].outputs.key_pair_name, var.key_pair_name)
    # Set eks variables from aws.
    } : var.vpc_id != "" ? {
    vpc_id                 = var.vpc_id
    k8s_private_subnet_ids = var.private_subnet_ids
    k8s_public_subnet_ids  = var.public_subnet_ids
    bastion_private_ip     = ""
    key_pair_name          = var.key_pair_name
    # vpc is not setting.
    } : {
    vpc_id                 = ""
    k8s_private_subnet_ids = []
    k8s_public_subnet_ids  = []
    bastion_private_ip     = ""
    key_pair_name          = ""
  }
  resource_postfix = random_string.random.result

  # Cluster block
  existing_cluster                       = contains(data.aws_eks_clusters.this.names, local.eks_cluster_name)
  existing_nodes                         = local.existing_cluster ? try(length(data.aws_eks_node_groups.this[0].names) > 0 ? data.aws_eks_node_groups.this[0].names : {}, {}) : {}
  node_number                            = length(var.eks_node_groups) == 0 ? 0 : try(sum(var.eks_node_groups[*].desired_size), 0)
  existing_node_number                   = try(length(data.aws_eks_node_groups.this[0]), 0) == 0 ? 0 : try(sum(values(data.aws_eks_node_group.this)[*].scaling_config[0].desired_size), 0)
  addon_install_enabled                  = max(local.node_number, local.existing_node_number) > 0 ? true : false
  eks_cluster_name                       = var.eks_cluster_name == "" ? format("%s-%s-%s-%s-eks", var.project, var.org, var.abbr_region, var.env) : var.eks_cluster_name
  eks_cluster_endpoint                   = local.existing_cluster ? data.aws_eks_cluster.this[0].endpoint : module.eks_cluster.eks_cluster_endpoint
  eks_cluster_certificate_authority_data = local.existing_cluster ? data.aws_eks_cluster.this[0].certificate_authority[0].data : module.eks_cluster.eks_cluster_certificate_authority_data
  eks_auth_token                         = local.existing_cluster ? data.aws_eks_cluster_auth.existing_cluster[0].token : data.aws_eks_cluster_auth.cluster[0].token
  kubernetes_network_config              = local.existing_cluster ? data.aws_eks_cluster.this[0].kubernetes_network_config[0] : module.eks_cluster.eks_cluster_info.kubernetes_network_config[0]
  public_access_white_list               = length(var.public_access_cidrs) > 0 ? var.public_access_cidrs : ["0.0.0.0/0"]

  # Security group block
  cluster_sg_ids    = try(var.additional_cluster_security_group_ids, [])
  nodegroup_sg_ids  = concat([aws_security_group.nodegroup.id], [aws_security_group.shared.id], try(var.additional_nodegroup_security_group_ids, []))
  sg_name_cluster   = var.cluster_sg_name == "" ? format("%s-cluster/ControlPlaneSG", local.eks_cluster_name) : var.cluster_sg_name
  sg_name_nodegroup = var.node_sg_name == "" ? format("%s-nodegroup/NodeGroupSG", local.eks_cluster_name) : var.node_sg_name
  sg_name_shared    = var.shared_sg_name == "" ? format("%s-cluster/SharedSG", local.eks_cluster_name) : var.shared_sg_name

  # Remote backend metadata block
  # Supported remote backend type
  REMOTE_BACKEND_TYPE = ["s3", "remote"]
  # Get network metadata from remote backend
  remote_state_network   = contains(local.REMOTE_BACKEND_TYPE, var.remote_backend.type) ? { for i in var.remote_backend.workspaces : i.service => i if i.service == "network" } : {}
  backend_s3_network     = length(keys(local.remote_state_network)) > 0 && var.remote_backend.type == "s3" ? true : false
  backend_remote_network = length(keys(local.remote_state_network)) > 0 && var.remote_backend.type == "remote" ? true : false
  # Tag block
  common_tags = merge(var.default_tags, {
    "project"    = var.project
    "region"     = var.region
    "env"        = var.env
    "org"        = var.org
    "managed by" = "terraform"
  })
}

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}
