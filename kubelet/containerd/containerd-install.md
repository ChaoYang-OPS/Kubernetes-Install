# install containerd 

```shell
# refer: https://kubernetes.io/zh/docs/setup/production-environment/container-runtimes/#containerd
# work node stop service
root@172-16-100-63:~# supervisorctl stop kube-kubelet-service
kube-kubelet-service: stopped
root@172-16-100-63:~# systemctl stop docker
root@172-16-100-63:~# systemctl disable docker
root@172-16-100-63:~# systemctl stop containerd
root@172-16-100-63:~# iptables -t nat -F 
# create containerd config dir
root@172-16-100-63:~# mkdir -p /etc/containerd 
root@172-16-100-63:~# containerd config default | tee /etc/containerd/config.toml
version = 2
root = "/var/lib/containerd"
state = "/run/containerd"
plugin_dir = ""
disabled_plugins = []
required_plugins = []
oom_score = 0

[grpc]
  address = "/run/containerd/containerd.sock"
  tcp_address = ""
  tcp_tls_cert = ""
  tcp_tls_key = ""
  uid = 0
  gid = 0
  max_recv_message_size = 16777216
  max_send_message_size = 16777216

[ttrpc]
  address = ""
  uid = 0
  gid = 0

[debug]
  address = ""
  uid = 0
  gid = 0
  level = ""

[metrics]
  address = ""
  grpc_histogram = false

[cgroup]
  path = ""

[timeouts]
  "io.containerd.timeout.shim.cleanup" = "5s"
  "io.containerd.timeout.shim.load" = "5s"
  "io.containerd.timeout.shim.shutdown" = "3s"
  "io.containerd.timeout.task.state" = "2s"

[plugins]
  [plugins."io.containerd.gc.v1.scheduler"]
    pause_threshold = 0.02
    deletion_threshold = 0
    mutation_threshold = 100
    schedule_delay = "0s"
    startup_delay = "100ms"
  [plugins."io.containerd.grpc.v1.cri"]
    disable_tcp_service = true
    stream_server_address = "127.0.0.1"
    stream_server_port = "0"
    stream_idle_timeout = "4h0m0s"
    enable_selinux = false
    selinux_category_range = 1024
    sandbox_image = "k8s.gcr.io/pause:3.2"
    stats_collect_period = 10
    systemd_cgroup = false
    enable_tls_streaming = false
    max_container_log_line_size = 16384
    disable_cgroup = false
    disable_apparmor = false
    restrict_oom_score_adj = false
    max_concurrent_downloads = 3
    disable_proc_mount = false
    unset_seccomp_profile = ""
    tolerate_missing_hugetlb_controller = true
    disable_hugetlb_controller = true
    ignore_image_defined_volumes = false
    [plugins."io.containerd.grpc.v1.cri".containerd]
      snapshotter = "overlayfs"
      default_runtime_name = "runc"
      no_pivot = false
      disable_snapshot_annotations = true
      discard_unpacked_layers = false
      [plugins."io.containerd.grpc.v1.cri".containerd.default_runtime]
        runtime_type = ""
        runtime_engine = ""
        runtime_root = ""
        privileged_without_host_devices = false
        base_runtime_spec = ""
      [plugins."io.containerd.grpc.v1.cri".containerd.untrusted_workload_runtime]
        runtime_type = ""
        runtime_engine = ""
        runtime_root = ""
        privileged_without_host_devices = false
        base_runtime_spec = ""
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"
          runtime_engine = ""
          runtime_root = ""
          privileged_without_host_devices = false
          base_runtime_spec = ""
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    [plugins."io.containerd.grpc.v1.cri".cni]
      bin_dir = "/opt/cni/bin"
      conf_dir = "/etc/cni/net.d"
      max_conf_num = 1
      conf_template = ""
    [plugins."io.containerd.grpc.v1.cri".registry]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
          endpoint = ["https://registry-1.docker.io"]
    [plugins."io.containerd.grpc.v1.cri".image_decryption]
      key_model = ""
    [plugins."io.containerd.grpc.v1.cri".x509_key_pair_streaming]
      tls_cert_file = ""
      tls_key_file = ""
  [plugins."io.containerd.internal.v1.opt"]
    path = "/opt/containerd"
  [plugins."io.containerd.internal.v1.restart"]
    interval = "10s"
  [plugins."io.containerd.metadata.v1.bolt"]
    content_sharing_policy = "shared"
  [plugins."io.containerd.monitor.v1.cgroups"]
    no_prometheus = false
  [plugins."io.containerd.runtime.v1.linux"]
    shim = "containerd-shim"
    runtime = "runc"
    runtime_root = ""
    no_shim = false
    shim_debug = false
  [plugins."io.containerd.runtime.v2.task"]
    platforms = ["linux/amd64"]
  [plugins."io.containerd.service.v1.diff-service"]
    default = ["walking"]
  [plugins."io.containerd.snapshotter.v1.devmapper"]
    root_path = ""
    pool_name = ""
    base_image_size = ""
    async_remove = false
# modify default configuration
root@172-16-100-63:~# sed -i 's#k8s.gcr.io/#registry.aliyuncs.com/google_containers/#g' /etc/containerd/config.toml
root@172-16-100-63:~# sed -i s#'SystemdCgroup = false'#'SystemdCgroup = true'#g /etc/containerd/config.toml
# Edit kubelet config and add extra args
Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --container-runtime-endpoint=unix:///run/containerd/containerd.sock --pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.5"

# modify scripts file
root@172-16-100-63:~# cat /data/applications/kubernetes/server/scripts/kube-kubelet-service.sh
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
      --container-runtime=remote \
      --container-runtime-endpoint=unix:///run/containerd/containerd.sock \
      --node-labels=node.kubernetes.io/node='' \
      --tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 \
      --image-pull-progress-deadline=30m \
      --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1
root@172-16-100-63:~# systemctl restart containerd

# client
cat <<EOF | tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
EOF
root@172-16-100-63:~# cat  /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock

#  work node install  crictl client 
root@172-16-100-63:~# wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.23.0/crictl-v1.23.0-linux-amd64.tar.gz
2022-02-03 18:14:12 (107 KB/s) - 'crictl-v1.23.0-linux-amd64.tar.gz' saved [18510359/18510359]
root@172-16-100-63:~# tar -xf crictl-v1.23.0-linux-amd64.tar.gz -C /usr/local/bin/
root@172-16-100-63:~# chmod +x /usr/local/bin/crictl 
root@172-16-100-63:~# crictl ps
CONTAINER           IMAGE               CREATED             STATE               NAME                   ATTEMPT             POD ID
3839ce6ea7728       c2103589e99f9       10 minutes ago      Running             oss-driver-registrar   0                   67b75b4d974bd
root@172-16-100-63:~# crictl images
IMAGE                                                             TAG                 IMAGE ID            SIZE
registry.aliyuncs.com/google_containers/pause                     3.2                 80d28bedfe5de       300kB
registry.cn-hangzhou.aliyuncs.com/acs/csi-node-driver-registrar   v1.2.0              c2103589e99f9       7.68MB
root@172-16-100-63:~# supervisorctl start kube-kubelet-service 
kube-kubelet-service: started
# all worknode change containerd
root@172-16-100-62:~# kubectl describe node 172-16-100-63 | grep -A 10 "System Info"
System Info:
  Machine ID:                 f8a22bcfe9704542afe54b9304cdaa34
  System UUID:                fae64d56-463a-7544-f4e4-1edad7ec71a1
  Boot ID:                    380429c0-f342-4612-b5fb-42081f578153
  Kernel Version:             4.19.0-13-amd64
  OS Image:                   Debian GNU/Linux 10 (buster)
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  containerd://1.4.4
  Kubelet Version:            v1.19.10
  Kube-Proxy Version:         v1.19.10
```