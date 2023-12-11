output "service_account" {
  value = {
    name       = local.service_account_name
    role_arn   = aws_iam_role.this.arn
    policy_arn = aws_iam_policy.this.arn
  }
}

output "helm_release" {
  value = {
    name      = helm_release.aws_load_balancer_controller.name
    varsion   = helm_release.aws_load_balancer_controller.version
    namespace = helm_release.aws_load_balancer_controller.namespace
  }
}
