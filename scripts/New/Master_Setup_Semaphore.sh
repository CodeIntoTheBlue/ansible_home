#########################################################################################

# S E M A P H O R E

# Update system
sudo apt update && sudo apt upgrade -y

# create a system user for semaphore
sudo adduser --system --group --home /home/semaphore semaphore

# Set up MariaDB
sudo mysql_secure_installation <<EOF

y
rootdbpasswort
rootdbpasswort
y
y
y
y
EOF

# Create Semaphore database and user
sudo mariadb <<EOF
CREATE DATABASE semaphore_db;
GRANT ALL PRIVILEGES ON semaphore_db.* TO semaphore_user@localhost IDENTIFIED BY 'passwortuser';
FLUSH PRIVILEGES;
EOF

# Install Semaphore
# search for the latest and upgrade link (manually)
wget https://github.com/semaphoreui/semaphore/releases/download/v2.10.7/semaphore_2.10.7_linux_amd64.deb
sudo apt install ./semaphore_2.10.7_linux_amd64.deb

# Set up Semaphore
sudo semaphore setup <<EOF

1

semaphore_user
passwortuser
semaphore_db




janina
janinahc@outlook.com
Janina HC
passwort
EOF




# user:group change ownership
sudo chown semaphore:semaphore config.json

# directory erstellen
sudo mkdir /etc/semaphore/.ssh

# copy ansible pub key to the directory
sudo cp ~/.ssh/ansible.pub /home/semaphore/.ssh/ansible.pub

# change ownership
sudo chown semaphore:semaphore /etc/semaphore

# config.json verschieben
sudo mv config.json /etc/semaphore/


# Create initial config.json
sudo cat << EOF > /etc/semaphore/config.json
{
    "master_server": "$(hostname -I | awk '{print $1}')",
    "linux_servers": [],
    "windows_clients": []
}
EOF


# creating systemd service for semaphore
# to run each time the server itself restarts

cat << EOF | sudo tee /etc/systemd/system/semaphore.service
[Unit]
Description=Ansible Semaphore
Documentation=https://docs.ansible-semaphore.com/
Wants=network-online.target
After=network-online.target
ConditionPathExists=/usr/bin/semaphore
ConditionPathExists=/etc/semaphore/config.json

[Service]
ExecStart=/usr/bin/semaphore server --config /etc/semaphore/config.json
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
RestartSec=10s
User=semaphore
Group=semaphore

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable semaphore.service
sudo systemctl start semaphore.service


# to ensure Semaphore can run commands
# giving sudo rights
echo "semaphore ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/semaphore
