# install redis service

```shell
# kubectl apply -f devops-redis-configmap.yaml
configmap/devops-redis-cm created
# 本地测试，固定到指定节点
# kubectl label node 172-16-100-62 redis-server=true
node/172-16-100-62 labeled
# kubectl apply -f devops-redis-deployment.yaml
deployment.apps/devops-redis-deployment created
# kubectl apply -f devops-redis-service.yaml
service/devops-redis-service created
# kubectl get pods -n devops | grep redis
devops-redis-deployment-5d8d6d49b9-4qmhd   1/1     Running   0          105s
# kubectl exec -it devops-redis-deployment-5d8d6d49b9-4qmhd /bin/bash -n devops
127.0.0.1:6379> auth devops
OK
127.0.0.1:6379> ping
PONG
```