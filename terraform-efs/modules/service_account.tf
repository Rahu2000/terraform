resource "aws_iam_policy" "this" {
  name        = local.service_account_policy_name
  description = "aws efs csi driver policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:DescribeAccessPoints",
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:DescribeMountTargets",
        "ec2:DescribeAvailabilityZones"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:CreateAccessPoint"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:RequestTag/efs.csi.aws.com/cluster": "true"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "elasticfilesystem:DeleteAccessPoint",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
        }
      }
    }
  ]
}
EOF

  tags = merge(
    var.common_tags,
    tomap({ "Name" = local.service_account_policy_name })
  )
}

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.this.json
  name               = local.service_account_role_name

  tags = merge(
    var.common_tags,
    tomap({ "Name" = local.service_account_role_name })
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

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}
