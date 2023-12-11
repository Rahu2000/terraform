controller:
  replicaCount: ${replica_count}

  ingressClassResource:
    name: ${ingress_class_name}

  ingressClass: ${ingress_class_name}

%{if sysctls != "" ~}
  sysctls:
    ${indent(4, sysctls)}
%{ endif ~}

  service:
%{if service_annotations != "" ~}
    annotations:
      ${indent(6, service_annotations)}
%{ endif ~}

    enableHttp: ${enable_http}
    enableHttps: ${enable_https}

%{if service_ports != "" ~}
    ports:
      ${indent(6, service_ports)}
%{ endif ~}

%{if service_target_ports != "" ~}
    ports:
      ${indent(6, service_target_ports)}
%{ endif ~}

  metrics:
    enabled: ${metrics_enabled}

%{if service_monitor_enabled ~}
    serviceMonitor:
      enabled: ${service_monitor_enabled}
      namespace: ${namespace}
%{ endif ~}

%{if prometheus_rule_enabled ~}
    prometheusRule:
      enabled: ${prometheus_rule_enabled}
      namespace: ${namespace}
      rules:
        - alert: NGINXConfigFailed
          expr: count(nginx_ingress_controller_config_last_reload_successful == 0) > 0
          for: 1s
          labels:
            severity: critical
          annotations:
            description: bad ingress config - nginx config test failed
            summary: uninstall the latest ingress changes to allow config reloads to resume
        - alert: NGINXCertificateExpiry
          expr: (avg(nginx_ingress_controller_ssl_expire_time_seconds) by (host) - time()) < 604800
          for: 1s
          labels:
            severity: critical
          annotations:
            description: ssl certificate(s) will expire in less then a week
            summary: renew expiring certificates to avoid downtime
        - alert: NGINXTooMany500s
          expr: 100 * ( sum( nginx_ingress_controller_requests{status=~"5.+"} ) / sum(nginx_ingress_controller_requests) ) > 5
          for: 1m
          labels:
            severity: warning
          annotations:
            description: Too many 5XXs
            summary: More than 5% of all requests returned 5XX, this requires your attention
        - alert: NGINXTooMany400s
          expr: 100 * ( sum( nginx_ingress_controller_requests{status=~"4.+"} ) / sum(nginx_ingress_controller_requests) ) > 5
          for: 1m
          labels:
            severity: warning
          annotations:
            description: Too many 4XXs
            summary: More than 5% of all requests returned 4XX, this requires your attention
%{ endif ~}

%{if resources != "" ~}
  resources:
    ${indent(4, resources)}
%{ endif ~}

%{if affinity != "" ~}
  affinity:
    ${indent(4, affinity)}
%{ endif ~}

%{if node_selector != "" ~}
  nodeSelector:
    ${indent(4, node_selector)}
%{ endif ~}

%{if tolerations != "" ~}
  tolerations:
    ${indent(4, tolerations)}
%{ endif ~}

%{if topology_spread_constraints != "" ~}
  topologySpreadConstraints:
    ${indent(4, topology_spread_constraints)}
%{ endif ~}

%{if autoscaling_enabled ~}
  autoscaling:
    enabled: ${autoscaling_enabled}
    minReplicas: ${autoscaling_min_replicas}
    maxReplicas: ${autoscaling_max_replicas}
%{ endif ~}

%{if resources != "" ~}
  resources:
    ${indent(4, resources)}
%{ endif ~}

%{if affinity != "" ~}
  affinity:
    ${indent(4, affinity)}
%{ endif ~}

%{if node_selector != "" ~}
  nodeSelector:
    ${indent(4, node_selector)}
%{ endif ~}

%{if tolerations != "" ~}
  tolerations:
    ${indent(4, tolerations)}
%{ endif ~}

%{if topology_spread_constraints != "" ~}
  topologySpreadConstraints:
    ${indent(4, topology_spread_constraints)}
%{ endif ~}

serviceAccount:
  create: true
  name: ${service_account_name}

%{if tcp_services != "" ~}
tcp:
  ${indent(2, tcp_services)}
%{ endif ~}

%{if udp_services != "" ~}
udp:
  ${indent(2, udp_services)}
%{ endif ~}