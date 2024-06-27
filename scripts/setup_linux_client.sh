#!/bin/bash

# setup_linux_client.sh

# Read configuration
CONFIG=$(cat config.json)
LINUX_SERVERS=$(echo $CONFIG | jq -r .linux_servers[])

# Update system
sudo apt update && sudo apt upgrade -y

# Install SSH server and jq
sudo apt install -y openssh-server jq

# Configure SSH for Ansible
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Create Ansible user Simone
sudo adduser --system --group simone
sudo usermod -aG sudo simone

# Set up sudo rights for Ansible user simone
echo "simone ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/simone
sudo chmod 440 /etc/sudoers.d/simone

# Create .ssh directory for ansible user simone
sudo mkdir -p /home/simone/.ssh
sudo chown simone:simone /home/simone/.ssh
sudo chmod 700 /home/simone/.ssh

echo "Linux client/server has been set up for Ansible management."
echo "The Ansible SSH key will be deployed from the master server."

# Output server IP for verification
SERVER_IP=$(hostname -I | awk '{print $1}')
if [[ " ${LINUX_SERVERS[@]} " =~ " ${SERVER_IP} " ]]; then
    echo "This server ($SERVER_IP) is correctly listed in the configuration."
else
    echo "Warning: This server ($SERVER_IP) is not listed in the configuration file."
fi