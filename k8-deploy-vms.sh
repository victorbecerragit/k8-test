#!/bin/bash

# This script assume that you have already setup Google CLI "gcloud init" with a project and user authenticated.
# Set debug level for better troubleshooting.
# GCE startup script output shows up in "/var/log/syslog" .
set -xe

#Startup_script that will be executed on each VM during the first boot.
#Install required packages in all VMs, included docker and kubernetes
cat > startup_script.sh <<EOF
# Install Google's Stackdriver logging agent, as per
# https://cloud.google.com/logging/docs/agent/installation
#
curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
bash install-logging-agent.sh

# Make sure installed packages are up to date with all security patches.
sudo apt-get -y update  && sudo apt-get -y upgrade

#Install tools packages like apt-add-repository, apt-transport-https , bash-completion
sudo apt-get -y install software-properties-common ca-certificates curl apt-transport-https bash-completion

#Download and add the apt-key from google repository
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Add to the local repository the kubernetes-bionic & kubernetes-xenial
#sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-bionic main"
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" 
sudo apt-add-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

## Install Docker CE.
apt-get update && apt-get install docker-ce=18.06.2~ce~3-0~ubuntu
sudo apt-get -y install docker-ce
sudo systemctl enable docker

#Install kubeadm & kubelet
sudo apt-get -y install kubeadm kubelet kubernetes-cni --allow-unauthenticated

#Disable swap as is not supported on kubernetes
sudo swapoff -a

EOF

#Check your current configuration of gcloud.
gcloud config list

#Create Node Master
echo " Create VM Master \n"
gcloud compute instances create k8-master --machine-type n1-standard-1  \
--scopes https://www.googleapis.com/auth/devstorage.full_control,https://www.googleapis.com/auth/compute \
--metadata-from-file startup-script=startup_script.sh \
--image-family ubuntu-minimal-1804-lts  --image-project ubuntu-os-cloud --subnet default --zone us-central1-a

#Create VM Worker1
echo " Create Node Worker1 \n"
gcloud compute instances create k8-worker-1 --machine-type g1-small  \
--scopes https://www.googleapis.com/auth/devstorage.full_control,https://www.googleapis.com/auth/compute \
--metadata-from-file startup-script=startup_script.sh \
--image-family ubuntu-minimal-1804-lts  --image-project ubuntu-os-cloud --subnet default --zone us-central1-b

#Create Node Worker2
echo " Create VM Worker2 \n"
gcloud compute instances create k8-worker-2 --machine-type g1-small  \
--scopes https://www.googleapis.com/auth/devstorage.full_control,https://www.googleapis.com/auth/compute \
--metadata-from-file startup-script=startup_script.sh \
--image-family ubuntu-minimal-1804-lts  --image-project ubuntu-os-cloud --subnet default --zone us-central1-c

#Enable port 80 for http in "default" network.
gcloud compute --project=challenge-lab-228920 firewall-rules create nginx-allow-http --direction=INGRESS \
--network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0

#List VMs created.
gcloud compute instances list
