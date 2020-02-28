resource "kubernetes_daemonset" "nmi" {
  metadata {
    name      = "nmi"
    namespace = "default"
    labels = {
      component = "nmi"
      tier      = "node"
      k8s-app   = "aad-pod-id"
    }
  }

  spec {
    strategy {
      type = "RollingUpdate"
    }
    selector {
      match_labels = {
        component = "nmi"
        tier      = "node"
      }
    }

    template {
      metadata {
        labels = {
          component = "nmi"
          tier      = "node"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.aad-pod-id-nmi-service-account.metadata.0.name
        host_network         = "true"
        volume {
          name = "iptableslock"
          host_path {
            path = "/run/xtables.lock"
            type = "FileOrCreate"
          }
        }
        automount_service_account_token = true
        container {
          name            = "nmi"
          image           = "mcr.microsoft.com/k8s/aad-pod-identity/nmi:1.5.5"
          image_pull_policy = "Always"
          args = [
            "--host-ip=$(HOST_IP)",
            "--node=$(NODE_NAME)"
          ]

          env {
            name = "HOST_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }
          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

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

          security_context {
            privileged = true
            capabilities {
              add = ["NET_ADMIN"]
            }
          }

          volume_mount {
            mount_path = "/run/xtables.lock"
            name      = "iptableslock"
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = 8080
            }

            initial_delay_seconds = 10
            period_seconds        = 5
          }
        }
        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
      }
    }
  }
}
