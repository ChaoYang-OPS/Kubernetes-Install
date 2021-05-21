# + instal controller-manager
```shell
# 控制平面安装controller-manager服务
# mkdir /opt/logs/kubernetes/kube-controller-manager-service
# cat /data/applications/kubernetes-v1.19.10/server/scripts/kube-controller-manager-service.sh
#!/bin/bash
../bin/kube-controller-manager \
      --v=2 \
      --logtostderr=true \
      --address=127.0.0.1 \
      --root-ca-file=../certs/kubernetes-ca.pem \
      --cluster-signing-cert-file=../certs/kubernetes-ca.pem \
      --cluster-signing-key-file=../certs/kubernetes-ca-key.pem \
      --service-account-private-key-file=../certs/kubernetes-ca-key.pem \
      --kubeconfig=../conf/kube-controller-manager.kubeconfig \
      --log-dir=/opt/logs/kubernetes/kube-controller-manager-service \
      --leader-elect=true \
      --use-service-account-credentials=true \
      --node-monitor-grace-period=40s \
      --node-monitor-period=5s \
      --pod-eviction-timeout=2m0s \
      --controllers=*,bootstrapsigner,tokencleaner \
      --allocate-node-cidrs=true \
      --cluster-cidr=10.244.0.0/16 \
      --requestheader-client-ca-file=../certs/front-proxy-ca.pem \
      --node-cidr-mask-size=24
# chmod +x /data/applications/kubernetes/server/scripts/kube-controller-manager-service.sh
# 生成supervisor文件
# cat /etc/supervisor/conf.d/kube-controller-manager-service.conf 
[program:kube-controller-manager-service]
command=/data/applications/kubernetes/server/scripts/kube-controller-manager-service.sh
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
stdout_logfile=/opt/logs/kubernetes/kube-controller-manager-service/kube-controller-manager-service_info.log        ; stderr log path, NONE for none; default AUTO
stdout_logfile_maxbytes=64MB                                    ; max # logfile bytes b4 rotation (default 50MB)
stdout_logfile_backups=4                                        ; # of stdout logfile backups (default 10)
stdout_capture_maxbytes=1MB                                     ; number of bytes in 'capturemode' (default 0)
stdout_events_enabled=false                                     ; emit events on stdout writes (default false)
killasgroup=true
stopasgroup=true
~# supervisorctl update
kube-controller-manager-service: added process group
# supervisorctl status kube-controller-manager-service
kube-controller-manager-service   RUNNING   pid 16147, uptime 0:00:52
```