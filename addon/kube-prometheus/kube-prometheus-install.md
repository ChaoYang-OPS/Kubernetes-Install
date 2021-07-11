# install kube-prometheus


```shell
# refer: https://github.com/prometheus-operator/kube-prometheus
# control plan 
# wget https://github.com/prometheus-operator/kube-prometheus/archive/refs/heads/release-0.7.zip
# unzip kube-prometheus-release-0.7.zip
# cd kube-prometheus-release-0.7/manifests/setup/
# vim prometheus-operator-deployment.yaml

# registry.cn-chengdu.aliyuncs.com/ops-k8s/prometheus-operator:v0.44.1
# registry.cn-chengdu.aliyuncs.com/ops-k8s/brancz-kube-rbac-proxy:v0.8.0
# kubectl apply -f .
namespace/monitoring created
customresourcedefinition.apiextensions.k8s.io/alertmanagerconfigs.monitoring.coreos.com created
customresourcedefinition.apiextensions.k8s.io/alertmanagers.monitoring.coreos.com created
customresourcedefinition.apiextensions.k8s.io/podmonitors.monitoring.coreos.com created
customresourcedefinition.apiextensions.k8s.io/probes.monitoring.coreos.com created
customresourcedefinition.apiextensions.k8s.io/prometheuses.monitoring.coreos.com created
customresourcedefinition.apiextensions.k8s.io/prometheusrules.monitoring.coreos.com created
customresourcedefinition.apiextensions.k8s.io/servicemonitors.monitoring.coreos.com created
customresourcedefinition.apiextensions.k8s.io/thanosrulers.monitoring.coreos.com created
clusterrole.rbac.authorization.k8s.io/prometheus-operator created
clusterrolebinding.rbac.authorization.k8s.io/prometheus-operator created
deployment.apps/prometheus-operator created
service/prometheus-operator created
serviceaccount/prometheus-operator created
# kubectl get pods,svc,deploy -n monitoring
NAME                                      READY   STATUS    RESTARTS   AGE
pod/prometheus-operator-fcf4dd4f7-5s6s4   2/2     Running   0          22s

NAME                          TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
service/prometheus-operator   ClusterIP   None         <none>        8443/TCP   9m26s

NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prometheus-operator   1/1     1            1           9m26s
# create grafana deployment pv and pvc
# kubectl apply -f oss/grafana-oss-pv.yaml
# kubectl apply -f oss/grafana-oss-pvc.yaml
manifests# kubectl apply -f .
alertmanager.monitoring.coreos.com/main created
secret/alertmanager-main created
service/alertmanager-main created
serviceaccount/alertmanager-main created
servicemonitor.monitoring.coreos.com/alertmanager created
secret/grafana-datasources created
configmap/grafana-dashboard-apiserver created
configmap/grafana-dashboard-cluster-total created
configmap/grafana-dashboard-controller-manager created
configmap/grafana-dashboard-k8s-resources-cluster created
configmap/grafana-dashboard-k8s-resources-namespace created
configmap/grafana-dashboard-k8s-resources-node created
configmap/grafana-dashboard-k8s-resources-pod created
configmap/grafana-dashboard-k8s-resources-workload created
configmap/grafana-dashboard-k8s-resources-workloads-namespace created
configmap/grafana-dashboard-kubelet created
configmap/grafana-dashboard-namespace-by-pod created
configmap/grafana-dashboard-namespace-by-workload created
configmap/grafana-dashboard-node-cluster-rsrc-use created
configmap/grafana-dashboard-node-rsrc-use created
configmap/grafana-dashboard-nodes created
configmap/grafana-dashboard-persistentvolumesusage created
configmap/grafana-dashboard-pod-total created
configmap/grafana-dashboard-prometheus-remote-write created
configmap/grafana-dashboard-prometheus created
configmap/grafana-dashboard-proxy created
configmap/grafana-dashboard-scheduler created
configmap/grafana-dashboard-statefulset created
configmap/grafana-dashboard-workload-total created
configmap/grafana-dashboards created
deployment.apps/grafana configured
service/grafana created
serviceaccount/grafana created
servicemonitor.monitoring.coreos.com/grafana created
clusterrole.rbac.authorization.k8s.io/kube-state-metrics created
clusterrolebinding.rbac.authorization.k8s.io/kube-state-metrics created
deployment.apps/kube-state-metrics created
service/kube-state-metrics created
serviceaccount/kube-state-metrics created
servicemonitor.monitoring.coreos.com/kube-state-metrics created
clusterrole.rbac.authorization.k8s.io/node-exporter created
clusterrolebinding.rbac.authorization.k8s.io/node-exporter created
daemonset.apps/node-exporter created
service/node-exporter created
serviceaccount/node-exporter created
servicemonitor.monitoring.coreos.com/node-exporter created
apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io configured
clusterrole.rbac.authorization.k8s.io/prometheus-adapter created
clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader unchanged
clusterrolebinding.rbac.authorization.k8s.io/prometheus-adapter created
clusterrolebinding.rbac.authorization.k8s.io/resource-metrics:system:auth-delegator created
clusterrole.rbac.authorization.k8s.io/resource-metrics-server-resources created
configmap/adapter-config created
deployment.apps/prometheus-adapter created
rolebinding.rbac.authorization.k8s.io/resource-metrics-auth-reader created
service/prometheus-adapter created
serviceaccount/prometheus-adapter created
servicemonitor.monitoring.coreos.com/prometheus-adapter created
clusterrole.rbac.authorization.k8s.io/prometheus-k8s created
clusterrolebinding.rbac.authorization.k8s.io/prometheus-k8s created
servicemonitor.monitoring.coreos.com/prometheus-operator created
prometheus.monitoring.coreos.com/k8s created
rolebinding.rbac.authorization.k8s.io/prometheus-k8s-config created
rolebinding.rbac.authorization.k8s.io/prometheus-k8s created
rolebinding.rbac.authorization.k8s.io/prometheus-k8s created
rolebinding.rbac.authorization.k8s.io/prometheus-k8s created
role.rbac.authorization.k8s.io/prometheus-k8s-config created
role.rbac.authorization.k8s.io/prometheus-k8s created
role.rbac.authorization.k8s.io/prometheus-k8s created
role.rbac.authorization.k8s.io/prometheus-k8s created
prometheusrule.monitoring.coreos.com/prometheus-k8s-rules created
service/prometheus-k8s created
serviceaccount/prometheus-k8s created
servicemonitor.monitoring.coreos.com/prometheus created
servicemonitor.monitoring.coreos.com/kube-apiserver created
servicemonitor.monitoring.coreos.com/coredns created
servicemonitor.monitoring.coreos.com/kube-controller-manager created
servicemonitor.monitoring.coreos.com/kube-scheduler created
servicemonitor.monitoring.coreos.com/kubelet created


# kubectl get pods -n monitoring
NAME                                  READY   STATUS    RESTARTS   AGE
alertmanager-main-0                   2/2     Running   0          4m21s
alertmanager-main-1                   2/2     Running   0          4m28s
alertmanager-main-2                   2/2     Running   0          5m56s
grafana-69fd5cf5b6-shn55              1/1     Running   0          31m
kube-state-metrics-587bfd4f97-ng6gt   3/3     Running   0          42m
node-exporter-nqsqh                   2/2     Running   0          8m42s
node-exporter-r6khz                   2/2     Running   0          8m24s
node-exporter-sskpk                   2/2     Running   0          8m48s
prometheus-adapter-69b8496df6-jzglc   1/1     Running   0          42m
prometheus-k8s-0                      2/2     Running   1          30s
prometheus-k8s-1                      2/2     Running   1          51s
prometheus-operator-fcf4dd4f7-5s6s4   2/2     Running   0          169m
# kubectl get svc -n monitoring
NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
alertmanager-main       ClusterIP   10.99.161.152   <none>        9093/TCP                     53m
alertmanager-operated   ClusterIP   None            <none>        9093/TCP,9094/TCP,9094/UDP   53m
grafana                 ClusterIP   10.99.135.208   <none>        3000/TCP                     53m
kube-state-metrics      ClusterIP   None            <none>        8443/TCP,9443/TCP            53m
node-exporter           ClusterIP   None            <none>        9100/TCP                     53m
prometheus-adapter      ClusterIP   10.99.203.49    <none>        443/TCP                      53m
prometheus-k8s          ClusterIP   10.99.176.188   <none>        9090/TCP                     53m
prometheus-operated     ClusterIP   None            <none>        9090/TCP                     53m
prometheus-operator     ClusterIP   None            <none>        8443/TCP                     3h9m
# kubectl get pv grafana-oss-pv
NAME             CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                        STORAGECLASS   REASON   AGE
grafana-oss-pv   5Gi        RWO            Retain           Bound    monitoring/grafana-oss-pvc                           43m

# kubectl describe pods grafana-69fd5cf5b6-shn55 -n monitoring | grep -A 3 grafana-storage
--
  grafana-storage:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  grafana-oss-pvc
    ReadOnly:   false
# create ingress
# kubectl apply -f kube-prometheus-ingress.yaml
Warning: extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
ingress.extensions/kube-prometheus-ingress created
# kubectl get ingress -n monitoring
Warning: extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
NAME                      CLASS    HOSTS                                                              ADDRESS   PORTS   AGE
kube-prometheus-ingress   <none>   grafana.opsk8s.com,alertmanager.opsk8s.com,prometheus.opsk8s.com             80      24s


# Only binary Fix kube-schedule, kubeadmin install is ok
# kubectl get servicemonitor -n monitoring
# kubectl get servicemonitor kube-controller-manager -n monitoring -o yaml
      sourceLabels:
      - __name__
    - action: drop
      regex: etcd_(debugging|disk|request|server).*
      sourceLabels:
      - __name__
    port: https-metrics
    scheme: https
    tlsConfig:
      insecureSkipVerify: true
  jobLabel: k8s-app
  namespaceSelector:
    matchNames:
    - kube-system
  selector:
    matchLabels:
      k8s-app: kube-controller-manager
# kubectl get svc -n kube-system
NAME             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                                     AGE
kube-dns         ClusterIP   10.99.0.10    <none>        53/UDP,53/TCP,9153/TCP                      48d
kubelet          ClusterIP   None          <none>        10250/TCP,10255/TCP,4194/TCP                8h
metrics-server   ClusterIP   10.99.53.29   <none>        443/TCP                                     48d
traefik          ClusterIP   10.99.51.78   <none>        80/TCP,443/TCP,8080/TCP,8000/TCP,9000/UDP   35d

# modify kube-controller-manager listen address 0.0.0.0
# cat /data/applications/kubernetes/server/scripts/kube-controller-manager-service.sh
#!/bin/bash
../bin/kube-controller-manager \
      --v=2 \
      --logtostderr=true \
      --address=0.0.0.0 \
      --root-ca-file=../certs/kubernetes-ca.pem \
      --cluster-signing-cert-file=../certs/kubernetes-ca.pem \
      --cluster-signing-key-file=../certs/kubernetes-ca-key.pem \
      --service-account-private-key-file=../certs/service-account.key \
      --kubeconfig=../conf/kube-controller-manager.kubeconfig \
      --log-dir=/opt/logs/kubernetes/kube-controller-manager-service \
      --leader-elect=true \
      --use-service-account-credentials=true \
      --node-monitor-grace-period=40s \
      --node-monitor-period=5s \
      --pod-eviction-timeout=2m0s \
      --experimental-cluster-signing-duration=87600h0m0s \
      --controllers=*,bootstrapsigner,tokencleaner \
      --allocate-node-cidrs=true \
      --cluster-cidr=10.244.0.0/16 \
      --requestheader-client-ca-file=../certs/front-proxy-ca.pem \
      --node-cidr-mask-size=24
# restart service
# supervisorctl restart kube-controller-manager-service
# netstat -lntp | grep 10252
tcp6       0      0 :::10252                :::*                    LISTEN      21135/../bin/kube-c 

# create service file
# cat kube-controller-manager-service.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    k8s-app: kube-controller-manager
  name: kube-controller-manager-service
  namespace: kube-system
spec:
  ports:
  - name: https-metrics
    port: 10252
    protocol: TCP
    targetPort: 10252
  sessionAffinity: None
  type: ClusterIP
# kubectl apply -f kube-controller-manager-service.yaml
service/kube-controller-manager-service created
# kubectl get svc kube-controller-manager-service -n kube-system
NAME                              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)     AGE
kube-controller-manager-service   ClusterIP   10.99.158.99   <none>        10252/TCP   61s
# create endpoint
# cat kube-controller-manager-ep.yaml
apiVersion: v1
kind: Endpoints
metadata:
  labels:
    k8s-app: kube-controller-manager
  name: kube-controller-manager-service
  namespace: kube-system
subsets:
- addresses:
  - ip: 172.16.100.61
  - ip: 172.16.100.62
  - ip: 172.16.100.63
  ports:
  - name: https-metrics
    port: 10252
    protocol: TCP
# kubectl apply -f kube-controller-manager-service-ep.yaml
endpoints/kube-controller-manage-monitor created
# kubectl get svc,ep kube-controller-manager-service  -n kube-system
NAME                                      TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)     AGE
service/kube-controller-manager-service   ClusterIP   10.99.56.49   <none>        10252/TCP   11m

NAME                                        ENDPOINTS                                                     AGE
endpoints/kube-controller-manager-service   172.16.100.61:10252,172.16.100.62:10252,172.16.100.63:10252   2m19s
# curl 10.99.56.49:10252
404 page not found
# curl 172.16.100.61:10252
404 page not found
# modify /data/applications/kubernetes/server/scripts/kube-scheduler-service.sh change address is  0.0.0.0

```

