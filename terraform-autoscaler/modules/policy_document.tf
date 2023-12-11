resource "aws_iam_policy" "cluster-autoscaler" {
  name        = local.service_account_policy_name
  description = "cluster autoscaler policy"

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup"
      ],
      "Resource": ["*"]
    }
	]
}
EOF

  tags = merge (
    var.common_tags,
    tomap( {"Name" = local.service_account_policy_name })
  )
}

