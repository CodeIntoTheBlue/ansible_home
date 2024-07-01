########################################################
 
 # # # A N S I B L E


# Update system
sudo apt update && sudo apt upgrade -y

# Install SSH server and sshpass
sudo apt install -y openssh-server sshpass

# Install Ansible and other dependencies
sudo apt install -y ansible git mariadb-server python3-pip

# Install pywinrm for Windows management
sudo pip3 install pywinrm

# Configure SSH_Config for Ansible
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Create Ansible user ansible
sudo adduser --system --group ansible
sudo usermod -aG sudo ansible

# Set up sudo rights for Ansible user ansible
echo "ansible ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ansible
sudo chmod 440 /etc/sudoers.d/ansible


sudo usermod -s /bin/bash ansible

sudo usermod -s /bin/bash ansible
sudo mkdir -p /home/ansible
sudo chown ansible:ansible /home/ansible 


# Create .ssh directory for ansible user ansible
sudo mkdir -p /home/ansible/.ssh
sudo chown ansible:ansible /home/ansible/.ssh
sudo chmod 700 /home/ansible/.ssh

# Generate Ansible SSH key
ssh-keygen -t ed25519 -C "ansible" -f ~/.ssh/ansible




# Clone the Git repository with Ansible playbooks
git clone https://github.com/CodeIntoTheBlue/ansible_home.git

# Branch wechseln
git checkout ansible_semaphore

