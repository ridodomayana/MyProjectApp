sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install java-17-amazon-corretto -y
sudo yum install jenkins -y

#----------------Install Jenkins-----------------------------
# Become a root
sudo su -
# Jenkins repo is added to yum.repos.d
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
# Import key from Jenkins
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# Install Java-11
amazon-linux-extras install java-openjdk17 -y
# Install Jenkins
yum install jenkins -y
#------Start Jenkins------
# Become a root, no need to execute if you are alread root.
sudo su -
# You can enable the Jenkins service to start at boot with the command:
systemctl enable jenkins
# You can start the Jenkins service with the command:
systemctl start jenkins
# You can check the status of the Jenkins service using the command:
systemctl status jenkins

#########--------Install Jenkins on Ubuntu----########
sudo apt update
sudo apt install fontconfig openjdk-17-jre
java -version
openjdk version "17.0.13" 2024-10-15
OpenJDK Runtime Environment (build 17.0.13+11-Debian-2)
OpenJDK 64-Bit Server VM (build 17.0.13+11-Debian-2, mixed mode, sharing)

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

############---------------------###################


############------Install Maven & Set Home Path for Java and Maven-----------##############
#####-- find / -name java-17*-------#################
#####-- Modify the .bash_profile file-----(source .bash_profile) to rebooth #################

# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto.x86_64
M2_HOME=/opt/maven
M2=/opt/maven/bin

# User specific environment and startup programs

PATH=$PATH:$HOME/bin:$JAVA_HOME:$M2_HOME:$M2

export PATH


#######----To Set Java Home in Ubuntu-------#######
# to laocate java directory------ find / -name java-17*

# Add environment variable settings to ~/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/default-java' >> ~/.bashrc
echo 'export M2_HOME=/usr/bin/maven' >> ~/.bashrc
source ~/.bashrc

$ source /etc/bashrc
$ echo $JAVA_HOME

sudo gedit jenkins.service in /etc/systemd/system/multi-user.target.wants

Uncomment JAVA_HOME variable in jenkins.service file and set to your JDK directory (in my case /usr/local/bin/jdk-17.0.7)

Environment="JAVA_HOME=/usr/local/bin/jdk-17.0.7"



---------------------------------------------------------------------

Plugins to install and Configure when connecting to SonarQube etc

Maven Integration, 
Pipeline Maven Integration
Eclipse Temurin Installer


------------------------------------------------------
OWAPS Dependency Checks for Jenkins Server

Install the Plugin on Jenkins
Tools --> Add Dependency Check --> Give Name --> Install Automatically from github.com
