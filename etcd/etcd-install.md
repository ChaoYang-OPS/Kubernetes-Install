## install etcd cluster

```
# 操作主机为ETCD主机 ，生成ETCD公钥私钥
root@172-16-100-61:~# mkdir /data/applications/ /opt/logs/etcd  -p
root@172-16-100-61:~#  wget https://github.com/etcd-io/etcd/releases/download/v3.4.12/etcd-v3.4.12-linux-amd64.tar.gz
root@172-16-100-61:~# tar -xf etcd-v3.4.12-linux-amd64.tar.gz -C /data/applications/
root@172-16-100-61:~# mv /data/applications/etcd-v3.4.12-linux-amd64/ /data/applications/etcd-v3.4.12  
root@172-16-100-61:~# mkdir -p /data/applications/etcd-v3.4.12/{certs,scripts,conf}
root@172-16-100-61:~# cd /data/applications/etcd-v3.4.12/certs/
# 注意: 生成私钥在安装cfss节点生成即可，其它ETCD节点复制即可
root@172-16-100-61:/data/applications/etcd-v3.4.12/certs# cat etcd-service-ca-csr.json
{
  "CN": "etcd",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "shanxi",
      "L": "shanxi",
      "O": "etcd",
      "OU": "Etcd Security"
    }
  ],
  "ca": {
    "expiry": "876000h"
  }
}
root@172-16-100-61:/data/applications/etcd-v3.4.12/certs# cat ca-config.json
{
    "signing": {
      "default": {
        "expiry": "876000h"
      },
      "profiles": {
        "kubernetes": {
          "usages": [
              "signing",
              "key encipherment",
              "server auth",
              "client auth"
          ],
          "expiry": "876000h"
        }
      }
    }
  }
# 生成ETCD CA
root@172-16-100-61:/data/applications/etcd-v3.4.12/certs# cfssl gencert -initca etcd-service-ca-csr.json | cfssljson -bare etcd-service-ca
2021/05/09 21:36:18 [INFO] generating a new CA key and certificate from CSR
2021/05/09 21:36:18 [INFO] generate received request
2021/05/09 21:36:18 [INFO] received CSR
2021/05/09 21:36:18 [INFO] generating key: rsa-2048
2021/05/09 21:36:18 [INFO] encoded CSR
2021/05/09 21:36:18 [INFO] signed certificate with serial number 362096364711412197369143116744659703426246256387
root@172-16-100-61:/data/applications/etcd-v3.4.12/certs# ls -l *.pem
-rw------- 1 root root 1679 May  9 21:36 etcd-service-ca-key.pem
-rw-r--r-- 1 root root 1314 May  9 21:36 etcd-service-ca.pem
root@172-16-100-61:/data/applications/etcd-v3.4.12/certs# cat etcd-service-csr.json 
{
    "CN": "k8s-etcd",
    "hosts": [
        "127.0.0.1",
        "172.16.100.61",
        "172.16.100.62",
        "172.16.100.63",
        "172.16.100.64",
        "172.16.100.65",
        "172.16.100.66",
        "172.16.100.67",
        "172.16.100.99"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "ST": "shanxi",
            "L": "shanxi",
            "O": "sre",
            "OU": "ops"
        }
    ]
}
root@172-16-100-61:/data/applications/etcd-v3.4.12/certs# cfssl gencert -ca=etcd-service-ca.pem -ca-key=etcd-service-ca-key.pem -profile=ca-config.json etcd-service-csr.json | cfssljson -bare etcd-server-keys
2021/05/09 21:53:58 [INFO] generate received request
2021/05/09 21:53:58 [INFO] received CSR
2021/05/09 21:53:58 [INFO] generating key: rsa-2048
2021/05/09 21:53:58 [INFO] encoded CSR
2021/05/09 21:53:58 [INFO] signed certificate with serial number 644493687145643529850271900560014166583443964871
root@172-16-100-61:/data/applications/etcd-v3.4.12/certs# ls -l etcd-server-keys*.pem
-rw------- 1 root root 1679 May  9 21:56 etcd-server-keys-key.pem
-rw-r--r-- 1 root root 1472 May  9 21:56 etcd-server-keys.pem
```
---
**安装ETCD SERVER**
```
root@172-16-100-61:~# ln -sv /data/applications/etcd-v3.4.12/ /data/applications/etcd-service
'/data/applications/etcd-service' -> '/data/applications/etcd-v3.4.12/'
root@172-16-100-61:~# useradd -u 1800 -s /sbin/nologin etcd
# 创建数据存储目录
root@172-16-100-61:~# mkdir /data/applications/data/etcd-data -p
root@172-16-100-61:~# chown etcd.etcd /data/applications/data/etcd-data/ /opt/logs/etcd/ /data/applications/etcd-v3.4.12/ -R
# 生成服务启动脚本
root@172-16-100-61:/data/applications/etcd-service/scripts# cat etcd-service.sh 
#!/bin/sh
../etcd --config-file=/data/applications/etcd-service/conf/etcd-config.yaml
root@172-16-100-61:/data/applications/etcd-service/scripts# sh -x etcd-service.sh 
root@172-16-100-61:/data/applications/etcd-service/scripts# chmod +x etcd-service.sh 
2021-05-10 07:18:27.026307 C | etcdmain: cannot access data directory: directory "/data/applications/data/etcd-data","drwxr-xr-x" exist without desired file permission "-rwx------".
# 解决方法
root@172-16-100-61:/data/applications/etcd-service/scripts# chmod 700 /data/applications/data/etcd-data/ -R
root@172-16-100-61:~# chown etcd.etcd /data/applications/data/etcd-data/ -R
```

