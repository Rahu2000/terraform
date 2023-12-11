autoDiscovery:
  clusterName: ${cluster_name}

awsRegion: ${region}
replicaCount: ${replica_count}

serviceMonitor:
  enabled: ${service_monitor_enabled}
  interval: 15s
  path: /metrics
  namespace: ${namespace}

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

%{if topology_spread_constraints != "" ~}
topologySpreadConstraints:
  ${indent(2, topology_spread_constraints)}
%{ endif ~}

rbac:
  create: true
  pspEnabled: false 
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: ${role_arn}
    create: true  
    name: ${service_account_name}
    automountServiceAccountToken: true

extraArgs:
  logtostderr: true
  stderrthreshold: info
  v: 4
  # write-status-configmap: true
  # leader-elect: true
  skip-nodes-with-local-storage: false
  expander: least-waste
  # scale-down-enabled: true
  balance-similar-node-groups: true
  # min-replica-count: 0
  # scale-down-utilization-threshold: 0.5
  # scale-down-non-empty-candidates-count: 30
  # max-node-provision-time: 15m0s
  # scan-interval: 10s
  # scale-down-delay-after-add: 10m
  # scale-down-delay-after-delete: 0s
  # scale-down-delay-after-failure: 3m
  # scale-down-unneeded-time: 10m
  skip-nodes-with-system-pods: false

extraVolumes:
  - name: ssl-certs
    hostPath:
      path: /etc/ssl/certs/ca-bundle.crt

extraVolumeMounts:
  - name: ssl-certs
    mountPath: /etc/ssl/certs/ca-certificates.crt
    readOnly: true

fullnameOverride: aws-cluster-autoscaler

containerSecurityContext:
  capabilities:
    drop:
    - ALL

securityContext:
  runAsNonRoot: true
  runAsUser: 1001
  runAsGroup: 1001

# podDisruptionBudget -- Pod disruption budget.
podDisruptionBudget:
  maxUnavailable: 1
  # minAvailable: 2
