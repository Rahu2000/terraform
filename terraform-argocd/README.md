# argocd
Argo CD is a declarative, GitOps continuous delivery tool for kubernetes.

- [argo helm chart](https://github.com/argoproj/argo-helm)
- [redis-ha subchart](https://github.com/DandyDeveloper/charts)


# Install / Uninstall

## Installing the chart

```
# env/an2_dev.hcl: s3 backend configuration file
terraform init -backend-config=env/an2_dev.hcl

# Create workspaces for each environment (DEV,STG,PROD)
terraform workspace new DEV

# env/an2_dev.tfvars: configuration file
terraform plan -var-file=env/an2_dev.tfvars

terraform apply -var-file=env/an2_dev.tfvars -auto-approve
```

## Uninstalling the Chart

```
terraform destroy -var-file=env/an2_dev.tfvars -auto-approve
```

## change admin password after install

```
# admin 초기 비밀번호 확인
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
Z1a2tV04Btsx5uPp

# argocd cli를 이용하여 admin 로그인
$ argocd login ARGOCD_SERVER_ENDPOINT
Username: admin
Password:
'admin:login' logged in successfully
Context 'ARGOCD_SERVER_ENDPOINT' updated

# admin 비밀번호 변경
$ argocd account update-password
*** Enter password of currently logged in user (admin):
*** Enter new password for user admin:
*** Confirm new password for user admin:
Password updated
Context 'ARGOCD_SERVER_ENDPOINT' updated

```

# Configuration

|파라미터|타입|기본값|설명|
|--------|--------|--------|--------|
|project|string|""|프로젝트 코드명|
|region|string|""|리전명|
|abbr_region|string|""|리전명 약어|
|env|string|""|프로비전 구성 환경 </br>(예시: dev, stg, qa, prod, ...)|
|org|string|""|조직명|
|backend_s3_bucket_name|string|""|terraform s3버킷명|
|eks_s3_key|string|""|eks backend에 대한 s3 키파일|
|eks_cluster_name|string|""|EKS클러스터명<br/>* eks_s3_key 설정시 자동 설정됨|
|helm_release_name|string|""|helm release명|
|helm_chart_name|string|""|helm 차트명|
|helm_chart_version|string|""|helm 차트버전|
|helm_repository_url|string|""|helm repository url|
|create_namespace|bool|true|namespace 생성여부|
|namespace|string|""|namespace명|
|controller_values|object|{}|contorller 설정(helm value파일 참고)|
|dex_values|object|{}|dex 설정(helm value파일 참고)|
|redis_values|object|{}|redis 설정(helm value파일 참고)|
|redis_ha_values|object|{}|redis-ha 설정(helm value파일 참고)|
|server_values|object|{}|server 설정(helm value파일 참고)|
|repoServer_values|object|{}|repoServer 설정(helm value파일 참고)|
|configs_values|object|{}|configs 설정(helm value파일 참고)|
|applicationset_values|object|{}|applicationSet 설정(helm value파일 참고)|
|notifications_values|object|{}|notifications 설정(helm value파일 참고)|
|global_values|object|{}|global 설정(helm value파일 참고)|
|shared_account|object|{}|배포를 위한 공용 account 설정|
|target_account|object|{}|배포 타겟 account 설정|
|
