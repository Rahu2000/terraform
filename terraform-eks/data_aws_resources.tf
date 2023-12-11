# Get AWS Account ID
data "aws_caller_identity" "current" {
  provider = aws.TARGET
}

# Get a list of EKS clusters to find existing clusters
data "aws_eks_clusters" "this" {
  provider = aws.TARGET
}

# Get existing cluster information
data "aws_eks_cluster" "this" {
  count = local.existing_cluster ? 1 : 0
  name  = local.eks_cluster_name

  provider = aws.TARGET
}

# Get a list of EKS cluster's nodegroup
data "aws_eks_node_groups" "this" {
  count        = local.existing_cluster ? 1 : 0
  cluster_name = local.eks_cluster_name

  provider = aws.TARGET
}

# Get EKS nodes metadata
data "aws_eks_node_group" "this" {
  for_each = local.existing_nodes

  cluster_name    = local.eks_cluster_name
  node_group_name = each.value

  provider = aws.TARGET
}

data "aws_iam_openid_connect_provider" "this" {
  count = local.existing_cluster ? 1 : 0
  url   = data.aws_eks_cluster.this[0].identity[0].oidc[0].issuer

  provider = aws.TARGET
}

data "aws_eks_cluster_auth" "cluster" {
  count = local.existing_cluster ? 0 : 1
  name  = module.eks_cluster.eks_cluster_name

  depends_on = [
    module.eks_cluster
  ]

  provider = aws.TARGET
}

data "aws_eks_cluster_auth" "existing_cluster" {
  count = local.existing_cluster ? 1 : 0
  name  = local.eks_cluster_name

  provider = aws.TARGET
}
