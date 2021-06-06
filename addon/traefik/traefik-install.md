# install traefik 2.4

**git地址: https://github.com/traefik/traefik**

```shell
# https://doc.traefik.io/traefik/user-guides/crd-acme/#services
# https://doc.traefik.io/traefik/reference/static-configuration/cli/
# https://doc.traefik.io/traefik/v2.2/routing/providers/kubernetes-ingress/
#  https://doc.traefik.io/traefik/operations/dashboard/

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

# 开启认证访问

```shell
# kubectl apply -f traefik-secure-demonset.yaml
service/traefik unchanged
daemonset.apps/traefik-ingress-controller configured
# apt-get install  apache2-utils -y
#  htpasswd -c users admin
New password: 123456
Re-type new password: 123456
Adding password for user admin
# kubectl create secret generic admin-traefik --from-file=users -n kube-system
secret/admin-traefik created
# https://doc.traefik.io/traefik/middlewares/basicauth/
# cat traefik-dashboard-basic-auth.yaml
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: traefik-dashboard-basic-auth
  namespace: kube-system
spec:
  basicAuth:
    secret: admin-traefik
# kubectl apply -f traefik-dashboard-basic-auth.yaml
middleware.traefik.containo.us/traefik-dashboard-basic-auth created
# cat traefik-dashboard-middleware.yaml
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: traefik-dashboard-middleware
  namespace: kube-system
spec:
  chain:
    middlewares:
    - name: traefik-dashboard-basic-auth
# kubectl apply -f traefik-dashboard-middleware.yaml
middleware.traefik.containo.us/traefik-dashboard-middleware created
# cat traefik-dashboard-ingress-route.yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: traefik-dashboard-ingress-route
  namespace: kube-system
spec:
  routes:
  - match: Host(`traefik.opsk8s.com`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))
    kind: Rule
    services:
    - name: api@internal
      kind: TraefikService
    middlewares:
      - name: traefik-dashboard-middleware
# kubectl apply -f traefik-dashboard-ingress-route.yaml
ingressroute.traefik.containo.us/traefik-dashboard-ingress-route created
# kubectl get secret -n kube-system | grep admin-traefik
admin-traefik                                    Opaque                                1      27m
# kubectl get IngressRoute,Middleware -n kube-system
NAME                                                               AGE
ingressroute.traefik.containo.us/traefik-dashboard-ingress-route   10m

NAME                                                          AGE
middleware.traefik.containo.us/traefik-dashboard-basic-auth   7m56s
middleware.traefik.containo.us/traefik-dashboard-middleware   8m17s
# 验证
# curl traefik.opsk8s.com/api/http/routers -I
HTTP/1.1 401 Unauthorized
Content-Type: text/plain
Www-Authenticate: Basic realm="traefik"
Date: Sun, 06 Jun 2021 14:15:32 GMT
Content-Length: 17
# curl -u admin:123456 traefik.opsk8s.com/api/http/routers
[{"entryPoints":["tcpep","web","websecure"],"middlewares":["kube-system-traefik-dashboard-middleware@kubernetescrd"],"service":"api@internal","rule":"Host(`traefik.opsk8s.com`) \u0026\u0026 (PathPrefix(`/api`) || PathPrefix(`/dashboard`))","status":"enabled","using":["tcpep","web","websecure"],"name":"kube-system-traefik-dashboard-ingress-route-4d832f59d314c75f16e8@kubernetescrd","provider":"kubernetescrd"},{"entryPoints":["traefik"],"service":"ping@internal","rule":"PathPrefix(`/ping`)","priority":2147483647,"status":"enabled","using":["traefik"],"name":"ping@internal","provider":"internal"},{"entryPoints":["traefik"],"service":"prometheus@internal","rule":"PathPrefix(`/metrics`)","priority":2147483647,"status":"enabled","using":["traefik"],"name":"prometheus@internal","provider":"internal"},{"entryPoints":["web"],"service":"terraform-terraform-python-demo-service-80","rule":"Host(`demo-python.opsk8s.com`) \u0026\u0026 PathPrefix(`/`)","status":"enabled","using":["web"],"name":"terraform-python-demo-ingress-terraform-demo-python-opsk8s-com@kubernetes","provider":"kubernetes"}]
```