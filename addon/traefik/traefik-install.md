# install traefik 2.4

**git地址: https://github.com/traefik/traefik**

```shell
# https://doc.traefik.io/traefik/user-guides/crd-acme/#services
# https://doc.traefik.io/traefik/reference/static-configuration/cli/
# https://doc.traefik.io/traefik/v2.2/routing/providers/kubernetes-ingress/

# kubectl get node --show-labels
NAME            STATUS   ROLES    AGE   VERSION    LABELS
172-16-100-61   Ready    <none>   12d   v1.19.10   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=172-16-100-61,kubernetes.io/os=linux,node.kubernetes.io/node=
172-16-100-62   Ready    <none>   12d   v1.19.10   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=172-16-100-62,kubernetes.io/os=linux,node.kubernetes.io/node=
172-16-100-63   Ready    <none>   12d   v1.19.10   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=172-16-100-63,kubernetes.io/os=linux,node.kubernetes.io/node=
# kubectl label nodes 172-16-100-61 traefik-ingress=true
node/172-16-100-61 labeled
# kubectl get node 172-16-100-61 --show-labels
NAME            STATUS   ROLES    AGE   VERSION    LABELS
172-16-100-61   Ready    <none>   12d   v1.19.10   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=172-16-100-61,kubernetes.io/os=linux,node.kubernetes.io/node=,traefik-ingress=true

# kubectl apply -f traefik-crd.yaml
Warning: apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
customresourcedefinition.apiextensions.k8s.io/ingressroutes.traefik.containo.us created
customresourcedefinition.apiextensions.k8s.io/middlewares.traefik.containo.us created
customresourcedefinition.apiextensions.k8s.io/ingressroutetcps.traefik.containo.us created
customresourcedefinition.apiextensions.k8s.io/ingressrouteudps.traefik.containo.us created
customresourcedefinition.apiextensions.k8s.io/tlsoptions.traefik.containo.us created
customresourcedefinition.apiextensions.k8s.io/tlsstores.traefik.containo.us created
customresourcedefinition.apiextensions.k8s.io/traefikservices.traefik.containo.us created
customresourcedefinition.apiextensions.k8s.io/serverstransports.traefik.containo.us created
# kubectl apply -f traefik-rbac.yaml
Warning: rbac.authorization.k8s.io/v1beta1 ClusterRole is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 ClusterRole
clusterrole.rbac.authorization.k8s.io/traefik-ingress-controller created
Warning: rbac.authorization.k8s.io/v1beta1 ClusterRoleBinding is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 ClusterRoleBinding
clusterrolebinding.rbac.authorization.k8s.io/traefik-ingress-controller created
serviceaccount/traefik-ingress-controller created
# kubectl apply -f traefik-demonset.yaml
service/traefik created
daemonset.apps/traefik-ingress-controller created
# kubectl get pods -n kube-system | grep traefik
traefik-ingress-controller-kfq25          1/1     Running   0          35s
# kubectl logs -f traefik-ingress-controller-kfq25   -n kube-system
time="2021-06-05T03:57:51Z" level=info msg="Configuration loaded from flags."
# curl http://172.16.100.61 -I
HTTP/1.1 404 Not Found
Content-Type: text/plain; charset=utf-8
X-Content-Type-Options: nosniff
Date: Sat, 05 Jun 2021 04:03:24 GMT
Content-Length: 19
# kubectl exec -it traefik-ingress-controller-kfq25   /bin/sh -n kube-system  # 查看日志
# cat /var/log/access.log
{"ClientAddr":"172.16.100.61:49880","ClientHost":"172.16.100.61","ClientPort":"49880","ClientUsername":"-","DownstreamContentSize":19,"DownstreamStatus":404,"Duration":204055,"Overhead":204055,"RequestAddr":"172.16.100.61","RequestContentSize":0,"RequestCount":1,"RequestHost":"172.16.100.61","RequestMethod":"GET","RequestPath":"/","RequestPort":"-","RequestProtocol":"HTTP/1.1","RequestScheme":"http","RetryAttempts":0,"StartLocal":"2021-06-05T04:03:22.742209746Z","StartUTC":"2021-06-05T04:03:22.742209746Z","level":"info","msg":"","time":"2021-06-05T04:03:22Z"}
{"ClientAddr":"172.16.100.61:49898","ClientHost":"172.16.100.61","ClientPort":"49898","ClientUsername":"-","DownstreamContentSize":19,"DownstreamStatus":404,"Duration":95821,"Overhead":95821,"RequestAddr":"172.16.100.61","RequestContentSize":0,"RequestCount":2,"RequestHost":"172.16.100.61","RequestMethod":"HEAD","RequestPath":"/","RequestPort":"-","RequestProtocol":"HTTP/1.1","RequestScheme":"http","RetryAttempts":0,"StartLocal":"2021-06-05T04:03:24.756554897Z","StartUTC":"2021-06-05T04:03:24.756554897Z","level":"info","msg":"","time":"2021-06-05T04:03:24Z"}
{"ClientAddr":"172.16.100.1:54118","ClientHost":"172.16.100.1","ClientPort":"54118","ClientUsername":"-","DownstreamContentSize":19,"DownstreamStatus":404,"Duration":102036,"Overhead":102036,"RequestAddr":"172.16.100.61","RequestContentSize":0,"RequestCount":3,"RequestHost":"172.16.100.61","RequestMethod":"GET","RequestPath":"/","RequestPort":"-","RequestProtocol":"HTTP/2.0","RequestScheme":"https","RetryAttempts":0,"StartLocal":"2021-06-05T04:06:31.454888748Z","StartUTC":"2021-06-05T04:06:31.454888748Z","level":"info","msg":"","time":"2021-06-05T04:06:31Z"}
```
# 配置路由

