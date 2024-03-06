project     = "demo"
region      = "ap-southeast-2"
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

nginx_config = {
  service = {
    annotations = <<-EOT
      service.beta.kubernetes.io/aws-load-balancer-name: "sso-demo"
      service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
      service.beta.kubernetes.io/aws-load-balancer-type: "external"
      service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: "ip"
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "tcp"
      service.beta.kubernetes.io/aws-load-balancer-subnets: "subnet-093cb68bb2933ab2e, subnet-0f1cd84f3284c7bd6"
      service.beta.kubernetes.io/aws-load-balancer-attributes: "load_balancing.cross_zone.enabled=true"		# cross zone 설정
      service.beta.kubernetes.io/aws-load-balancer-target-group-attributes: preserve_client_ip.enabled=true
    EOT
  }
}
