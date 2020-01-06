#!/usr/bin/env bash
set -e

echo "---- dehydrated"


TEMP="$(mktemp)" &&
wget -O "$TEMP" "https://github.com/lukas2511/dehydrated/releases/download/v0.6.5/dehydrated-0.6.5.tar.gz" &&
sudo mkdir -p /etc/dehydrated/ &&
sudo tar xvf "$TEMP" --strip-components=1 --directory=/usr/bin/   dehydrated-0.6.5/dehydrated ;
rm -f "$TEMP"
sudo mkdir -p /var/certs && sudo chown www-data:www-data /var/certs;
sudo chown -R www-data:www-data /etc/dehydrated