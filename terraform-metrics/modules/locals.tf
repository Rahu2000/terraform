locals {
  values = templatefile("${path.module}/template/metrics-server-values.tpl", {
    replicas      = var.replica_count
    service_monitor_enabled = var.service_monitor_enabled
    defaultArgs   = var.default_args

    resources     = var.resources
    affinity      = var.affinity
    node_selector = var.node_selector
    tolerations   = var.tolerations

    # image_repository = "481230465846.dkr.ecr.ap-northeast-2.amazonaws.com/k8s.gcr.io/metrics-server/metrics-server"
    # image_repository = "k8s.gcr.io/metrics-server/metrics-server"
    # image_tag = "v0.6.2"
    # image_repository = var.image_repo
    # image_tag = var.image_tag 

  })
}

# locals {
#   # set eks variables from backend s3
# 	# eks_cluster_name      = var.eks_cluster_name      == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_name : var.eks_cluster_name
# 	# eks_endpoint_url      = var.eks_endpoint_url      == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_endpoint : var.eks_endpoint_url
# 	# eks_cluster_certificate_authority_data = var.eks_cluster_certificate_authority_data == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data : var.eks_cluster_certificate_authority_data
#   # eks_auth_token        = data.aws_eks_cluster_auth.cluster.token

#   eks_cluster_name            = data.terraform_remote_state.s3_eks[0].outputs.eks_cluster_name
#   endpoint_url                = data.terraform_remote_state.s3_eks[0].outputs.eks_cluster_endpoint
#   auth_token                  = data.aws_eks_cluster_auth.this.token
#   certificate_authority_data  = data.terraform_remote_state.s3_eks[0].outputs.eks_cluster_certificate_authority_data

#   common_tags = {
#     "project" = var.project
#     "env"     = var.env
#     "region"  = var.region
#     "managed" = "terraform"
#   }
# }