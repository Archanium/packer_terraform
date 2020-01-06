#!/bin/bash
set -e

echo '---- install Docker'
echo 'Installing docker key'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "Verifying docker key"
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
echo "see if something is running"
ps aux | grep -i apt
echo "Updating apt repos"
sudo DEBIAN_FRONTEND=noninteractive apt-get -y update

echo "Installing docker-ce"
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install docker-ce

echo "modifying user groups"
sudo usermod --append --groups docker ubuntu

echo "Pulling freegeoip"
sudo docker pull fiorix/freegeoip