resource "kubernetes_namespace" "terraform_namespace" {
  metadata {
    annotations = {
    }

    labels = {
      env     = "DEV"
      app     = "python-demo"
      manager = "Terraform"
    }
    name = var.namespace_name
  }
}