# turn on psp

```shell
root@172-16-100-62:~/psp# kubectl apply -f privileged.yaml 
podsecuritypolicy.policy/privileged created
root@172-16-100-62:~/psp# kubectl apply -f privileged-binding.yaml 
clusterrole.rbac.authorization.k8s.io/privileged-psp created
rolebinding.rbac.authorization.k8s.io/kube-system-psp created
root@172-16-100-62:~/psp# kubectl apply -f restricted.yaml 
podsecuritypolicy.policy/restricted created
root@172-16-100-62:~/psp# kubectl get psp
NAME         PRIV    CAPS   SELINUX    RUNASUSER          FSGROUP     SUPGROUP    READONLYROOTFS   VOLUMES
privileged   true    *      RunAsAny   RunAsAny           RunAsAny    RunAsAny    false            *
restricted   false          RunAsAny   MustRunAsNonRoot   MustRunAs   MustRunAs   false            configMap,emptyDir,projected,secret,downwardAPI,csi,persistentVolumeClaim,ephemeral
# apiserver turn on podsecuritypolicy

#modify the apiserver start script add --enable-admission-plugins=PodSecurityPolicy
root@172-16-100-62:~# vim /data/applications/kubernetes/server/scripts/kube-apiserver-service.sh
root@172-16-100-62:~# cat /data/applications/kubernetes/server/scripts/kube-apiserver-service.sh
#!/bin/bash
../bin/kube-apiserver \
      --v=2  \
      --logtostderr=true  \
      --allow-privileged=true  \
      --bind-address=0.0.0.0  \
      --secure-port=6443  \
      --insecure-port=0  \
      --advertise-address=172.16.100.62 \
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
      --service-account-key-file=../certs/service-account.pub  \
      --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname  \
      --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,PodSecurityPolicy,ResourceQuota  \
      --authorization-mode=Node,RBAC  \
      --enable-bootstrap-token-auth=true  \
      --log-dir=/opt/logs/kubernetes/kube-apiserver \
      --audit-log-mode=batch \
      --audit-policy-file=../conf/audit-policy.yaml \
      --audit-log-path=/opt/logs/kubernetes/kube-apiserver-service/kubernetes_audit_info.log \
      --audit-log-maxbackup=10 \
      --audit-log-maxage=30 \
      --audit-log-maxsize=100 \
      --encryption-provider-config=../conf/encryptionconfiguration.yaml \
      --requestheader-client-ca-file=../certs/front-proxy-ca.pem \
      --proxy-client-cert-file=../certs/front-proxy-client.pem \
      --proxy-client-key-file=../certs/front-proxy-client-key.pem \
      --requestheader-allowed-names=aggregator  \
      --requestheader-group-headers=X-Remote-Group  \
      --requestheader-extra-headers-prefix=X-Remote-Extra-  \
      --requestheader-username-headers=X-Remote-User

# 控制平面 全部修改
root@172-16-100-62:~# supervisorctl restart kube-apiserver-service 
kube-apiserver-service: stopped
kube-apiserver-service: started
# log 
I0203 16:33:58.982211  127486 plugins.go:158] Loaded 13 mutating admission controller(s) successfully in the following order: NamespaceLifecycle,LimitRanger,ServiceAccount,NodeRestriction,TaintNodesByCondition,PodSecurityPolicy,Priority,DefaultTolerationSeconds,DefaultStorageClass,StorageObjectInUseProtection,RuntimeClass,DefaultIngressClass,MutatingAdmissionWebhook.

# create pods ,check events
root@172-16-100-63:~# kubectl get events -n terraform
LAST SEEN   TYPE      REASON              OBJECT                                       MESSAGE
24s         Warning   FailedCreate        replicaset/terraform-python-demo-c7864dc7b   Error creating: pods "terraform-python-demo-c7864dc7b-" is forbidden: PodSecurityPolicy: unable to admit pod: []
65s         Normal    ScalingReplicaSet   deployment/terraform-python-demo             Scaled up replica set terraform-python-demo-c7864dc7b to 1
```

