kubeTargetVersionOverride: ${kube_version}
fullnameOverride: ${full_name}

commonLabels:
  tenant: ${org}
  project: ${project}
  env: ${env}
  region: ${region}

defaultRules:
  labels:
    tenant: ${org}
    project: ${project}
    env: ${env}
    region: ${region}

%{ if additional_prometheus_rules != "" ~}
additionalPrometheusRulesMap:
  rule-name:
    ${indent(4, additional_prometheus_rules)}
%{ endif ~}

alertmanager:
  enabled: ${alertmanager_enabled}

  ingress:
    enabled: ${alertmanager_ingress_enabled}
%{ if alertmanager_ingress_class_name != "" ~}
    ingressClassName: ${alertmanager_ingress_class_name}
%{ endif ~}
%{ if alertmanager_ingress_annotations != "" ~}
    annotations:
      ${indent(6, alertmanager_ingress_annotations)}
%{ endif ~}
%{ if length(alertmanager_hosts) > 0 ~}
    hosts:
%{ for host in alertmanager_hosts }
    - ${host}
%{ endfor ~}
%{ endif ~}
%{ for tls in alertmanager_tls }
    tls:
    - secretName:  ${tls.secret_name}
%{ if length(tls.hosts) > 0 ~}
      hosts:
%{ for host in tls.hosts }
      - ${host}
%{ endfor ~}
%{ endif ~}
%{ endfor ~}

  alertmanagerSpec:
%{ if affinity != "" ~}
    affinity:
      ${indent(6, affinity)}
%{ endif ~}
%{ if node_selector != "" ~}
    nodeSelector:
      ${indent(6, node_selector)}
%{ endif ~}
%{ if tolerations != "" ~}
    tolerations:
      ${indent(6, tolerations)}
%{ endif ~}
%{ if alertmanager_resources != "" ~}
    resources:
      ${indent(6, alertmanager_resources)}
%{ endif ~}
%{ if alertmanager_volume_enabled == true ~}
    storage:
      volumeClaimTemplate:
        spec:
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: ${alertmanager_volume_size}
%{ endif ~}

grafana:
  enabled: ${grafana_enabled}
  adminPassword: ${grafana_admin_password}
  defaultDashboardsTimezone: ${grafana_timezone}

%{ if affinity != "" ~}
  affinity:
    ${indent(4, affinity)}
%{ endif ~}
%{ if node_selector != "" ~}
  nodeSelector:
    ${indent(4, node_selector)}
%{ endif ~}
%{ if tolerations != "" ~}
  tolerations:
    ${indent(4, tolerations)}
%{ endif ~}
%{ if grafana_resources != "" ~}
  resources:
    ${indent(4, grafana_resources)}
%{ endif ~}
  persistence:
    enabled: ${grafana_volume_enabled}
    size: ${grafana_volume_size}

  ingress:
    enabled: ${grafana_ingress_enabled}
%{ if grafana_ingress_class_name != "" ~}
    ingressClassName: ${grafana_ingress_class_name}
%{ endif ~}
%{ if grafana_ingress_annotations != "" ~}
    annotations:
      ${indent(6, grafana_ingress_annotations)}
%{ endif ~}
%{ if length(grafana_hosts) > 0 ~}
    hosts:
%{ for host in grafana_hosts }
    - ${host}
%{ endfor ~}
%{ endif ~}
%{ for tls in grafana_tls }
    tls:
    - secretName:  ${tls.secret_name}
%{ if length(tls.hosts) > 0 ~}
      hosts:
%{ for host in tls.hosts }
      - ${host}
%{ endfor ~}
%{ endif ~}
%{ endfor ~}

%{ if grafana_ini != "" ~}
  grafana.ini:
    ${indent(4, grafana_ini)}
%{ endif ~}
%{ if grafana_sidecar_resources != "" ~}
  sidecar:
    resources:
      ${indent(6, grafana_sidecar_resources)}
%{ endif ~}

kube-state-metrics:
  extraArgs:
    - '--metric-labels-allowlist=nodes=[eks.amazonaws.com/nodegroup]'
%{ if affinity != "" ~}
  affinity:
    ${indent(4, affinity)}
%{ endif ~}
%{ if node_selector != "" ~}
  nodeSelector:
    ${indent(4, node_selector)}
%{ endif ~}
%{ if tolerations != "" ~}
  tolerations:
    ${indent(4, tolerations)}
