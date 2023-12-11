data "terraform_remote_state" "s3_network" {
  count = local.backend_s3_network ? 1 : 0

  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = local.remote_state_network.network.bucket
    key    = local.remote_state_network.network.key
    region = local.remote_state_network.network.region
  }
}

data "terraform_remote_state" "remote_network" {
  count = local.backend_remote_network ? 1 : 0

  backend = "remote"
  config = {
    organization = local.remote_state_network.network.org
    workspaces = {
      name = local.remote_state_network.network.workspace_name
    }
  }
}
