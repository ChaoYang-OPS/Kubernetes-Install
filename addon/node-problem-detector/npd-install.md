# install npd

```shell
# kubectl apply -f npd.yaml
serviceaccount/node-problem-detector created
clusterrolebinding.rbac.authorization.k8s.io/npd-binding created
daemonset.apps/npd-v0.8.5 created
# kubectl get pods -n kube-system | grep npd
npd-v0.8.5-6nnr7                          1/1     Running   0          84s
npd-v0.8.5-bl5hr                          1/1     Running   0          84s
npd-v0.8.5-dj247                          1/1     Running   0          84s
```