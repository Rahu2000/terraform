# Create static PV
resource "kubernetes_manifest" "this" {
  for_each = { for x in var.file_systems : x.manifest.name => x if !x.manifest.dynamic_storage_class }

  manifest = {
    "apiVersion" = "v1"
    "kind"       = "PersistentVolume"
    "metadata" = {
      "name" = "${each.value.manifest.name}"
    }
    "spec" = {
      "capacity" = {
        "storage" = "${each.value.manifest.storage_capacity}"
      }
      "volumeMode"                    = "Filesystem"
      "accessModes"                   = "${each.value.manifest.access_mode}"
      "persistentVolumeReclaimPolicy" = "${each.value.manifest.reclaim_policy}"
      "storageClassName"              = "${each.value.manifest.name}"
      "csi" = {
        "driver"       = "efs.csi.aws.com"
        "volumeHandle" = "${each.value.manifest.volume_handle}"
      }
    }
  }
}

# Add new efs default storage class
resource "kubernetes_storage_class" "this" {
  for_each = { for x in var.file_systems : x.manifest.name => x if x.manifest.dynamic_storage_class }

  metadata {
    name = coalesce(each.value.manifest.storage_class_name, each.value.manifest.name)
  }
  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = each.value.manifest.reclaim_policy
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = each.value.manifest.volume_handle
    directoryPerms   = each.value.manifest.directory_perms
    gidRangeStart    = try(each.value.manifest.gid_start, "") == "" ? null : each.value.manifest.gid_start
    gidRangeEnd      = try(each.value.manifest.gid_end, "") == "" ? null : each.value.manifest.gid_end
    basePath         = try(each.value.manifest.base_path, "") == "" ? null : each.value.manifest.base_path
  }
}
