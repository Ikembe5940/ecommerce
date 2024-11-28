#!/bin/bash

# Install git 
sudo yum install git -y

# Clone the remote repository into local
git clone https://github.com/awanmbandi/eagles-batch-devops-projects.git

# Change directory to "eagles-batch-devops-projects"
cd eagles-batch-devops-projects

# Swtitch to the "prometheus-and-grafana" git branch
git checkout prometheus-and-grafana

# Install prometheus
sh install-prometheus.sh

# Change the hostname of the Ec2 Sever
sudo hostnamectl set-hostname Prometheus