data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.helm_release.namespace.name}:${local.service_account_name}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider.url, "https://", "")}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }

    principals {
      identifiers = [var.oidc_provider.arn]
      type        = "Federated"
    }
  }
}

# create an iam policy for aws-load-balancer-controller
resource "aws_iam_policy" "this" {
  name        = local.service_account_policy_name
  description = format("policy document for %s aws load balance controller ", var.cluster_name)

  policy = data.http.iam_policy.response_body

  tags = merge(
    var.common_tags,
    tomap({ "Name" = local.service_account_policy_name })
  )
}

# create an iam role for aws-load-balancer-controller
resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.this.json
  name               = local.service_account_role_name
  description        = format("role for %s aws load balance controller", var.cluster_name)

  tags = merge(
    var.common_tags,
    tomap({ "Name" = local.service_account_role_name })
  )
}

# attach policy to role
resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}
