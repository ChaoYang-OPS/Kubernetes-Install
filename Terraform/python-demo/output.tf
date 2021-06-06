output "deployment_name"{
    value = kubernetes_deployment.terraform_deployment.metadata[0].name
}
output "namespace_name"{
    value = kubernetes_namespace.terraform_namespace.metadata[0].name
}
output "service_name"{
    value = kubernetes_service.terraform_service.metadata[0].name
}
output "service_cluster_ip"{
    value = kubernetes_service.terraform_service.spec[0].cluster_ip
}
output "service_cluster_ip_port"{
    value = kubernetes_service.terraform_service.spec[0].port[0].port
}
output "ingress_host_name"{
    value = kubernetes_ingress.terraform_ingress.spec[0].rule[0].host
}
output "web_access_url"{
    value =  "http://${kubernetes_ingress.terraform_ingress.spec[0].rule[0].host}"
}