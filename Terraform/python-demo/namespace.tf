resource "kubernetes_namespace" "terraform_namespace" {
  metadata {
    annotations = {
    }

    labels = var.metadata_labels
    name = var.namespace_name
  }
}