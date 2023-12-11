apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: simple-prometheus-network-policy
  namespace: ${namespace}
spec:
  podSelector: {}
  policyTypes:
    - Egress
    - Ingress
  ingress:
    - from:
        - podSelector: {}
      ports:
        - port: 443
          protocol: TCP
        - port: 3000
          protocol: TCP
        - port: 8080
          protocol: TCP
        - port: 8443
          protocol: TCP
        - port: 9090
          protocol: TCP
        - port: 9093
          protocol: TCP
        - port: 9094
          protocol: TCP
        - port: 9094
          protocol: UDP
        - port: 9100
          protocol: TCP
        - port: 9115
          protocol: TCP
        - port: 9443
          protocol: TCP
        - port: 19115
          protocol: TCP
    - from:
        - namespaceSelector: {}
      ports:
        - port: 9090
          protocol: TCP
  egress:
    - to:
        - ipBlock:
            cidr: ${kubernetes_api_ip}
      ports:
        - port: 443
    - to:
%{ for pod_ip_range in pod_ip_ranges }
        - ipBlock:
            cidr: ${pod_ip_range}
%{ endfor }