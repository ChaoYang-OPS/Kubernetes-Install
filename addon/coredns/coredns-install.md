# intall coredns

```shell
# kubectl apply -f coredns.yaml
serviceaccount/coredns created
clusterrole.rbac.authorization.k8s.io/system:coredns created
clusterrolebinding.rbac.authorization.k8s.io/system:coredns created
configmap/coredns created
deployment.apps/coredns created
service/kube-dns created
# kubectl get pods -n kube-system | grep coredns
coredns-744ddcfcb5-5pmxc                  1/1     Running   0          39s

```