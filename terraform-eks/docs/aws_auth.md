# EKS/AWS AUTH

## **_THIS PAGE IS DEPRECATED_**

Amazon EKS 제어 플레인에서 실행되는 Kubernetes용 AWS IAM Authenticator과 AWS Identity and Access Management(IAM)을 통해 Amazon EKS에 접속할 수 있으며 Kubernetes용 AWS IAM Authenticator는 Amazon EKS를 생성할 때 자동으로 활성화되며 Kubernetes ConfigMap의 aws-auth에서 인증 대상을 조회한다.

## 사용 예제

- tfvars에 role 또는 user를 추가

```tfvars

... 중략

rbac_roles = [
  {
    rolearn  = "arn:aws:iam::123456789012:role/deployer"
    username = "{{SessionName}}"
    roletype = "CLUSTER_ADMIN"
  }
]

rbac_users = [
  {
    userarn  = "arn:aws:iam::123456789012:user/ann"
    username = "ann"
    usertype = ""
  },
  {
    userarn  = "arn:aws:iam::123456789012:user/john"
    username = "john"
    usertype = "CLUSTER_ADMIN"
  }
]

```

- terraform apply
- 적용 내용 확인

```sh
kubectl get cm/aws-auth -n kube-system -oyaml

apiVersion: v1
data:
  mapRoles: |
    ... 중략
    # data.mapRoles에 Role이 추가 된 것을 확인
    - "groups":
      - "system:masters"
      - "system:nodes"
      "rolearn": "arn:aws:iam::123456789012:role/deployer"
      "username" = "{{SessionName}}"

    # data.mapUsers에 User가 추가 된 것을 확인
  mapUsers: |
    - "userarn": "arn:aws:iam::123456789012:user/deployer"
      "username": "deployer"
    ... 후략
```

## `karpenter` variables

| 항목                | 필수 | 유형   | 기본 값 | 설명                      |
| ------------------- | ---- | ------ | ------- | ------------------------- |
| karpenter.enabled   | O    | bool   | `false` | Karpenter 사용 여부       |
| karpenter.role_name | X    | string | `""`    | Karpenter용 IAM Role 이름 |

### Karpenter - _TO DO_

Karpenter 설치 및 IAM Role 생성은 별도 구현

## `rbac_roles` variables

| 항목     | 필수 | 유형   | 기본 값                             | 설명                                                |
| -------- | ---- | ------ | ----------------------------------- | --------------------------------------------------- |
| rolearn  | O    | string | `""`                                | AWS IAM Role Arn                                    |
| username | O    | string | `aws:{{AccountID}}:{{SessionName}}` | 감사 로그에 출력되는 Role 사용자 명                 |
| roletype | O    | string | `""`                                | role 유형, 현재 BOOTSTRAPPER, CLUSTER_ADMIN 만 지원 |

### RBAC ROLE - _TO DO_

`BOOTSTRAPPER`, `CLUSTER_ADMIN` 이외의 roletype이 필요할 경우 namespace 및 ClusterRole/Role/ClusterRoleBinding/RoleBinding 생성을 구현

## `rbac_users` variables

| 항목      | 필수 | 유형   | 기본 값                             | 설명                                                               |
| --------- | ---- | ------ | ----------------------------------- | ------------------------------------------------------------------ |
| userarn   | O    | string | `""`                                | AWS IAM User Arn                                                   |
| username  | O    | string | `aws:{{AccountID}}:{{SessionName}}` | 감사 로그에 출력되는 사용자 명                                     |
| usertype  | O    | string | `""`                                | 사용자 유형, 현재 CLUSTER_ADMIN, CLUSTER_VIEW, ADMIN, VIEW 만 지원 |
| namespace | X    | string | `""`                                | 네임스페이스, 사용자 유형이 ADMIN, VIEW일 경우 필수                |

### RBAC USER - _TO DO_

`CLUSTER_ADMIN, CLUSTER_VIEW, ADMIN, VIEW`이외의 usertype이 필요할 경우 namespace 및 ClusterRole/Role/ClusterRoleBinding/RoleBinding 생성을 별도 구현
