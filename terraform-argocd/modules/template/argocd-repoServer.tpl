repoServer:
  name: repo-server
  replicas: 1

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
