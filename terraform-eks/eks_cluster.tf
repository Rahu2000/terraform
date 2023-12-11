module "eks_cluster" {
  source = "./modules/cluster"

  project = var.project
  env     = var.env
  region  = var.region

  eks_cluster_name      = local.eks_cluster_name
  eks_cluster_version   = var.eks_cluster_version
  eks_cluster_role_name = var.eks_cluster_role_name == "" ? format("%s-role", local.eks_cluster_name) : var.eks_cluster_role_name

  subnet_id_list      = concat(local.network.k8s_private_subnet_ids, local.network.k8s_public_subnet_ids)
  security_group_list = concat([aws_security_group.cluster.id], local.cluster_sg_ids)

  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = var.endpoint_private_access

  public_access_cidrs = local.public_access_white_list

  common_tags = local.common_tags

  providers = {
    aws = aws.TARGET
  }
}
