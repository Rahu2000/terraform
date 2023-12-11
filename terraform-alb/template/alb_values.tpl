replicaCount: ${replicaCount}

clusterName: ${clusterName}

region: ${region}

vpcId: ${vpcId}

ingressClass: alb
podDisruptionBudget:
  minAvailable: 1

serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: ${role_arn}
  name: ${service_account_name}
  automountServiceAccountToken: true

enableShield: ${enable_shield}
enableWaf: ${enable_waf}
enableWafv2: ${enable_wafv2}

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

%{if topology_spread_constraints != "" ~}
topologySpreadConstraints:
  ${indent(2, topology_spread_constraints)}
%{ endif ~}

serviceMonitor:
  enabled: ${service_monitor_enabled}
  additionalLabels: {}
  interval: 30s