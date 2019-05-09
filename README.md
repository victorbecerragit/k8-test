# Lab scripts to deploy kubernetes on GCP using GCE.

#Deploy 3 GCE VMs - Ubuntu 18.04, with starup-script, install docker & kubernetes. 
- k8-deploy-vms.sh
#Configure docker and kubernetes on master
- k8-setup-master.sh
#Configure docker cgroup in all nodes
- docker-daemon.sh

This lab assume that you have already a user/service account configured on GCP.
Also, this lab require enable login from gcloud CLI.

1 - Deploy the vms from google CLI desktop

bash -x k8-deploy-vms.sh

2 - Login to the Master and setup kubernet

ssh master
wget https://raw.githubusercontent.com/victorbecerragit/k8-test/master/k8-setup-master.sh

bash -x k8-setup-master.sh

