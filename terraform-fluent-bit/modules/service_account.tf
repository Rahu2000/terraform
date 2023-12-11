resource "aws_iam_policy" "opensearch" {
  count       = local.opensearch_policy.enabled ? 1 : 0
  name        = local.opensearch_policy.name
  description = "aws opensearch policy for fluent-bit"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": ["es:ESHttp*"],
        "Resource": "${var.conf.outputs.opensearch.aws.domain_arn}",
        "Effect": "Allow"
      }
    ]
  }
  EOF

  tags = merge(
    var.common_tags,
    tomap({ "Name" = local.opensearch_policy.name })
  )
}

resource "aws_iam_policy" "cloudwatch" {
  count       = local.cloudwatch_policy.enabled ? 1 : 0
  name        = local.cloudwatch_policy.name
  description = "aws opensearch policy for fluent-bit"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
  }
  EOF

  tags = merge(
    var.common_tags,
    tomap({ "Name" = local.cloudwatch_policy.name })
  )
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.helm_release.namespace.name}:${var.helm_release.service_account.name}"
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

resource "aws_iam_role" "this" {
  count              = var.helm_release.service_account.iam.create ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.this.json
  name               = local.service_account_role_name

  tags = merge(
    var.common_tags,
    tomap({ "Name" = local.service_account_role_name })
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = { for k, v in local.fluent_bit_policies : k => v if v != "" }
  policy_arn = each.value
  role       = var.helm_release.service_account.iam.create ? aws_iam_role.this[0].name : ""
}
