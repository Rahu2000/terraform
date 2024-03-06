# 배포 기본 정보
project     = "demo"
region      = "ap-southeast-2"
abbr_region = "an2"
env         = "dev"
org         = "example"

# 설치 대상 클러스터
cluster_name = "demo-example-an2-dev-eks"

# 설치할 helm release 정보 설정
helm_release = {
  # helm release 이름 및 설치할 chart 버전. 생략시 최신 버전을 설치
  name          = "aws-load-balancer-controller"

  # Service Account 사용 설정
  service_account = {
    create = true
    name   = "alb-controller-sa"
  }
  # 클러스터의 vpc id
  vpc_id                  = "vpc-0246797feb4832a25"

  # 서비스 모니터 설정 여부. Prometheus가 사전에 구성되어 있어야 한다.
  service_monitor_enabled = false

  # Deployment 의 replica 수 설정
  replicas = 1

  # ALB를 위한 addon 활성화 여부
  enable_shield               = false
  enable_waf                  = false
  enable_wafv2                = false
}