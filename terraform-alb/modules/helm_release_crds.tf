locals {
  # https://github.com/hashicorp/terraform-provider-kubernetes-alpha/issues/164
  # 'status' attribute key is not allowed
  not_allowed_key = "status:\n  acceptedNames:\n    kind: \"\"\n    plural: \"\"\n  conditions: []\n  storedVersions: []\n"
  yamls           = [for data in split("---", replace(data.http.crds.response_body, local.not_allowed_key, "")) : yamldecode(data)]
}

# apply crds
resource "kubernetes_manifest" "crds" {
  count    = length(local.yamls)
  manifest = local.yamls[count.index]
}
