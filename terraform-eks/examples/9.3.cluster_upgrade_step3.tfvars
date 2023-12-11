project     = "demo"
region      = "ap-northeast-2"
abbr_region = "an2"
env         = "dev"
org         = "example"

vpc_id             = "vpc-0d2502934730afebd"
private_subnet_ids = ["subnet-0e0586fa9048f932a", "subnet-0c7ea9aa38102c6d4"]
public_subnet_ids  = ["subnet-0ab6dc3405d2c171c", "subnet-09eef3c587f0f5f7d"]

eks_cluster_version = "1.26"

eks_node_groups = [
  {
    name                = "apps-v1-26"
    use_spot            = true
    spot_instance_types = ["t3.small"]
    instance_volume     = "10"
    desired_size        = 2
    min_size            = 1
    max_size            = 4
    description         = "Dev EKS Cluster"
  }
]

eks_addons = [
  {
    name    = "aws-ebs-csi-driver"
    install = true
    version = "v1.17.0-eksbuild.1"
    policy_arns = [
      "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    ]
    policy_file = "kms-key-for-encryption-on-ebs.tpl"
  },
  {
    name              = "vpc-cni"
    install           = true
    version           = "v1.12.6-eksbuild.1"
    resolve_conflicts = "PRESERVE"
    policy_arns = [
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ]
  },
  {
    name    = "coredns"
    version = "v1.9.3-eksbuild.2"
    install = true
  },
  {
    name    = "kube-proxy"
    version = "v1.26.2-eksbuild.1"
    install = true
  }
]
