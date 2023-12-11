data "aws_caller_identity" "current" {
  provider = aws.TARGET
}

data "aws_eks_cluster" "this" {
  name = local.cluster_name

  provider = aws.TARGET
}

data "aws_eks_cluster_auth" "this" {
  name = local.cluster_name

  provider = aws.TARGET
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer

  provider = aws.TARGET
}

data "aws_vpc" "this" {
  id = data.aws_eks_cluster.this.vpc_config[0].vpc_id

  provider = aws.TARGET
}
