#!/usr/bin/env bash

config="PrintLastLog yes
TCPKeepAlive yes
PermitRootLogin no
PasswordAuthentication no
X11Forwarding no
IgnoreRhosts yes
PermitEmptyPasswords no
MaxAuthTries 3
PubkeyAuthentication yes
Protocol 2"

echo "${config}" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart ssh.service
