project     = "demo"
region      = "ap-northeast-2"
abbr_region = "ane2"
env         = "dev"
org         = "example"

cluster_name = "demo-example-an2-dev-eks"

helm_release = {
  name = "kyverno"
  service_account = {
    create = true
  }
  namespace = {
    create = true
  }
}

policies_release = {
  name = "kyverno-policies"
}
