# prometheus

Prometheus 설치 가이드로서 `kube-prometheus-stack` chart를 통해 prometheus-operator와 prometheus 등 부속 컴포넌트를 설치한다.

- [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [alertmanager](https://github.com/prometheus-community/helm-charts/tree/main/charts/alertmanager)
- [grafana](https://github.com/grafana/helm-charts/tree/main/charts/grafana)
- [kube-state-metrics](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-state-metrics)

## Install/Uninstall the chart

설치에 관한 자세한 내용은 다음을 참조한다.

- [HowToInstall](./doc/HowToInstall.md)

## Configuration

### main

| 파라미터                    | 타입     | 기본값                                               | 설명                                                               |
| --------------------------- | -------- | ---------------------------------------------------- | ------------------------------------------------------------------ |
| project                     | string   | ""                                                   | 프로젝트 코드명                                                    |
| region                      | string   | ""                                                   | 리전명                                                             |
| abbr_region                 | string   | ""                                                   | 리전 약명 (예시: an2 ~> ap-northeast-2 )                           |
| env                         | string   | ""                                                   | 프로비전 구성 환경 (예시: dev, stg, qa, prod, ...)                 |
| org                         | string   | ""                                                   | 조직명                                                             |
| default_tags                | map(any) | {}                                                   | 태그 목록                                                          |
| remote_backend              | object   | {}                                                   | 원격 백엔드 조회 [세부사항](#remotebackend)                        |
| cluster_name                | string   | ""                                                   | 클러스터명                                                         |
| helm_chart                  | object   | {}                                                   | helm chart                                                         |
| helm_chart.name             | string   | "kube-prometheus-stack"                              | helm chart 명                                                      |
| helm_chart.repository_url   | string   | "https://prometheus-community.github.io/helm-charts" | helm chart repository url                                          |
| helm_release                | object   | {}                                                   | helm release [세부사항](#helmrelease)                              |
| prometheus                  | object   | {}                                                   | prometheus 설정 [세부사항](#prometheus)                            |
| alert_manager               | object   | {}                                                   | alertmanager 설정 [세부사항](#alertmanager)                        |
| grafana                     | object   | {}                                                   | grafana 설정 [세부사항](#grafana)                                  |
| kube_state_metrics          | object   | {}                                                   | kube_state_metrics 설정 [세부사항](#kubestatemetrics)              |
| node_exporter               | object   | {}                                                   | prometheus_node_exporter 설정 [세부사항](#prometheusnodeexporter)  |
| prometheus_operator         | object   | {}                                                   | prometheus_operator 설정 [세부사항](#prometheusoperator)           |
| network_policy_enabled      | bool     | false                                                | prometheus default network policy 활성화 여부                      |
| additional_prometheus_rules | map(any) | {}                                                   | prometheus 추가 규칙                                               |
| shared_account              | object   | {}                                                   | Source account information [세부사항](#sharedaccounttargetaccount) |
| target_account              | object   | {}                                                   | Target account information [세부사항](#sharedaccounttargetaccount) |

### remote_backend

[원격 백엔드 사용법에 대해서는 다음을 참조:S3](./docs/HowToInstall.md##backend-type-s3)
[원격 백엔드 사용법에 대해서는 다음을 참조:Remote](./docs/HowToInstall.md#backend-type-terraform-cloud)

| 파라미터                                 | 타입         | 기본값               | 설명                                            |
| ---------------------------------------- | ------------ | -------------------- | ----------------------------------------------- |
| remote_backend.type                      | string       | optional(string, "") | 원격 백엔드 유형 (s3 \| remote)                 |
| remote_backend.workspaces                | list(object) | optional(list, [])   | 원격 백엔드 워크스페이스                        |
| remote_backend.workspaces.service        | string       | optional(string, "") | 원격 백엔드 서비스 유형 (e.g. (eks \| network)) |
| remote_backend.workspaces.bucket         | string       | optional(string, "") | S3 버킷명                                       |
| remote_backend.workspaces.key            | string       | optional(string, "") | S3 오브젝트 키                                  |
| remote_backend.workspaces.region         | string       | optional(string, "") | S3 리전                                         |
| remote_backend.workspaces.org            | string       | optional(string, "") | Terraform Cloud ORG                             |
| remote_backend.workspaces.workspace_name | string       | optional(string, "") | Terraform Cloud 워크스페이스 명                 |

### helm_release

| 파라미터                                 | 타입         | 기본값                                    | 설명                                                           |
| ---------------------------------------- | ------------ | ----------------------------------------- | -------------------------------------------------------------- |
| helm_release.name                        | string       | ""                                        | helm release 명                                                |
| helm_release.chart_version               | string       | optional(string, "")                      | helm release chart version. 생략 시, 최신 chart version을 설치 |
| helm_release.namespace                   | object       | optional(object)                          | helm release 설치 네임 스페이스 설정                           |
| helm_release.namespace.create            | bool         | optional(bool, false)                     | 네임스페이스 생성 유무                                         |
| helm_release.namespace.name              | string       | optional(string, "kube-system")           | 네임스페이스 명                                                |
| helm_release.service_account             | object       | {}                                        | Service account 설정                                           |
| helm_release.service_account.create      | bool         | optional(bool, false)                     | Service account 생성 유무                                      |
| helm_release.service_account.name        | string       | optional(string, "efs-csi-controller-sa") | Service account 명                                             |
| helm_release.service_account.iam         | object       | {}                                        | Service account를 위한 iam 설정                                |
| helm_release.service_account.create      | bool         | optional(bool, false)                     | iam 생성 유무                                                  |
| helm_release.service_account.role_name   | string       | optional(string, "")                      | role 명. 생략 시, 자동 생성                                    |
| helm_release.service_account.policy_name | string       | optional(string, "")                      | policy 명. 생량 시, 자동 생성                                  |
| helm_release.sets                        | list(object) | optional(list(object))                    | helm 배포 시, 추가 설정                                        |
| helm_release.sets.key                    | string       | ""                                        | helm value에서 지원하는 schema의 key                           |
| helm_release.sets.value                  | string       | ""                                        | helm value에서 지원하는 schema key의 value                     |
| helm_release.resources                   | string       | optional(string, "")                      | Deployment/DaemonSet의 resources 설정                          |
| helm_release.replicas                    | string       | optional(number, 2)                       | Deployment의 replica 설정                                      |
| helm_release.affinity                    | string       | optional(string, "")                      | Deployment/DaemonSet의 affinity 설정                           |
| helm_release.tolerations                 | string       | optional(string, "")                      | Deployment/DaemonSet의 tolerations 설정                        |
| helm_release.node_selector               | string       | optional(string, "")                      | Deployment/DaemonSet의 node_selector 설정                      |
| helm_release.topology_spread_constraints | string       | optional(string, "")                      | Deployment/DaemonSet의 topology_spread_constraints 설정        |

### prometheus

| 파라미터                               | 타입         | 기본값                              | 설명                                                       |
| -------------------------------------- | ------------ | ----------------------------------- | ---------------------------------------------------------- |
| prometheus.enabled                     | bool         | true                                | prometheus 설치 여부                                       |
| prometheus.scrape_interval             | string       | optional(string, "30s")             | 지표 수집 주기. 기본 값: `30초`                            |
| prometheus.retention                   | string       | optional(string, "10d")             | 지표 보관 기간. 기본 값: `10일`                            |
| prometheus.ingress                     | object       | {}                                  | prometheus 대시보드 용 ingress 설정                        |
| prometheus.ingress.enabled             | bool         | optional(bool, false)               | prometheus 대시보드 용 ingress 생성 여부                   |
| prometheus.ingress.class_name          | string       | optional(string, "")                | prometheus ingress class 명 (e.g. `nginx`, `alb` )         |
| prometheus.ingress.annotations         | string       | optional(string, "")                | prometheus ingress annotations                             |
| prometheus.ingress.hosts               | list(string) | optional(list(string), [])          | prometheus ingress host 목록                               |
| prometheus.ingress.tls                 | list(object) | optional(list(object), [])          | prometheus ingress tls 목록                                |
| prometheus.ingress.tls.secret_name     | string       | optional(string, "")                | prometheus ingress tls의 cert key를 저장한 k8s secret 이름 |
| prometheus.ingress.tls.hosts           | list(string) | optional(list(string), [])          | prometheus ingress tls의 host 목록                         |
| prometheus.volume                      | object       | optional(object, {})                | prometheus pv 설정                                         |
| prometheus.volume.enabled              | bool         | optional(bool, true)                | prometheus pv 사용 여부                                    |
| prometheus.volume.size                 | string       | optional(string, "50Gi")            | prometheus pv 사이즈                                       |
| prometheus.resources                   | string       | optional(string, "")                | prometheus 할당 리소스                                     |
| prometheus.replica_external_label_name | string       | optional(string, "\_\_replica\_\_") | prometheus replica 구성 시, 추가 설정 레이블(prefix)       |
| prometheus.external_labels             | string       | optional(string, "")                | prometheus 추가 레이블 (cluster는 레이블은 기본 제공)      |
| prometheus.remote_write                | string       | optional(string, "")                | prometheus 원격 쓰기 설정                                  |
| prometheus.remote_write_dashboards     | bool         | optional(bool, false)               | prometheus 원격 쓰기 대시보드 활성화 여부                  |

[자세한 prometheus 설정은 다음을 참조](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

### alertmanager

| 파라미터                              | 타입         | 기본값                     | 설명                                                         |
| ------------------------------------- | ------------ | -------------------------- | ------------------------------------------------------------ |
| alert_manager.enabled                 | bool         | true                       | alertmanager 설치 여부                                       |
| alert_manager.ingress                 | object       | {}                         | alertmanager 대시보드 용 ingress 설정                        |
| alert_manager.ingress.enabled         | bool         | optional(bool, false)      | alertmanager 대시보드 용 ingress 생성 여부                   |
| alert_manager.ingress.class_name      | string       | optional(string, "")       | alertmanager ingress class 명 (e.g. `nginx`, `alb` )         |
| alert_manager.ingress.annotations     | string       | optional(string, "")       | alertmanager ingress annotations                             |
| alert_manager.ingress.hosts           | list(string) | optional(list(string), []) | alertmanager ingress host 목록                               |
| alert_manager.ingress.tls             | list(object) | optional(list(object), []) | alertmanager ingress tls 목록                                |
| alert_manager.ingress.tls.secret_name | string       | optional(string, "")       | alertmanager ingress tls의 cert key를 저장한 k8s secret 이름 |
| alert_manager.ingress.tls.hosts       | list(string) | optional(list(string), []) | alertmanager ingress tls의 host 목록                         |
| alert_manager.volume                  | object       | optional(object, {})       | alertmanager pv 설정                                         |
| alert_manager.volume.enabled          | bool         | optional(bool, true)       | alertmanager pv 사용 여부                                    |
| alert_manager.volume.size             | string       | optional(string, "10Gi")   | alertmanager pv 사이즈                                       |
| alert_manager.resources               | string       | optional(string, "")       | alertmanager 할당 리소스                                     |

### grafana

| 파라미터                        | 타입         | 기본값                     | 설명                                                    |
| ------------------------------- | ------------ | -------------------------- | ------------------------------------------------------- |
| grafana.enabled                 | bool         | true                       | grafana 설치 여부                                       |
| grafana.ingress                 | object       | {}                         | grafana 대시보드 용 ingress 설정                        |
| grafana.ingress.enabled         | bool         | optional(bool, false)      | grafana 대시보드 용 ingress 생성 여부                   |
| grafana.ingress.class_name      | string       | optional(string, "")       | grafana ingress class 명 (e.g. `nginx`, `alb` )         |
| grafana.ingress.annotations     | string       | optional(string, "")       | grafana ingress annotations                             |
| grafana.ingress.hosts           | list(string) | optional(list(string), []) | grafana ingress host 목록                               |
| grafana.ingress.tls             | list(object) | optional(list(object), []) | grafana ingress tls 목록                                |
| grafana.ingress.tls.secret_name | string       | optional(string, "")       | grafana ingress tls의 cert key를 저장한 k8s secret 이름 |
| grafana.ingress.tls.hosts       | list(string) | optional(list(string), []) | grafana ingress tls의 host 목록                         |
| grafana.volume                  | object       | optional(object, {})       | grafana pv 설정                                         |
| grafana.volume.enabled          | bool         | optional(bool, true)       | grafana pv 사용 여부                                    |
| grafana.volume.size             | string       | optional(string, "10Gi")   | grafana pv 사이즈                                       |
| grafana.resources               | string       | optional(string, "")       | grafana 할당 리소스                                     |
| grafana.timezone                | string       | optional(string, "utc")    | grafana 타임존                                          |
| grafana.ini                     | string       | optional(string, "")       | grafana 설정                                            |
| grafana.sidecar                 | object       | optional(object, {})       | grafana 사이드카 설정                                   |
| grafana.sidecar.resources       | string       | optional(string, "")       | grafana 사이드카 할당 리소스                            |

[자세한 grafana 설정은 다음을 참조](https://github.com/grafana/helm-charts/tree/main/charts/grafana)

### kube_state_metrics

| 파라미터                                     | 타입   | 기본값               | 설명                                         |
| -------------------------------------------- | ------ | -------------------- | -------------------------------------------- |
| kube_state_metrics.resources                 | string | optional(string, "") | kube_state_metrics 할당 리소스               |
| kube_state_metrics.monitor                   | object | optional(object, {}) | kube_state_metrics 모니터링 설정             |
| kube_state_metrics.monitor.enabled           | bool   | optional(bool, "")   | kube_state_metrics 모니터링 활성화 여부      |
| kube_state_metrics.monitor.metric_relabeling | string | optional(string, "") | kube_state_metrics 모니터링 지표 레이블 변경 |
| kube_state_metrics.monitor.relabeling        | string | optional(string, "") | kube_state_metrics 레이블 변경               |

### prometheus_node_exporter

| 파라미터                         | 타입   | 기본값               | 설명                                          |
| -------------------------------- | ------ | -------------------- | --------------------------------------------- |
| node_exporter.resources          | string | optional(string, "") | prometheus_node_exporter 할당 리소스          |
| node_exporter.monitor            | object | optional(object, {}) | prometheus_node_exporter 모니터링 설정        |
| node_exporter.monitor.enabled    | bool   | optional(bool, "")   | prometheus_node_exporter 모니터링 활성화 여부 |
| node_exporter.monitor.relabeling | string | optional(string, "") | prometheus_node_exporter 레이블 변경          |

### prometheus_operator

| 파라미터                               | 타입   | 기본값                | 설명                                       |
| -------------------------------------- | ------ | --------------------- | ------------------------------------------ |
| prometheus_operator.resources          | string | optional(string, "")  | prometheus_operator 할당 리소스            |
| prometheus_operator.host_network       | bool   | optional(bool, false) | prometheus_operator host network 사용 여부 |
| prometheus_operator.reloader           | object | optional(object, {})  | prometheus_operator 리로더 설정            |
| prometheus_operator.reloader.resources | string | optional(string, "")  | prometheus_operator 리로더 할당 리소스     |

### shared_account,target_account

[교차계정 설치는 다음을 참조](./docs/HowToInstall.md#교차-계정-설치)

| 파라미터                       | 타입   | 기본값       | 설명                          |
| ------------------------------ | ------ | ------------ | ----------------------------- |
| shared_account.region          | string | ""           | AWS configure region          |
| shared_account.profile         | string | optional("") | AWS configure profile name    |
| shared_account.assume_role_arn | string | optional("") | AWS configure assume role arn |