```shell
# kubectl apply -f treafik-dashboard.yaml
ingressroute.traefik.containo.us/traefik-dashboard-route created
# curl traefik.opsk8s.com/dashboard -I
HTTP/1.1 200 OK
Accept-Ranges: bytes
Content-Length: 3026
Content-Security-Policy: frame-src 'self' https://traefik.io https://*.traefik.io;
Content-Type: text/html; charset=utf-8
Date: Sat, 05 Jun 2021 04:19:31 GMT
Last-Modified: Tue, 23 Mar 2021 15:48:36 GMT
# 日志
{"ClientAddr":"172.16.100.1:54483","ClientHost":"172.16.100.1","ClientPort":"54483","ClientUsername":"-","DownstreamContentSize":452,"DownstreamStatus":200,"Duration":920832,"OriginContentSize":452,"OriginDuration":852748,"OriginStatus":200,"Overhead":68084,"RequestAddr":"traefik.opsk8s.com","RequestContentSize":0,"RequestCount":335,"RequestHost":"traefik.opsk8s.com","RequestMethod":"GET","RequestPath":"/api/overview","RequestPort":"-","RequestProtocol":"HTTP/1.1","RequestScheme":"http","RetryAttempts":0,"RouterName":"kube-system-traefik-dashboard-route-c9eb41cf8c3e448fcc6a@kubernetescrd","ServiceAddr":"10.244.33.180:8080","ServiceName":"kube-system-traefik-dashboard-route-c9eb41cf8c3e448fcc6a@kubernetescrd","ServiceURL":{"Scheme":"http","Opaque":"","User":null,"Host":"10.244.33.180:8080","Path":"","RawPath":"","ForceQuery":false,"RawQuery":"","Fragment":"","RawFragment":""},"StartLocal":"2021-06-05T04:21:11.48979838Z","StartUTC":"2021-06-05T04:21:11.48979838Z","entryPointName":"web","level":"info","msg":"","time":"2021-06-05T04:21:11Z"}
# 再添加一台traefik-ingress=true
# kubectl label nodes 172-16-100-62 traefik-ingress=true
node/172-16-100-62 labeled
# kubectl get pods -n kube-system | grep traefik
traefik-ingress-controller-7rrbn          1/1     Running   0          114s
traefik-ingress-controller-kfq25          1/1     Running   0          20m

```
