output "deployment_name"{
    value = kubernetes_deployment.terraform_deployment.metadata[0].name
}
output "namespace_name"{
    value = kubernetes_namespace.terraform_namespace.metadata[0].name
}
output "service_name"{
    value = kubernetes_service.terraform_service.metadata[0].name
}