#!/bin/bash

# Set the username and the path to the SSH key on the local machine
username=simone
ssh_key_path=~/.ssh/ansible.pub

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
    # adding them to the known_hosts
    echo "Copying SSH key to known_hosts $server..."
    ssh-keyscan -H $server >> ~/.ssh/known_hosts


done


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
    # adding them to the known_hosts
    echo "Copying SSH key to known_hosts $server..."
    ssh-keyscan -H $server >> ~/.ssh/known_hosts
done


