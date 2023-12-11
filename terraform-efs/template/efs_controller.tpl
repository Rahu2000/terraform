
replicaCount: ${replica_count}

controller:
  extraCreateMetadata: true
  tags:
    region: ${region}
    env: ${env}
  serviceAccount:
    name: ${service_account_name}
    annotations:
      eks.amazonaws.com/role-arn: ${service_account_arn}
      eks.amazonaws.com/sts-regional-endpoints: 'true'

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