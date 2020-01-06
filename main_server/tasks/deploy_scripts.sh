#! /usr/bin/env bash
set -e
sudo mkdir -p /var/release;
cat << "EOH" | sudo tee /var/release/helpers.sh
copy_env_file () {
    local OUTPUT_FILE=$1
    cp /var/release/env_base $OUTPUT_FILE
}

copy_nginx_parts () {
    local SOURCE=$1
    changes=$(rsync --recursive --checksum --perms $SOURCE/config/live/nginx/. /usr/local/openresty/nginx/conf/. --out-format=%n)
    echo $changes;
    if [ ! -z "${changes}" ]; then
        openresty -t
        service openresty reload
    fi
}

copy_supervisor_parts () {
    local SOURCE=$1
    changes=$(rsync --recursive --checksum --perms $SOURCE/config/live/supervisor/. /etc/supervisor/conf.d/. --out-format=%n)
    echo $changes;
    if [ ! -z "${changes}" ]; then
        service supervisor restart
    fi
}
EOH

cat << "EOF" | sudo tee /var/release/releaser && sudo chmod +x /var/release/releaser
#!/usr/bin/env bash

source /var/release/helpers.sh;
cleanup() {

    if [ -f /var/www/dreamshop_byflou.current/public/maintenance.php ]; then
        rm /var/www/dreamshop_byflou.current/public/maintenance.php
    fi
}
trap cleanup EXIT;

ARCHIVE_FILE=$1
if [ -z $ARCHIVE_FILE ]; then
    echo "Missing Archive file";
    exit 1
fi

DATE=$(date "+%y%m%d.%H%M")
DESTINATION=/var/www/dreamshop_byflou
REL="${DESTINATION}.${DATE}";
LOGDIR=/var/log/dreamshop_byflou
mkdir -p $REL;
tar xJf $ARCHIVE_FILE -C $REL
copy_env_file "${REL}/.env"
if [[ ! -f $REL/.env ]]; then
    echo "Could not generate env file in: ${REL}"
    exit 1
fi

source $REL/.env; 
export PHINX_DBHOST=$DB_HOST
export PHINX_DBNAME=$DB_NAME
export PHINX_DBUSER=$DB_USER
export PHINX_DBPASS=$DB_PASS
export PHINX_ENVIRONMENT="production"
cd $REL;

if [[ -e $DESTINATION.current ]]; then
  echo "Putting into maintenance" 
  cp $DESTINATION.current/public/_maintenance.php $DESTINATION.current/public/maintenance.php
fi

echo $(copy_nginx_parts $REL)
ln -s $LOGDIR $REL/logs
mkdir -p ./config/cache
chown -R www-data:www-data $REL/config/cache
chmod  a+w $LOGDIR;
echo "ln -s $REL $DESTINATION.current_next.$DATE"
sudo ln -s $REL $DESTINATION.current_next.$DATE
echo "mv -f -T $DESTINATION.current_next.$DATE $DESTINATION.current"
if [[ -e "${DESTINATION}.current" ]]; then
    sudo cp -P -f $DESTINATION.current $DESTINATION.backup
fi

sudo mv -f -T $DESTINATION.current_next.$DATE $DESTINATION.current
cd $DESTINATION.current;
if [[ $(./vendor/bin/phinx status | grep down --quiet) -eq 0 ]]; then
    ./vendor/bin/phinx migrate;
fi

echo "Released"

rm $ARCHIVE_FILE

echo $(copy_supervisor_parts $REL)

oldReleases=$(find /var/www -maxdepth 1 -type d -name 'dreamshop_byflou*' | sort -h | head -n-3)
if [[ $oldReleases ]]; then
echo "Removing ${oldReleases}"
echo $oldReleases | xargs rm -rf
fi;
oldReleases=$(find /var/www -maxdepth 1 -type d -name 'dreamshop_old*' | sort -h | head -n-3)
if [[ $oldReleases ]]; then
echo "Removing ${oldReleases}"
echo $oldReleases | xargs rm -rf
fi;

EOF

cat << "EOF" | sudo tee /var/release/old_releaser && sudo chmod +x /var/release/old_releaser
#!/usr/bin/env bash

source /var/release/helpers.sh;
cleanup() {

    if [ -f /var/www/dreamshop_old.current/public/maintenance.php ]; then
        rm /var/www/dreamshop_old.current/public/maintenance.php
    fi
}
trap cleanup EXIT;

ARCHIVE_FILE=$1
if [ -z $ARCHIVE_FILE ]; then
    echo "Missing Archive file";
    exit 1
fi

DATE=$(date "+%y%m%d.%H%M")
DESTINATION=/var/www/dreamshop_old
REL="${DESTINATION}.${DATE}";
LOGDIR=/var/log/dreamshop
mkdir -p $REL;
tar xJf $ARCHIVE_FILE -C $REL
cd $REL;
ln -s $LOGDIR $REL/logs
mkdir -p ./config/cache
chown -R www-data:www-data $REL/config/cache
chmod  a+w $LOGDIR;
echo "ln -s $REL $DESTINATION.current_next.$DATE"
sudo ln -s $REL $DESTINATION.current_next.$DATE
echo "mv -f -T $DESTINATION.current_next.$DATE $DESTINATION.current"
if [[ -e "${DESTINATION}.current" ]]; then
    sudo cp -P -f $DESTINATION.current $DESTINATION.backup
fi

sudo mv -f -T $DESTINATION.current_next.$DATE $DESTINATION.current
cd $DESTINATION.current;

echo "Released"

rm $ARCHIVE_FILE
EOF

sudo chown -R www-data:www-data /var/release

