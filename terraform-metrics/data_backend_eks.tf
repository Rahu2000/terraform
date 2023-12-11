locals {
  eks_package_bucket_name   = var.backend_s3_bucket_name
  eks_package_bucket_key    = var.bucket_key
  eks_package_bucket_region = var.bucket_region
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  # workspace = terraform.workspace 
  config = {
    bucket = local.eks_package_bucket_name
    key    = local.eks_package_bucket_key
    region = local.eks_package_bucket_region
  }
}

# data "terraform_remote_state" "s3_eks" {
#   count = lower(var.remote_backend.type) == "s3" ? 1 : 0

#   backend   = "s3"
#   workspace = terraform.workspace
#   config = {
#     bucket = var.remote_backend.bucket
#     key    = var.remote_backend.key
#     region = var.region
#   }
# }

# data "terraform_remote_state" "remote_eks" {
#   count = lower(var.remote_backend.type) == "remote" ? 1 : 0

#   backend   = "remote"
#   workspace = terraform.workspace
#   config = {
#     organization = var.remote_backend.org
#     workspaces = {
#       name = var.remote_backend.workspace_name
#     }
#   }
# }


