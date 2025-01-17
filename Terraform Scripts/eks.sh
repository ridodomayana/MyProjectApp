Install kubectl
Install eksctl
Install aws cli

===============================Setup Bootstrap Server for eksctl==================================
# Install AWS Cli on the above EC2
Refer==https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ unzip awscliv2.zip
$ sudo ./aws/install
         OR
$ sudo yum remove -y aws-cli
$ pip3 install --user awscli
$ sudo ln -s $HOME/.local/bin/aws /usr/bin/aws
$ aws --version

# Installing kubectl
Refer===https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
$ curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.1/2023-04-19/bin/linux/amd64/kubectl
$ chmod +x ./kubectl 
$ mv kubectl /bin  OR $ mv kubectl /usr/local/bin
$ kubectl version --output=yaml

#Installing or eksctl
Refer==https://github.com/eksctl-io/eksctl/blob/main/README.md#installation
$ curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
$ cd /tmp
$ sudo mv /tmp/eksctl /bin   OR  $ sudo mv /tmp/eksctl /usr/local/bin
$ eksctl version

# Setup Kubernetes using eksctl
Refer===https://github.com/aws-samples/eks-workshop/issues/734
eksctl create cluster --name virtualtechbox-cluster \
--region ap-south-1 \
--node-type t2.small \
$ kubectl get nodes

# Create deployment Manifest File
Refer===https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
$ nano regapp-deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ridoapp-regapp
  labels:
     app: regapp

spec:
  replicas: 2
  selector:
    matchLabels:
      app: regapp

  template:
    metadata:
      labels:
        app: regapp
    spec:
      containers:
      - name: regapp
        image: rido4good/regapp
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1

# Create Service Manifest File 
Refer===https://kubernetes.io/docs/tutorials/services/connect-applications-service/
$ nano regapp-service.yml
apiVersion: v1
kind: Service
metadata:
  name: virtualtechbox-service
  labels:
    app: regapp 
spec:
  selector:
    app: regapp 

  ports:
    - port: 8080
      targetPort: 8080

  type: LoadBalancer

===============================Integrate Bootstrap Server with Ansible==================================
On eks - server
vi /etc/ssh/ssh_d
Password required = Yes 
Then set root password
$ passwd root
reload ssh_d
systemctl reload sshd


On Ansible server
$ nano /etc/ansible/hosts
[ansible]
localhost

[kubernetes]
BootStrap-Server-IP

$ ssh-copy-id root@BootStrap-Server-IP

# Create Ansible Playbook to Run Deployment and Service Manifest files
$ mv regapp.yml creat_image_regapp.yml 
$ nano kube_deploy.yml
---
- hosts: kubernetes
  user: root

  tasks:
    - name: deploy regapp on kubernetes
      command: kubectl apply -f regapp-deployment.yml

    - name: create service for regapp
      command: kubectl apply -f regapp-service.yml

    - name: update deployment with new pods if image updated in docker hub
      command: kubectl rollout restart deployment.apps/virtualtechbox-regapp

$ ansible-playbook kube_deploy.yml
Exec command:ansible-playbook /opt/Docker/kube_deploy.yml

kubectl get nodes
kubectl get pods
kubectl get svc
kubectl get all

===============================Cleanup==================================
$ kubectl delete deployment.apps/virtualtechbox-regapp
$ kubectl delete service/virtualtechbox-service
$ eksctl delete cluster virtualtechbox --region ap-south-1     OR    eksctl delete cluster --region=ap-south-1 --name=virtualtechbox-cluster
