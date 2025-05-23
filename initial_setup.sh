#!/bin/bash
if (( $EUID != 0 )); then
  echo 'Run script as root'
  exit
fi

echo 'This script is designed to be run on a fresh install of WSL Ubuntu.'
<< 'COMMENT'
This commented code is deprecated. Mainly used for reference.

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
# sudo update-ca-certificates
COMMENT

# Install Required Packages
# Install Ansible To Leverage That For Rest of Setup Work
apt install software-properties-common -y
apt-add-repository -y ppa:ansible/ansible
apt update && apt -y upgrade
apt install net-tools -y
apt install ansible -y
apt install pipx -y
#pipx install ansible-dev-tools
#pipx ensurepath

echo 'Pull down from repository and run playbook'
cd /
#git clone 1https://github.com/mattdclark31/wsl_ubuntu_image_setup.git
git clone https://github.com/pierreribeiro/wsl_ubuntu_image_setup.git
cd /wsl_ubuntu_image_setup
git pull
# Solicitar parâmetros do usuário
read -p "Digite o nome do usuário: " user_param
read -p "Digite o nome do grupo: " group_param
read -p "Continuar com a execução? (Y/N): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    pwd
    echo "Executando o playbook com os parâmetros fornecidos..."
    export ANSIBLE_STDOUT_CALLBACK=ansible.posix.debug
    export ANSIBLE_LOG_PATH=/tmp/ansible.log
    ansible-playbook playbook.yml --extra-vars "user=$user_param group=$group_param" -vvv
    echo "Playbook executado com sucesso."
    echo "Verificando o log do Ansible..."
    cat /tmp/ansible.log
    echo "Processo concluído."
else
    echo "Execução abortada pelo usuário."
    exit 1
fi
