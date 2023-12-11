locals {

  helm_values = {
    controller = var.controller_values
    dex           = var.dex_values
    redis         = var.redis_values
    redis-ha      = var.redis_ha_values
    server        = var.server_values
    repoServer    = var.repoServer_values
    configs       = var.configs_values
    applicationSet = var.applicationset_values
    notifications = var.notifications_values
    global        = var.global_values

  }

}