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

  sets = [
    {
      key   = "global.imageRegistry"
      value = "<ACCOUNT>.dkr.ecr.ap-northeast-2.amazonaws.com"
    },
    {
      key   = "grafana.image.repository"
      value = "<ACCOUNT>.dkr.ecr.ap-northeast-2.amazonaws.com/grafana/grafana"
    },
    {
      key   = "grafana.downloadDashboardsImage.image.repository"
      value = "<ACCOUNT>.dkr.ecr.ap-northeast-2.amazonaws.com/curlimages/curl"
    },
    {
      key   = "grafana.initChownData.image.repository"
      value = "<ACCOUNT>.dkr.ecr.ap-northeast-2.amazonaws.com/busybox"
    },
    {
      key   = "grafana.sidecar.image.repository"
      value = "<ACCOUNT>.dkr.ecr.ap-northeast-2.amazonaws.com/kiwigrid/k8s-sidecar"
    }
  ]
}
