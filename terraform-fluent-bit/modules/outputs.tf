output "service_account" {
  value = {
    name       = var.helm_release.service_account.name
    role_arn   = aws_iam_role.this[0].arn
    policy_arn = values(aws_iam_role_policy_attachment.this)[*].policy_arn
  }
}

output "helm_release" {
  value = {
    name      = helm_release.fluent_bit.name
    version   = helm_release.fluent_bit.version
    namespace = helm_release.fluent_bit.namespace
    values    = helm_release.fluent_bit.values
  }
}
