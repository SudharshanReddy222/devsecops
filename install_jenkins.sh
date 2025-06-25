#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -e

# Install Java 17
sudo amazon-linux-extras enable corretto17
sudo yum install java-17-amazon-corretto -y

# Add Jenkins repository and install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install jenkins git -y

# Set custom Jenkins port (optional)
sudo sed -i -e 's/Environment="JENKINS_PORT=[0-9]\+"/Environment="JENKINS_PORT=8081"/' /usr/lib/systemd/system/jenkins.service

# Start Jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
