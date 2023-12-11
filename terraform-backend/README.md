# Terraform S3 Backend 구성

## Prerequisites

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [github tokens](https://github.com/settings/tokens)
- S3 backend를 구성 할 경우 반드시 별도의 S3 버킷을 생성한 후 `backend.hcl`에 등록한다. 설정 예제는 [다음](env/prod_backend.hcl)을 참고한다.

## Git clone

```sh
git clone https://github.com/psa-terraform/s3-backend.git
cd s3-backend
```

## Terraform init

### 1. 본 모듈에 대한 s3 backend 구성하지 않을 경우

- versions.tf 파일수정

```txt
terraform {
  ...

  # uncomment if you use s3 for backend
  # backend s3 {}         # 주석을 설정한다.
}
```

- `Terraform init`

```sh
terraform init
```

### 2. 본 모듈에 대한 s3 backend 구성할 경우 (사전에 생성한 S3 bucket 필요)

- versions.tf 파일 수정

```txt
terraform {
  ...

  # uncomment if you use s3 for backend
  backend s3 {}         # 주석을 해제한다.
}
```

- XXX.hcl 파일 수정

```text
bucket = "<S3_BUCKET_NAME>"
key    = "<S3_BUCKET_OBJECTS_NAME>"
region = "<AWS_REGION>"
```

[설정 항목 상세](#backend-configuration)

- `Terraform init`

```sh
terraform init -backend-config=<path/to/hcl file>

# e.g.
terraform init -backend-config=env/dev_backend.hcl
```

## Terraform plan

테라폼 변수 또는 변수 설정 파일을 이용해 plan 실행

### 1. 본 모듈에 대해서 사전에 구성한 S3 bucket에 s3 backend 구성할 경우

- tfvars 설정

  - Terraform Backend s3 버킷을 신규 생성할 경우

  ```sh
  ...
  create_s3_bucket = true

  s3_bucket_name = "<S3_BUCKET_NAME>"   # 신규 생성할 S3 Bucket 이름, hcl의 설정한 S3 bucket name과 달라야 한다.
  ...
  ```

  - Terraform Backend s3 버킷을 기존 버킷으로 설정할 경우

  ```sh
  ...
  create_s3_bucket = false

  s3_bucket_name = "<S3_BUCKET_NAME>"   # 사전에 생성한 S3 bucket 이름 (hcl에 설정한 bucket)
  ...
  ```

- `Terraform plan`

```sh
terraform plan -var-file=<path/to/tfvar file>

# e.g.
terraform plan -var-file=env/dev.tfvars
```

### 2. 본 모듈에 대해서 S3 bucket을 신규 생성하여 s3 backend 구성할 경우

이 경우, backend는 local 또는 terraform cloud로 구성한다.

- tfvars 설정

```sh
...
create_s3_bucket = true                          # S3 bucket 신규 생성 안함

s3_bucket_name = "demo-common-terraform-state"    # 신규 생성할 S3 bucket 이름
...
```

- `Terraform plan`

```sh
terraform plan -var-file=<path/to/tfvar file>

# e.g.
terraform plan -var-file=env/dev.tfvars
```

## Terraform apply

```shell
terraform apply -var-file=env/dev.tfvars -auto-approve
```

### Terraform state 확인

- backend 설정이 local의 경우

```sh
ls -al *tfstate*
```

```txt
-rwxrwxrwx 1 mzc mzc  156 Apr  5 13:34 terraform.tfstate
-rwxrwxrwx 1 mzc mzc 7850 Apr  5 13:34 terraform.tfstate.backup
```

- backend 설정이 s3의 경우

```sh
terraform show
```

## Terraform destroy

```sh
terraform destroy -var-file=env/dev.tfvars -auto-approve
```

---

## Configuration

### Backend Configuration

| 파라미터 |  타입  | 설명                  | 비고                                     |
| -------- | :----: | --------------------- | ---------------------------------------- |
| bucket   | string | s3 bucket 이름        | S3 backend 구성 시 필수 항목             |
| key      | string | s3 객체 이름          | S3 backend 구성 시 필수 항목             |
| region   | string | aws 리전 이름         | S3 backend 구성 시 필수 항목             |
| encrypt  |  bool  | s3 bucket 암호화 여부 | s3 bucket에 암호화를 활성화 한 경우 필수 |

### Variable Configuration

| 파라미터                       |     타입     | 필수 구분 | 기본값 | 설명                                                            |
| ------------------------------ | :----------: | :-------: | ------ | --------------------------------------------------------------- |
| project                        |    string    |     O     | ""     | 프로젝트 코드명                                                 |
| env                            |    string    |     O     | ""     | 프로비전 구성 환경 </br>(예시: dev, stg, qa, prod, ...)         |
| region                         |    string    |     O     | ""     | 리전명                                                          |
| abbr_region                    |    string    |     O     | ""     | 리전 약명                                                       |
| org                            |    string    |     O     | ""     | 조직명                                                          |
| create_s3_bucket               |     bool     |     O     | true   | s3 bucket 생성여부                                              |
| s3_bucket_name                 |    string    |     X     | ""     | s3 bucket 이름                                                  |
| enable_encrypt                 |     bool     |     X     | false  | s3 bucket 서버 암호화 활성화 여부. 기본 암호화 알고리즘: AES256 |
| dynamo_tables                  | list(string) |     X     | []     | 테라폼 동시 실행 방지용 dynamo table 목록 (lock용)              |
| shared_account                 |     map      |     O     | {}     | 공용 account 또는 기본 account aws provider 정보                |
| shared_account.region          |    string    |     O     | ""     | 리전명                                                          |
| shared_account.profile         |    string    |     x     | ""     | aws config profile 명                                           |
| shared_account.assume_role_arn |    string    |     X     | ""     | assume_role arn                                                 |
| target_account                 |     map      |     O     | {}     | 설치 대상 account aws provider 정보                             |
| target_account.region          |    string    |     O     | ""     | 리전명                                                          |
| target_account.profile         |    string    |     X     | ""     | aws config profile 명                                           |
| target_account.assume_role_arn |    string    |     X     | ""     | assume_role arn                                                 |

#### S3 버킷 서버 암호화

`s3 버킷`의 서버 암호화가 활성 상태이고 terraform tfstate의 backend 유형이 `s3`이면, terraform backend 설정에 다음 값을 추가

e.g.

```yaml
bucket  = "demo-terraform-tfstat"
key     = "dev/eks.tfstat"
region  = "ap-northeast-2"
encrypt = true               # s3 backend의 암호화를 활성화 한 경우 추가
```

#### DynamoDB table

- `KEY` : Dynamo table 명

```JavaScript
dynamo_tables = [
  "KEY"
]
```

## History

- 23/02/22 private network 환경에 맞게 변경
- 23/02/23 cross account 환경에 맞게 변경
