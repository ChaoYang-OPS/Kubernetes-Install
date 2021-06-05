# install python-demo

```shell
# terraform init
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/kubernetes versions matching ">= 2.0.0"...
- Installing hashicorp/kubernetes v2.3.1...
- Installed hashicorp/kubernetes v2.3.1 (self-signed, key ID 34365D9472D7468F)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

```shell
# terraform apply -auto-approve
kubernetes_namespace.terraform_namespace: Creating...
kubernetes_deployment.terraform_deployment: Creating...
kubernetes_namespace.terraform_namespace: Creation complete after 0s [id=terraform]
kubernetes_deployment.terraform_deployment: Creation complete after 8s [id=terraform/terraform-python-demo]
kubernetes_service.terraform_service: Creating...
kubernetes_service.terraform_service: Creation complete after 0s [id=terraform/terraform-python-demo-service]
kubernetes_ingress.terraform_ingress: Creating...
kubernetes_ingress.terraform_ingress: Creation complete after 0s [id=terraform/terraform-python-demo-ingress]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

deployment_name = "terraform-python-demo"
namespace_name = "terraform"
service_name = "terraform-python-demo-service"
# 验证服务
# kubectl get pods,svc,ingress,deployment -n terraform
Warning: extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
NAME                                        READY   STATUS    RESTARTS   AGE
pod/terraform-python-demo-c7864dc7b-6q8c5   1/1     Running   0          67s

NAME                                    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/terraform-python-demo-service   ClusterIP   10.99.194.91   <none>        80/TCP    60s

NAME                                               CLASS    HOSTS                    ADDRESS   PORTS   AGE
ingress.extensions/terraform-python-demo-ingress   <none>   demo-python.opsk8s.com             80      60s

NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/terraform-python-demo   1/1     1            1           67s
# curl demo-python.opsk8s.com -i
HTTP/1.1 200 OK
Content-Length: 128
Content-Type: text/html; charset=UTF-8
Date: Sat, 05 Jun 2021 11:36:54 GMT
Etag: "850f84b4dc4eafaf9ecdc3fd8de91106ec9374f3"
Server: TornadoServer/6.1
{"code": 200, "status": "ok", "access_time": "2021-06-05 11:36:54.149214", "request_id": "38dfbf52-99e4-4e1d-9728-e9fe7026ac99"}
```