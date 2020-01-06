#!/usr/bin/env bash

echo "--- installing openresty"
# import our GPG key:
wget -qO - https://openresty.org/package/pubkey.gpg | sudo apt-key add -
# for installing the add-apt-repository command
# (you can remove this package and its dependencies later):
sudo DEBIAN_FRONTEND=noninteractive  apt-get -y install software-properties-common
# add the our official APT repository:
sudo add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main"

# to update the APT index:
sudo DEBIAN_FRONTEND=noninteractive  apt-get update
sudo DEBIAN_FRONTEND=noninteractive  apt-get install -y openresty

sudo mkdir -p /etc/systemd/system/openresty.service.d /usr/local/openresty/nginx/conf/sites-enabled/
cat << "EOF" | sudo tee /etc/systemd/system/openresty.service.d/override.conf 
[Service]
PIDFile=/run/nginx.pid
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pid $MAINPID
Restart=on-failure
RestartSec=10s

EOF

echo "pid /run/nginx.pid;" | sudo tee -a /usr/local/openresty/nginx/conf/nginx.conf