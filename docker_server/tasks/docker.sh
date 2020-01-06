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
echo '{
"hosts":["unix:///var/run/docker.sock","tcp://0.0.0.0:2375"]
}' | sudo tee /etc/docker/daemon.json
sudo mkdir -p /etc/systemd/system/docker.service.d/
echo '[Service]
ExecStart=
ExecStart=/usr/bin/dockerd' | sudo tee /etc/systemd/system/docker.service.d/docker.conf
sudo systemctl daemon-reload