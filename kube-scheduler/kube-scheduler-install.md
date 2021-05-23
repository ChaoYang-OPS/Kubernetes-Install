# + contro plan install kube-scheduler

```shell
# mkdir /opt/logs/kubernetes/kube-scheduler-service -p
# cat /data/applications/kubernetes-v1.19.10/server/scripts/kube-scheduler-service.sh
#!/bin/bash
../bin/kube-scheduler \
      --v=2 \
      --logtostderr=true \
      --address=127.0.0.1 \
      --leader-elect=true \
      --log-dir=/opt/logs/kubernetes/kube-scheduler-service \
      --kubeconfig=../conf/kube-scheduler.kubeconfig
# chmod +x /data/applications/kubernetes-v1.19.10/server/scripts/kube-scheduler-service.sh
# cat /etc/supervisor/conf.d/kube-scheduler-service.conf
[program:kube-scheduler-service]
command=/data/applications/kubernetes/server/scripts/kube-scheduler-service.sh
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
stdout_logfile=/opt/logs/kubernetes/kube-scheduler-service/kube-scheduler-service_info.log        ; stderr log path, NONE for none; default AUTO
stdout_logfile_maxbytes=64MB                                    ; max # logfile bytes b4 rotation (default 50MB)
stdout_logfile_backups=4                                        ; # of stdout logfile backups (default 10)
stdout_capture_maxbytes=1MB                                     ; number of bytes in 'capturemode' (default 0)
stdout_events_enabled=false                                     ; emit events on stdout writes (default false)
killasgroup=true
stopasgroup=true
# supervisorctl update
kube-scheduler-service: added process group
# 创建目录
#  mkdir /root/.kube -p
# cp /data/applications/kubernetes-v1.19.10/server/conf/kubernetes-admin.kubeconfig /root/.kube/config
# ln -sv /data/applications/kubernetes/server/bin/kubectl /usr/local/bin/kubectl
# kubectl get cs
Warning: v1 ComponentStatus is deprecated in v1.19+
NAME                 STATUS    MESSAGE             ERROR
scheduler            Healthy   ok                  
controller-manager   Healthy   ok                  
etcd-2               Healthy   {"health":"true"}   
etcd-0               Healthy   {"health":"true"}   
etcd-1               Healthy   {"health":"true"}  
# 此时控制平面安装成功
```