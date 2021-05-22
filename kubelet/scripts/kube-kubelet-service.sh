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
      --node-labels=node.kubernetes.io/node='' \
      --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1