testFramework:
  enabled: ${test_framework_enabled}

serviceAccount:
  name: ${service_account_name}
  annotations:
    eks.amazonaws.com/role-arn: ${service_account_arn}
    eks.amazonaws.com/sts-regional-endpoints: 'true'

podSecurityContext:
  fsGroup: 20001

securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop:
    - ALL
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 10001

serviceMonitor:
  enabled: ${service_monitor_enabled}
%{if service_monitor_enabled ~}
  namespace: ${service_monitor_namespace}
  jobLabel: fluentbit
  selector:
   prometheus: ${prometheus_selector}
  metricRelabelings:
    - sourceLabels: [__meta_kubernetes_service_label_cluster]
      targetLabel: cluster
      regex: (.*)
      replacement: ${1}
      action: replace
  relabelings:
    - sourceLabels: [__meta_kubernetes_pod_node_name]
      separator: ;
      regex: ^(.*)$
      targetLabel: nodename
      replacement: $1
      action: replace
%{ endif ~}

prometheusRule:
  enabled: ${prometheus_rule_enabled}
%{if prometheus_rule_enabled ~}
  rules:
    - alert: NoOutputBytesProcessed
      expr: rate(fluentbit_output_proc_bytes_total[5m]) == 0
      annotations:
        message: |
          Fluent Bit instance {{ $labels.instance }}'s output plugin {{ $labels.name }} has not processed any
          bytes for at least 15 minutes.
        summary: No Output Bytes Processed
      for: 15m
      labels:
        severity: critical
%{ endif ~}

lifecycle:
  preStop:
    exec:
      command: ["/bin/sh", "-c", "sleep 20"]

%{if resources != "" ~}
resources:
  ${indent(2, resources)}
%{ endif ~}

%{if affinity != "" ~}
affinity:
  ${indent(2, affinity)}
%{ endif ~}

%{if node_selector != "" ~}
nodeSelector:
  ${indent(2, node_selector)}
%{ endif ~}

%{if tolerations != "" ~}
tolerations:
  ${indent(2, tolerations)}
%{ endif ~}

config:
%{if service != "" ~}
  service: |
    ${indent(4, service)}
%{ endif ~}

%{if inputs != "" ~}
  inputs: |
    ${indent(4, inputs)}
%{ endif ~}

%{if filters != "" ~}
  filters: |
    ${indent(4, filters)}
%{ endif ~}

%{if outputs != "" ~}
  outputs: |
    ${indent(4, outputs)}
%{ endif ~}

%{if custom_parsers != "" ~}
  customParsers: |
    ${indent(4, custom_parsers)}
%{ endif ~}

logLevel: ${log_level}
