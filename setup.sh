#!/bin/bash

sudo apt-get update
sudo apt-get -y install curl
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null 
sudo apt-get update
sudo apt-get -y install openjdk-11-jre-headless
echo java -version 
sudo apt-get -y install jenkins
systemctl daemon-reload
systemctl start jenkins 
systemctl enable jenkins

echo "install git"
sudo apt-get -y install git

echo "install unzip"
sudo apt-get install unzip

echo "Setup SSH key"
sudo mkdir /var/lib/jenkins/.ssh
touch /var/lib/jenkins/.ssh/known_hosts
sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
sudo chmod 700 /var/lib/jenkins/.ssh
sudo mv /tmp/id_rsa /var/lib/jenkins/.ssh/id_rsa
sudo chmod 600 /var/lib/jenkins/.ssh/id_rsa
sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa

echo "configure jenkins"
sudo mkdir -p /var/lib/jenkins/init.groovy.d
sudo mv /tmp/scripts/*.groovy /var/lib/jenkins/init.groovy.d/ 
chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d
sudo mv /tmp/jenkins /etc/NetworkManager/dispatcher.d/jenkins
sudo chmod +x /tmp/install-plugins.sh 
sudo bash /tmp/install-plugins.sh 
systemctl start jenkins
