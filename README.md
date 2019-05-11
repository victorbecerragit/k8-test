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

$wget https://raw.githubusercontent.com/victorbecerragit/k8-test/master/k8-deploy-vms.sh

bash -x k8-deploy-vms.sh

2 - Login to the Master and setup kubernet

login ssh master
$wget https://raw.githubusercontent.com/victorbecerragit/k8-test/master/k8-setup-master.sh

bash -x k8-setup-master.sh


-Ref:
.https://kubernetes.io/docs/setup/cri/

.https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/

.https://medium.com/infrastructure-adventures/centralized-ssh-login-to-google-compute-engine-instances-d00f8654f379


#Setup gcloud init (define user and project to use)
gcloud init

# Setup ssh key to ssh remote to GCP project # 
gcloud compute project-info add-metadata --metadata enable-oslogin=TRUE

# Upload your local user SSH key to the google CLI project #

gcloud compute os-login ssh-keys add --key-file ~/id_rsa.pub

gcloud compute instances list

NAME                       ZONE            MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP      STATUS

k8-master                  us-central1-a   n1-standard-1               10.128.0.39  104.198.169.234  RUNNING

k8-worker-1                us-central1-b   g1-small                    10.128.0.40  35.238.109.68    RUNNING

k8-worker-2                us-central1-c   g1-small                    10.128.0.41  35.239.94.25     RUNNING


#Login to the GCE VM with your local user 
(same user which is the service account defined on GCP for your project)

ssh <local_user>@104.198.169.234
