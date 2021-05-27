# install dashboard

```shell
# release: https://github.com/kubernetes/dashboard/releases
# Reference: https://github.com/kubernetes/dashboard/releases/tag/v2.0.5
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.yaml
namespace/kubernetes-dashboard created
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
deployment.apps/dashboard-metrics-scraper created
# kubectl get pods,svc -n kubernetes-dashboard
NAME                                             READY   STATUS    RESTARTS   AGE
pod/dashboard-metrics-scraper-86b7f67444-mxmwh   1/1     Running   0          51s
pod/kubernetes-dashboard-b4755645c-j7sft         1/1     Running   0          51s

NAME                                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/dashboard-metrics-scraper   ClusterIP   10.99.36.120    <none>        8000/TCP   22m
service/kubernetes-dashboard        ClusterIP   10.99.152.206   <none>        443/TCP    22m
# kubectl apply -f user.yaml
serviceaccount/super-user created
clusterrolebinding.rbac.authorization.k8s.io/super-user created
# 获取超级用户权限
# kubectl describe secret `kubectl get secret -n kube-system | grep super-user | awk '{print $1}'` -n kube-system

```