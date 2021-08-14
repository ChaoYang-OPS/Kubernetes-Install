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
      --service-cluster-ip-range=10.99.0.0/16  \
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
      --service-account-private-key-file=../certs/service-account.key  \
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
# 静态加密
```shell
# refer: https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/
# head -c 32 /dev/urandom | base64
rbKljLKeL7f1CiGDUj+T0CnpB3kNDoYkotgLd8e8ysk=
# 控制面板需要加入以下配置
# cat /data/applications/kubernetes/server/conf/encryptionconfiguration.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - aescbc:
        keys:
        - name: key1
          secret: rbKljLKeL7f1CiGDUj+T0CnpB3kNDoYkotgLd8e8ysk=
    - identity: {}
# chmod 600 /data/applications/kubernetes/server/conf/encryptionconfiguration.yaml
# modify start scripts file
# /data/applications/kubernetes/server/scripts/kube-apiserver-service.sh
# grep "encryptionconfiguration.yaml" /data/applications/kubernetes/server/scripts/kube-apiserver-service.sh
      --encryption-provider-config=../conf/encryptionconfiguration.yaml \
# supervisorctl restart kube-apiserver-service
kube-apiserver-service: stopped
kube-apiserver-service: started
# Verifying that data is encrypted
# Create a new secret called secret1 in the default namespace:
# kubectl create secret generic secret1 -n default --from-literal=mykey=mydata
secret/secret1 created
# kubectl get secret secret1 -o jsonpath='{.data}'
{"mykey":"bXlkYXRh"}
# /data/applications/etcd-service/etcdctl --endpoints="172.16.100.61:2379,172.16.100.62:2379,172.16.100.63:2379" --cacert=/data/applications/etcd-service/certs/etcd-service-ca.pem --cert=/data/applications/etcd-service/certs/etcd-server-keys.pem --key=/data/applications/etcd-service/certs/etcd-server-keys-key.pem get /registry/secrets/default/secret1
/registry/secrets/default/secret1
k8s:enc:aescbc:v1:key1:5
# Ensure all secrets are encrypted
# kubectl get secrets --all-namespaces -o json | kubectl replace -f -
secret/default-token-cqxbc replaced
secret/secret1 replaced
secret/default-token-jbd7n replaced
secret/devops-mysql-secrets replaced
secret/default-token-kc4qg replaced
secret/default-token-pd2fx replaced
secret/admin-traefik replaced
secret/attachdetach-controller-token-75smq replaced
secret/bootstrap-signer-token-w47mt replaced
secret/bootstrap-token-c3c5c6 replaced
secret/calico-kube-controllers-token-zzj7q replaced
secret/calico-node-token-sb4mf replaced
secret/certificate-controller-token-zq8ll replaced
secret/clusterrole-aggregation-controller-token-j2zz2 replaced
secret/coredns-token-m85tz replaced
secret/cronjob-controller-token-gxgtw replaced
secret/csi-admin-token-qwtkj replaced
secret/daemon-set-controller-token-b66mz replaced
secret/default-token-gc82x replaced
secret/deployment-controller-token-ptvd8 replaced
secret/disruption-controller-token-2jlpq replaced
secret/endpoint-controller-token-fcng8 replaced
secret/endpointslice-controller-token-v6tcv replaced
secret/endpointslicemirroring-controller-token-zk2br replaced
secret/expand-controller-token-4ctqp replaced
secret/generic-garbage-collector-token-7xrk7 replaced
secret/horizontal-pod-autoscaler-token-cmdtj replaced
secret/job-controller-token-w9cj6 replaced
secret/kube-dns-autoscaler-token-k7sql replaced
secret/kube-eventer-token-hsrg5 replaced
secret/kube-proxy-token-qjk7m replaced
secret/metrics-server-token-n7rkb replaced
secret/namespace-controller-token-hgkkh replaced
secret/node-controller-token-h75nl replaced
secret/node-problem-detector-token-pn8qc replaced
secret/persistent-volume-binder-token-kz8q9 replaced
secret/pod-garbage-collector-token-7q8xt replaced
secret/pv-protection-controller-token-spfbm replaced
secret/pvc-protection-controller-token-hgd5w replaced
secret/replicaset-controller-token-pjqvs replaced
secret/replication-controller-token-hsljw replaced
secret/resourcequota-controller-token-lktgx replaced
secret/service-account-controller-token-jdgv4 replaced
secret/service-controller-token-pngtc replaced
secret/statefulset-controller-token-txmxj replaced
secret/super-user-token-bb8s5 replaced
secret/token-cleaner-token-hqn2h replaced
secret/traefik-dashboard-auth replaced
secret/traefik-ingress-controller-token-9ljt8 replaced
secret/ttl-controller-token-jjxf9 replaced
secret/default-token-x2wpc replaced
secret/kubernetes-dashboard-certs replaced
secret/kubernetes-dashboard-csrf replaced
secret/kubernetes-dashboard-key-holder replaced
secret/kubernetes-dashboard-token-6r89p replaced
secret/alertmanager-main replaced
secret/alertmanager-main-generated replaced
secret/alertmanager-main-tls-assets replaced
secret/alertmanager-main-token-5gtlq replaced
secret/default-token-b5m2w replaced
secret/grafana-datasources replaced
secret/grafana-token-tcnsd replaced
secret/kube-state-metrics-token-wt4c2 replaced
secret/node-exporter-token-j97r4 replaced
secret/prometheus-adapter-token-5gdtt replaced
secret/prometheus-k8s replaced
secret/prometheus-k8s-tls-assets replaced
secret/prometheus-k8s-token-7npcz replaced
secret/prometheus-operator-token-69qx9 replaced
secret/default-token-g8l2g replaced
secret/default-candidate-registry-secret replaced
secret/default-token-42fm9 replaced
secret/default-token-hktkc replaced
```
