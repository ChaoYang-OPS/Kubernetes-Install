+ **生成证书**
# SERVICE_IP: 10.99.0.0/12
#  生成CA,操作节点在61: 172-16-100-61

```shell
~# cd /data/applications/kubernetes-v1.19.10/server/certs/
# cat kubernetes-certs-ca.json
{
    "CN": "kubernetes",
    "key": {
      "algo": "rsa",
      "size": 2048
    },
    "names": [
      {
        "C": "CN",
        "ST": "ShanXI",
        "L": "ShanXI",
        "O": "Kubernetes",
        "OU": "Kubernetes-ops"
      }
    ],
    "ca": {
      "expiry": "876000h"
    }
}
# 生成CA
# cfssl gencert -initca kubernetes-certs-ca.json | cfssljson -bare  kubernetes-ca
2021/05/16 11:50:46 [INFO] generating a new CA key and certificate from CSR
2021/05/16 11:50:46 [INFO] generate received request
2021/05/16 11:50:46 [INFO] received CSR
2021/05/16 11:50:46 [INFO] generating key: rsa-2048
2021/05/16 11:50:46 [INFO] encoded CSR
2021/05/16 11:50:46 [INFO] signed certificate with serial number 487732247813411803675607444728261074130125037767
# ls -l
-rw------- 1 root root 1675 May 16 11:50 kubernetes-ca-key.pem
-rw-r--r-- 1 root root 1066 May 16 11:50 kubernetes-ca.csr
-rw-r--r-- 1 root root 1346 May 16 11:50 kubernetes-ca.pem
-rw-r--r-- 1 root root  295 May 16 11:50 kubernetes-certs-ca.json
# 查看证书有效期
# cfssl-certinfo -cert kubernetes-ca.pem | egrep "not_before|not_after"
"not_before": "2021-05-16T03:46:00Z",
"not_after": "2121-04-22T03:46:00Z",
# 生成CA配置文件
# cat kubernetes-certs-ca-config.json
{
    "signing": {
      "default": {
        "expiry": "876000h"
      },
      "profiles": {
        "kubernetes": {
          "usages": [
              "signing",
              "key encipherment",
              "server auth",
              "client auth"
          ],
          "expiry": "876000h"
        }
      }
    }
  }
# api-server请求文件,多备用几个IP
# cat kubernetes-certs-apiserver-csr.json 
{
    "CN": "kube-apiserver",
    "hosts": [
        "127.0.0.1",
        "10.99.0.1",
        "kubernetes.default",
        "kubernetes.default.svc",
        "kubernetes.default.svc.cluster",
        "kubernetes.default.svc.cluster.local",
        "172.16.100.61",
        "172.16.100.62",
        "172.16.100.63",
        "172.16.100.69",
        "172.16.100.99"
    ],
    "key": {
      "algo": "rsa",
      "size": 2048
    },
    "names": [
      {
        "C": "CN",
        "ST": "ShanXI",
        "L": "ShanXI",
        "O": "Kubernetes",
        "OU": "Kubernetes-ops"
      }
    ]
  }
# 生成apiserver证书
cfssl gencert   -ca=kubernetes-ca.pem   -ca-key=kubernetes-ca-key.pem    -config=kubernetes-certs-ca-config.json   -profile=kubernetes   kubernetes-certs-apiserver-csr.json | cfssljson -bare kube-apiserver

# cfssl gencert   -ca=kubernetes-ca.pem   -ca-key=kubernetes-ca-key.pem    -config=kubernetes-certs-ca-config.json   -profile=kubernetes   kubernetes-certs-apiserver-csr.json | cfssljson -bare kube-apiserver
2021/05/16 12:13:49 [INFO] generate received request
2021/05/16 12:13:49 [INFO] received CSR
2021/05/16 12:13:49 [INFO] generating key: rsa-2048
2021/05/16 12:13:49 [INFO] encoded CSR
2021/05/16 12:13:49 [INFO] signed certificate with serial number 315858997875855133164355035651158161954019069302
# ls -l kube-apiserver*
-rw------- 1 root root 1679 May 16 12:13 kube-apiserver-key.pem
-rw-r--r-- 1 root root 1281 May 16 12:13 kube-apiserver.csr
-rw-r--r-- 1 root root 1671 May 16 12:13 kube-apiserver.pem

# cat kubernetes-certs-front-proxy-ca-csr.json 
{
    "CN": "kubernetes",
    "key": {
       "algo": "rsa",
       "size": 2048
    }
  }
# 生成聚合CA
# cfssl gencert   -initca kubernetes-certs-front-proxy-ca-csr.json  | cfssljson -bare front-proxy-ca 
# cfssl gencert   -initca kubernetes-certs-front-proxy-ca-csr.json  | cfssljson -bare front-proxy-ca 
2021/05/16 12:22:05 [INFO] generating a new CA key and certificate from CSR
2021/05/16 12:22:05 [INFO] generate received request
2021/05/16 12:22:05 [INFO] received CSR
2021/05/16 12:22:05 [INFO] generating key: rsa-2048
2021/05/16 12:22:05 [INFO] encoded CSR
2021/05/16 12:22:05 [INFO] signed certificate with serial number 166804392919659260576228473461080605938269825892
# 生成apiserver的聚合证书
# cat kubernetes-certs-front-proxy-client-csr.json
{
    "CN": "kubernetes",
    "key": {
       "algo": "rsa",
       "size": 2048
    }
  }
# cfssl gencert   -ca=front-proxy-ca.pem   -ca-key=front-proxy-ca-key.pem   -config=kubernetes-certs-ca-config.json   -profile=kubernetes   kubernetes-certs-front-proxy-client-csr.json | cfssljson -bare front-proxy-client
# cfssl gencert   -ca=front-proxy-ca.pem   -ca-key=front-proxy-ca-key.pem   -config=kubernetes-certs-ca-config.json   -profile=kubernetes   kubernetes-certs-front-proxy-client-csr.json | cfssljson -bare front-proxy-client
2021/05/16 12:28:38 [INFO] generate received request
2021/05/16 12:28:38 [INFO] received CSR
2021/05/16 12:28:38 [INFO] generating key: rsa-2048
2021/05/16 12:28:38 [INFO] encoded CSR
2021/05/16 12:28:38 [INFO] signed certificate with serial number 259416252041558061699222268402537870109678362112
2021/05/16 12:28:38 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
# 生成kube-controller-manager证书
# cat kubernetes-certs-controller-manager-csr.json   
{
    "CN": "system:kube-controller-manager",
    "key": {
      "algo": "rsa",
      "size": 2048
    },
    "names": [
      {
        "C": "CN",
        "ST": "ShanXI",
        "L": "ShanXI",
        "O": "system:kube-controller-manager",
        "OU": "Kubernetes-ops"
      }
    ]
  }
cfssl gencert \
   -ca=kubernetes-ca.pem  \
   -ca-key=kubernetes-ca-key.pem \
   -config=kubernetes-certs-ca-config.json \
   -profile=kubernetes \
   kubernetes-certs-controller-manager-csr.json | cfssljson -bare controller-manager

# cfssl gencert    -ca=kubernetes-ca.pem     -ca-key=kubernetes-ca-key.pem    -config=kubernetes-certs-ca-config.json    -profile=kubernetes    kubernetes-certs-controller-manager-csr.json | cfssljson -bare controller-manager
2021/05/16 12:35:59 [INFO] generate received request
2021/05/16 12:35:59 [INFO] received CSR
2021/05/16 12:35:59 [INFO] generating key: rsa-2048
2021/05/16 12:35:59 [INFO] encoded CSR
2021/05/16 12:35:59 [INFO] signed certificate with serial number 68284351194136522990293776278904680765806644394
2021/05/16 12:35:59 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
# ls -l controller-manager*
-rw------- 1 root root 1675 May 16 12:35 controller-manager-key.pem
-rw-r--r-- 1 root root 1074 May 16 12:35 controller-manager.csr
-rw-r--r-- 1 root root 1484 May 16 12:35 controller-manager.pem

# 生成kube-scheduler证书
# cat kubernetes-certs-scheduler-csr.json
{
    "CN": "system:kube-scheduler",
    "key": {
      "algo": "rsa",
      "size": 2048
    },
    "names": [
      {
        "C": "CN",
        "ST": "ShanXI",
        "L": "ShanXI",
        "O": "system:kube-scheduler",
        "OU": "Kubernetes-ops"
      }
    ]
  }

cfssl gencert \
   -ca=kubernetes-ca.pem  \
   -ca-key=kubernetes-ca-key.pem \
   -config=kubernetes-certs-ca-config.json \
   -profile=kubernetes \
   kubernetes-certs-scheduler-csr.json | cfssljson -bare scheduler
# cfssl gencert    -ca=kubernetes-ca.pem     -ca-key=kubernetes-ca-key.pem    -config=kubernetes-certs-ca-config.json    -profile=kubernetes    kubernetes-certs-scheduler-csr.json | cfssljson -bare scheduler
2021/05/16 12:44:19 [INFO] generate received request
2021/05/16 12:44:19 [INFO] received CSR
2021/05/16 12:44:19 [INFO] generating key: rsa-2048
2021/05/16 12:44:19 [INFO] encoded CSR
2021/05/16 12:44:19 [INFO] signed certificate with serial number 146451273793043537427775782455227201109083915271
2021/05/16 12:44:19 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
# 生成kube-proxy证书
# cat kubernetes-certs-proxy-csr.json   
{
    "CN": "system:kube-proxy",
    "key": {
      "algo": "rsa",
      "size": 2048
    },
    "names": [
      {
        "C": "CN",
        "ST": "ShanXI",
        "L": "ShanXI",
        "O": "system:kube-proxy",
        "OU": "Kubernetes-ops"
      }
    ]
  }
cfssl gencert \
   -ca=kubernetes-ca.pem  \
   -ca-key=kubernetes-ca-key.pem \
   -config=kubernetes-certs-ca-config.json \
   -profile=kubernetes \
   kubernetes-certs-proxy-csr.json  | cfssljson -bare kube-proxy
# cfssl gencert    -ca=kubernetes-ca.pem     -ca-key=kubernetes-ca-key.pem    -config=kubernetes-certs-ca-config.json    -profile=kubernetes    kubernetes-certs-proxy-csr.json  | cfssljson -bare kube-proxy
2021/05/16 12:54:03 [INFO] generate received request
2021/05/16 12:54:03 [INFO] received CSR
2021/05/16 12:54:03 [INFO] generating key: rsa-2048
2021/05/16 12:54:03 [INFO] encoded CSR
2021/05/16 12:54:03 [INFO] signed certificate with serial number 478034492155188959180816271951429757074890441477
2021/05/16 12:54:03 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
```