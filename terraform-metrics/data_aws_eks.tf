data "aws_caller_identity" "current" {
  provider = aws.TARGET
}

data "aws_eks_cluster" "this" {
  name = local.eks_cluster_name

  provider = aws.TARGET
}

data "aws_eks_cluster_auth" "this" {
  name = local.eks_cluster_name

  provider = aws.TARGET
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer

  provider = aws.TARGET
}