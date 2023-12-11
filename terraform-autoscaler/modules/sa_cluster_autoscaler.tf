resource "aws_iam_role" "cluster-autoscaler" {
  assume_role_policy = data.aws_iam_policy_document.cluster-autoscaler.json
  name               = local.service_account_role_name

  tags = merge (
    var.common_tags,
    tomap( {"Name" = local.service_account_role_name })
  )
}

data "aws_iam_policy_document" "cluster-autoscaler" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_provider_url, "https://", "")}:sub"
      values   = [
        "system:serviceaccount:${var.namespace}:${local.service_account_name}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_provider_url, "https://", "")}:aud"
      values   = [
        "sts.amazonaws.com"
      ]
    }

    principals {
      identifiers = [var.eks_oidc_provider_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role_policy_attachment" "cluster-autoscaler" {
  policy_arn = aws_iam_policy.cluster-autoscaler.arn
  role       = aws_iam_role.cluster-autoscaler.name
}

output "sa_role_name" {
  value = aws_iam_role.cluster-autoscaler.name
}

output "sa_role_arn" {
  value = aws_iam_role.cluster-autoscaler.arn
}

output "sa_policy_document" {
	value = data.aws_iam_policy_document.cluster-autoscaler.json
}