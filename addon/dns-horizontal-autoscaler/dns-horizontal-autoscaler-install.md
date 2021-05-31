# install dns-horizontal-autoscaler


```shell
# install refence https://kubernetes.io/docs/tasks/administer-cluster/dns-horizontal-autoscaling/
# kubectl apply -f dns-horizontal-autoscaler.yaml
serviceaccount/kube-dns-autoscaler created
clusterrole.rbac.authorization.k8s.io/system:kube-dns-autoscaler created
clusterrolebinding.rbac.authorization.k8s.io/system:kube-dns-autoscaler created
deployment.apps/kube-dns-autoscaler created
# kubectl get pods -n kube-system | grep kube-dns-autoscaler
kube-dns-autoscaler-5df755dfb5-tvtgf      1/1     Running   0          2m17s
# kubectl logs  kube-dns-autoscaler-5df755dfb5-tvtgf -n kube-system
I0531 12:14:02.558316       1 autoscaler.go:49] Scaling Namespace: kube-system, Target: deployment/coredns
I0531 12:14:02.823526       1 plugin.go:50] Set control mode to linear
I0531 12:14:02.823565       1 linear_controller.go:60] ConfigMap version change (old:  new: 339086) - rebuilding params
I0531 12:14:02.823569       1 linear_controller.go:61] Params from apiserver: 
{"coresPerReplica":256,"includeUnschedulableNodes":true,"nodesPerReplica":16,"preventSinglePointFailure":true}
I0531 12:14:02.823638       1 linear_controller.go:80] Defaulting min replicas count to 1 for linear controller
```