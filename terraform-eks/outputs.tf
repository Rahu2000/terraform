output "eks_cluster_name" {
  value = module.eks_cluster.eks_cluster_name
}

output "eks_cluster_version" {
  value = module.eks_cluster.eks_cluster_version
}

output "eks_cluster_endpoint" {
  value = module.eks_cluster.eks_cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = module.eks_cluster.eks_cluster_certificate_authority_data
}

output "eks_oidc_provider_arn" {
  value = module.eks_cluster.oidc_provider_arn
}

output "eks_oidc_provider_url" {
  value = module.eks_cluster.oidc_provider_url
}

output "eks_cluster_security_group_ids" {
  value = module.eks_cluster.eks_cluster_security_group_ids
}

output "eks_cluster_info" {
  value = module.eks_cluster.eks_cluster_info
}

output "aws_auth" {
  value = module.kubernetes.aws_auth
}
