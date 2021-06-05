resource "kubernetes_deployment" "terraform_deployment" {
  metadata {
    name = var.deployment_name
    namespace = var.namespace_name
    labels = {
      env     = "DEV"
      app     = "python-demo"
      manager = "Terraform"
    }
  }

  spec {
    replicas = var.deployment_replicas

    selector {
      match_labels = {
        app     = "python-demo"
        env     = "DEV"
        manager = "Terraform"
      }
    }
    template {
      metadata {
        labels = {
          app     = "python-demo"
          env     = "DEV"
          manager = "Terraform"
        }
      }
      spec {
        container {
          image = var.image_family_name
          name  = var.container_name
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          liveness_probe {
            http_get {
              path = "/healthy"
              port = 8080
            }
          }

          readiness_probe {
            http_get {
              path = "/healthy"
              port = 8080
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}