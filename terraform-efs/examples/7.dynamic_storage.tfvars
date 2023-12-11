project     = "DEMO"
region      = "ap-northeast-2"
abbr_region = "ANE2"
env         = "DEV"
org         = "ORG"

cluster_name = "DEMO-ANE2-EKS"

helm_release = {
  name          = "aws-efs-csi-driver"
  chart_version = "2.3.8"

  service_account = {
    create = true
    name   = "efs-csi-controller-sa"
    iam = {
      create      = true
      role_name   = "DEMO-ANE2-EKS-EFS-IAM-ROLE"
      policy_name = "DEMO-ANE2-EKS-EFS-IAM-POLICY"
    }
  }
}

file_systems = [
  {
    manifest = {
      name                  = "default-efs"
      dynamic_storage_class = true
      storage_capacity      = "100Gi"
      volume_handle         = "fs-0a9c4aeb51c36375b"
      directory_perms       = "770"
    }
  }
]

shared_account = {
  region = "ap-northeast-2"
}

target_account = {
  region = "ap-northeast-2"
}
