#!/bin/bash

if [ ! -z $SECRET_KEY ]; then
  sed -E -i "s/^environment = (.*)$/environment = \1,SECRET_KEY='$SECRET_KEY'/" /etc/supervisor/conf.d/supervisord.conf
fi

mkdir -p /opt/graphite/storage/log/webapp
mkdir -o /opt/graphite/storage/log/carbon-cache/carbon-cache-a/
mkdir -p /opt/graphite/storage/whisper
touch /opt/graphite/storage/graphite.db /opt/graphite/storage/index
chown -R www-data /opt/graphite/storage
chmod 0775 /opt/graphite/storage /opt/graphite/storage/whisper
chmod 0664 /opt/graphite/storage/graphite.db
cd /opt/graphite/webapp/graphite && python manage.py syncdb --noinput

echo "================"
ls -allh /opt/graphite/conf
cat /opt/graphite/conf/storage-schemas.conf
echo "================"

/usr/bin/supervisord
