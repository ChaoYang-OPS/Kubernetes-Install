#!/bin/bash
../bin/kube-scheduler \
      --v=2 \
      --logtostderr=true \
      --address=127.0.0.1 \
      --leader-elect=true \
      --log-dir=/opt/logs/kubernetes/kube-scheduler-service \
      --kubeconfig=../conf/kube-scheduler.kubeconfig