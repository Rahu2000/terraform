locals {
  addon = { for x in var.eks_addons : replace(x.name, "-", "_") => x if x.name == "vpc-cni" }
  DEFAULT_POLICY_ARNS = [
    { arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" },
    { arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" },
    { arn = try(local.addon.vpc_cni.install, false) ? "" : "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" },
    { arn = var.eks_node_group_info.enable_ssm ? "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" : "" },
    { arn = var.eks_node_group_info.enable_ssm ? "arn:aws:iam::aws:policy/AmazonSSMFullAccess" : "" }
  ]
}

resource "aws_iam_role" "nodegroup" {
  name                  = var.eks_node_group_info.role_name
  force_detach_policies = false

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = merge(
    var.common_tags,
    tomap({ "Name" = var.eks_node_group_info.role_name })
  )

  lifecycle {
    ignore_changes = [
      tags["created"]
    ]
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = { for k, v in local.DEFAULT_POLICY_ARNS : v.arn => v.arn if v.arn != "" }
  policy_arn = each.value
  role       = aws_iam_role.nodegroup.name
}
