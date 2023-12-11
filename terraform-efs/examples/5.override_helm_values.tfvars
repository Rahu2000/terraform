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

  sets = [
    {
      key   = "image.repository"
      value = "<ACCOUNT>.dkr.ecr.ap-northeast-2.amazonaws.com/aws-efs-csi-driver"
    },
    {
      key   = "sidecars.livenessProbe.image.repository"
      value = "<ACCOUNT>.dkr.ecr.ap-northeast-2.amazonaws.com/livenessprobe"
    },
    {
      key   = "sidecars.nodeDriverRegistrar.image.repository"
      value = "<ACCOUNT>.dkr.ecr.ap-northeast-2.amazonaws.com/node-driver-registrar"
    },
    {
      key   = "sidecars.csiProvisioner.image.repository"
      value = "<ACCOUNT>.dkr.ecr.ap-northeast-2.amazonaws.com/external-provisioner"
    }
  ]
}

shared_account = {
  region = "ap-northeast-2"
}

target_account = {
  region = "ap-northeast-2"
}
