project     = "demo"
region      = "ap-northeast-2"
abbr_region = "an2"
env         = "dev"
org         = "example"

remote_backend = {
  type = "s3"
  workspaces = [{
    service = "network"
    bucket  = "demo-common-terraform-state"
    key     = "demo/ap-northeast-2/network.tfstat"
    region  = "ap-northeast-2"
  }]
}

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
