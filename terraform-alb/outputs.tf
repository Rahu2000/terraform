output "service_account" {
  value = module.aws_load_balancer_controller.service_account
}

output "helm_release" {
  value = module.aws_load_balancer_controller.helm_release
}
