%{ if ha_mode == false ~}
redis-ha:
  enabled: false

redis:
  enabled: true

  metrics:
    enabled: ${service_monitor_enabled}
    serviceMonitor:
      enabled: ${service_monitor_enabled}
      interval: 30s
      relabelings: []
      metricRelabelings: []
      selector: {}
      namespace: ${namespace}
      additionalLabels: {}

%{if resources != "" ~}
  resources:
    ${indent(4, resources)}
%{ endif ~}

%{if node_selector != "" ~}
  nodeSelector:
    ${indent(4, node_selector)}
%{ endif ~}

%{if tolerations != "" ~}
  tolerations:
    ${indent(4, tolerations)}
%{ endif ~}

%{if affinity != "" ~}
  affinity:
    ${indent(4, affinity)}
%{ endif ~}

%{if topology_spread_constraints != "" ~}
  topologySpreadConstraints:
    ${indent(4, topology_spread_constraints)}
%{ endif ~}

exporter:
  enabled: true

  serviceMonitor:
    enabled: true
    namespace: ""
    interval: 30s
    labels: {}
    timeout: 10s

  resources: {}

prometheusRule:
  enabled: true
  additionalLabels: {}
  namespace: prometheus
  interval: 10s
  rules:
  - alert: RedisPodDown
    expr: |
      redis_up{job="{{ include "redis-ha.fullname" . }}"} == 0
    for: 5m
    labels:
      severity: critical
    annotations:
      description: Redis pod {{ "{{ $labels.pod }}" }} is down
      summary: Redis pod {{ "{{ $labels.pod }}" }} is down
%{ endif ~}
