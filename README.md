二进制安装Kubernetes 1.19.10

CHANGELOG: https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.19.md
# 操作系统关键信息
```
Distributor ID: Debian
Description:    Debian GNU/Linux 10 (buster)
Release:        10
Codename:       buster
内核版本: 4.19.0-13-amd64
Kubernetes version: 1.19.10
etcd version: 3.4.12
下载软件包地址: https://dl.k8s.io/v1.19.10/kubernetes-server-linux-amd64.tar.gz
service_ip: 10.99.0.0/12
```
__环境说明__

| 主机名             | IP    | 组件 | 角色      | 配置   | Description                                                                              |
| ---------------- | ----------- | ----------- | ------------ | ------- | ---------------------------------------------------------------------------------------- |
| 172-16-100-61             | 172.16.100.61   | kube-apiserver,kube-controller-manager,kube-scheduler,etcd,VIP    |    控制平面         |    2核2G     | Master and HA.                                            | 控制平面
| 172-16-100-62             | 172.16.100.62  | kube-apiserver,kube-controller-manager,kube-scheduler,etcd,VIP    |      控制平面        | 2核2G | Master and HA.                                                                    |
| 172-16-100-63          | 172.16.100.63  | kube-apiserver,kube-controller-manager,kube-scheduler,VIP    | 控制平面            | 2核2G | Master and HA.                                                   |
| 172-16-100-64           | 172.16.100.64   | docker,kubelet,kube-proxy    | 数据平面 |   2核2G     | data plan Work node                                   |
| 172-16-100-65    | 172.16.100.65  | docker,kubelet,kube-proxy    | 数据平面         | 2核2G | data plan Work node  
| 172-16-100-65    | 172.16.100.69  | VIP    | LB         |  | VIP                                                       |