resource "kubernetes_service_account" "aad-pod-id-nmi-service-account" {
  metadata {
    name      = "aad-pod-id-nmi-service-account"
    namespace = "default"
  }
}