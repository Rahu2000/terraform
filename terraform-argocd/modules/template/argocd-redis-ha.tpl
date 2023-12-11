%{ if ha_mode == true ~}
redis:
  enabled: false

redis-ha:
  enabled: true

  replicas: 3

  persistentVolume:
    enabled: true
    storageClass: gp3
    accessModes:
    - ReadWriteOnce
    size: 10Gi

%{ if node_selector != "" ~}
  nodeSelector:
    ${indent(4, node_selector)}
%{ endif ~}

%{ if affinity != "" ~}
  affinity: |
    ${indent(4, affinity)}
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - redis-ha
        topologyKey: kubernetes.io/hostname
%{ endif ~}

  haproxy:
    replicas: 3

    metrics:
      enabled: ${service_monitor_enabled}
      serviceMonitor:
        enabled: ${service_monitor_enabled}
        interval: 15s
        namespace: ${namespace}
        labels: []
        timeout: 10s

%{ if resources != "" ~}
    resources: 
      ${indent(6, resources)}
%{ endif ~}

%{ if affinity != "" ~}
    affinity: |
      ${indent(6, affinity)}
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
            - key: app
              operator: In
              values:
              - redis-ha-proxy
          topologyKey: kubernetes.io/hostname
%{ endif ~}

%{ endif ~}