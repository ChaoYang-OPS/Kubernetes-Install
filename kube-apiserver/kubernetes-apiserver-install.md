# 安装apiserver

```shell
# 控制面板
# mkdir /opt/logs/kubernetes -p  
# cd /data/applications/kubernetes-v1.19.10/server/scripts/
# 主控节点创建服务启动脚本
# cat /data/applications/kubernetes-v1.19.10/server/scripts/kube-apiserver-service.sh
# chmod +x /data/applications/kubernetes-v1.19.10/server/scripts/kube-apiserver-service.sh
# cat /data/applications/kubernetes-v1.19.10/server/scripts/kube-apiserver-service.sh
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
      --audit-policy-file=../conf/audit-policy.yaml \
      --audit-log-path=/opt/logs/kubernetes/kube-apiserver-service/kubernetes_audit_info.log \
      --audit-log-maxbackup=10 \
      --audit-log-maxage=30 \
      --audit-log-maxsize=100 \
      --requestheader-client-ca-file=../certs/front-proxy-ca.pem \
      --proxy-client-cert-file=../certs/front-proxy-client.pem \
      --proxy-client-key-file=../certs/front-proxy-client-key.pem \
      --requestheader-allowed-names=aggregator  \
      --requestheader-group-headers=X-Remote-Group  \
      --requestheader-extra-headers-prefix=X-Remote-Extra-  \
      --requestheader-username-headers=X-Remote-User
# 创建日志目录
# mkdir  /opt/logs/kubernetes/kube-apiserver-service  -p
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
stdout_logfile=/opt/logs/kubernetes/kube-apiserver-service/kube-apiserver-service_info.log        ; stderr log path, NONE for none; default AUTO
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

```yaml
# 生成审计策略文件
# cat /data/applications/kubernetes-v1.19.10/server/conf/audit-policy.yaml 
apiVersion: audit.k8s.io/v1  # This is required.
kind: Policy
# Don't generate audit events for all requests in RequestReceived stage.
omitStages:
  - "RequestReceived"
rules:
  # The following requests were manually identified as high-volume and low-risk,
  # so drop them.
  - level: None
    users: ["system:kube-proxy"]
    verbs: ["watch"]
    resources:
      - group: "" # core
        resources: ["endpoints", "services"]
  - level: None
    users: ["system:unsecured"]
    namespaces: ["kube-system"]
    verbs: ["get"]
    resources:
      - group: "" # core
        resources: ["configmaps"]
  - level: None
    users: ["kubelet"] # legacy kubelet identity
    verbs: ["get"]
    resources:
      - group: "" # core
        resources: ["nodes"]
  - level: None
    userGroups: ["system:nodes"]
    verbs: ["get"]
    resources:
      - group: "" # core
        resources: ["nodes"]
  - level: None
    users:
      - system:kube-controller-manager
      - system:kube-scheduler
      - system:serviceaccount:kube-system:endpoint-controller
    verbs: ["get", "update"]
    namespaces: ["kube-system"]
    resources:
      - group: "" # core
        resources: ["endpoints"]
  - level: None
    users: ["system:apiserver"]
    verbs: ["get"]
    resources:
      - group: "" # core
        resources: ["namespaces"]
  # Don't log these read-only URLs.
  - level: None
    nonResourceURLs:
      - /healthz*
      - /version
      - /swagger*
  # Don't log events requests.
  - level: None
    resources:
      - group: "" # core
        resources: ["events"]
  # Secrets, ConfigMaps, and TokenReviews can contain sensitive & binary data,
  # so only log at the Metadata level.
  - level: Metadata
    resources:
      - group: "" # core
        resources: ["secrets", "configmaps"]
      - group: authentication.k8s.io
        resources: ["tokenreviews"]
  # Get repsonses can be large; skip them.
  - level: Request
    verbs: ["get", "list", "watch"]
    resources:
      - group: "" # core
      - group: "admissionregistration.k8s.io"
      - group: "apps"
      - group: "authentication.k8s.io"
      - group: "authorization.k8s.io"
      - group: "autoscaling"
      - group: "batch"
      - group: "certificates.k8s.io"
      - group: "extensions"
      - group: "networking.k8s.io"
      - group: "policy"
      - group: "rbac.authorization.k8s.io"
      - group: "settings.k8s.io"
      - group: "storage.k8s.io"
  # Default level for known APIs
  - level: RequestResponse
    resources:
      - group: "" # core
      - group: "admissionregistration.k8s.io"
      - group: "apps"
      - group: "authentication.k8s.io"
      - group: "authorization.k8s.io"
      - group: "autoscaling"
      - group: "batch"
      - group: "certificates.k8s.io"
      - group: "extensions"
      - group: "networking.k8s.io"
      - group: "policy"
      - group: "rbac.authorization.k8s.io"
      - group: "settings.k8s.io"
      - group: "storage.k8s.io"
  # Default level for all other requests.
  - level: Metadata

```