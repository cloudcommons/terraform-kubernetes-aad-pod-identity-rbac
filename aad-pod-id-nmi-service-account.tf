resource "kubernetes_service_account" "aad-pod-id-nmi-service-account" {
  metadata {
    name      = "aad-pod-id-nmi-service-account"
    namespace = "default"
  }

  depends_on = [
    helm_release.aad-pod-identity-crds
  ]  
}