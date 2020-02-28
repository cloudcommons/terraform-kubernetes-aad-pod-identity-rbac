resource "kubernetes_cluster_role" "aad-pod-id-nmi-role" {
  metadata {
    name = "aad-pod-id-nmi-role"
  }

  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get"]
  }

  rule {
    api_groups = ["aadpodidentity.k8s.io"]
    resources  = ["azureidentitybindings", "azureidentities", "azurepodidentityexceptions"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["aadpodidentity.k8s.io"]
    resources  = ["azureassignedidentities"]
    verbs      = ["get", "list", "watch"]
  }

  depends_on = [
    helm_release.aad-pod-identity-crds
  ]
}
