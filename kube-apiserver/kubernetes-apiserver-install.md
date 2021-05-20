# 安装apiserver

```shell
# 控制面板
# mkdir /opt/logs/kubernetes -p  
# cd /data/applications/kubernetes-v1.19.10/server/scripts/
# 主控节点创建服务启动脚本
# cat /data/applications/kubernetes-v1.19.10/server/scripts/kube-apiserver-service.sh
# chmod +x /data/applications/kubernetes-v1.19.10/server/scripts/kube-apiserver-service.sh
#!/bin/bash
../bin/kube-apiserver \
      --v=2  \
      --logtostderr=true  \
      --allow-privileged=true  \
      --bind-address=0.0.0.0  \
      --secure-port=6443  \
      --insecure-port=0  \
      --advertise-address=172.16.100.61 \
      --service-cluster-ip-range=10.99.0.0/12  \
      --service-node-port-range=30000-32767  \
      --etcd-servers=https://172.16.100.61:2379,https://172.16.100.62:2379,https://172.16.100.63:2379 \
      --etcd-cafile=/data/applications/etcd-service/certs/etcd-service-ca.pem  \
      --etcd-certfile=/data/applications/etcd-service/certs/etcd-server-keys.pem \
      --etcd-keyfile=/data/applications/etcd-service/certs/etcd-server-keys-key.pem \
      --client-ca-file=../certs/kubernetes-ca.pem \
      --tls-cert-file=../certs/kube-apiserver.pem  \
      --tls-private-key-file=../certs/kube-apiserver-key.pem  \
      --kubelet-client-certificate=../certs/kube-apiserver.pem  \
      --kubelet-client-key=../certs/kube-apiserver-key.pem  \
      --service-account-key-file=../certs/kubernetes-ca-key.pem  \
      --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname  \
      --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,ResourceQuota  \
      --authorization-mode=Node,RBAC  \
      --enable-bootstrap-token-auth=true  \
      --log-dir=/opt/logs/kubernetes/kube-apiserver \
      --audit-log-mode=batch \
      --audit-log-maxbackup=10 \
      --audit-log-maxsize=100 \
      # --target-ram-mb=1024 \
      --requestheader-client-ca-file=../certs/front-proxy-ca.pem  \
      --proxy-client-cert-file=../certs/front-proxy-client.pem  \
      --proxy-client-key-file=../certs/front-proxy-client-key.pem  \
      --requestheader-allowed-names=aggregator  \
      --requestheader-group-headers=X-Remote-Group  \
      --requestheader-extra-headers-prefix=X-Remote-Extra-  \
      --requestheader-username-headers=X-Remote-User
      # --token-auth-file=/etc/kubernetes/token.csv
# 创建日志目录
# mkdir  /opt/logs/kubernetes/kube-apiserver-service -p
# cat /etc/supervisor/conf.d/kube-apiserver-service.conf 
[program:kube-apiserver-service]
command=/data/applications/kubernetes/server/scripts/kube-apiserver-service.sh 
numprocs=1                                                      ; number of processes copies to start (def 1)
directory=/data/applications/kubernetes/server/scripts
autostart=true                                                  ; start at supervisord start (default: true)
autorestart=true                                                ; retstart at unexpected quit (default: true)
startsecs=15                                                    ; number of secs prog must stay running (def. 1)
startretries=3                                                  ; max # of serial start failures (default 3)
exitcodes=0,2                                                   ; 'expected' exit codes for process (default 0,2)
stopsignal=QUIT                                                 ; signal used to kill process (default TERM)
stopwaitsecs=10                                                 ; max num secs to wait b4 SIGKILL (default 10)
user=root                                                       ; setuid to this UNIX account to run the program
redirect_stderr=true                                            ; redirect proc stderr to stdout (default false)
stdout_logfile=/opt/logs/kubernetes/kube-apiserver/kube-apiserver-service_info.log        ; stderr log path, NONE for none; default AUTO
stdout_logfile_maxbytes=64MB                                    ; max # logfile bytes b4 rotation (default 50MB)
stdout_logfile_backups=4                                        ; # of stdout logfile backups (default 10)
stdout_capture_maxbytes=1MB                                     ; number of bytes in 'capturemode' (default 0)
stdout_events_enabled=false                                     ; emit events on stdout writes (default false)
killasgroup=true
stopasgroup=true
# supervisorctl update
kube-apiserver-service: added process group
# supervisorctl status kube-apiserver-service 
kube-apiserver-service           RUNNING   pid 13201, uptime 0:02:30
# 此时控制节点apiserver安装完成，其它控制节点安装步骤类似

```