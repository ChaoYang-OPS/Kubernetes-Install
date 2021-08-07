# install mysql with kubernetes

```shell
# https://www.serverlab.ca/tutorials/containers/kubernetes/how-to-deploy-mysql-server-5-7-to-kubernetes/
# echo -n "opsk8s123456" | base64
b3BzazhzMTIzNDU2

# cat mysql-secrts.yaml
apiVersion: v1
kind: Secret
metadata:
  name: devops-mysql-secrets
  namespace: devops
type: Opaque
data:
  ROOT_PASSWORD: b3BzazhzMTIzNDU2
# kubectl apply -f mysql-secrts.yaml
secret/devops-mysql-secrets created
# kubectl get secrets devops-mysql-secrets -n devops
NAME                   TYPE                                  DATA   AGE
devops-mysql-secrets   Opaque                                1      34s
# 以下操作属于测试环境,部署到work节点上, 172-16-100-61
# kubectl label node 172-16-100-61 mysql-server=true
node/172-16-100-61 labeled
# kubectl apply -f devops-mysql-deployment.yaml
deployment.apps/devops-mysql-deployment created
# kubectl apply -f devops-mysql-service.yaml
service/devops-mysql-service created
# kubectl get pods,svc -n devops
NAME                                           READY   STATUS    RESTARTS   AGE
pod/devops-mysql-deployment-7f86d88d68-59thv   1/1     Running   0          4m6s

NAME                           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/devops-mysql-service   ClusterIP   10.99.129.32   <none>        3306/TCP   8m52s
# ls -l /data/applications/data/mysql/
-rw-r----- 1 systemd-coredump systemd-coredump       56 Aug  7 10:30 auto.cnf
-rw------- 1 systemd-coredump systemd-coredump     1679 Aug  7 10:30 ca-key.pem
-rw-r--r-- 1 systemd-coredump systemd-coredump     1107 Aug  7 10:30 ca.pem
-rw-r--r-- 1 systemd-coredump systemd-coredump     1107 Aug  7 10:30 client-cert.pem
-rw------- 1 systemd-coredump systemd-coredump     1675 Aug  7 10:30 client-key.pem
-rw-r----- 1 systemd-coredump systemd-coredump     1335 Aug  7 10:30 ib_buffer_pool
-rw-r----- 1 systemd-coredump systemd-coredump 50331648 Aug  7 10:30 ib_logfile0
-rw-r----- 1 systemd-coredump systemd-coredump 50331648 Aug  7 10:30 ib_logfile1
-rw-r----- 1 systemd-coredump systemd-coredump 79691776 Aug  7 10:30 ibdata1
-rw-r----- 1 systemd-coredump systemd-coredump 12582912 Aug  7 10:30 ibtmp1
drwxr-x--- 2 systemd-coredump systemd-coredump     4096 Aug  7 10:30 mysql
drwxr-x--- 2 systemd-coredump systemd-coredump     8192 Aug  7 10:30 performance_schema
-rw------- 1 systemd-coredump systemd-coredump     1679 Aug  7 10:30 private_key.pem
-rw-r--r-- 1 systemd-coredump systemd-coredump      451 Aug  7 10:30 public_key.pem
-rw-r--r-- 1 systemd-coredump systemd-coredump     1107 Aug  7 10:30 server-cert.pem
-rw------- 1 systemd-coredump systemd-coredump     1679 Aug  7 10:30 server-key.pem
drwxr-x--- 2 systemd-coredump systemd-coredump     8192 Aug  7 10:30 sys
# kubectl exec -it devops-mysql-deployment-7f86d88d68-59thv -n devops /bin/bash
root@devops-mysql-deployment-7f86d88d68-59thv:/# mysql -uroot -p -h 127.0.0.1
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.7.21 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
mysql> grant all privileges on *.* to 'opsk8s'@'%' identified by 'opsk8s';
Query OK, 0 rows affected, 1 warning (0.00 sec)

```