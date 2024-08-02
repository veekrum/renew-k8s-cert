### This script will Renew the certificate that is expired anually ###
### processList ###
## check expiration
## create a backup folder and copy all the old certs
## renew certs
## move the kublet.conf to tmp
## generate the kubelet.conf
## restart the kubelet service
## restart all the service pods
## Wait a while
## copy the config
## finish

#!/bin/bash

echo " #### check expiration date ####"
kubeadm certs check-expiration

echo "### create a backup folder and backup all the old files"
mkdir -p /$HOME/backup
cp -r /etc/kubernetes/* /root/backup/

echo " ####  Running Renew certs command  #### "
kubeadm certs renew all

echo " ### Moving kubelet.conf #### "
mv /etc/kubernetes/kubelet.conf /tmp/

echo " ### Generating kubelet conf ### "
kubeadm init phase kubeconfig kubelet

echo " ### Restaring kubelet service ### "
sudo systemctl restart kubelet

sleep 2s
echo "### Restarting the apiserver pods ### " 
crictl pods | grep kube-apiserver | awk '{print $1}' | xargs crictl stopp

echo "### Restarting the kube-controller-manager pods ### " 
sleep 2s
crictl pods | grep kube-controller-manager | awk '{print $1}' | xargs crictl stopp

echo "### Restarting the kube-scheduler pods ### " 
sleep 2s
crictl pods | grep kube-scheduler | awk '{print $1}' | xargs crictl stopp

echo "### Restarting the etcd pods ### " 
sleep 2s
crictl pods | grep etcd | awk '{print $1}' | xargs crictl stopp

echo " #### Wait a while till all the service pods gets up and running #### "
sleep 25s

echo " ### Copying config to .kube/config ###"
mkdir -p /$HOME/.kube
rm -rf /$HOME/.kube/config
sudo cp -i /etc/kubernetes/admin.conf /$HOME/.kube/config
sudo chown root:root /$HOME/.kube/config

echo " ### Finished ### "
