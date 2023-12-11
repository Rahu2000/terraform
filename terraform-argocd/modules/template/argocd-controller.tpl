controller:
  name: application-controller

%{ if ha_mode == true ~}
  replicas: 2
  enableStatefulSet: true
  env:
  - name: "ARGOCD_CONTROLLER_REPLICAS"
    value: "2"
%{ else ~}
  replicas: 1
%{ endif ~}

  metrics:
    enabled: ${service_monitor_enabled}
    serviceMonitor:
      enabled: ${service_monitor_enabled}
      interval: 15s
      relabelings: []
      metricRelabelings: []
      selector: {}
      namespace: ${namespace}
      additionalLabels: {}
    rules:
      enabled: true
      spec:
      - alert: ArgoAppMissing
        expr: |
          absent(argocd_app_info)
        for: 15m
        labels:
          severity: critical
        annotations:
          summary: "[ArgoCD] No reported applications"
          description: >
            ArgoCD has not reported any applications data for the past 15 minutes which
            means that it must be down or not functioning properly.  This needs to be
            resolved for this cloud to continue to maintain state.
      - alert: ArgoAppNotSynced
        expr: |
          argocd_app_info{sync_status!="Synced"} == 1
        for: 12h
        labels:
          severity: warning
        annotations:
          summary: "[{{`{{$labels.name}}`}}] Application not synchronized"
          description: >
            The application [{{`{{$labels.name}}`}} has not been synchronized for over
            12 hours which means that the state of this cloud has drifted away from the
            state inside Git.
#      selector: {}
#        prometheus: kube-prometheus
#      namespace: ""
#      additionalLabels: {}

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
