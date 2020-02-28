resource "kubernetes_cluster_role_binding" "aad-pod-id-mic-binding" {
  metadata {
    name = "aad-pod-id-mic-binding"
    labels = {
        k8s-app = "aad-pod-id-mic-binding"
    }    
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.aad-pod-id-mic-role.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.aad-pod-id-mic-service-account.metadata.0.name
    namespace = "default"
  }
}