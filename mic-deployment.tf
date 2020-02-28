resource "kubernetes_deployment" "mic" {
  metadata {
    name      = "mic"
    namespace = "default"
    labels = {
      component = "mic"
      k8s-app   = "aad-pod-id"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        component = "mic"
        app       = "mic"
      }
    }

    template {
      metadata {
        labels = {
          component = "mic"
          app       = "mic"
        }
      }


      spec {
        service_account_name = kubernetes_service_account.aad-pod-id-mic-service-account.metadata.0.name
        automount_service_account_token = true
        container {
          name              = "mic"
          image             = "mcr.microsoft.com/k8s/aad-pod-identity/mic:1.5.5"
          image_pull_policy = "Always"
          args = [
            "--cloudconfig=/etc/kubernetes/azure.json",
            "--logtostderr"
          ]
          resources {
            limits {
              cpu    = "200m"
              memory = "512Mi"
            }
            requests {
              cpu    = "100m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = 8080
            }

            initial_delay_seconds = 10
            period_seconds        = 5
          }

          volume_mount {
            mount_path = "/etc/kubernetes/azure.json"
            name       = "k8s-azure-file"
            read_only  = true
          }
        }
        volume {
          name = "k8s-azure-file"
          host_path {
            path = "/etc/kubernetes/azure.json"
          }
        }

        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
      }
    }
  }
}
