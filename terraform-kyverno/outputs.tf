output "helm_release_kyverno" {
  value = module.kyverno.helm_release
}

output "helm_release_policies" {
  value = module.policies.helm_release
}

output "helm_release_namespace" {
  value = module.kyverno.namespace
}
