output "eks_cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "eks_cluster_version" {
  value = aws_eks_cluster.cluster.version
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "eks_cluster_security_group_ids" {
  value = flatten([aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id, try(aws_eks_cluster.cluster.vpc_config.0.security_group_ids, "")])
}

output "eks_cluster_info" {
  value = aws_eks_cluster.cluster
}
