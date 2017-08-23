#! /bin/bash

read -p "Sudo user username?" USER
if [[ ! $PUB ]]; then read -p "SSH pubkey: " PUB; fi

#add User and sudo
adduser $USER
adduser $USER sudo
mkdir /home/$USER/.ssh
touch /home/$USER/.ssh/authorized_keys
echo "$PUB" > /home/$USER/.ssh/authorized_keys
chmod 700 /home/${USER}/.ssh
chmod 600 /home/${USER}/.ssh/authorized_keys
chown ${USER}:${USER} /home/${USER}/.ssh/authorized_keys
chown ${USER}:${USER} /home/${USER}/.ssh

# disable password and root over ssh
sed -i -e "s/PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -e "s/#PermitRootLogin no/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -e "s/PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
sed -i -e "s/#PasswordAuthentication no/PasswordAuthentication no/" /etc/ssh/sshd_config
systemctl restart sshd

#Upgrade
apt-get update && apt-get upgrade -y
echo
echo All Set!  Lets check sshd configs
echo
sleep 5
cat /etc/ssh/sshd_config | grep -i 'PasswordA\|root\|pub' |grep -v '#'
echo
echo Right Right, Chip Chip lets get some useful things
sleep 5

#Install packages
apt-get -y install nmap
apt-get -y install ncdu
apt-get -y install wget
apt-get -y install htop
