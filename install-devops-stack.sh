#!/bin/bash

echo "----- Updating system -----"
sudo apt update -y && sudo apt upgrade -y

echo "----- Installing Java (OpenJDK 17) -----"
sudo apt install -y openjdk-17-jdk

echo "----- Installing Jenkins -----"
# Add Jenkins GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /etc/apt/keyrings/jenkins.asc > /dev/null

# Add Jenkins repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins.asc] https://pkg.jenkins.io/debian binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update and install Jenkins
sudo apt update -y
sudo apt install -y jenkins

# Start and enable Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "----- Installing Docker -----"
# Prerequisites
sudo apt install -y ca-certificates curl gnupg lsb-release apt-transport-https software-properties-common

# Docker GPG key and repo
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker
sudo systemctl enable docker
sudo systemctl start docker

# Allow Jenkins and current user to use Docker
sudo usermod -aG docker jenkins
sudo usermod -aG docker $USER

echo "----- Installing Ansible and SSH Utilities -----"
sudo apt install -y ansible sshpass

echo "----- Disabling Ansible SSH host key checking -----"
echo -e "[defaults]\nhost_key_checking = False" | sudo tee -a /etc/ansible/ansible.cfg > /dev/null

echo "----- Installation Complete -----"
echo "Versions:"
java -version
jenkins --version
docker --version
ansible --version

