#!/bin/bash

sudo apt-get install -y adduser libfontconfig1

# Change the hostname of the Ec2 Sever
sudo hostnamectl set-hostname grafana-server

# Download the package
wget https://dl.grafana.com/oss/release/grafana_7.3.4_amd64.deb

# Install the package
sudo dpkg -i grafana_7.3.4_amd64.deb

# Reload the daemon system
sudo systemctl daemon-reload

# Launch Grafana
sudo systemctl enable grafana-server.service
sudo systemctl start grafana-server
sudo systemctl status grafana-server


