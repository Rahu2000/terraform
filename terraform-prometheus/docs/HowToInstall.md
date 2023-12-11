# How to install

테라폼 코드의 helm을 통해 `kube-prometheus-stack`을 설치하는 방법을 설명한다.

테라폼 코드는 다음 기능을 지원한다.

- 다양한 백엔드 지원
  - local
  - s3
  - terraform cloud
- PV(Persistent volume) 또는 SC(Storage class) 생성 지원
- AWS 교차 계정 지원
- 복수 Workspace 지원

## kube-prometheus-stack를 설치하는 예제

### Backend Type: Local

- 배포

```sh
# init
terraform init

# Create Workspace (option)
terraform workspace new dev

# Change Workspace (option)
terraform workspace select dev

# Check installation plan (option)
terraform plan -var-file=examples/1.basic_install.tfvars

# Install
terraform apply -var-file=examples/1.basic_install.tfvars --auto-approve
```

- 배포 결과 확인

```sh
# 'terraform.tfstate'가 생성 된 것을 확인 할 수 있다.
ls -al

...
-rw-r--r-- 1 mzc mzc 19575 Mar 24 14:34 terraform.tfstate
...
```

- 삭제

```sh
# Destroy
terraform destroy -var-file=examples/1.basic_install.tfvars --auto-approve
```

### Backend Type: S3

다음을 수행한 후, `terraform init`을 실행

- hcl 작성

```txt
bucket         = "demo-common-terraform-state"                  # S3 버킷명 (필수)
key            = "demo/<REGION>/prometheus.tfstat"              # terraform.tfstate를 S3 버킷에 저장하기 위한 경로 및 파일 (필수)
region         = "<REGION>"                                     # S3 버킷 리전 (필수)
encrypt        = true                                           # S3 버킷에 업로드/다운로드 할 경우 암호화 적용 여부 (선택 - default:false)
dynamodb_table = "PROMETHEUS"                                   # Lock 용 Dynamodb 테이블 명 (필수)
```

- versions.tf 수정

```yaml
terraform {
  ... 중략 ...
  # Uncomment if you are using s3 as backend.
  backend "s3" {}

}
```

- 배포

```sh
# Init
terraform init -backend-config="/PATH/TO/BACKEND.hcl"

# Create Workspace (option)
terraform workspace new dev

# Change Workspace (option)
terraform workspace select dev

# Check installation plan (option)
terraform plan -var-file=examples/2.backend_type_s3.tfvars

# Install
terraform apply -var-file=examples/2.backend_type_s3.tfvars --auto-approve
```

- 삭제

```sh
# Destroy
terraform destroy -var-file=examples/2.backend_type_s3.tfvars --auto-approve
```

### Backend Type: Terraform Cloud

다음을 수행한 후, `terraform init`을 실행

- versions.tf 수정

```yaml
terraform {
  ... 중략 ...
  # Uncomment if you are using terraform cloud as backend.
  cloud {
    organization = "TERRAFORM CLOUD ORGANIZATION NAME"
    workspaces {
      tags = ["TERRAFORM CLOUD WORKSPACE TAGS"]
    }
  }
}
```

- 배포

```sh
# Init
terraform init

# Check installation plan (option)
terraform plan -var-file=examples/3.backend_type_remote.tfvars

# Install
terraform apply -var-file=examples/3.backend_type_remote.tfvars --auto-approve
```

- 삭제

```sh
# Destroy
terraform destroy -var-file=examples/3.backend_type_remote.tfvars --auto-approve
```

### 교차 계정 설치

