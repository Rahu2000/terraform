resource "aws_eks_cluster" "cluster" {
  name     = var.eks_cluster_name
  version  = var.eks_cluster_version
  role_arn = aws_iam_role.cluster.arn

  enabled_cluster_log_types = var.log_types

  vpc_config {
    security_group_ids      = var.security_group_list
    subnet_ids              = var.subnet_id_list
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  tags = merge(
    var.common_tags,
    tomap({ "Name" = var.eks_cluster_name })
  )

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController
  ]
}
