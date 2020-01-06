#!/usr/bin/env bash
echo "--- install metricbeat"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
# for installing the add-apt-repository command
sudo apt-get install -y apt-transport-https
# (you can remove this package and its dependencies later):
echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
# to update the APT index:
sudo DEBIAN_FRONTEND=noninteractive  apt-get update
sudo DEBIAN_FRONTEND=noninteractive  apt-get install -y metricbeat
sudo systemctl enable metricbeat
