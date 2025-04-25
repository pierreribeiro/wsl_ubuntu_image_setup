#!/bin/bash
if (( $EUID != 0 )); then
  echo 'Run script as root'
  exit
fi

echo 'Ensure /etc/resolv.conf isnt symlink'
if [[ -L "/etc/resolv.conf" ]]; then
  echo 'Removing symlink file: /etc/resolv.conf'
  sudo rm "/etc/resolv.conf"
  echo 'Removed symlink file: /etc/resolv.conf'
fi

# Fix network issues as first step and this would need to be done manually since wont have connectivity out of WSL
echo 'nameserver 8.8.8.8' > /etc/resolv.conf
echo '[network]' > /etc/wsl.conf
echo 'generateResolvConf = false' >> /etc/wsl.conf

# Install Proper Certificates
mkdir /usr/local/share/ca-certificates/school
cd /usr/local/share/ca-certificates/school
# Copy any required certificates 
sudo update-ca-certificates

# Install Ansible To Leverage That For Rest of Setup Work
apt-get update
apt install python3-pip -y
pip install ansible

# Pull down from repository and run playbook
cd /
git clone https://github.com/mattdclark31/wsl_ubuntu_image_setup.git
cd /wsl_ubuntu_image_setup
git pull
ansible-playbook init.yml
