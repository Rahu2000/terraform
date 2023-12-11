server:
  name: server

%{ if ha_mode == true ~}
  replicas: 2
  env:
  - name: "ARGOCD_API_SERVER_REPLICAS"
    value: "2"
%{ else ~}
  replicas: 1
%{ endif ~}

  service:
    type: ClusterIP

  ingress:
    enabled: ${ingress_enabled}
%{ if ingress_enabled == true ~}
    annotations:
      ${indent(6, ingress_annotations)} 
    hosts:
    - ${ingress_host}
    paths:
    - /
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

  configEnabled: true
  config:
    url: https://${ingress_host}

  configAnnotations: {}
  additionalApplications: []
  additionalProjects: []
# additionalProjects:
# - name: ops-project
#   description: project to provision echo systems
#  repositories: |
#      - type: git
#        url: https://github.com/dabbi-heimdall/addons.git
#      - name: argo-helm
#        type: helm
#        url: https://argoproj.github.io/argo-helm
#  additionalApplications: 
#    - name: argocd
#      namespace: argocd
#      destination:
#        namespace: argocd
#        server: https://kubernetes.default.svc
#      project: argocd
#      source:
#        helm:
#          version: v3
#          valueFiles:
#          - values.yaml
#          - ../values-override.yaml
#        path: argocd-install/argo-cd
#        repoURL: https://github.com/dabbi-heimdall/addons.git
#        targetRevision: HEAD
#      syncPolicy:
#        syncOptions:
#        - CreateNamespace=true
#    - name: argocd-apps
#      namespace: argocd
#      destination:
#        namespace: argocd
#        server: https://kubernetes.default.svc
#      project: argocd
#      source:
#        path: argocd-apps
#        repoURL: https://github.com/dabbi-heimdall/addons.git
#        targetRevision: HEAD
#        directory:
#          recurse: true
#          jsonnet: {}
#      syncPolicy:
#        automated:
#          selfHeal: true
#          prune: true
#    - name: argocd-appprojects
#      namespace: argocd
#      destination:
#        namespace: argocd
#        server: https://kubernetes.default.svc
#      project: argocd
#      source:
#        path: argocd-appprojects
#        repoURL: https://github.com/dabbi-heimdall/addons.git
#        targetRevision: HEAD
#        directory:
#          recurse: true
#          jsonnet: {}
#      syncPolicy:
#        automated:
#          selfHeal: true
#          prune: true
#  additionalProjects: 
#  - name: argocd
#    namespace: argocd
#    additionalLabels: {}
#    additionalAnnotations: {}
#    description: Argocd Project
#    sourceRepos:
#    - '*'
#    destinations:
#    - namespace: argocd
#      server: https://kubernetes.default.svc
#    clusterResourceWhitelist:
#    - group: '*'
#      kind: '*'
#    orphanedResources:
#      warn: false