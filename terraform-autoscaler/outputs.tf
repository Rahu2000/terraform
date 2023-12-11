output "eks_cluster_name" {
  # value = data.terraform_remote_state.eks.outputs.eks_cluster_name
  value = var.eks_cluster_name

}

output "eks_oidc_povider_arn" {
  value = local.eks_oidc_provider_arn 

} 
