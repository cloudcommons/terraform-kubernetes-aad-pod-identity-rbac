resource "kubernetes_service_account" "aad-pod-id-mic-service-account" {
  metadata {
    name      = "aad-pod-id-mic-service-account"
    namespace = "default"
  }

  depends_on = [
    helm_release.aad-pod-identity-crds
  ]  
}