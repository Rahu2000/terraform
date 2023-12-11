# Terraform-EKS

Terraform-EKS는 eks의 손쉬운 설치 및 운영을 목적으로 terraform 기반으로 개발되었다.
Terraform-EKS가 제공하는 주요 기능은 다음과 같다.

- eks cluster 생명주기 관리
- eks nodegroup 생명주기 관리
- eks addon 생명주기 관리
- custom network 지원
- AWS IAM과 Kubernetes RBAC 연동 지원
- AWS Cross account 지원

## 설치 및 삭제

### 1. git clone

```sh
git clone https://github.com/psa-terraform/eks.git --recursive
```

### 2. 설치

[다음을 참조](./docs/HowToInstall.md)

### 3. 특정 노드그룹 삭제

#### **프로비전된 노드그룹에서 nodegroup["ops"] 삭제시**

- s3 백엔드 tfstat에서 삭제할 대상 정보를 확인

```sh
terraform state list
```

```sh
$ terraform state list
...
module.eks_cluster.aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
module.eks_cluster.aws_iam_role_policy_attachment.AmazonEKSVPCResourceController
module.nodegroup["ops"].aws_eks_node_group.nodegroup
module.nodegroup["ops"].aws_iam_role.nodegroup
module.nodegroup["ops"].aws_iam_role_policy_attachment.nodegroup_cni_policy
module.nodegroup["ops"].aws_iam_role_policy_attachment.nodegroup_ec2_container_policy
module.nodegroup["ops"].aws_iam_role_policy_attachment.nodegroup_node_policy
module.nodegroup["ops"].aws_iam_role_policy_attachment.nodegroup_ssm_policy
module.nodegroup["ops"].aws_launch_template.nodegroup
...
```

- nodegroup["ops"] 삭제

```sh
terraform destroy -target [삭제대상] -var-file=env/dev.tfvars -auto-approve
```

```sh
$ terraform destroy \
-target module.nodegroup["ops"].aws_eks_node_group.nodegroup \
-target module.nodegroup["ops"].aws_iam_role.nodegroup \
-target module.nodegroup["ops"].aws_iam_role_policy_attachment.nodegroup_cni_policy \
-target module.nodegroup["ops"].aws_iam_role_policy_attachment.nodegroup_ec2_container_policy \
-target module.nodegroup["ops"].aws_iam_role_policy_attachment.nodegroup_node_policy \
-target module.nodegroup["ops"].aws_iam_role_policy_attachment.nodegroup_ssm_policy \
-target module.nodegroup["ops"].aws_launch_template.nodegroup \
-var-file=env/dev.tfvars -auto-approve
'''
```

- Code와 tfstat 정합성 확인
  . tfvars, eks_node_group.tf에서 삭제된 노드그룹 comment out 후 다음 plan 확인

```sh
terraform plan -var-file=env/dev.tfvars
```

```sh
$ terraform plan -var-file=env/dev.tfvars

...
No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```

## Cluster Upgrade

클러스터 업그레이드는 [다음을 참조](./docs/HowToClusterUpgrade.md).

## Custom network settings

사용자 지정 네트워크 설정은 [다음을 참조](./docs/HowToSetupCustomNetwork.md).

## Configuration

### Variables

