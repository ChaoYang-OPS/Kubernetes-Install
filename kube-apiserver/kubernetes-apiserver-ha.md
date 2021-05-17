# 所有控制平台安装Haproxy与Keepalived,当然也可以通过Nginx来实现高可用，如果在云上，直接使用云上负载均衡即可

```
# apt-get install haproxy keepalived -y
# cp /etc/haproxy/haproxy.cfg{,.bak}
# 所有控制平面配置haproxy，配置一样
# cat /etc/haproxy/haproxy.cfg
global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        ulimit-n  16384
        daemon
        maxconn  2000

 
defaults
  log global
  mode  http
  option  httplog
  timeout connect 5000
  timeout client  50000
  timeout server  50000
  timeout http-request 15s
  timeout http-keep-alive 15s
 
frontend k8s-master
  bind 0.0.0.0:8443
  bind 127.0.0.1:8443
  mode tcp
  option tcplog
  tcp-request inspect-delay 5s
  default_backend k8s-master
 
backend k8s-master
  mode tcp
  option tcplog
  option tcp-check
  balance roundrobin
  default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100
  server k8s-master01    172.16.100.61:6443  check
  server k8s-master02    172.16.100.62:6443  check
  server k8s-master03    172.16.100.63:6443  check
# systemctl restart haproxy.service 
# netstat -lntp | grep haproxy
tcp        0      0 127.0.0.1:8443          0.0.0.0:*               LISTEN      11613/haproxy       
tcp        0      0 0.0.0.0:8443            0.0.0.0:*               LISTEN      11613/haproxy 
# 所有控制平面配置keepalived，配置不一样，注意区分IP与网卡名称
root@172-16-100-61:~# cat /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {
    router_id LVS_DEVEL
}
vrrp_script chk_apiserver {
    script "/etc/keepalived/check_apiserver_health.sh"
    interval 2
    weight -5
    fall 3  
    rise 2
}
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    mcast_src_ip 172.16.100.61
    virtual_router_id 51
    priority 100
    advert_int 2
    authentication {
        auth_type PASS
        auth_pass OPS_K8S
    }
    virtual_ipaddress {
         172.16.100.69
    }
    track_script {
      check_apiserver_health 
} }
root@172-16-100-62:~# cat /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {
    router_id LVS_DEVEL
}
vrrp_script chk_apiserver {
    script "/etc/keepalived/check_apiserver_health.sh"
    interval 2
    weight -5
    fall 3  
    rise 2
}
vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    mcast_src_ip 172.16.100.62
    virtual_router_id 51
    priority 90
    advert_int 2
    authentication {
        auth_type PASS
        auth_pass OPS_K8S
    }
    virtual_ipaddress {
         172.16.100.69
    }
    track_script {
      check_apiserver_health 
} }
root@172-16-100-63:~# cat /etc/keepalived/keepalived.conf 
! Configuration File for keepalived
global_defs {
    router_id LVS_DEVEL
}
vrrp_script chk_apiserver {
    script "/etc/keepalived/check_apiserver_health.sh"
    interval 2
    weight -5
    fall 3  
    rise 2
}
vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    mcast_src_ip 172.16.100.63
    virtual_router_id 51
    priority 90
    advert_int 2
    authentication {
        auth_type PASS
        auth_pass OPS_K8S
    }
    virtual_ipaddress {
         172.16.100.69
    }
    track_script {
      check_apiserver_health 
} }
# 控制平面配置服务检测脚本
# cat /etc/keepalived/check_apiserver_health.sh 
#!/bin/bash

err=0
for k in $(seq 1 5)
do
    check_code=$(curl -k -s https://127.0.0.1:6443/healthz)
    if [[ $check_code != "ok" ]]; then
        err=$(expr $err + 1)
        sleep 5
        continue
    else
        err=0
        break
    fi
done

if [[ $err != "0" ]]; then
    echo "systemctl stop keepalived"
    /usr/bin/systemctl stop keepalived
    exit 1
else
    exit 0
fi
# chmod +x /etc/keepalived/check_apiserver_health.sh
# systemctl enable haproxy && systemctl enable keepalived
root@172-16-100-61:~# ip addr
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:f7:05:d7 brd ff:ff:ff:ff:ff:ff
    inet 172.16.100.61/24 brd 172.16.100.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet 172.16.100.69/32 scope global eth0
       valid_lft forever preferred_lft forever
# ping 172.16.100.69
PING 172.16.100.69 (172.16.100.69) 56(84) bytes of data.
64 bytes from 172.16.100.69: icmp_seq=1 ttl=64 time=0.096 ms
64 bytes from 172.16.100.69: icmp_seq=2 ttl=64 time=0.021 ms
```