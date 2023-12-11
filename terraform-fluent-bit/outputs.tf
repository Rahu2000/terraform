output "service_account" {
  value = module.fluent_bit.service_account
}

output "helm_release" {
  value = module.fluent_bit.helm_release
}
