# aws-efs-csi-driver

aws-efs-csi-driver 설치 가이드로서 다음 [helm chart](https://github.com/kubernetes-sigs/aws-efs-csi-driver/tree/master/charts/aws-efs-csi-driver)를 terraform을 통해 설치한다.

## Installing/Uninstall the chart

설치에 관한 자세한 내용은 다음을 참조한다.

- [HowToInstall](./doc/HowToInstall.md)

## tfvars Configuration

### Main

| 파라미터                  | 타입         | 기본값                                               | 설명                                                               |
| ------------------------- | ------------ | ---------------------------------------------------- | ------------------------------------------------------------------ |
| project                   | string       | ""                                                   | 프로젝트 코드명                                                    |
| region                    | string       | ""                                                   | 리전명                                                             |
| abbr_region               | string       | ""                                                   | 리전 약명 (예시: an2 ~> ap-northeast-2 )                           |
| env                       | string       | ""                                                   | 프로비전 구성 환경 (예시: dev, stg, qa, prod, ...)                 |
| org                       | string       | ""                                                   | 조직명                                                             |
| default_tags              | map(any)     | {}                                                   | 태그 목록                                                          |
| remote_backend            | Object       | {}                                                   | 원격 백엔드 조회 [세부사항](#remotebackend)                        |
| cluster_name              | string       | ""                                                   | 클러스터명                                                         |
| helm_chart                | Object       | {}                                                   | helm chart                                                         |
| helm_chart.name           | string       | "aws-efs-csi-driver"                                 | helm chart 명                                                      |
| helm_chart.repository_url | string       | https://kubernetes-sigs.github.io/aws-efs-csi-driver | helm chart repository url                                          |
| helm_release              | Object       | {}                                                   | helm release [세부사항](#helmrelease)                              |
| file_systems              | list(Object) | []                                                   | efs 파일 시스템 설정 [세부사항](#filesystems)                      |
| shared_account            | Object       | {}                                                   | Source account information [세부사항](#sharedaccounttargetaccount) |
| target_account            | Object       | {}                                                   | Target account information [세부사항](#sharedaccounttargetaccount) |

### remote_backend

[원격 백엔드 사용법에 대해서는 다음을 참조:S3](./doc/HowToInstall.md#backend-type-s3)
[원격 백엔드 사용법에 대해서는 다음을 참조:Remote](./doc/HowToInstall.md#backend-type-terraform-cloud)

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
| helm_release.namespace                   | Object       | optional(object)                          | helm release 설치 네임 스페이스 설정                           |
| helm_release.namespace.create            | bool         | optional(bool, false)                     | 네임스페이스 생성 유무                                         |
| helm_release.namespace.name              | string       | optional(string, "kube-system")           | 네임스페이스 명                                                |
| helm_release.service_account             | Object       | {}                                        | Service account 설정                                           |
| helm_release.service_account.create      | bool         | optional(bool, false)                     | Service account 생성 유무                                      |
| helm_release.service_account.name        | string       | optional(string, "efs-csi-controller-sa") | Service account 명                                             |
| helm_release.service_account.iam         | Object       | {}                                        | Service account를 위한 iam 설정                                |
| helm_release.service_account.create      | bool         | optional(bool, false)                     | iam 생성 유무                                                  |
| helm_release.service_account.role_name   | string       | optional(string, "")                      | role 명. 생략 시, 자동 생성                                    |
| helm_release.service_account.policy_name | string       | optional(string, "")                      | policy 명. 생량 시, 자동 생성                                  |
| helm_release.sets                        | list(Object) | optional(list(object))                    | helm 배포 시, 추가 설정                                        |
| helm_release.sets.key                    | string       | ""                                        | helm value에서 지원하는 schema의 key                           |
| helm_release.sets.value                  | string       | ""                                        | helm value에서 지원하는 schema key의 value                     |
| helm_release.resources                   | string       | optional(string, "")                      | Deployment/DaemonSet의 resources 설정                          |
| helm_release.replicas                    | string       | optional(number, 2)                       | Deployment의 replica 설정                                      |
| helm_release.affinity                    | string       | optional(string, "")                      | Deployment/DaemonSet의 affinity 설정                           |
| helm_release.tolerations                 | string       | optional(string, "")                      | Deployment/DaemonSet의 tolerations 설정                        |
| helm_release.node_selector               | string       | optional(string, "")                      | Deployment/DaemonSet의 node_selector 설정                      |
| helm_release.topology_spread_constraints | string       | optional(string, "")                      | Deployment/DaemonSet의 topology_spread_constraints 설정        |

### file_systems

[동적 스토리지 클래스 생성](./doc/HowToInstall.md#efs-storage-class-생성-지원)
[정적 PV 생성](./doc/HowToInstall.md#efs-정적-pv-생성-지원)

| 파라미터                                    | 타입         | 기본값                                    | 설명                                                                                                               |
| ------------------------------------------- | ------------ | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| file_systems.manifest.name                  | string       | ""                                        | terraform resource(kubernetes pv or storage class) key. must be unique                                             |
| file_systems.manifest.dynamic_storage_class | bool         | optional(bool, false)                     | true를 설정하면 storage class를 생성. false를 설정하면 PV를 생성 (true \| false)                                   |
| file_systems.manifest.storage_class_name    | string       | optional(string, "")                      | storage class 명. 생략 할 경우 `file_systems.manifest.name`을 `storage class name`으로 대체                        |
| file_systems.manifest.storage_capacity      | string       | optional(string, "10Gi")                  | storage capacity                                                                                                   |
| file_systems.manifest.access_mode           | list(string) | optional(list(string), ["ReadWriteMany"]) | access mode (`ReadWriteMany`\|`ReadWriteOnce`)                                                                     |
| file_systems.manifest.reclaim_policy        | string       | optional(string, "Retain")                | default reclaim policy. (`Retain`\|`Delete`) Delete를 입력하면 access point만 삭제하고 파일은 삭제하지 않음에 주의 |
| file_systems.manifest.directory_perms       | string       | optional(string, "700")                   | default directory permission                                                                                       |
| file_systems.manifest.gid_start             | string       | optional(string, "")                      | gid start                                                                                                          |
| file_systems.manifest.gid_end               | string       | optional(string, "")                      | gid end                                                                                                            |
| file_systems.manifest.base_path             | string       | optional(string, "")                      | efs base path                                                                                                      |
| file_systems.manifest.volume_handle         | string       | ""                                        | efs file system id                                                                                                 |

### shared_account,target_account

[교차계정 설치는 다음을 참조](./doc/HowToInstall.md#교차-계정-설치)

| 파라미터                       | 타입   | 기본값       | 설명                          |
| ------------------------------ | ------ | ------------ | ----------------------------- |
| shared_account.region          | string | ""           | AWS configure region          |
| shared_account.profile         | string | optional("") | AWS configure profile name    |
| shared_account.assume_role_arn | string | optional("") | AWS configure assume role arn |
