create a new user: useradd ansadmin
passwd ansadmin passwd123

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
webapp/target/*.war
remove prefix --- webapp/target
remote directory --- //opt//docker







