#!/bin/bash

# Directory to hold docker volumes
MOUNTPOINT=/mnt/sda1
mkdir $MOUNTPOINT/docker

# Stop the Docker service
systemctl stop docker.service

# Remove old Versions of Docker
apt-get remove -y docker-ce docker docker-engine docker.io containerd runc

# Update computer
apt-get update -y

# Installed packages requried for apt to install repo over HTTPS
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Dockers official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set to use the stable repository
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

# Install Docker and dependincies
apt-get -y install docker-ce docker-ce-cli containerd.io

# Add a docker group
groupadd docker

# Add user to docker group
usermod -aG docker $USER

# Configure the Docker Daemon for remote use and 
# set the volume directory to mountpoint
printf "{\\n  \"data-root\":\"$MOUNTPOINT/docker\"\\n}" > /etc/docker/daemon.json

# Enable Docker
systemctl enable --now docker.service