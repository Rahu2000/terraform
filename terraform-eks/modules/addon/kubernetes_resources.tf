# Add new default storage class
resource "kubernetes_storage_class" "gp3" {
  count = local.create_storage_class ? 1 : 0

  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Retain"
  parameters = {
    "type"                      = "gp3"
    "csi.storage.k8s.io/fstype" = "ext4"
    "encrypted"                 = local.create_storage_class && local.enable_ebs_encryption ? "'true'" : null
    "kmsKeyId"                  = local.create_storage_class && local.enable_ebs_encryption ? "${local.kmsKeyId}" : null
  }
  allow_volume_expansion = "true"
  volume_binding_mode    = "WaitForFirstConsumer"

  depends_on = [
    aws_eks_addon.addon
  ]
}

# Remove default annotation from gp2 (kubernetes.io/aws-ebs: no longer supported PROVISIONER)
resource "kubernetes_annotations" "gp2" {
  count = local.create_storage_class ? 1 : 0

  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  metadata {
    name = "gp2"
  }
  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "false"
  }

  force = "true"

  depends_on = [
    aws_eks_addon.addon
  ]
}

# Add encrypted storage class
resource "kubernetes_storage_class" "encrypted" {
  count = local.create_storage_class && local.enable_ebs_encryption ? 1 : 0

  metadata {
    name = "encrypted"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"
  parameters = {
    "type"                      = "gp3"
    "csi.storage.k8s.io/fstype" = "ext4"
    "encrypted"                 = "'true'"
    "kmsKeyId"                  = "${local.kmsKeyId}"
  }
  allow_volume_expansion = "true"
  volume_binding_mode    = "WaitForFirstConsumer"

  depends_on = [
    aws_eks_addon.addon
  ]
}
