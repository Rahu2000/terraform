nameOverride: ""

replicas: ${replicas}

metrics:
  enabled: true

serviceMonitor:
  enabled: ${service_monitor_enabled}
  additionalLabels: {}
  interval: 15s
  scrapeTimeout: 10s

%{ if defaultArgs != "" ~}
defaultArgs: 
  ${indent(2, defaultArgs)}
%{ endif ~}

%{ if resources != "" ~}
resources: 
  ${indent(2, resources)}
%{ endif ~}

%{ if affinity != "" ~}
affinity: 
  ${indent(2, affinity)}
%{ endif ~}

%{ if node_selector != "" ~}
nodeSelector: 
  ${indent(2, node_selector)}
%{ endif ~}

%{ if tolerations != "" ~}
tolerations:
  ${indent(2, tolerations)}
%{ endif ~}
