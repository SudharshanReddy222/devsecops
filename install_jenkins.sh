#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -e

# -------------------------------
# ✅ 1. Install Java 17 & Jenkins
# -------------------------------

sudo amazon-linux-extras enable corretto17
sudo yum install -y java-17-amazon-corretto

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install -y jenkins git

# Optional: Change Jenkins port to 8081
sudo sed -i -e 's/Environment="JENKINS_PORT=[0-9]\+"/Environment="JENKINS_PORT=8081"/' /usr/lib/systemd/system/jenkins.service

# Start Jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# -------------------------------
# ✅ 2. Install Docker
# -------------------------------

sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins

# Apply group changes
newgrp docker

# -------------------------------
# ✅ 3. Install AWS CLI
# -------------------------------

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo yum install unzip -y
unzip awscliv2.zip
sudo ./aws/install

# -------------------------------
# ✅ 4. Install ZAP (OWASP)
# -------------------------------

wget https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2_14_0_unix.sh
chmod +x ZAP_2_14_0_unix.sh
./ZAP_2_14_0_unix.sh -q

# -------------------------------
# ✅ 5. Install kubectl
# -------------------------------

curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo cp ./kubectl /usr/local/bin/

# -------------------------------
# ✅ 6. Install eksctl
# -------------------------------

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# -------------------------------
# ✅ 7. Install jq
# -------------------------------

sudo yum install -y jq
