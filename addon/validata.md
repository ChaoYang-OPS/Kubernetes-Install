```yaml
cat<<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  namespace: default
spec:
  containers:
  - name: busybox
    image: busybox:1.28
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
  restartPolicy: Always
EOF

```
```shell
# kubectl exec  busybox -n default -- nslookup kubernetes
Server:    10.99.0.10
Address 1: 10.99.0.10 kube-dns.kube-system.svc.cluster.local

Name:      kubernetes
Address 1: 10.99.0.1 kubernetes.default.svc.cluster.local
# kubectl create deploy demo-python --image=registry.cn-chengdu.aliyuncs.com/ops-k8s/demo-python-app:v1 --replicas=3
deployment.apps/demo-python created
# kubectl get pods -o wide
NAME                           READY   STATUS    RESTARTS   AGE   IP               NODE            NOMINATED NODE   READINESS GATES
demo-python-68b7b8ffcd-2bx4t   1/1     Running   0          40s   10.244.69.68     172-16-100-61   <none>           <none>
demo-python-68b7b8ffcd-rlnwv   1/1     Running   0          40s   10.244.33.132    172-16-100-62   <none>           <none>
demo-python-68b7b8ffcd-tvl4b   1/1     Running   0          40s   10.244.236.196   172-16-100-63   <none>           <none>
# curl 10.244.69.68:8080
{"code": 200, "status": "ok", "host_name": "demo-python-68b7b8ffcd-2bx4t", "access_time": "2021-05-23 10:08:59.738796"}
```