#!/bin/bash
set -e

echo "---- set locale"
sudo locale-gen C.UTF-8 || true
sudo update-locale LANG=en_US.UTF-8
sudo /bin/bash -c 'echo "export LANG=C.UTF-8" >> /etc/skel/.bashrc'

echo "---- make Apt non interactive"
sudo /bin/bash -c 'echo "force-confnew" >> /etc/dpkg/dpkg.cfg'
sudo /bin/bash -c 'echo "DPkg::options { \"--force-confdef\"; };" >> /etc/apt/apt.conf'
echo "---- Remove the automatic update checks"
cat | sudo tee /etc/apt/apt.conf.d/99disableAuto <<__EOF
APT::Periodic::Enable "0";
// undo what's in 20auto-upgrade
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
__EOF

sudo systemctl stop apt-daily.timer
sudo systemctl disable apt-daily.timer
sudo systemctl mask apt-daily.service
sudo systemctl daemon-reload

echo "%admin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/no_passwd_admin

