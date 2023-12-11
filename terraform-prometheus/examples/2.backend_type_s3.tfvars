project     = "demo"
region      = "ap-northeast-2"
abbr_region = "ane2"
env         = "dev"
org         = "example"

remote_backend = {
  type = "s3"
  workspaces = [{
    service = "eks"
    bucket  = "demo-common-terraform-state"
    key     = "demo/ap-northeast-2/eks.tfstat"
    region  = "ap-northeast-2"
  }]
}

helm_release = {
  name = "prometheus"
  service_account = {
    create = true
  }
  namespace = {
    create = true
  }
}
