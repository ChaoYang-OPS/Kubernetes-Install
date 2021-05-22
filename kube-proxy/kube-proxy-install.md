# data plan install kube-proxy

```shell
# 控制节点执行以下步骤
# kubectl -n kube-system create serviceaccount kube-proxy
serviceaccount/kube-proxy created
 kubectl create clusterrolebinding system:kube-proxy         --clusterrole system:node-proxier         --serviceaccount kube-system:kube-proxy
#  kubectl create clusterrolebinding system:kube-proxy         --clusterrole system:node-proxier         --serviceaccount kube-system:kube-proxy
clusterrolebinding.rbac.authorization.k8s.io/system:kube-proxy created
# kubectl -n kube-system get sa/kube-proxy -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2021-05-22T12:33:49Z"
  name: kube-proxy
  namespace: kube-system
  resourceVersion: "149293"
  selfLink: /api/v1/namespaces/kube-system/serviceaccounts/kube-proxy
  uid: 744e2647-220f-423a-9a12-e29ce7191957
secrets:
- name: kube-proxy-token-jxg5c
# kubectl -n kube-system get secret/kube-proxy-token-jxg5c  --output=jsonpath='{.data.token}'
# KUBE_PROXY_TOKEN=`kubectl -n kube-system get secret/kube-proxy-token-jxg5c  --output=jsonpath='{.data.token}' | base64 -d`


kubectl config set-cluster kubernetes     --certificate-authority=kubernetes-ca.pem     --embed-certs=true     --server=https://172.16.100.69:8443     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
# kubectl config set-cluster kubernetes     --certificate-authority=kubernetes-ca.pem     --embed-certs=true     --server=https://172.16.100.69:8443     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
Cluster "kubernetes" set.
kubectl config set-credentials kubernetes     --token=${KUBE_PROXY_TOKEN}     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
# kubectl config set-credentials kubernetes     --token=${KUBE_PROXY_TOKEN}     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
User "kubernetes" set.
kubectl config set-context kubernetes     --cluster=kubernetes     --user=kubernetes     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
# kubectl config set-context kubernetes     --cluster=kubernetes     --user=kubernetes     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
Context "kubernetes" created.
# kubectl config use-context kubernetes     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
Switched to context "kubernetes".
# 复制文件kube-proxy.kubeconfig
# scp 172.16.100.61:/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig  /data/applications/kubernetes-v1.19.10/server/conf
# mkdir /opt/logs/kubernetes/kube-proxy-service  -p
```

```yaml
apiVersion: kubeproxy.config.k8s.io/v1alpha1
bindAddress: 0.0.0.0
clientConnection:
  acceptContentTypes: ""
  burst: 10
  contentType: application/vnd.kubernetes.protobuf
  kubeconfig: /data/applications/kubernetes/server/conf/kube-proxy.kubeconfig
  qps: 5
clusterCIDR: 10.244.0.0/16
configSyncPeriod: 15m0s
conntrack:
  max: null
  maxPerCore: 32768
  min: 131072
  tcpCloseWaitTimeout: 1h0m0s
  tcpEstablishedTimeout: 24h0m0s
enableProfiling: false
healthzBindAddress: 0.0.0.0:10256
hostnameOverride: ""
iptables:
  masqueradeAll: false
  masqueradeBit: 14
  minSyncPeriod: 0s
  syncPeriod: 30s
ipvs:
  masqueradeAll: true
  minSyncPeriod: 5s
  scheduler: "rr"
  syncPeriod: 30s
kind: KubeProxyConfiguration
metricsBindAddress: 127.0.0.1:10249
mode: "ipvs"
nodePortAddresses: null
oomScoreAdj: -999
portRange: ""
udpIdleTimeout: 250ms

```


```shell
# 控制节点执行以下步骤
# kubectl -n kube-system create serviceaccount kube-proxy
serviceaccount/kube-proxy created
 kubectl create clusterrolebinding system:kube-proxy         --clusterrole system:node-proxier         --serviceaccount kube-system:kube-proxy
#  kubectl create clusterrolebinding system:kube-proxy         --clusterrole system:node-proxier         --serviceaccount kube-system:kube-proxy
clusterrolebinding.rbac.authorization.k8s.io/system:kube-proxy created
# kubectl -n kube-system get sa/kube-proxy -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2021-05-22T12:33:49Z"
  name: kube-proxy
  namespace: kube-system
  resourceVersion: "149293"
  selfLink: /api/v1/namespaces/kube-system/serviceaccounts/kube-proxy
  uid: 744e2647-220f-423a-9a12-e29ce7191957
secrets:
- name: kube-proxy-token-jxg5c
# kubectl -n kube-system get secret/kube-proxy-token-jxg5c  --output=jsonpath='{.data.token}'
# KUBE_PROXY_TOKEN=`kubectl -n kube-system get secret/kube-proxy-token-jxg5c  --output=jsonpath='{.data.token}' | base64 -d`


kubectl config set-cluster kubernetes     --certificate-authority=kubernetes-ca.pem     --embed-certs=true     --server=https://172.16.100.69:8443     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
# kubectl config set-cluster kubernetes     --certificate-authority=kubernetes-ca.pem     --embed-certs=true     --server=https://172.16.100.69:8443     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
Cluster "kubernetes" set.
kubectl config set-credentials kubernetes     --token=${KUBE_PROXY_TOKEN}     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
# kubectl config set-credentials kubernetes     --token=${KUBE_PROXY_TOKEN}     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
User "kubernetes" set.
kubectl config set-context kubernetes     --cluster=kubernetes     --user=kubernetes     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
# kubectl config set-context kubernetes     --cluster=kubernetes     --user=kubernetes     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
Context "kubernetes" created.
# kubectl config use-context kubernetes     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-proxy.kubeconfig
Switched to context "kubernetes".
# cat /data/applications/kubernetes-v1.19.10/server/scripts/kube-proxy-service.sh
#!/bin/bash
../bin/kube-proxy  \
      --v=2 \
      --logtostderr=true \
      --log-dir=/opt/logs/kubernetes/kube-proxy-service \
      --config=../conf/kube-proxy-conf.yaml
# chmod +x /data/applications/kubernetes-v1.19.10/server/scripts/kube-proxy-service.sh
# cat /etc/supervisor/conf.d/kube-apiserver-service.conf 
[program:kube-proxy-service]
command=/data/applications/kubernetes/server/scripts/kube-proxy-service.sh 
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
stdout_logfile=/opt/logs/kubernetes/kube-proxy-service/kube-proxy-service_info.log        ; stderr log path, NONE for none; default AUTO
stdout_logfile_maxbytes=64MB                                    ; max # logfile bytes b4 rotation (default 50MB)
stdout_logfile_backups=4                                        ; # of stdout logfile backups (default 10)
stdout_capture_maxbytes=1MB                                     ; number of bytes in 'capturemode' (default 0)
stdout_events_enabled=false                                     ; emit events on stdout writes (default false)
killasgroup=true
stopasgroup=true
# supervisorctl update
kube-proxy-service: added process group
root@172-16-100-64:~# supervisorctl status kube-proxy-service 
kube-proxy-service               RUNNING   pid 56229, uptime 0:00:48
# 此时data-plan kube-proxy安装完成
```