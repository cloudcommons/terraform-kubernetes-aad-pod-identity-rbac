resource "helm_release" "aad-pod-identity-crds" {
  name       = "aad-pod-id-rbac-crds"
  chart      = "${path.module}/charts/aad-pod-id-rbac"
}

