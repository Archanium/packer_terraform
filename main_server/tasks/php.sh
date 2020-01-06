#!/usr/bin/env bash
set -e

echo "---- install php"
sudo DEBIAN_FRONTEND=noninteractive  apt-get install -y \
    php7.2-fpm \
    php7.2-cli \
    php7.2-common \
    php7.2-curl \
    php7.2-json \
    php7.2-soap \
    php7.2-mysql \
    php7.2-readline \
    php7.2-intl \
    php7.2-mbstring \
    php7.2-gd \
    php7.2-dev \
    php7.2-opcache \
    php7.2-xml \
    php7.2-zip \
    php7.2-bcmath \
    php-mongodb \
    php-memcached \
    php-igbinary



cat << EOF | sudo tee -a /etc/php/7.2/fpm/conf.d/99-dreamabout.ini
### DREAMSHOP SETTINGS
max_input_vars=1000000
memory_limit=768M
post_max_size=100M

EOF

cat << EOF | sudo tee /etc/php/7.2/fpm/pool.d/www.conf
[www]
user = www-data
group = www-data
listen = 127.0.0.1:7777
listen = /run/php/php7.0-fpm.sock
listen.owner = www-data
listen.group = www-data
pm = static 
pm.max_children = 12 
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
pm.max_requests = 250 
pm.status_path = /status
catch_workers_output = yes
php_admin_value[error_log] = /var/log/fpm-php.www.log
php_admin_flag[log_errors] = on

EOF