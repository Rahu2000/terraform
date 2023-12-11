project     = "demo"
region      = "ap-northeast-2"
abbr_region = "an2"
env         = "dev"
org         = "example"

vpc_id             = "vpc-0d2502934730afebd"
private_subnet_ids = ["subnet-0e0586fa9048f932a", "subnet-0c7ea9aa38102c6d4"]
public_subnet_ids  = ["subnet-0ab6dc3405d2c171c", "subnet-09eef3c587f0f5f7d"]

eks_node_groups = [
  {
    name                = "apps"
    use_spot            = true
    spot_instance_types = ["t3.small"]
    instance_volume     = "10"
    desired_size        = 2
    min_size            = 1
    max_size            = 4
    description         = "Dev EKS Cluster"
  }
]

# Supported addons: vpc-cni, kube-proxy, coredns, aws-ebs-csi-driver
eks_addons = [
  {
    name    = "aws-ebs-csi-driver"
    install = true
    policy_arns = [
      "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    ]
    policy_file = "kms-key-for-encryption-on-ebs.tpl"
  },
  {
    name    = "vpc-cni"
    install = true
    policy_arns = [
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ]
  },
  {
    name    = "coredns"
    install = true
  },
  {
    name    = "kube-proxy"
    install = true
  }
]
