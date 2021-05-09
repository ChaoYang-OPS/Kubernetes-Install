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
~# apt-get install ntpdate vim git psmisc lvm2 jq  -y
~# apt-get install ipvsadm ipset sysstat conntrack  libseccomp2 -y
```