%{ endif ~}
%{ if kube_state_metrics_resources != "" ~}
  resources:
    ${indent(4, kube_state_metrics_resources)}
%{ endif ~}
  prometheus:
    monitor:
      enabled: ${kube_state_metrics_monitor_enabled}
%{ if kube_state_metrics_metric_relabeling != "" ~}
      metricRelabelings:
        ${indent(8, kube_state_metrics_metric_relabeling)}
%{ endif ~}
%{ if kube_state_metrics_relabeling != "" ~}
      relabelings:
        ${indent(8, kube_state_metrics_relabeling)}
%{ endif ~}

prometheus-node-exporter:
%{ if node_exporter_resources != "" ~}
  resources:
    ${indent(4, node_exporter_resources)}
%{ endif ~}
  prometheus:
    monitor:
      enabled: ${node_exporter_monitor_enabled}
%{ if node_exporter_relabeling != "" ~}
      relabelings:
        ${indent(8, node_exporter_relabeling)}
%{ endif ~}

prometheusOperator:
  logFormat: logfmt
  logLevel: error
  hostNetwork: ${prometheus_operator_host_network}

%{ if affinity != "" ~}
  affinity:
    ${indent(4, affinity)}
%{ endif ~}
%{ if node_selector != "" ~}
  nodeSelector:
    ${indent(4, node_selector)}
%{ endif ~}
%{ if tolerations != "" ~}
  tolerations:
    ${indent(4, tolerations)}
%{ endif ~}
%{ if prometheus_operator_resources != "" ~}
  resources:
    ${indent(4, prometheus_operator_resources)}
%{ endif ~}
%{ if prometheus_operator_reloader_resources != "" ~}
  prometheusConfigReloader:
    resources:
      ${indent(6, prometheus_operator_reloader_resources)}
%{ endif ~}

prometheus:
  enabled: ${prometheus_enabled}
  ingress:
    enabled: ${prometheus_ingress_enabled}
%{ if prometheus_ingress_class_name != "" ~}
    ingressClassName: ${prometheus_ingress_class_name}
%{ endif ~}
%{ if prometheus_ingress_annotations != "" ~}
    annotations:
      ${indent(6, prometheus_ingress_annotations)}
%{ endif ~}
%{ if length(prometheus_hosts) > 0 ~}
    hosts:
%{ for host in prometheus_hosts }
    - ${host}
%{ endfor ~}
%{ endif ~}
    paths:
    - "/*"
%{ for tls in prometheus_tls }
    tls:
    - secretName:  ${tls.secret_name}
%{ if length(tls.hosts) > 0 ~}
      hosts:
%{ for host in tls.hosts }
      - ${host}
%{ endfor ~}
%{ endif ~}
%{ endfor ~}

  prometheusSpec:
    scrapeInterval: ${prometheus_scrape_interval}
    retention: ${prometheus_retention}
    serviceMonitorSelectorNilUsesHelmValues: false
    # additionalScrapeConfigs:
    # - job_name: "kafka"
    #   static_configs:
    #   - targets:
    #     -  "kafka-release-metrics.kafka.svc:9308"
    #     -  "kafka-release-jmx-metrics.kafka.svc:5556"

%{ if affinity != "" ~}
    affinity:
      ${indent(6, affinity)}
%{ endif ~}
%{ if node_selector != "" ~}
    nodeSelector:
      ${indent(6, node_selector)}
%{ endif ~}
%{ if tolerations != "" ~}
    tolerations:
      ${indent(6, tolerations)}
%{ endif ~}
%{ if prometheus_resources != "" ~}
    resources:
      ${indent(6, prometheus_resources)}
%{ endif ~}
%{ if prometheus_volume_enabled == true ~}
    storageSpec:
      volumeClaimTemplate:
        spec:
          resources:
            requests:
              storage: ${prometheus_volume_size}
%{ endif ~}
    replicaExternalLabelName: ${prometheus_replica_external_label_name}
    externalLabels:
      cluster: ${prometheus_external_cluster_name}
%{ if prometheus_external_labels != "" ~}
      ${indent(6, prometheus_external_labels)}
%{ endif ~}
%{ if prometheus_remote_write != "" ~}
    remoteWrite:
      ${indent(6, prometheus_remote_write)}
%{ endif ~}
    remoteWriteDashboards: ${prometheus_remote_write_dashboards}
