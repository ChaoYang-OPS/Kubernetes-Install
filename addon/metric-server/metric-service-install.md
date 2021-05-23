# install metric-server

```shell
# kubectl apply -f metrics-server-3.6/
# data plan 需要复制相关证书文件
# scp 172.16.100.61:/data/applications/kubernetes-v1.19.10/server/certs/front-proxy-ca.pem  /data/applications/kubernetes-v1.19.10/server/certs/
clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
rolebinding.rbac.authorization.k8s.io/metrics-server-auth-reader created
Warning: apiregistration.k8s.io/v1beta1 APIService is deprecated in v1.19+, unavailable in v1.22+; use apiregistration.k8s.io/v1 APIService
apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created
serviceaccount/metrics-server created
deployment.apps/metrics-server created
service/metrics-server created
clusterrole.rbac.authorization.k8s.io/system:metrics-server created
clusterrolebinding.rbac.authorization.k8s.io/system:metrics-server created
# kubectl get pods -n kube-system | grep metrics-server
metrics-server-58d59b6888-ls9cr           1/1     Running   0          20s
# kubectl top node
NAME            CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
172-16-100-61   181m         9%     1044Mi          55%       
172-16-100-62   147m         7%     902Mi           48%       
172-16-100-63   105m         5%     823Mi           44%       
172-16-100-64   90m          2%     1109Mi          29%       
172-16-100-65   77m          1%     586Mi           15%  
# kubectl top pods -A
NAMESPACE     NAME                                      CPU(cores)   MEMORY(bytes)   
kube-system   calico-kube-controllers-97769f7c7-qgfrq   3m           12Mi            
kube-system   calico-node-flzmj                         22m          45Mi            
kube-system   calico-node-n9spk                         18m          33Mi            
kube-system   calico-node-rdxdg                         21m          51Mi            
kube-system   calico-node-t68g7                         17m          36Mi            
kube-system   coredns-744ddcfcb5-5pmxc                  3m           13Mi            
kube-system   metrics-server-58d59b6888-pt8jr           7m           18Mi            
```