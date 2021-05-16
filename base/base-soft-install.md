**install cfssl**
https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl_1.5.0_linux_amd64
https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssljson_1.5.0_linux_amd64
https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl-certinfo_1.5.0_linux_amd64
```
# 选择一台机器安装即可,这里使用172-16-100-61
~# wget https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl_1.5.0_linux_amd64 -O /usr/local/bin/cfssl
~# chmod +x /usr/local/bin/cfssl
~# cfssl version
Version: 1.5.0
Runtime: go1.12.12
~# wget https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssljson_1.5.0_linux_amd64 -O /usr/local/bin/cfssljson && chmod +x /usr/local/bin/cfssljson
~# cfssljson  -version
Version: 1.5.0
Runtime: go1.12.12
~# wget https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl-certinfo_1.5.0_linux_amd64 -O /usr/local/bin/cfssl-certinfo  && chmod +x /usr/local/bin/cfssl-certinfo
~# cfssl-certinfo
Must specify certinfo target through -cert, -csr, -domain or -serial + -aki
```
***install core soft in all node***
```
~# apt-get install ntpdate vim git psmisc lvm2 jq supervisor -y
~# apt-get install ipvsadm ipset sysstat conntrack  libseccomp2 -y
~# tar -xf kubernetes-server-linux-amd64.tar.gz -C /data/applications/
~# mv /data/applications/kubernetes/ /data/applications/kubernetes-v1.19.10
~# rm -rf /data/applications/kubernetes-v1.19.10/addons/ /data/applications/kubernetes-v1.19.10/LICENSES
~# rm -rf /data/applications/kubernetes-v1.19.10/kubernetes-src.tar.gz 
~# rm -rf /data/applications/kubernetes-v1.19.10/server/bin/*_tag
~# rm -rf /data/applications/kubernetes-v1.19.10/server/bin/*.tar
# ls -l /data/applications/kubernetes-v1.19.10/server/bin/
-rwxr-xr-x 1 root root  46764032 Apr 15 11:42 apiextensions-apiserver
-rwxr-xr-x 1 root root  43859968 Apr 15 11:42 kube-aggregator
-rwxr-xr-x 1 root root 115273728 Apr 15 11:42 kube-apiserver
-rwxr-xr-x 1 root root 107241472 Apr 15 11:42 kube-controller-manager
-rwxr-xr-x 1 root root  38748160 Apr 15 11:42 kube-proxy
-rwxr-xr-x 1 root root  42930176 Apr 15 11:42 kube-scheduler
-rwxr-xr-x 1 root root  39055360 Apr 15 11:42 kubeadm
-rwxr-xr-x 1 root root  42946560 Apr 15 11:42 kubectl
-rwxr-xr-x 1 root root 110019784 Apr 15 11:42 kubelet
-rwxr-xr-x 1 root root   1634304 Apr 15 11:42 mounter
~# mkdir /data/applications/kubernetes-v1.19.10/server/{scripts,conf,certs}
~# ln -sv /data/applications/kubernetes-v1.19.10/ /data/applications/kubernetes          
'/data/applications/kubernetes' -> '/data/applications/kubernetes-v1.19.10/'
# 内核4.18以下nf_conntrack_ipv4，内核高于4.18 nf_conntrack
# cat /etc/modules-load.d/ipvs.conf
ip_vs
ip_vs_lc
ip_vs_wlc
ip_vs_rr
ip_vs_wrr
ip_vs_lblc
ip_vs_lblcr
ip_vs_dh
ip_vs_sh
ip_vs_fo
ip_vs_nq
ip_vs_sed
ip_vs_ftp
ip_vs_sh
nf_conntrack
ip_tables
ip_set
xt_set
ipt_set
ipt_rpfilter
ipt_REJECT
ipip
~# systemctl enable --now systemd-modules-load.service
~# systemctl restart systemd-modules-load.service
#  lsmod | grep --color=auto -e ip_vs -e nf_conntrack
ip_vs_ftp              16384  0
nf_nat                 36864  1 ip_vs_ftp
ip_vs_sed              16384  0
ip_vs_nq               16384  0
ip_vs_fo               16384  0
ip_vs_sh               16384  0
ip_vs_dh               16384  0
ip_vs_lblcr            16384  0
ip_vs_lblc             16384  0
ip_vs_wrr              16384  0
ip_vs_rr               16384  0
ip_vs_wlc              16384  0
ip_vs_lc               16384  0
ip_vs                 172032  24 ip_vs_wlc,ip_vs_rr,ip_vs_dh,ip_vs_lblcr,ip_vs_sh,ip_vs_fo,ip_vs_nq,ip_vs_lblc,ip_vs_wrr,ip_vs_lc,ip_vs_sedip_vs_ftp
nf_conntrack          172032  2 nf_nat,ip_vs
nf_defrag_ipv6         20480  2 nf_conntrack,ip_vs
nf_defrag_ipv4         16384  1 nf_conntrack
libcrc32c              16384  4 nf_conntrack,nf_nat,xfs,ip_vs
# 配置内核参数
cat <<EOF > /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
fs.may_detach_mounts = 1
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_watches=89100
fs.file-max=52706963
fs.nr_open=52706963
net.netfilter.nf_conntrack_max=2310720
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl =15
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_max_orphans = 327680
net.ipv4.tcp_orphan_retries = 3
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.ip_conntrack_max = 65536
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_timestamps = 0
net.core.somaxconn = 16384
EOF
# cat /etc/sysctl.d/k8s.conf 
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
fs.may_detach_mounts = 1
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_watches=89100
fs.file-max=52706963
fs.nr_open=52706963
net.netfilter.nf_conntrack_max=2310720
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl =15
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_max_orphans = 327680
net.ipv4.tcp_orphan_retries = 3
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.ip_conntrack_max = 65536
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_timestamps = 0
net.core.somaxconn = 16384
# sysctl --system
* Applying /etc/sysctl.d/99-sysctl.conf ...
* Applying /etc/sysctl.d/k8s.conf ...
net.ipv4.ip_forward = 1
vm.overcommit_memory = 1
vm.panic_on_oom = 0
fs.inotify.max_user_watches = 89100
fs.file-max = 52706963
fs.nr_open = 52706963
net.netfilter.nf_conntrack_max = 2310720
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_max_orphans = 327680
net.ipv4.tcp_orphan_retries = 3
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_timestamps = 0
net.core.somaxconn = 16384
* Applying /etc/sysctl.d/protect-links.conf ...
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
* Applying /etc/sysctl.conf ...
```