# Lab scripts to deploy kubernetes on GCP using GCE.

#Deploy 3 GCE VMs - Ubuntu 18.04, with starup-script, install docker & kubernetes. 
- k8-deploy-vms.sh
#Configure docker and kubernetes on master
- k8-setup-master.sh
#Configure docker cgroup in all nodes
- docker-daemon.sh
