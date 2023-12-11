output "aws_auth" {
  value = kubernetes_config_map_v1_data.aws_auth[*].data
}
