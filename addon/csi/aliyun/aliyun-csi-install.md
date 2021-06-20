# install csi for aliyun

```shell
# https://github.com/kubernetes-sigs/alibaba-cloud-csi-driver/tree/master?spm=a2c4g.11186623.2.24.4b473fc76B59lj
# kubectl apply -f rbac.yaml
serviceaccount/csi-admin created
clusterrole.rbac.authorization.k8s.io/alicloud-csi-plugin created
clusterrolebinding.rbac.authorization.k8s.io/alicloud-csi-plugin created
# kubectl apply -f oss-plugin.yaml
Warning: storage.k8s.io/v1beta1 CSIDriver is deprecated in v1.19+, unavailable in v1.22+; use storage.k8s.io/v1 CSIDriver
csidriver.storage.k8s.io/ossplugin.csi.alibabacloud.com created
daemonset.apps/csi-plugin created
# kubectl get pods -n kube-system | grep csi
csi-plugin-nwscl                          2/2     Running   0          23s
csi-plugin-pj45d                          2/2     Running   0          2m57s
csi-plugin-zvt8s                          2/2     Running   0          2m57s
# kubectl logs  csi-plugin-rglkg -c csi-plugin -n kube-system | tail -15
time="2021-06-20T16:33:32+08:00" level=info msg="Multi CSI Driver Name: oss, nodeID: 172-16-100-62, endPoints: unix://var/lib/kubelet/csi-plugins/driverplugin.csi.alibabacloud.com-replace/csi.sock"
time="2021-06-20T16:33:32+08:00" level=info msg="CSI Driver Branch: 'master', Version: 'v1.18.8.47-906bd535-aliyun', Build time: '2021-05-13-20:56:55'\n"
time="2021-06-20T16:33:32+08:00" level=info msg="Create Stroage Path: /var/lib/kubelet/csi-plugins/ossplugin.csi.alibabacloud.com/controller"
time="2021-06-20T16:33:32+08:00" level=info msg="Create Stroage Path: /var/lib/kubelet/csi-plugins/ossplugin.csi.alibabacloud.com/node"
time="2021-06-20T16:33:32+08:00" level=info msg="CSI is running status."
time="2021-06-20T16:33:32+08:00" level=info msg="Metric listening on address: /healthz"
time="2021-06-20T16:33:32+08:00" level=info msg="Driver: ossplugin.csi.alibabacloud.com version: 1.0.0"
I0620 16:33:32.943384   56729 driver.go:93] Enabling volume access mode: MULTI_NODE_MULTI_WRITER
I0620 16:33:32.943464   56729 driver.go:81] Enabling controller service capability: UNKNOWN
I0620 16:33:32.949580   56729 server.go:108] Listening for connections on address: &net.UnixAddr{Name:"/var/lib/kubelet/csi-plugins/ossplugin.csi.alibabacloud.com/csi.sock", Net:"unix"}
time="2021-06-20T16:33:32+08:00" level=info msg="Metric listening on address: /metrics"
# 需要修改为自己的AK与SK,并且需要绑定相关的权限 AliyunOSSReadOnlyAccess
# kubectl apply -f pv.yaml
persistentvolume/oss-csi-pv created
# kubectl apply -f pvc.yaml
persistentvolumeclaim/oss-pvc created
# kubectl get pv,pvc
NAME                             CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                 STORAGECLASS   REASON   AGE
persistentvolume/oss-csi-pv      5Gi        RWO            Retain           Bound    default/oss-pvc                               14s
NAME                            STATUS   VOLUME       CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/oss-pvc   Bound    oss-csi-pv   5Gi        RWO                           4s
# kubectl apply -f deploy.yaml
deployment.apps/deployment-oss created
# kubectl describe pods deployment-oss-5ff7499666-lzfts
 Warning  FailedMount  32s (x8 over 96s)  kubelet            MountVolume.SetUp failed for volume "oss-csi-pv" : rpc error: code = Unknown desc = Create OSS volume fail: oss connector exec command error:Fail: systemd-run --scope -- /usr/local/bin/ossfs ops-kubernetes:/kubernetes /var/lib/kubelet/pods/cf6b8006-d120-42c3-93a0-e9210f60a6c4/volumes/kubernetes.io~csi/oss-csi-pv/mount -ourl=ops-kubernetes.oss-cn-chengdu.aliyuncs.com -o max_stat_cache_size=0 -o allow_other, error: Failed to run cmd: systemd-run --scope -- /usr/local/bin/ossfs ops-kubernetes:/kubernetes /var/lib/kubelet/pods/cf6b8006-d120-42c3-93a0-e9210f60a6c4/volumes/kubernetes.io~csi/oss-csi-pv/mount -ourl=ops-kubernetes.oss-cn-chengdu.aliyuncs.com -o max_stat_cache_size=0 -o allow_other, with out: Failed to find executable /usr/local/bin/ossfs: No such file or directory
, with error: exit status 1, out: Fail: systemd-run --scope -- /usr/local/bin/ossfs ops-kubernetes:/kubernetes /var/lib/kubelet/pods/cf6b8006-d120-42c3-93a0-e9210f60a6c4/volumes/kubernetes.io~csi/oss-csi-pv/mount -ourl=ops-kubernetes.oss-cn-chengdu.aliyuncs.com -o max_stat_cache_size=0 -o allow_other, error: Failed to run cmd: systemd-run --scope -- /usr/local/bin/ossfs ops-kubernetes:/kubernetes /var/lib/kubelet/pods/cf6b8006-d120-42c3-93a0-e9210f60a6c4/volumes/kubernetes.io~csi/oss-csi-pv/mount -ourl=ops-kubernetes.oss-cn-chengdu.aliyuncs.com -o max_stat_cache_size=0 -o allow_other, with out: Failed to find executable /usr/local/bin/ossfs: No such file or directory
, with error: exit status 1
# 排查错误
# worker节点 (数据面板)安装 ossfs
# 参考文档: https://github.com/aliyun/ossfs
# apt-get install automake autotools-dev g++ git libcurl4-gnutls-dev  libfuse-dev libssl-dev libxml2-dev make pkg-config
# git clone https://github.com/aliyun/ossfs.git
Cloning into 'ossfs'...
remote: Enumerating objects: 544, done.
remote: Total 544 (delta 0), reused 0 (delta 0), pack-reused 544
Receiving objects: 100% (544/544), 350.61 KiB | 389.00 KiB/s, done.
Resolving deltas: 100% (353/353), done.
# cd ossfs/
# ./autogen.sh
--- Make commit hash file -------
--- Finished commit hash file ---
--- Start autotools -------------
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
        LANGUAGE = "en_US:en",
        LC_ALL = (unset),
        LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
        LANGUAGE = "en_US:en",
        LC_ALL = (unset),
        LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
        LANGUAGE = "en_US:en",
        LC_ALL = (unset),
        LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
        LANGUAGE = "en_US:en",
        LC_ALL = (unset),
        LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
        LANGUAGE = "en_US:en",
        LC_ALL = (unset),
        LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
        LANGUAGE = "en_US:en",
        LC_ALL = (unset),
        LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
configure.ac:31: installing './compile'
configure.ac:27: installing './config.guess'
configure.ac:27: installing './config.sub'
configure.ac:28: installing './install-sh'
configure.ac:28: installing './missing'
src/Makefile.am: installing './depcomp'
parallel-tests: installing './test-driver'
--- Finished autotools ----------
# ./configure
# make && make install
# which ossfs
/usr/local/bin/ossfs
# 删除POD，再次验证
# kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
deployment-oss-5ff7499666-9g7vr   1/1     Running   0          15s
# kubectl describe pods deployment-oss-5ff7499666-9g7vr
Volumes:
  oss-pvc:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  oss-pvc
    ReadOnly:   false
# kubectl logs  csi-plugin-rglkg  -c csi-plugin -n kube-system | tail -n 5
time="2021-06-20T17:08:59+08:00" level=info msg="NodePublishVolume:: Mount Oss successful, volume oss-csi-pv, targetPath: /var/lib/kubelet/pods/2b6eb900-68ce-4728-b758-1e78adeeb1c5/volumes/kubernetes.io~csi/oss-csi-pv/mount, with Command: systemd-run --scope -- /usr/local/bin/ossfs ops-kubernetes:/kubernetes /var/lib/kubelet/pods/2b6eb900-68ce-4728-b758-1e78adeeb1c5/volumes/kubernetes.io~csi/oss-csi-pv/mount -ourl=oss-cn-chengdu.aliyuncs.com -o max_stat_cache_size=0 -o allow_other"
# kubectl exec -it deployment-oss-5ff7499666-9g7vr   -- ls -l /data/minio-service.yaml
-rwxrwxrwx 1 root root 169 Jun 20 09:13 /data/minio-service.yaml
```
