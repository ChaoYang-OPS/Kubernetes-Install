# install istio

```shell
CP
curl -L https://istio.io/downloadIstio | sh -
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   102  100   102    0     0    223      0 --:--:-- --:--:-- --:--:--   224
100  4549  100  4549    0     0   9464      0 --:--:-- --:--:-- --:--:--  9464

Downloading istio-1.12.2 from https://github.com/istio/istio/releases/download/1.12.2/istio-1.12.2-linux-amd64.tar.gz ...

Istio 1.12.2 Download Complete!

Istio has been successfully downloaded into the istio-1.12.2 folder on your system.

Next Steps:
See https://istio.io/latest/docs/setup/install/ to add Istio to your Kubernetes cluster.

To configure the istioctl client tool for your workstation,
add the /root/istio-1.12.2/bin directory to your environment path variable with:
         export PATH="$PATH:/root/istio-1.12.2/bin"

Begin the Istio pre-installation check by running:
         istioctl x precheck 

Need more information? Visit https://istio.io/latest/docs/setup/install/ 
root@172-16-100-62:~# cat /etc/profile.d/istio.sh
export PATH="$PATH:/root/istio-1.12.2/bin"
root@172-16-100-62:~# source /etc/profile.d/istio.sh
root@172-16-100-62:~# istioctl version
no running Istio pods in "istio-system"
1.12.2
root@172-16-100-62:~# istioctl install --set profile=demo -y
Detected that your cluster does not support third party JWT authentication. Falling back to less secure first party JWT. See https://istio.io/v1.12/docs/ops/best-practices/security/#configure-third-party-service-account-tokens for details.
! values.global.jwtPolicy is deprecated; use Values.global.jwtPolicy=third-party-jwt. See http://istio.io/latest/docs/ops/best-practices/security/#configure-third-party-service-account-tokens for more information instead
✔ Istio core installed                                                                                                         
✔ Istiod installed                                                                                                             
✔ Ingress gateways installed                                                                                                   
✔ Egress gateways installed                                                                                                    
✔ Installation complete                                                                                                        Making this installation the default for injection and validation.

Thank you for installing Istio 1.12.  Please take a few minutes to tell us about your install/upgrade experience!  https://forms.gle/FegQbc9UvePd4Z9z7
root@172-16-100-62:~# kubectl get pods -n istio-system
NAME                                    READY   STATUS    RESTARTS   AGE
istio-egressgateway-7448498979-76j28    1/1     Running   0          46s
istio-ingressgateway-679d96497c-mqxc9   1/1     Running   0          3m53s
istiod-5c879c65c7-jsnx6                 1/1     Running   0          7m6s
```