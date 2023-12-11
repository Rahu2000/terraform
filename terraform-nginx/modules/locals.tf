locals {
  values = templatefile("${path.root}/template/ingress-nginx-values.tpl", {
    # Helm charts configuration
    namespace                   = var.helm_release.namespace.name
    service_account_name        = var.helm_release.service_account.name
    replica_count               = var.helm_release.replicas
    resources                   = var.helm_release.resources
    affinity                    = var.helm_release.affinity
    node_selector               = var.helm_release.node_selector
    tolerations                 = var.helm_release.tolerations
    topology_spread_constraints = var.helm_release.topology_spread_constraints

    # Ingress nginx configuration
    service_annotations      = var.nginx_config.service.annotations
    enable_http              = var.nginx_config.service.enable_http
    enable_https             = var.nginx_config.service.enable_https
    service_ports            = var.nginx_config.service.ports
    service_target_ports     = var.nginx_config.service.target_ports
    ingress_class_name       = var.nginx_config.controller.ingress_class_name
    sysctls                  = var.nginx_config.controller.sysctls
    metrics_enabled          = var.nginx_config.controller.metrics_enabled
    service_monitor_enabled  = var.nginx_config.controller.service_monitor_enabled
    prometheus_rule_enabled  = var.nginx_config.controller.prometheus_rule_enabled
    autoscaling_enabled      = var.nginx_config.controller.autoscaling.enable
    autoscaling_min_replicas = var.nginx_config.controller.autoscaling.min_replicas
    autoscaling_max_replicas = var.nginx_config.controller.autoscaling.max_replicas
    tcp_services             = var.nginx_config.tcp_services
    udp_services             = var.nginx_config.udp_services
  })
}
