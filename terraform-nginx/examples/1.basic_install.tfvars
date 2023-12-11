project     = "demo"
region      = "ap-northeast-2"
abbr_region = "an2"
env         = "dev"
org         = "example"

cluster_name = "demo-example-an2-dev-eks"

helm_release = {
  name = "ingress-nginx"
  namespace = {
    create = true
    name   = "ingress-nginx"
  }
}
