#!/usr/bin/env bash
echo "--- install java"
sudo DEBIAN_FRONTEND=noninteractive  apt-get update
sudo DEBIAN_FRONTEND=noninteractive  apt-get install -y default-jre
