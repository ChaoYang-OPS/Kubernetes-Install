resource "kubernetes_service" "terraform_service" {
  metadata {
    name = var.service_name
    namespace = var.namespace_name
  }
  spec {
    selector = {
      env = kubernetes_deployment.terraform_deployment.metadata.0.labels.env
      app = kubernetes_deployment.terraform_deployment.metadata.0.labels.app
      manager = kubernetes_deployment.terraform_deployment.metadata.0.labels.manager
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 8080
    }

    type = "ClusterIP"
  }
}