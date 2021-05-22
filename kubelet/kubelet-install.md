# data plan install docker and kubelet

```shell
# 配置源
# cat /etc/apt/sources.list.d/docker.list 
deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/debian buster stable
# apt-get update
# apt-cache madison docker-ce | grep 19
# apt-get install docker-ce=5:19.03.9~3-0~debian-buster -y
# grep "LimitNOFILE" /lib/systemd/system/docker.service
LimitNOFILE=1048576
# sed -i "/ExecStart=/a\ExecStartPost=/usr/sbin/iptables -P FORWARD ACCEPT" /lib/systemd/system/docker.service
# systemctl daemon-reload
# cat /etc/docker/daemon.json 
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m",
        "max-file": "10"
    },
    "oom-score-adjust": -1000,
    "registry-mirrors": ["https://pqbap4ya.mirror.aliyuncs.com"],
    "storage-driver": "overlay2",
    "max-concurrent-downloads": 10,
    "max-concurrent-uploads": 5,
    "storage-opts":["overlay2.override_kernel_check=true"],
    "live-restore": true
}
# systemctl restart docker
# 复制bootstrap-kubelet.kubeconfig
# scp 172.16.100.61:/data/applications/kubernetes-v1.19.10/server/conf/bootstrap-kubelet.kubeconfig  /data/applications/kubernetes-v1.19.10/server/conf/
# scp 172.16.100.61:/data/applications/kubernetes-v1.19.10/server/certs/kubernetes-ca.pem   /data/applications/kubernetes-v1.19.10/server/certs
# mkdir /data/applications/kubernetes-v1.19.10/server/manifests
# mkdir /opt/logs/kubernetes/kube-kubelet-service -p
```

```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
address: 0.0.0.0
port: 10250
readOnlyPort: 10255
authentication:
  anonymous:
    enabled: false
  webhook:
    cacheTTL: 2m0s
    enabled: true
  x509:
    clientCAFile: /data/applications/kubernetes/server/certs/kubernetes-ca.pem
authorization:
  mode: Webhook
  webhook:
    cacheAuthorizedTTL: 5m0s
    cacheUnauthorizedTTL: 30s
cgroupDriver: systemd
cgroupsPerQOS: true
clusterDNS:
- 10.99.0.10
clusterDomain: cluster.local
containerLogMaxFiles: 5
containerLogMaxSize: 10Mi
contentType: application/vnd.kubernetes.protobuf
cpuCFSQuota: true
cpuManagerPolicy: none
cpuManagerReconcilePeriod: 10s
enableControllerAttachDetach: true
enableDebuggingHandlers: true
enforceNodeAllocatable:
- pods
eventBurst: 10
eventRecordQPS: 5
evictionHard:
  imagefs.available: 15%
  memory.available: 100Mi
  nodefs.available: 10%
  nodefs.inodesFree: 5%
evictionPressureTransitionPeriod: 5m0s
failSwapOn: true
fileCheckFrequency: 20s
hairpinMode: promiscuous-bridge
healthzBindAddress: 127.0.0.1
healthzPort: 10248
httpCheckFrequency: 20s
imageGCHighThresholdPercent: 85
imageGCLowThresholdPercent: 80
imageMinimumGCAge: 2m0s
iptablesDropBit: 15
iptablesMasqueradeBit: 14
kubeAPIBurst: 10
kubeAPIQPS: 5
makeIPTablesUtilChains: true
maxOpenFiles: 1000000
maxPods: 64
nodeStatusUpdateFrequency: 10s
oomScoreAdj: -999
podPidsLimit: -1
registryBurst: 10
registryPullQPS: 5
resolvConf: /etc/resolv.conf
rotateCertificates: true
runtimeRequestTimeout: 2m0s
serializeImagePulls: true
staticPodPath: /data/applications/kubernetes/server/manifests
streamingConnectionIdleTimeout: 4h0m0s
syncFrequency: 1m0s
volumeStatsAggPeriod: 1m0s

```



```shell
# cat /data/applications/kubernetes-v1.19.10/server/scripts/kube-kubelet-service.sh 
#!/bin/bash
../bin/kubelet \
      --v=2 \
      --logtostderr=true \
      --log-dir=/opt/logs/kubernetes/kube-kubelet-service \
      --kubeconfig=../conf/kube-kubelet-service.kubeconfig \
      --bootstrap-kubeconfig=../conf/bootstrap-kubelet.kubeconfig \
      --network-plugin=cni \
      --cni-conf-dir=/etc/cni/net.d \
      --cni-bin-dir=/opt/cni/bin \
      --config=../conf/kubelet-conf.yaml \
      --node-labels=node.kubernetes.io/node='' \
      --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1
# chmod +x /data/applications/kubernetes-v1.19.10/server/scripts/kube-kubelet-service.sh
# cat /etc/supervisor/conf.d/kube-kubelet-service.conf
[program:kube-kubelet-service]
command=/data/applications/kubernetes/server/scripts/kube-kubelet-service.sh
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
stdout_logfile=/opt/logs/kubernetes/kube-kubelet-service/kube-kubelet-service_info.log        ; stderr log path, NONE for none; default AUTO
stdout_logfile_maxbytes=64MB                                    ; max # logfile bytes b4 rotation (default 50MB)
stdout_logfile_backups=4                                        ; # of stdout logfile backups (default 10)
stdout_capture_maxbytes=1MB                                     ; number of bytes in 'capturemode' (default 0)
stdout_events_enabled=false                                     ; emit events on stdout writes (default false)
killasgroup=true
stopasgroup=true
# supervisorctl update
kube-kubelet-service: added process group
# supervisorctl status
kube-kubelet-service             RUNNING   pid 30022, uptime 0:00:21
# 主控节点查询
# kubectl get node
NAME            STATUS     ROLES    AGE   VERSION
172-16-100-64   NotReady   <none>   40s   v1.19.10
```