테라폼 백엔드 저장소 계정과 kube-prometheus-stack 설치 대상 계정이 다른 경우 교차 계정 설치를 실행한다.
교차 계정 설치는 먼저 교차 계정 설정을 수행한 후 terraform 설치를 수행한다. 백엔드 구성 설정은 위에서 설명한 내용과 동일하게 설정한다. 예제는 [Backend Type: Local](#backend-type-local)과 유사하다.

다음을 수행한 후 `terraform init`을 실행

- 로컬에 AWS profile을 설정한 경우

  - source 계정에 대해 aws configure을 실행 (profile 옵션 생략 가능)

  ```sh
  aws configure --profile <SOURCE PROFILE>
  ```

  - target 계정에 대해 aws configure을 실행 (profile 옵션 필수)

  ```sh
  aws configure --profile <TARGET PROFILE>
  ```

  - `4.cross_account_install.tfvars` 코드를 다음과 같이 수정

  ```sh
  shared_account = {
    region  = "<REGION>"
    profile = "SOURCE PROFILE" # e.g. default
  }

  target_account = {
    region  = "<REGION>"
    profile = "TARGET PROFILE" # e.g. dev
  }
  ```

- ASSUME ROLE을 설정할 경우

  - source 계정의 aws configure을 실행 (예제에서는 profile 옵션 생략)

  ```sh
  aws configure --profile <SOURCE PROFILE>
  ```

  - Target 계정의 ASSUME ROLE에 신뢰 관계 설정

  ```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            ... 중략
            "arn:aws:iam::<SOURCE ACCOUNT>:role/<SOURCE ROLE: e.g. INSTANCE PROFILE>"
          ]
        },
        "Action": "sts:AssumeRole",
        "Condition": {}
      }
    ]
  }
  ```

  - `4.cross_account_install.tfvars` 코드를 다음과 같이 수정

  ```sh
  shared_account = {
    region = "<REGION>"
  }

  target_account = {
    region          = "<REGION>"
    assume_role_arn = "arn:aws:iam::<TARGET ACCOUNT>:role/<ASSUME ROLE NAME>"
  }
  ```

- 배포

```sh
# init
terraform init

# Create Workspace (option)
terraform workspace new dev

# Change Workspace (option)
terraform workspace select dev

# Check installation plan (option)
terraform plan -var-file=examples/4.cross_account_install.tfvars

# Install
terraform apply -var-file=examples/4.cross_account_install.tfvars --auto-approve
```

- 배포 결과 확인

```sh
# 'terraform.tfstate'가 생성 된 것을 확인 할 수 있다.
ls -al

...
-rw-r--r-- 1 mzc mzc 19575 Mar 24 14:34 terraform.tfstate
...
```

- 삭제

```sh
# Destroy
terraform destroy -var-file=examples/4.cross_account_install.tfvars --auto-approve
```

### IaC에서 지원하지 않는 Helm value properties를 추가하여 설치

tfvars 다음을 추가한 후, `terraform plan 또는 terraform apply`을 실행

- tfvars 수정

```bash
# helm chart의 value.yaml에 있는 key를 추가할 수 있다.
# 예제에서는 chart의 image repository를 변경하여 배포한다.
... 중략 ...

  sets = [
    {
      key   = "global.imageRegistry"
      value = "<ACCOUNT>.dkr.ecr.<REGION>.amazonaws.com"
    },
    {
      key   = "grafana.image.repository"
      value = "<ACCOUNT>.dkr.ecr.<REGION>.amazonaws.com/grafana/grafana"
    },
    {
      key   = "grafana.downloadDashboardsImage.image.repository"
      value = "<ACCOUNT>.dkr.ecr.<REGION>.amazonaws.com/curlimages/curl"
    },
    {
      key   = "grafana.initChownData.image.repository"
      value = "<ACCOUNT>.dkr.ecr.<REGION>.amazonaws.com/busybox"
    },
    {
      key   = "grafana.sidecar.image.repository"
      value = "<ACCOUNT>.dkr.ecr.<REGION>.amazonaws.com/kiwigrid/k8s-sidecar"
    }
  ]
... 후략 ...
```

- 배포

```sh
# Init
terraform init

# Check installation plan (option)
terraform plan -var-file=examples/5.override_helm_values.tfvars

# Install
terraform apply -var-file=examples/5.override_helm_values.tfvars --auto-approve
```

- 삭제

```sh
# Destroy
terraform destroy -var-file=examples/5.override_helm_values.tfvars --auto-approve
```
