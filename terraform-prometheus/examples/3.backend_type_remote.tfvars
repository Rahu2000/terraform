project     = "demo"
region      = "ap-northeast-2"
abbr_region = "ane2"
env         = "dev"
org         = "example"

remote_backend = {
  type = "remote"
  workspaces = [{
    service        = "eks"
    org            = "rahu2000"
    workspace_name = "demo-dev-eks"
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
