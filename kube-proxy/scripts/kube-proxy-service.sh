#!/bin/bash
../bin/kube-proxy  \
      --v=2 \
      --logtostderr=true \
      --log-dir=/opt/logs/kubernetes/kube-proxy-service \
      --config=/etc/kubernetes/kube-proxy.conf