data "terraform_remote_state" "s3_eks" {
  count = local.backend_s3_eks ? 1 : 0

  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = local.remote_state_eks.eks.bucket
    key    = local.remote_state_eks.eks.key
    region = local.remote_state_eks.eks.region
  }
}

data "terraform_remote_state" "remote_eks" {
  count = local.backend_remote_eks ? 1 : 0

  backend = "remote"
  config = {
    organization = local.remote_state_eks.eks.org
    workspaces = {
      name = local.remote_state_eks.eks.workspace_name
    }
  }
}
