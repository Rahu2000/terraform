output "service_account" {
  value = module.aws_efs_csi_driver.service_account
}

output "helm_release" {
  value = module.aws_efs_csi_driver.helm_release
}

output "persistent_volumes" {
  value = module.aws_efs_csi_driver.persistent_volumes
}

output "storage_classes" {
  value = module.aws_efs_csi_driver.storage_classes
}
