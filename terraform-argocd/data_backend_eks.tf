locals {
  eks_package_bucket_name   = var.backend_s3_bucket_name
  eks_package_bucket_key    = var.eks_s3_key
  eks_package_bucket_region = var.bucket_region
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = local.eks_package_bucket_name
    key    = local.eks_package_bucket_key
    region = local.eks_package_bucket_region
  }
}
