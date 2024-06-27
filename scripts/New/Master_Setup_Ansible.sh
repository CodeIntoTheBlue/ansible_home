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

# Generate Ansible SSH key
ssh-keygen -t ed25519 -C "ansible" -f ~/.ssh/ansible




# Clone the Git repository with Ansible playbooks
git clone https://github.com/CodeIntoTheBlue/ansible_home.git

# Branch wechseln
git checkout ansible_semaphore

