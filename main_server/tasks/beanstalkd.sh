#!/usr/bin/env bash

echo "--- install beanstalkd"
sudo DEBIAN_FRONTEND=noninteractive  apt-get install -y beanstalkd supervisor
sudo systemctl enable beanstalkd
cat <(echo '## Defaults for the beanstalkd init script, /etc/init.d/beanstalkd on
## Debian systems.

BEANSTALKD_LISTEN_ADDR=0.0.0.0
BEANSTALKD_LISTEN_PORT=11300

# You can use BEANSTALKD_EXTRA to pass additional options. See beanstalkd(1)
# for a list of the available options. Uncomment the following line for
# persistent job storage.
"BEANSTALKD_EXTRA="-b /var/lib/beanstalkd""') | sudo tee /etc/default/beanstalkd
sudo systemctl start beanstalkd

sudo systemctl enable supervisor