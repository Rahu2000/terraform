# ingress-nginx

- [ingress-nginx](https://github.com/kubernetes/ingress-nginx)


# Install / Uninstall

## Installing the chart

```
# env/dev_backend.hcl: s3 backend configuration file
terraform init -backend-config=env/dev_backend.hcl

# env/dev.tfvars: configuration file
terraform plan -var-file=env/dev.tfvars

terraform apply -var-file=env/dev.tfvars -auto-approve
```

## Uninstalling the Chart

```
terraform destroy -var-file=env/dev.tfvars -auto-approve
```


# Configuration

|파라미터|타입|기본값|설명|
|--------|--------|--------|--------|
|project|string|""|프로젝트 코드명|
|env|string|""|프로비전 구성 환경 </br>(예시: dev, stg, qa, prod, ...)|
|region|string|""|리전명|
|backend_s3_bucket_name|string|""|terraform s3버킷명|
|eks_cluster_name|string|""|EKS클러스터명|
|helm_release_name|string|""|helm release명|
|helm_chart_name|string|""|helm 차트명|
|helm_chart_version|string|""|helm 차트버전|
|helm_repository_url|string|""|helm repository url|
|create_namespace|bool|true|namespace 생성여부|
|namespace|string|""|namespace명|
|replica_count|number|1|replica 개수|

|min_available|number|1|replica 개수|
|ingress_class_name|number|1|replica 개수|
|annotations|number|1|replica 개수|
|metrics_enabled|number|1|replica 개수|
|service_monitor_enabled|number|1|replica 개수|
|prometheus_rule_enabled|number|1|prometheus rule 등록 여부|
|tcp_service|string|""|TCP 서비스 포트 설정 [namespace][service name]:[port]<br/><pre>예시) 8080: "default/example-tcp-svc:9000</pre>|
|udp_service|string|""|UDP 서비스 포트 설정 [namespace][service name]:[port]<br/><pre>예시) 53: "kube-system/kube-dns:53</pre>|

|resources|string|""|resources 설정(yaml)<br/><pre>limits:<br/>  memory: "100Mi"<br/>requests:<br/>  cpu: "100m"<br/>  memory: "100Mi"</pre>|
|affinity|string|""|affinity 설정(yaml)<br/><pre>nodeAffinity:<br/>  requiredDuringSchedulingIgnoredDuringExecution:<br/>    nodeSelectorTerms:<br/>    - matchExpressions:<br/>      - key: role<br/>        operator: In<br/>        values:<br/>        - ops</pre>|
|node_selector|string|""|*TODO LIST*<br/>nodeSelect설정(yaml)<br/><pre>role: ops</pre>|
|tolerations|string|""|*TODO LIST*<br/>tolerations설정(yaml)<br/><pre>- key: "role"<br/>  operator: "Equal"<br/>  value: "ops"<br/>  effect: "NoSchedule"</pre>|
|topology_spread_constraints|string|""|*TODO LIST*<br/>topologySpreadConstraints설정(yaml)</br>|



