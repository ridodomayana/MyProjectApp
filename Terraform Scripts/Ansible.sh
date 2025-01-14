create a new user: useradd ansadmin
passwd ansadmin rido

Add to sudo group
visudo
ansadmin ALL=(ALL) NOPASSWD: ALL

Enable Passwordless Authentication
vi /etc/ssh/sshd_config
PasswordAUthentication yes

systemctl reload sshd


----------------------
switch user to ansadmin
create the keygen to map ansadmin to host
ssh-keygen

ls .ssh

-----------------------------------
switch to back to root
Install Ansible to the main-root user account
amazon-linux-extras install ansible2
------------------------------------

Integrate Ansible with Jenkins
Install Publish Over SSH
Manage Jenkins --> System ----> Publish over ssh
Configure ssh server

------------------------------------------------
Install Docker in Ansadmin

(D0 below actions Inside ansadmin)
cd /opt
create dir docker (mkdir docker)
change ownership to ansadmin (sudo chown ansadmin:ansadmin docker)

## Test it out on Jenkins
Add post build action
Send over ssh
select ansible server
webapps/target/*.war
remove prefix --- webapps/target
remote directory --- //opt//docker

Download docker inside ansadmin
cd into docker directory
sudo yum install docker
add Docker to ansadmin
sudo usermod -aG docker ansadmin
systemctl start docker
restart the server.

------Create DockerFile---
vi Dockerfile
FROM tomcat:latest
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
COPY ./*.war /usr/local/tomcat/webapps/register.war

-----Create Ansible Playbook for Docker Task ---
if config to copy ansadmin ip address

sudo vi /etc/ansible/hosts

[ansible]
-input Ansible private IP

ssh-copy-id *Private IP of the Ansible-Server*
-------------------------------
Create Manifest file 
vi register-ci.yml
- hosts: ansible
tasks:
- name: create docker image
  command: docker build -t register:latest .
  args:
   chdir: /opt/docker

- name: create tag to push image onto dockerhub
  command: docker tag register:latest rido4good/register:latest

- name: push docker image
  command: docker push rido4good/register:latest

--------------------------------------------------
ansible-playbook register-ci.yml --check
------------------------
docker login -u rido4good
-----------------------
run playbook to test

#######################---CREATE CI JOB----##########################
create new Jenkins job, Register-CI


https://www.youtube.com/watch?v=NKUOSc9pCfk







