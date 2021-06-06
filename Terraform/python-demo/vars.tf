variable "deployment_name" {
  default = "terraform-python-demo"
}
variable "image_family_name" {
  default = "registry.cn-chengdu.aliyuncs.com/ops-k8s/demo-python-app:v3"
}
variable "container_name" {
  default = "terraform-python-demo"
}
variable "deployment_replicas" {
  type = number
  default = 1
}
variable "namespace_name"{
    default = "terraform"
}
variable "service_name"{
    default = "terraform-python-demo-service"
}
variable "ingress_name"{
    default = "terraform-python-demo-ingress"
}
variable "metadata_labels"{
    type = map(string)
    default = {
        env = "DEV"
        app = "python-demo"
        manager = "Terraform"
    }
}
variable "ingress_host_name"{
    type = string
    default = "demo-python.opsk8s.com"
}