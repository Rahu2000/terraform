project     = "demo"
region      = "ap-northeast-2"
abbr_region = "ane2"
env         = "dev"
org         = "example"

cluster_name = "demo-dev-example-ane2-prometheus"

helm_release = {
  name = "prometheus"
  service_account = {
    create = true
  }
  namespace = {
    create = true
  }
}

shared_account = {
  region = "ap-northeast-2"
}

target_account = {
  region          = "ap-northeast-2"
  assume_role_arn = "arn:aws:iam::<ACCOUNT>:role/<ASSUME_ROLE>"
}
