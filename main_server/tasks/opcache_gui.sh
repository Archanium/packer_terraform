#!/usr/bin/env bash
set -e 
echo "--- Installing opcache gui to look at things"
sudo mkdir -p /var/www/opcache;

curl https://raw.githubusercontent.com/rlerdorf/opcache-status/master/opcache.php | sudo tee /var/www/opcache/opcache.php

cat << EOF | sudo tee /usr/local/openresty/nginx/conf/sites-enabled/opcache_gui.conf
server {
    listen      8000;
    server_name opcache.nginx1.getdreamshop.dk;
    root        /var/www/opcache;

    # This is only needed when using URL paths
    try_files  / /opcache.php;
    location /status {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_pass backend7;
        log_not_found off;
    }
    location ~* \.php$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;

        fastcgi_pass backend7;
    }
}
EOF

sudo chown -R www-data:www-data /var/www/opcache;
sudo chmod 0600 /var/www/opcache/opcache.php;