root@172-16-100-61:~# supervisorctl update
etcd-service: added process group
**启动失败日志**
```
2021-05-10 07:28:12.142193 C | etcdserver: create snapshot directory error: mkdir /data/applications/data/etcd-data/member/snap: permission denied
```
**root@172-16-100-61:~# chown etcd.etcd /data/applications/data/etcd-data/ -R**

```
# 再次启动服务
root@172-16-100-61:~# supervisorctl start etcd-service
etcd-service: started
# 配置ETCD各节点时间同步
root@172-16-100-61:~# crontab -l | tail -1
*/5 * * * * /usr/sbin/ntpdate ntp1.aliyun.com &>/tmp/ntpdate.log
```

**其它节点，复制已经安装好的节点，同时修改配置文件，即可**

#### 以下是第二台安装ETCD详细操作步骤,参考上面步骤
```
root@172-16-100-62:~# mkdir /data/applications/ /opt/logs/etcd /data/applications/data/etcd-data  -p
root@172-16-100-62:~# chmod 700 /data/applications/data/etcd-data/ -R
root@172-16-100-62:~# useradd -u 1800 -s /sbin/nologin etcd
root@172-16-100-62:~# cd /data/applications/ 
root@172-16-100-62:/data/applications# scp -r 172.16.100.61:/data/applications/etcd-v3.4.12 .
root@172-16-100-62:~# chown etcd.etcd /data/applications/data/etcd-data/ /opt/logs/etcd /data/applications/etcd-v3.4.12 -R
# 修改配置文件
root@172-16-100-62:~# vim /data/applications/etcd-v3.4.12/conf/etcd-config.yaml
name: 'etcd-service-02'
listen-peer-urls: 'https://172.16.100.62:2380'
listen-client-urls: 'https://172.16.100.62:2379,http://127.0.0.1:2379'
initial-advertise-peer-urls: 'https://172.16.100.62:2380'
advertise-client-urls: 'https://172.16.100.62:2379'
root@172-16-100-62:~# ln -sv /data/applications/etcd-v3.4.12/ /data/applications/etcd-service
'/data/applications/etcd-service' -> '/data/applications/etcd-v3.4.12/'
root@172-16-100-62:~# scp 172.16.100.61:/etc/supervisor/conf.d/etcd-service-supervisor.conf /etc/supervisor/conf.d
root@172-16-100-62:~# supervisorctl update
etcd-service: added process group
root@172-16-100-62:~# supervisorctl status
etcd-service                     RUNNING   pid 6799, uptime 0:01:47
# 验证集群
root@172-16-100-61:~# tail /opt/logs/etcd/etcd-service_info.log
2021-05-10 08:11:27.924592 I | rafthttp: peer 6b96bd567559dbc2 became active
2021-05-10 08:11:27.924904 I | rafthttp: established a TCP streaming connection with peer 6b96bd567559dbc2 (stream MsgApp v2 reader)
2021-05-10 08:11:27.925063 I | rafthttp: established a TCP streaming connection with peer 6b96bd567559dbc2 (stream Message reader)
2021-05-10 08:11:27.927692 I | rafthttp: established a TCP streaming connection with peer 6b96bd567559dbc2 (stream MsgApp v2 writer)
2021-05-10 08:11:27.930921 I | rafthttp: established a TCP streaming connection with peer 6b96bd567559dbc2 (stream Message writer)
2021-05-10 08:11:31.531507 N | etcdserver/membership: updated the cluster version from 3.0 to 3.4
2021-05-10 08:11:31.531572 I | etcdserver/api: enabled capabilities for version 3.4

root@172-16-100-61:~# /data/applications/etcd-service/etcdctl --endpoints="172.16.100.61:2379,172.16.100.62:2379,172.16.100.63:2379" --cacert=/data/applications/etcd-service/certs/etcd-service-ca.pem --cert=/data/applications/etcd-service/certs/etcd-server-keys.pem --key=/data/applications/etcd-service/certs/etcd-server-keys-key.pem endpoint status --write-out=table
+--------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|      ENDPOINT      |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+--------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| 172.16.100.61:2379 | 4c1e0bff90e40bd9 |  3.4.12 |   20 kB |     false |      false |       205 |         35 |                 35 |        |
| 172.16.100.62:2379 | b82045b2109952d8 |  3.4.12 |   20 kB |      true |      false |       205 |         35 |                 35 |        |
| 172.16.100.63:2379 | 6b96bd567559dbc2 |  3.4.12 |   20 kB |     false |      false |       205 |         35 |                 35 |        |
+--------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
# 此时ETCD集群已经安装完成,生产环境建议与kubernetes集群分开，独立部署，并部署五节点！！！
```

