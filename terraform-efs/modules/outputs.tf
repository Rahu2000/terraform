output "service_account" {
  value = {
    name       = local.service_account_name
    role_arn   = aws_iam_role.this.arn
    policy_arn = aws_iam_policy.this.arn
  }
}

output "helm_release" {
  value = {
    name      = helm_release.aws_efs_csi_driver.name
    varsion   = helm_release.aws_efs_csi_driver.version
    namespace = helm_release.aws_efs_csi_driver.namespace
  }
}

output "persistent_volumes" {
  value = values(kubernetes_manifest.this)[*].manifest.metadata.name
}

output "storage_classes" {
  value = values(kubernetes_storage_class.this)[*].metadata[0].name
}
