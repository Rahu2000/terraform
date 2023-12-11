project     = "DEMO"
region      = "ap-northeast-2"
abbr_region = "ANE2"
env         = "DEV"
org         = "ORG"

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
  name = "aws-efs-csi-driver"
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

shared_account = {
  region = "ap-northeast-2"
}

target_account = {
  region = "ap-northeast-2"
}
