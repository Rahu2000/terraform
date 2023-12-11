locals {
  relabeling = var.kube_state_metrics.monitor.relabeling == "" ? (var.node_exporter.monitor.relabeling == "" ? "" : var.node_exporter.monitor.relabeling) : var.kube_state_metrics.monitor.relabeling
  values = templatefile("${path.root}/template/kube-prometheus-stack-values.tpl", {
    # Set tags
    project = var.project
    org     = var.org
    env     = var.env
    region  = var.region

    # Set global options
    full_name    = var.helm_release.name
    replicas     = var.helm_release.replicas
    kube_version = format("%s.%s", var.cluster_version, "0")

    # Set additional prometheus rules
    additional_prometheus_rules = var.additional_prometheus_rules

    # Set alertmanager options
    alertmanager_enabled             = var.alert_manager.enabled
    alertmanager_ingress_enabled     = var.alert_manager.ingress.enabled
    alertmanager_ingress_class_name  = var.alert_manager.ingress.class_name
    alertmanager_ingress_annotations = var.alert_manager.ingress.annotations
    alertmanager_hosts               = var.alert_manager.ingress.hosts
    alertmanager_tls                 = var.alert_manager.ingress.tls
    alertmanager_volume_enabled      = var.alert_manager.volume.enabled
    alertmanager_volume_size         = var.alert_manager.volume.size
    alertmanager_resources           = var.alert_manager.resources

    # Set grafana options
    grafana_enabled             = var.grafana.enabled
    grafana_admin_password      = random_password.grafana[0].result
    grafana_timezone            = var.grafana.timezone
    grafana_ingress_enabled     = var.grafana.ingress.enabled
    grafana_ingress_class_name  = var.grafana.ingress.class_name
    grafana_ingress_annotations = var.grafana.ingress.annotations
    grafana_hosts               = var.grafana.ingress.hosts
    grafana_tls                 = var.grafana.ingress.tls
    grafana_volume_enabled      = var.grafana.volume.enabled
    grafana_volume_size         = var.grafana.volume.size
    grafana_ini                 = var.grafana.ini
    grafana_resources           = var.grafana.resources
    grafana_sidecar_resources   = var.grafana.sidecar.resources

    # Set kube_state_metrics options
    kube_state_metrics_resources         = var.kube_state_metrics.resources
    kube_state_metrics_monitor_enabled   = var.kube_state_metrics.monitor.enabled
    kube_state_metrics_metric_relabeling = var.kube_state_metrics.monitor.metric_relabeling
    kube_state_metrics_relabeling        = local.relabeling

    # Set prometheus_node_exporter options
    node_exporter_resources       = var.node_exporter.resources
    node_exporter_monitor_enabled = var.node_exporter.monitor.enabled
    node_exporter_relabeling      = local.relabeling

    # Set prometheus operator options
    prometheus_operator_resources          = var.prometheus_operator.resources
    prometheus_operator_host_network       = var.prometheus_operator.host_network
    prometheus_operator_reloader_resources = var.prometheus_operator.reloader.resources

    # Set prometheus options
    prometheus_enabled                     = var.prometheus.enabled
    prometheus_ingress_enabled             = var.prometheus.ingress.enabled
    prometheus_ingress_class_name          = var.prometheus.ingress.class_name
    prometheus_ingress_annotations         = var.prometheus.ingress.annotations
    prometheus_hosts                       = var.prometheus.ingress.hosts
    prometheus_tls                         = var.prometheus.ingress.tls
    prometheus_scrape_interval             = var.prometheus.scrape_interval
    prometheus_retention                   = var.prometheus.retention
    prometheus_replica_external_label_name = var.prometheus.replica_external_label_name
    prometheus_external_cluster_name       = var.cluster_name
    prometheus_external_labels             = var.prometheus.external_labels
    prometheus_remote_write                = var.prometheus.remote_write
    prometheus_remote_write_dashboards     = var.prometheus.remote_write_dashboards
    prometheus_resources                   = var.prometheus.resources
    prometheus_volume_enabled              = var.prometheus.volume.enabled
    prometheus_volume_size                 = var.prometheus.volume.size

    # Set common options
    affinity                    = var.helm_release.affinity
    node_selector               = var.helm_release.node_selector
    tolerations                 = var.helm_release.tolerations
    topology_spread_constraints = var.helm_release.topology_spread_constraints
  })

  network_policy_yaml = templatefile("${path.root}/template/simple-prometheus-network-policy.tpl", {
    namespace         = var.helm_release.namespace.name
    kubernetes_api_ip = var.k8s_api_endpoint
    pod_ip_ranges     = var.vpc_cidr_blocks
  })
}
