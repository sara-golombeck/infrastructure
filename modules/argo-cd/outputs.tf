output "argocd_namespace" {
  value = helm_release.argocd.namespace
}

output "argocd_version" {
  value = helm_release.argocd.version
}