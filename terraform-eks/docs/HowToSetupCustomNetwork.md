# How to set up a custom network

기본적으로 Amazon VPC CNI plugin for Kubernetes는 Amazon EC2 노드의 보조 Elastic 네트워크 인터페이스(네트워크 인터페이스)를 생성하는 경우 노드의 기본 네트워크 인터페이스와 동일한 서브넷에서 생성한다. 또한 기본 네트워크 인터페이스에 연결된 보조 네트워크 인터페이스에 동일한 보안 그룹을 연결한다. 다음 중 하나 이상의 이유로 플러그 인이 다른 서브넷에서 보조 네트워크 인터페이스를 생성하거나 다른 보안 그룹을 보조 네트워크 인터페이스에 연결하거나, 둘 다 할 수 있다.

- 기본 네트워크 인터페이스가 있는 서브넷에서 사용할 수 있는 IPv4 주소의 수가 제한되는 경우
- 보안상의 이유로 pods는 노드의 기본 네트워크 인터페이스와 다른 서브넷 또는 보안 그룹을 사용해야 하는 경우
- 노드는 퍼블릭 서브넷에서 구성되며, pods를 프라이빗 서브넷에 배치할 경우

고려 사항

- 사용자 지정 네트워킹을 사용 설정하면 기본 네트워크 인터페이스에 할당된 IP 주소가 pods에 할당되지 않으며 보조 네트워크 인터페이스의 IP 주소만 pods에 할당한다.
- 클러스터에서 IPv6 패밀리를 사용하는 경우 사용자 지정 네트워킹을 사용할 수 없다.
- 보조 네트워크 인터페이스에 지정된 서브넷에 배포된 pods는 노드의 기본 네트워크 인터페이스와 다른 서브넷 및 보안 그룹을 사용할 수 있다고 해도 서브넷과 보안 그룹은 노드와 동일한 VPC에 있어야 한다.

## 사전 준비

[Custom networking](https://docs.aws.amazon.com/eks/latest/userguide/cni-custom-network.html)을 참고하여 다음 사항(`VPC`)이 준비 되어 있는지 확인한다.

- Step 1: Create a test VPC and cluster **_(Cluster 생성 부분은 생략할 것)_**
- Step 2: Configure your VPC

## 설치

Custom network를 활성화 순서는 다음과 같다.

1. Custom networking 활성
2. ENIconfig CRD 생성
3. NodeGroup 생성
   기존 노드 그룹이 존재하는 경우, `신규 노드 그룹 생성 > 워크로드 마이그레이션 > 기존 노드 그룹은 삭제` 또는 `기존 노드 그룹의 인스턴스 타입 변경 등을 통한 인스턴스 업그레이드`

### 1.Custom Networking 활성

- tfvars 수정

```yaml
... 중략 ...
# custom_network.enable 항목을 true 설정. 기본값: false
custom_network = {
  enable = true
}
```

- 적용

```bash
# 확인
terraform plan -var-file=examples/8.1.custom_network_step1.tfvars

# 적용
terraform apply -var-file=examples/8.1.custom_network_step1.tfvars --auto-approve
```

### 2.ENIConfig CRD 적용

- tfvars 수정

```yaml
... 중략 ...
eks_addons = [
  {
    name              = "vpc-cni"
    install           = true
    resolve_conflicts = "PRESERVE"            # 'PRESERVE'를 설정하여 업그레이드 시, vpc-cni의 설정이 초기화 되는 것을 방지한다.
    policy_arns = [
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ]
  }
]

# eniconfig을 추가
custom_network = {
  enable = true
  eniconfigs = [    # custom network(pod용)의 모든 subnet을 등록한다.
    {
      name      = "ap-northeast-2a"           # subnet과 동일한 az 이름을 입력
      subnet_id = "subnet-00ec814694f781b31"  # 신규 추가한 pod subnet id 1
    },
    {
      name      = "ap-northeast-2b"           # subnet과 동일한 az 이름을 입력
      subnet_id = "subnet-080cf4dd4acbc0f1d"  # 신규 추가한 pod subnet id N
    }
  ]
}
```

- 적용

```bash
# 확인
terraform plan -var-file=examples/8.2.custom_network_step2.tfvars

# 적용
terraform apply -var-file=examples/8.2.custom_network_step2.tfvars --auto-approve
```

- ENIconfig 확인

eniconfig crd가 생성되었는지 확인한다.

```bash
# eniconfig crd 목록 확인
kubectl get eniconfigs.crd.k8s.amazonaws.com

# eniconfig의 개별 설정 확인
kubectl get eniconfigs.crd.k8s.amazonaws.com/<eniconfig name> -oyaml
```

### 3.Custom Networking을 적용한 노드 그룹 생성

- tfvars 수정

```yaml
...  중략 ...
# Custom networking 설정이 적용 될 새 Node 그룹을 생성한다.
eks_node_groups = [
  {
    name                = "apps"
    use_spot            = true
    spot_instance_types = ["t3.small"]
    instance_volume     = "10"
    desired_size        = 2
    min_size            = 1
    max_size            = 4
    description         = "Dev EKS Cluster"
  }
]
... 후략 ...
```

- 적용

```bash
# 확인
terraform plan -var-file=examples/8.3.custom_network_step3.tfvars

# 적용
terraform apply -var-file=examples/8.3.custom_network_step3.tfvars --auto-approve
```

### Validation

```bash
# Pod에 할당된 IP 확인
kubectl get pods -A -o wide
```

---

**_Note!_**

Pod 중 `kube-proxy`, `aws-node`는 기본 spec 설정이 `hostNetwork=true`로 되어 있어 Node의 기본 IP를 할당 받음

---
