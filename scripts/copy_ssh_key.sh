#!/bin/bash

# Set the username and the path to the SSH key on the local machine
username=janina
ssh_key_path=~/.ssh/ansible

# Set the list of remote Linux servers
servers=(
    192.168.178.71
    192.168.178.72
)

# Loop through the servers and copy the SSH key
for server in "${servers[@]}"
do
    echo "Copying SSH key to linux $server..."
    ssh-copy-id -i $ssh_key_path $username@$server
done




# Set the username and the path to the SSH key on the local machine
username=ansible
ssh_key_path=~/.ssh/ansible
#################################### Windows 
servers=(
    192.168.178.74
    192.168.178.75
    
    192.168.178.79
    192.168.178.80
    192.168.178.81   
)

# Loop through the servers and copy the SSH key
for server in "${servers[@]}"
do
    echo "Copying SSH key to windows $server..."
    scp $ssh_key_path $username@$server:C:/Users/$username/.ssh/authorized_keys
done


