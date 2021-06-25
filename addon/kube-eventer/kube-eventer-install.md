# install kube-eventer

```shell
# https://github.com/AliyunContainerService/kube-eventer
# 需要修改Token dingtalk:https://oapi.dingtalk.com/robot/send?access_token=xxxx
# kubectl apply -f .
deployment.apps/kube-eventer created
clusterrole.rbac.authorization.k8s.io/kube-eventer created
clusterrolebinding.rbac.authorization.k8s.io/kube-eventer created
serviceaccount/kube-eventer created
# kubectl get pods -n kube-system | grep kube-eventer
kube-eventer-7ddb56c85f-4d8fv             1/1     Running   0          23s
kube-eventer-7ddb56c85f-64cdw             1/1     Running   0          93s

```

```yaml
# 钉钉收到message
OPS-K8S
Level:Warning 
Kind:Pod 
Namespace:default 
Name:deployment-oss-75fd7fc66f-tbxgw.168bdab7c394a05b 
Reason:Failed 
Timestamp:2021-06-25 22:50:10 
Message:Error: ImagePullBackOff

OPS-K8S
Level:Warning 
Kind:Pod 
Namespace:default 
Name:deployment-oss-75fd7fc66f-tbxgw.168bdab7c394a05b 
Reason:Failed 
Timestamp:2021-06-25 22:49:58 
Message:Failed to pull image "registry.cn-chengdu.aliyuncs.com/ops-k8s/demo-python-app:v4": rpc error: code = Unknown desc = Error response from daemon: manifest for registry.cn-chengdu.aliyuncs.com/ops-k8s/demo-python-app:v4 not found: manifest unknown: manifest unknown
```