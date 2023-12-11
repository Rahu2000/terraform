############################################
# AWS Provider Configuration
############################################
provider "aws" {
  region = var.shared_account.region == "" ? var.region : var.shared_account.region

  alias = "SHARED"

  profile = var.shared_account.profile == "" ? null : var.shared_account.profile

  dynamic "assume_role" {
    for_each = [var.shared_account.assume_role_arn]
    content {
      role_arn = assume_role.value
    }
  }

  ignore_tags {
    key_prefixes = ["created"]
  }
}

provider "aws" {
  region = var.target_account.region == "" ? var.region : var.target_account.region

  alias = "TARGET"

  profile = var.target_account.profile == "" ? null : var.target_account.profile

  dynamic "assume_role" {
    for_each = [var.target_account.assume_role_arn]
    content {
      role_arn = assume_role.value
    }
  }

  ignore_tags {
    key_prefixes = ["created"]
  }
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(local.cluster_info.certificate_authority_data)
    host                   = local.cluster_info.endpoint_url
    token                  = local.auth_token
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(local.cluster_info.certificate_authority_data)
  host                   = local.cluster_info.endpoint_url
  token                  = local.auth_token
}