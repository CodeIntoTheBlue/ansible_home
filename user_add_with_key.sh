sudo -i
useradd -m -s /bin/bash ansible
passwd ansible
passworti

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4uZMBl5Kw9+tH5UZmv6ByQgycS0dfDnb1psDDttJQp ansible" >>/home/ansible/.ssh/authorized_keys
