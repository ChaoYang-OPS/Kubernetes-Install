```shell

# 生成kube-controller-manager.kubeconfig
# cd /data/applications/kubernetes-v1.19.10/server/certs/
~# ln -sv /data/applications/kubernetes/server/bin/kubectl /usr/local/bin/kubectl
'/usr/local/bin/kubectl' -> '/data/applications/kubernetes/server/bin/kubectl'
# 控制平台节点选择其中一台进行操作即可
~# kubectl version  
Client Version: version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.10", GitCommit:"98d5dc5d36d34a7ee13368a7893dcb400ec4e566", GitTreeState:"clean", BuildDate:"2021-04-15T03:28:42Z", GoVersion:"go1.15.10", Compiler:"gc", Platform:"linux/amd64"}
Kubernetes v1.19.10
kubectl config set-cluster kubernetes \
     --certificate-authority=kubernetes-ca.pem \
     --embed-certs=true \
     --server=https://172.16.100.69:8443 \
     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-controller-manager.kubeconfig
# kubectl config set-cluster kubernetes      --certificate-authority=kubernetes-ca.pem      --embed-certs=true      --server=https://172.16.100.69:8443      --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-controller-manager.kubeconfig
Cluster "kubernetes" set.
# 设置一个环境项，设置上下文
kubectl config set-context system:kube-controller-manager@kubernetes \
    --cluster=kubernetes \
    --user=system:kube-controller-manager \
    --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-controller-manager.kubeconfig
# kubectl config set-context system:kube-controller-manager@kubernetes     --cluster=kubernetes     --user=system:kube-controller-manager     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-controller-manager.kubeconfig
Context "system:kube-controller-manager@kubernetes" created.
# set-credentials 设置用户项
kubectl config set-credentials system:kube-controller-manager \
     --client-certificate=controller-manager.pem \
     --client-key=controller-manager-key.pem \
     --embed-certs=true \
     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-controller-manager.kubeconfig
# kubectl config set-credentials system:kube-controller-manager      --client-certificate=controller-manager.pem      --client-key=controller-manager-key.pem      --embed-certs=true      --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-controller-manager.kubeconfig
User "system:kube-controller-manager" set.
# 设置某个环境当做默认环境
 kubectl config use-context system:kube-controller-manager@kubernetes \
     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-controller-manager.kubeconfig

#  kubectl config use-context system:kube-controller-manager@kubernetes      --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-controller-manager.kubeconfig
Switched to context "system:kube-controller-manager@kubernetes".
```
# 生成kube-scheduler.kubeconfig
```
kubectl config set-cluster kubernetes \
     --certificate-authority=kubernetes-ca.pem \
     --embed-certs=true \
     --server=https://172.16.100.69:8443 \
     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-scheduler.kubeconfig
# kubectl config set-cluster kubernetes      --certificate-authority=kubernetes-ca.pem      --embed-certs=true      --server=https://172.16.100.69:8443      --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-scheduler.kubeconfig
Cluster "kubernetes" set.

kubectl config set-credentials system:kube-scheduler \
     --client-certificate=scheduler.pem \
     --client-key=scheduler-key.pem \
     --embed-certs=true \
     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-scheduler.kubeconfig
# kubectl config set-credentials system:kube-scheduler      --client-certificate=scheduler.pem      --client-key=scheduler-key.pem      --embed-certs=true      --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-scheduler.kubeconfig
User "system:kube-scheduler" set.

kubectl config set-context system:kube-scheduler@kubernetes \
     --cluster=kubernetes \
     --user=system:kube-scheduler \
     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-scheduler.kubeconfig

# kubectl config set-context system:kube-scheduler@kubernetes      --cluster=kubernetes      --user=system:kube-scheduler      --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-scheduler.kubeconfig
Context "system:kube-scheduler@kubernetes" created.


kubectl config use-context system:kube-scheduler@kubernetes \
     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-scheduler.kubeconfig
# kubectl config use-context system:kube-scheduler@kubernetes      --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kube-scheduler.kubeconfig
Switched to context "system:kube-scheduler@kubernetes".
```

# 生成集群管理员admin的kubeconfig

```shell
# cat kubernetes-certs-admin-csr.json
{
    "CN": "admin",
    "key": {
      "algo": "rsa",
      "size": 2048
    },
    "names": [
      {
        "C": "CN",
        "ST": "ShanXI",
        "L": "ShanXI",
        "O": "system:masters",
        "OU": "Kubernetes-ops"
      }
    ]
  }

cfssl gencert \
   -ca=kubernetes-ca.pem \
   -ca-key=kubernetes-ca-key.pem \
   -config=kubernetes-certs-ca-config.json \
   -profile=kubernetes \
   kubernetes-certs-admin-csr.json | cfssljson -bare kubernetes-admin
# cfssl gencert    -ca=kubernetes-ca.pem    -ca-key=kubernetes-ca-key.pem    -config=kubernetes-certs-ca-config.json    -profile=kubernetes    kubernetes-certs-admin-csr.json | cfssljson -bare kubernetes-admin
2021/05/16 15:21:10 [INFO] generate received request
2021/05/16 15:21:10 [INFO] received CSR
2021/05/16 15:21:10 [INFO] generating key: rsa-2048
2021/05/16 15:21:10 [INFO] encoded CSR
2021/05/16 15:21:10 [INFO] signed certificate with serial number 619207823895604892368023143718705816893865908844
2021/05/16 15:21:10 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").

kubectl config set-cluster kubernetes     --certificate-authority=kubernetes-ca.pem     --embed-certs=true     --server=https://172.16.100.69:8443     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kubernetes-admin.kubeconfig
# kubectl config set-cluster kubernetes     --certificate-authority=kubernetes-ca.pem     --embed-certs=true     --server=https://172.16.100.69:8443     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kubernetes-admin.kubeconfig
Cluster "kubernetes" set.

kubectl config set-credentials kubernetes-admin     --client-certificate=kubernetes-admin.pem    --client-key=kubernetes-admin-key.pem     --embed-certs=true     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kubernetes-admin.kubeconfig
# kubectl config set-credentials kubernetes-admin     --client-certificate=kubernetes-admin.pem    --client-key=kubernetes-admin-key.pem     --embed-certs=true     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kubernetes-admin.kubeconfig
User "kubernetes-admin" set.

kubectl config set-context kubernetes-admin@kubernetes     --cluster=kubernetes     --user=kubernetes-admin     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kubernetes-admin.kubeconfig
# kubectl config set-context kubernetes-admin@kubernetes     --cluster=kubernetes     --user=kubernetes-admin     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kubernetes-admin.kubeconfig
Context "kubernetes-admin@kubernetes" created.

kubectl config use-context kubernetes-admin@kubernetes     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kubernetes-admin.kubeconfig

# kubectl config use-context kubernetes-admin@kubernetes     --kubeconfig=/data/applications/kubernetes-v1.19.10/server/conf/kubernetes-admin.kubeconfig
Switched to context "kubernetes-admin@kubernetes".
```