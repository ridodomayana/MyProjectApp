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
$ eksctl version ##***If you are unable to get the version with bash:eksctl: command not found error" #run this comand (export PATH=$PATH:/usr/local/bin/)

# Setup Kubernetes using eksctl
Refer===https://github.com/aws-samples/eks-workshop/issues/734
eksctl create cluster --name virtualtechbox-cluster \
--region ap-south-1 \
--node-type t2.small \
$ kubectl get nodes

############-----------IF KUBECTL IS NOT COMPATIBLE RUNNING-----############
cd
mv kubectl kubectl_1.24
mv bin bin_1.24 
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.15/2023-01-11/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
kubectl version

Finally, update your cluster
aws eks update-kubeconfig --region us-east-2 --name rido-cluster
########################################################


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
PermitRootLogin = Yes
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



############****CREATE ARGO CD****############
$ kubectl create namespace argocd
$ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
$ kubectl get pods -n argocd
$ curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.7/argocd-linux-amd64
$ chmod +x /usr/local/bin/argocd
$ kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
$ kubectl get svc -n argocd
$ kubectl get secret argocd-initial-admin-secret -n argocd -o yaml
$ echo XXXXXXX | base64 --decode        #Replace the XXXXX with the password

Login with the LoadBalancer URL
Username: admin
Decode Password is the Password

----------------------
User Info -> Update Password.
Log out and Log Back in with New Password
password is : Admin123!

----Add EKS to Argo CD---
Log into ArgoCd from Cli
argocd login **url of the argocd load balancer --username admin
argocd cluster list

Add eks-cluster to the argoCd
kubectl config get-contexts
argocd cluster add **name-of-ekscluster(That was gotten from the kubectl config get-contexts) --name **EKS-cluster-name
argocd cluster list

--------------------------------------------------------
Connect the Deployment.Yaml file and Service.Yml file in gitops-register-app on GitHubs to ArgoCD

Go to ArgoCd Dashboard --> Settins --> Repository --> COnnect REPO --> VIA HTTPS --> Type = git --> Project = default --> Github url --> Github Usernme and Github token for password --> Connect

Deploy Resources
NOTE: The name and Image ID in Deployment.yml must match the dockerhub image
Applications --> New Apps -> name = register-app --> Project Name = default --> Sync Policy = Automatic: Check PRUNE & SELF HEAL --> SOURCE repo url = gitops url --> Revision = HEAD --> Path = ./ 

--> Destination Clusterurl = eks cluster --> namespace = default. (CREATE).

Kubectl get pods
kubectl get svc to get your external Ip of load balancer. access on port 8080/webapp

----------------------------------------------------------

COnfigure CD job
This project is parameterized
String parameter
name = IMAGE_TAG

Trigger Build Remotely
Authentication Token = gitops-token

------------------------------
Set and Define Jenkins API Token 
Under Jenkins Username --> API Token -- ADD New -- JENKINS_API_TOKEN ---> GENERATE.

Copy the GENERATED TOKEN by highlighing and CTR C - Save on local system
Use the token to create secret text credentials for Jenkins
ID = JENKINS_API_TOKEN.

Add JENKINS_API_TOKEN to environement variables on Jenkinsfile

------------------
Create JenkinsFile in GitOps


###########--------------- WHEN Launching the Deployed App ---------------####
http://a44e2fde83a1249539ae3a60bbac7a1e-1126287126.us-east-2.elb.amazonaws.com:8080/webapp/











