# ### Local Output 
# output "aws_callerr_identity_current" {
#   value = data.aws_caller_identity.current
# }

output "endpoint_url" {
  value = local.endpoint_url #data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
}

# output "cluster_ca_cerrtificate" {
#   value = data.terraform_remote_state.s3_eks[0].outputs.eks_cluster_certificate_authority_data
# }


output "eks_cluster_name" {
  value = local.eks_cluster_name #data.terraform_remote_state.eks.outputs.eks_cluster_name
}

# output "aws_eks_cluster_auth" {
#   value = data.aws_eks_cluster_auth.this.token
#   sensitive = true

# }

# output "image_repo" {
#   value = var.image_repo

# }
# output "image_tag" {
#   value = var.image_tag

# }
