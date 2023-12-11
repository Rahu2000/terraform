# EKS AddOns

## **_THIS PAGE IS DEPRECATED_**

EKS Add-Ons는 Kubernetes 애플리케이션에 대한 지원 운영 기능을 제공하는 소프트웨어로써 AWS 리소스인 네트워킹, 컴퓨팅 및 스토리지에 대한 관리를 지원한다.

Add-Ons은 일반적으로 Kubernetes 커뮤니티, AWS 클라우드 공급자 또는 3rd party 공급업체에 의해 유지 관리 된다. AWS EKS는 모든 클러스터에 `Amazon VPC CNI`, `kube-proxy`, `CoreDNS`를 자동으로 설치하나 관리의 목적을 위해 기본 구성을 변경 또는 업데이트할 수 있다. 이를 위해 Add-Ons은 이를 관리하는 역할을 담당한다. AWS Add-Ons에서 제공하는 기능에는 최신 보안 패치, 버그 수정 사항이 포함되어 있으며, Amazon EKS와 작동하도록 AWS에서 검증되었다.

Amazon EKS Add-Ons는 1.18이상에서 사용할 수 있다.

## 지원되는 Add-Ons

- Amazon VPC CNI
- CoreDNS
- kube-proxy
- Amazon EBS CSI (제한적)

Add On은 계속 추가 될 예정이며 현재 EKS에서 지원되는 Add-Ons 및 버전은 다음 명령어를 실행하여 확인한다.

```sh
aws eks describe-addon-versions --kubernetes-version <value>
```

## Terraform Input Variables

addon 구성을 위해서는 input value를 설정한다.</br>
다음 예제와 같이 설정한다.

```text
... 생략

eks_addons = {
  aws_node = {
    "install" = true
    "version" = "v1.11.0-eksbuild.1"
  }

  kube_proxy = {
    "install" = true
    "version" = "v1.22.6-eksbuild.1"
  }

  coredns = {
    "install" = true
    "version" = "v1.8.7-eksbuild.1"
  }

  aws_ebs_csi_driver = {
    "install" = true
    "version" = "v1.6.0-eksbuild.1"
  }
}
```

aws_ebs_csi_driver는 `apply_manifest`를 추가로 설정 할 수 있다.</br>

```text
eks_addons = {
  aws_ebs_csi_driver = {
    "install" = true
    "version" = "v1.6.0-eksbuild.1"
    "apply_manifest" = "false"
  }
```

`apply_manifest`를 `true`로 설정(`default: false`) 할 경우, kubernetes에 `gp3` 스토리지 클래스를 등록한다.

```bash
terraform plan -var-file=example
terraform apply -var-file=example -auto-approve
```

### `eks_addons` variables

| 항목               | 필수 | 유형 | 기본 값 | 설명                                                                           |
| ------------------ | ---- | ---- | ------- | ------------------------------------------------------------------------------ |
| aws_ebs_csi_driver | X    | map  | `{}`    | `aws_ebs_csi_driver` add on 설치 여부. 상세 설정 사항은 `eks_addons_info` 참조 |
| aws_node           | X    | map  | `{}`    | `vpc_cni` add on 설치 여부. 상세 설정 사항은 `eks_addons_info` 참조            |
| coredns            | X    | map  | `{}`    | `coredns` add on 설치 여부. 상세 설정 사항은 `eks_addons_info` 참조            |
| kube_proxy         | X    | map  | `{}`    | `kube-proxy` add on 설치 여부. 상세 설정 사항은 `eks_addons_info` 참조         |

---

## Addon 추가

- addon 지원 여부를 확인한다.

```sh
aws eks describe-addon-versions --kubernetes-version <value>
```

- `${path.root}/variables.tf`에 addon 내용을 추가한다.
- `${path.root}/modules/addon/variables.tf`에 addon 내용을 추가한다.
- tfvars의 eks_addons 에 추가한다.
- 추가한 addon에 IAM이 필요한 경우
  - `eks_addons.tf`의 `local.NEED_IAM_ROLE`에 관련 내용을 추가한다.
  - `eks_addons.tf`의 `local.SERVICE_ACCOUNT`에 관련 내용을 추가한다.
  - AWS 관리형 Policy를 적용할 경우, `${path.root}/variables.tf` `eks_addons.default`의 `iam_role.policy_arn`에 `ARN`을 등록한다.
  - 고객 관리형 Policy를 적용할 경우, `${path.root}/templates`에 policy.json을 추가하고 `${path.root}/variables.tf` `eks_addons.default`의 `iam_role.policy_file`에 파일 이름을 등록한다.

### `eks_addons_info` variables

| 항목                     | 필수 | 유형         | 기본 값       | 설명                                                                                                                                                               |
| ------------------------ | ---- | ------------ | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| name                     | O    | string       | `""`          | Add on 이름. 지원하는 addon은 aws cli 통해 조회한다. `aws eks describe-addon-versions`                                                                             |
| install                  | O    | bool         | `false`       | Add on 추가 여부                                                                                                                                                   |
| version                  | X    | string       | `true`        | Add on 버전. 입력을 생략할 경우 Addon default 버전을 설치                                                                                                          |
| apply_manifest           | X    | bool         | `false`       | 사전 정의한 kubernetes resource를 kubernetes에 적용                                                                                                                |
| preserve                 | X    | bool         | `false`       | `true`로 설정 할 경우, Add on을 등록해제하여도 Kubernetes에서는 실제 삭제하지 않음                                                                                 |
| enable_encryption        | X    | bool         | `false`       | pod에 할당할 ebs에 암호화를 적용할 경우 `true` 설정.</br>aws-ebs-csi-driver.install이 `true`일 경우에만 유효                                                       |
| use_custom_kms           | X    | bool         | `false`       | pod에 할당할 ebs 암호화에 고객 관리형 KMS를 적용할 경우 `true` 설정. `false`의 경우 AWS 관리형 KMS를 설정.</br>aws-ebs-csi-driver.install이 `true`일 경우에만 유효 |
| iam_role.create          | X    | bool         | `false`       | Add on 구성 시, service account에 할당 할 iam role 생성 여부. `eks_addons.tf`의 `local.NEED_IAM_ROLE` 참조                                                         |
| iam_role.namespace       | X    | string       | `kube-system` | Service account가 종속 될 namespace. oidc와 연동 할 iam의 assume_policy 구성에 필요                                                                                |
| iam_role.service_account | X    | string       | `""`          | Service account 이름. oidc와 연동 할 iam의 assume_policy 구성에 필요. `eks_addons.tf`의 `local.SERVICE_ACCOUNT` 참조                                               |
| iam_role.role_name       | X    | string       | `""`          | iam role 이름                                                                                                                                                      |
| iam_role.policy_name     | X    | string       | `""`          | iam policy 이름. policy를 정책 json으로 생성해야 할 경우 policy 이름은 필수                                                                                        |
| iam_role.policy_file     | X    | string       | `""`          | policy 정책 파일 경로                                                                                                                                              |
| iam_role.policy_arns     | X    | list(string) | `[]`          | AWS 관리형 policy arn 목록                                                                                                                                         |
