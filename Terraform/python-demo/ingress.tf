resource "kubernetes_ingress" "terraform_ingress" {
  metadata {
    name = var.ingress_name
    namespace = var.namespace_name
    annotations = {
      "traefik.ingress.kubernetes.io/router.entrypoints" = "web"
    }
  }
  spec {
    rule {
      host = "demo-python.opsk8s.com"
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.terraform_service.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}