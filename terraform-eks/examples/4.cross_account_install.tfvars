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
    name            = "apps"
    instance_type   = "t3.small"
    instance_volume = "10"
    desired_size    = 2
    min_size        = 1
    max_size        = 4
    description     = "Dev EKS Cluster"
  }
]

shared_account = {
  region  = "ap-northeast-2"
  profile = "default"
}

target_account = {
  region          = "ap-northeast-2"
  assume_role_arn = "arn:aws:iam::<ACCOUNT>:role/<ROLE_NAME>"
}