| 항목                                    | 유형         | 기본 값        | 설명                                                                                                                             |
| --------------------------------------- | ------------ | -------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| project                                 | string       | ""             | 프로젝트 코드명                                                                                                                  |
| region                                  | string       | ""             | 리전명                                                                                                                           |
| abbr_region                             | string       | ""             | 리전 약어 (e.g. ANE2: ap-northeast-2)                                                                                            |
| env                                     | string       | ""             | 프로비전 구성 환경 (e.g. dev, stg, qa, prod, ...)                                                                                |
| org                                     | string       | ""             | 조직명                                                                                                                           |
| default_tags                            | map          | {}             | AWS리소스 생성시 공통 태그 설정                                                                                                  |
| remote_backend                          | object       | {}             | terraform backend 정보. [설정 값 참조](#remote-backend)                                                                          |
| vpc_id                                  | string       | ""             | VPC ID (네트워크가 이미 구성된 곳에 설치할 떄 사용)</br>remote_backend 구성 시, remote에서 조회                                  |
| private_subnet_ids                      | list(string) | []             | EKS가 설치될 Private Subnet ID 목록 설정(네트워크가 이미 구성된 곳에 설치할 떄 사용)</br>remote_backend 구성 시, remote에서 조회 |
| public_subnet_ids                       | list(string) | []             | EKS가 설치될 Public Subnet ID 목록 설정(네트워크가 이미 구성된 곳에 설치할 떄 사용)                                              |
| additional_cluster_security_group_ids   | list(string) | []             | EKS 클러스터에 security group을 추가로 붙이고 싶은 경우 security group id 정보를 설정                                            |
| additional_nodegroup_security_group_ids | list(string) | []             | 노드그룹에 security group을 추가로 붙이고 싶은 경우 security group id 정보를 설정                                                |
| custom_network                          | object       | {}             | 사용자 지정 네트워크 설정 정보. [설정 값 참조](#custom-network)                                                                  |
| eks_cluster_name                        | string       | ""             | EKS 클러스터명. 미입력 시, 자동 생성                                                                                             |
| eks_cluster_version                     | string       | ""             | EKS 클러스터 버전. 미입력 시, AWS EKS 기본 버전으로 설정                                                                         |
| eks_cluster_role_name                   | string       | ""             | EKS 클러스터 역할 명. 미입력 시, 자동 생성()                                                                                     |
| eks_endpoint_url                        | string       | ""             | EKS 클러스터 엔드포인트 url **deprecated**                                                                                       |
| eks_cluster_certificate_authority_data  | string       | ""             | EKS 클러스터 CA **deprecated**                                                                                                   |
| endpoint_public_access                  | bool         | true           | API서버 Public Endpoint 생성 여부                                                                                                |
| endpoint_private_access                 | bool         | true           | API서버 Private Endpoint 생성 여부                                                                                               |
| key_pair_name                           | string       | ""             | 노드 접속을 위한 키페어명                                                                                                        |
| public_access_cidrs                     | list(string) | ["0.0.0.0/32"] | EKS API 서버에 접근가능한 화이트리스트 설정                                                                                      |
| cluster_sg_name                         | string       | ""             | cluster security group name. 미입력 시, 자동 생성                                                                                |
| node_sg_name                            | string       | ""             | node group security group name. 미입력 시, 자동 생성                                                                             |
| shared_sg_name                          | string       | ""             | shared security group name. 미입력 시, 자동 생성                                                                                 |
| eks_node_groups                         | list(object) | []             | 노드그룹 생성을 위한 설정. [설정 값 참조](#eks-node-groups)                                                                      |
| eks_fargate_profiles                    | list(object) | []             | Fargate 프로파일 설정. [설정 값 참조](#eks-fargate-profiles)                                                                     |
| eks_addons                              | list(object) | []             | EKS 애드온 추가를 위한 설정. [설정 값 참조](#eks-add-ons)                                                                        |
| karpenter                               | object       | {}             | EKS configmap/aws-auth에 Karpenter IAM Role 추가를 위한 설정. [설정 값 참조](#karpenter)                                         |
| rbac_roles                              | list(object) | []             | EKS configmap/aws-auth에 AWS Role or Instance profile 추가를 위한 설정. [설정 값 참조](#rbac-roles)                              |
| rbac_users                              | list(object) | []             | EKS configmap/aws-auth에 AWS user 추가를 위한 설정. [설정 값 참조](#rbac-users)                                                  |
| shared_account                          | object       | {}             | Source 계정 정보. [설정 값 참조](#account)                                                                                       |
| target_account                          | object       | {}             | Target 계정 정보. [설정 값 참조](#account)                                                                                       |

### Remote backend

| 항목                                     | 유형         | 기본 값 | 설명                                                                              |
| ---------------------------------------- | ------------ | ------- | --------------------------------------------------------------------------------- |
| remote_backend.type                      | string       | ""      | 원격 벡엔드 저장소 유형. (`s3`\|`remote`) 만 지원                                 |
| remote_backend.workspaces                | list(object) | []      | 원격 벡엔드 워크스페이스 목록                                                     |
| remote_backend.workspaces.service        | string       | ""      | 원격 벡엔드 워크스페이스 서비스 유형. (`network`) 만 지원                         |
| remote_backend.workspaces.bucket         | string       | ""      | 원격 벡엔드 저장소가 `s3`인 경우 필수. 버킷명                                     |
| remote_backend.workspaces.key            | string       | ""      | 원격 벡엔드 저장소가 `s3`인 경우 필수. 키명                                       |
| remote_backend.workspaces.region         | string       | ""      | 원격 벡엔드 저장소가 `s3`인 경우 옵션. 리전 명. 미 입력 시, 전역 리전 명으로 대체 |
| remote_backend.workspaces.org            | string       | ""      | 원격 벡엔드 저장소가 `remote`인 경우 필수. 조직 명                                |
| remote_backend.workspaces.workspace_name | string       | ""      | 원격 벡엔드 저장소가 `remote`인 경우 필수. 워크스페이스 명                        |

### Custom network

| 항목                                | 유형         | 기본 값 | 설명                               |
| ----------------------------------- | ------------ | ------- | ---------------------------------- |
| custom_network.enable               | bool         | false   | 사용자 지정 네트워크 사용 여부     |
| custom_network.eniconfigs           | list(object) | []      | ENIConfig CRD 생성 정보 목록       |
| custom_network.eniconfigs.name      | string       | ""      | ENIConfig 명 (가급적 az 명을 권장) |
| custom_network.eniconfigs.subnet_id | string       | ""      | Pod용 서브넷 ID                    |

### EKS node groups

| 항목                                 | 유형           | 기본 값 | 설명                                                                                         |
| ------------------------------------ | -------------- | ------- | -------------------------------------------------------------------------------------------- |
| eks_node_groups.name                 | string         | ""      | node group 명. 목록에서 반드시 고유해야 한다.                                                |
| eks_node_groups.private_networking   | bool           | true    | node를 생성 할 서브넷의 특징. public 또는 private                                            |
| eks_node_groups.use_spot             | bool           | false   | SPOT 인스턴스 사용 여부. `true`로 설정 시 노드 그룹의 인스턴스 용량 유형은 `SPOT`            |
| eks_node_groups.instance_type        | string         | ""      | use_spot = `false`일 경우 필수. 인스턴스 유형                                                |
| eks_node_groups.spot_instance_types  | list(string)   | []      | use_spot = `true`일 경우 필수. 인스턴스 유형 목록                                            |
| eks_node_groups.instance_volume      | number         | 30      | 노드에 할당 할 디스크 용량. 단위: GB                                                         |
| eks_node_groups.desired_size         | number         | 1       | auto scaling 설정. 노드 그룹의 인스턴스 수                                                   |
| eks_node_groups.min_size             | number         | 1       | auto scaling 설정. 노드 그룹의 최소 인스턴스 수                                              |
| eks_node_groups.max_size             | number         | 2       | auto scaling 설정. 노드 그룹의 최대 인스턴스 수                                              |
| eks_node_groups.description          | string         | ""      | 노드 그룹에 대한 설명                                                                        |
| eks_node_groups.labels               | map            | {}      | 노드에 추가 설정 할 labels                                                                   |
| eks_node_groups.taints               | list(map(any)) | []      | 노드에 설정 할 taints                                                                        |
| eks_node_groups.kubelet_version      | string         | ""      | Kubelet 버전. 미 입력 시, 클러스터 버전과 동일                                               |
| eks_node_groups.user_data_script     | string         | ""      | ec2 user data 적용 할 스크립트 파일명. 해당 파일은 반드시 `/templates/`폴더에 존재해야 한다. |
| eks_node_groups.role_name            | string         | ""      | Instance profile 명. 미입력 시 자동 생성                                                     |
| eks_node_groups.launch_template_name | string         | ""      | 시작 템플릿 명. 미입력 시 자동 생성                                                          |
| eks_node_groups.enable_ssm           | bool           | false   | SSM 사용 여부. `true`를 설정 하면 SSM 관련 정책이 추가된다.                                  |

### EKS Fargate profiles

| 항목                                    | 유형     | 기본 값 | 설명                               |
| --------------------------------------- | -------- | ------- | ---------------------------------- |
| eks_fargate_profiles.name               | string   | ""      | fargate 프로파일 명                |
| eks_fargate_profiles.role_name          | string   | ""      | fargate 프로파일에 할당할 역할 명  |
| eks_fargate_profiles.role_arn           | string   | ""      | fargate 프로파일에 할당할 역할 arn |
| eks_fargate_profiles.selector           | object   | ""      | fargate selector                   |
| eks_fargate_profiles.selector.namespace | string   | ""      |                                    |
| eks_fargate_profiles.selector.labels    | map(any) | {}      |                                    |

### EKS add ons

| 항목                         | 유형         | 기본 값     | 설명                                                                                                  |
| ---------------------------- | ------------ | ----------- | ----------------------------------------------------------------------------------------------------- |
| eks_addons.name              | string       | ""          | addon 명. (`vpc-cni`\|`coredns`\|`kube-proxy`\|`aws-ebs-csi-driver`) 만 지원                          |
| eks_addons.install           | bool         | false       | `true`로 설정 시, 해당 addon을 설치                                                                   |
| eks_addons.version           | string       | ""          | addon 버전. 미입력 시, 기본 버전을 설치                                                               |
| eks_addons.apply_manifest    | bool         | true        | addon 설치 후, k8s resource 생성이 필요한 경우 `true` 설정. 현재 (`aws-ebs-csi-driver`) addon 만 지원 |
| eks_addons.enable_encryption | bool         | true        | ebs storage 암호화 적용 여부. 현재 (`aws-ebs-csi-driver`) addon 만 지원                               |
| eks_addons.use_custom_kms    | bool         | false       | ebs storage 암호화 key에 사용자 지정 kms 적용 여부. default kms: `aws/ebs`                            |
| eks_addons.role_name         | string       | ""          | 역할 생성 시 필요한 역할 명. 미입력 시, 이름 자동 생성                                                |
| eks_addons.policy_name       | string       | ""          | 정책 생성 시 필요한 정책 명. 미입력 시, 이름 자동 생성                                                |
| eks_addons.policy_arns       | list(string) | []          | AWS 관리 정책 등 기존 정책의 arn을 입력하면 역할에 해당 정책을 추가하여 할당                          |
| eks_addons.policy_file       | string       | ""          | 사용자 지정 정책의 경우 정책 템플릿의 파일명(json 형식). `/templates/` 폴더에 json 파일을 추가한다.   |
| eks_addons.resolve_conflicts | string       | "OVERWRITE" | addon 추가 시, 설정 충돌이 발생 할 경우 설치 정책. (`OVERWRITE`\|`PRESERVE`) 지원                     |

### karpenter

---

**_Note!_**

현재 karpenter 설치는 지원하지 않는다.

---

| 항목                | 유형   | 기본 값 | 설명                                            |
| ------------------- | ------ | ------- | ----------------------------------------------- |
| karpenter.enabled   | bool   | false   | karpenter 적용 여부                             |
| karpenter.role_name | string | ""      | karpenter Service Account에 할당 할 IAM 역할 명 |

### RBAC Roles

| 항목                | 유형   | 기본 값 | 설명                                                          |
| ------------------- | ------ | ------- | ------------------------------------------------------------- |
| rbac_roles.roletype | string | ""      | RBAC role 역할. (`BOOTSTRAPPER`\|`CLUSTER_ADMIN`\|``) 만 지원 |
| rbac_roles.username | string | ""      | role 사용자 명. audit 로그 출력 용                            |
| rbac_roles.rolearn  | string | ""      | AWS IAM Role arn                                              |

### RBAC Users

| 항목                | 유형   | 기본 값 | 설명                                          |
| ------------------- | ------ | ------- | --------------------------------------------- |
| rbac_users.usertype | string | ""      | RBAC user 역할. (`CLUSTER_ADMIN`\|``) 만 지원 |
| rbac_users.username | string | ""      | 사용자 명. audit 로그 출력 용                 |
| rbac_users.userarn  | string | ""      | AWS IAM User arn                              |

### Account

| 항목                           | 유형   | 기본 값 | 설명                                                    |
| ------------------------------ | ------ | ------- | ------------------------------------------------------- |
| shared_account.region          | string | ""      | 리전 명. 미입력 시, 전역 리전 명으로 대체               |
| shared_account.profile         | string | ""      | AWS Credential 프로파일 명. 미입력 시, `default`로 대체 |
| shared_account.assume_role_arn | string | ""      | AWS assume role arn                                     |
