# How to Cluster Upgrade

Cluster version upgrade 절차에 대해서 설명한다.

## Process

업그레이드 절차는 다음 순으로 진행한다.

- 사전 확인
- 업그레이드
- 정상 동작 확인

### 1. Pre-check

- [kubernetes changelog](https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG)
  - 특히 **_deprecation_** 및 **_api change_** 를 확인한다.
- [eks changelog](https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html)
- [Change image repositories](https://kubernetes.io/blog/2023/03/10/image-registry-redirect/) or [limit downloads](https://docs.docker.com/docker-hub/download-rate-limit/)

### 2. Upgrade

#### 2.0. Previous version cluster 준비

---

**_Note!_**

클러스터 버전을 명시하지 않을 경우 기본 버전을 설치하므로 기본 버전과 최신 버전이 동일 할 경우 예제를 진행 할 수 없다.

---

```bash
# Previous version cluster
terraform apply -var-file=examples/6.install_addons.tfvars --auto-approve
```

#### 2.1. Cluster upgrade

- tfvars 수정

```yaml
...  중략 ...
# 업그레이드 할 버전을 명시 e.g. v1.26
eks_cluster_version = "1.26"

eks_node_groups = [
  {
    name                = "apps"            # 기존 노드 그룹
    use_spot            = true
    spot_instance_types = ["t3.small"]
    instance_volume     = "10"
    desired_size        = 2
    min_size            = 1
    max_size            = 4
    kubelet_version     = "1.25"            # 기존 노드 그룹은 업그레이드 이후 삭제 할 예정으로 현재 버전을 명시 e.g. v1.25
    description         = "Dev EKS Cluster"
  },
  {
    name                = "apps-v1-26"      # v1.26 버전의 신규 노드 그룹
    use_spot            = true
    spot_instance_types = ["t3.small"]
    instance_volume     = "10"
    desired_size        = 2
    min_size            = 1
    max_size            = 4
    description         = "Dev EKS Cluster"
  }
]
...  후략 ...
```

- 적용

```bash
# 변경 사항 확인
terraform plan -var-file=examples/9.1.cluster_upgrade_step1.tfvars

# 변경 사항이 예상과 동일하면 업그레이드
terraform apply -var-file=examples/9.1.cluster_upgrade_step1.tfvars --auto-approve
```

---

**_Note!_**

kubernetes token의 유효 시간은 `15`분이다. 이로 인해 업그레이드 진행 시 `15`분을 초과하여 `aws-auth` 갱신 단계에서 `kubernetes authentication` 오류가 날 수 있다. 만일 노드 그룹이 생성되었다면 `kubernetes authentication` 오류는 무시하고 다음을 진행한다.

---

#### 2.2. Addon upgrade

기존 클러스터에 Addon을 구성한 경우, addon 버전을 업그레이드 한다. 특히 `kube-proxy`의 경우 cluster와 동일 버전 설치를 권장한다.

- addon 버전 확인

  현재 설치를 지원하는 addon

  - aws-ebs-csi-driver
  - vpc-cni
  - coredns
  - kube-proxy

```bash
# cli 명령어를 통해 확인
aws eks describe-addon-versions --kubernetes-version <CLUSTER VERSION> --query 'addons[?addonName==`<ADDON NAME>`].addonVersions[*].addonVersion'
```

- tfvars 수정

```yaml
... 중략 ...
eks_addons = [
  {
    name    = "aws-ebs-csi-driver"
    install = true
    version = "v1.17.0-eksbuild.1"              # 업그레이드 한 클러스터에서 지원하는 버전을 명시한다.
    policy_arns = [
      "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    ]
    policy_file = "kms-key-for-encryption-on-ebs.tpl"
  },
  {
    name              = "vpc-cni"
    install           = true
    version           = "v1.12.6-eksbuild.1"    # 업그레이드 한 클러스터에서 지원하는 버전을 명시한다.
    resolve_conflicts = "PRESERVE"
    policy_arns = [
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ]
  },
  {
    name    = "coredns"
    version = "v1.9.3-eksbuild.2"               # 업그레이드 한 클러스터에서 지원하는 버전을 명시한다.
    install = true
  },
  {
    name    = "kube-proxy"
    version = "v1.26.2-eksbuild.1"              # 업그레이드 한 클러스터에서 지원하는 버전을 명시한다.
    install = true
  }
]
... 중략 ...
```

```bash
# 변경 사항 확인
terraform plan -var-file=examples/9.2.cluster_upgrade_step2.tfvars

# 변경 사항이 예상과 동일하면 업그레이드
terraform apply -var-file=examples/9.2.cluster_upgrade_step2.tfvars --auto-approve
```

#### 2.3. Workload migration

기존 워크로드를 `kubectl cordon`, `kubectl drain` 명령어를 사용하여 이전 버전 노드에서 새 버전 노드로 이전한다.

```bash
# cordon
kubectl get nodes | grep <PREVIOUS VERSION> | awk -F ' ' '{print $1}' | xargs kubectl cordon

# evict pods
# DO NOT DRAIN ALL NODE AT ONCE
kubectl drain <node-to-drain> --ignore-daemonsets --delete-emptydir-data
```

---

**_Warning!_**

drain 작업은 노드 별 순차적으로 진행한다. 모든 노드를 한번에 drain 할 경우, 서비스 장애가 발생 할 수 있다.

---

#### 2.4. Delete previous version

워크로드 이전을 완료 한 후, 기존 노드그룹을 제거한다.

- tfvars 수정

이전 버전의 노드 그룹을 삭제한다.

```yaml
... 중략 ...
eks_node_groups = [
  {
    name                = "apps-v1-26"
    use_spot            = true
    spot_instance_types = ["t3.small"]
    instance_volume     = "10"
    desired_size        = 2
    min_size            = 1
    max_size            = 4
    description         = "Dev EKS Cluster"
  }
]
```

---

**_Note!_**

이전 단계 `2.2. Addon upgrade`를 실행한 경우 tfvars에 해당 내용을 반영해야 한다.

---

- 적용

```bash
# 변경 사항 확인
terraform plan -var-file=examples/9.3.cluster_upgrade_step3.tfvars

# 변경 사항이 예상과 동일하면 업그레이드
terraform apply -var-file=examples/9.3.cluster_upgrade_step3.tfvars --auto-approve
```

### 3. Validation

업그레이드 과정 전반을 모니터링 하며, kubernetes event 로그의 오류 내용 및 pod 상태 및 pod log를 확인한다.

```bash
# 업그레이드 노드 확인
kubectl get nodes | grep <UPGRADED VERSION> | awk -F ' ' '{print $1}'

# 비정상 이벤트 확인
watch kubectl get events --field-selector type!=Normal -A

# 비정상 Pods 확인
kubectl get pods -A --field-selector status.phase!=Running

# 재실행이 Pods 확인
kubectl get pods -A | awk '$5 > 0'
```
