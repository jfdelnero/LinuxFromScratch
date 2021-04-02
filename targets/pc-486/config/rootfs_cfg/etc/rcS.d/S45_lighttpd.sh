#!/bin/sh

echo "---> Starting lighttpd..."

# For POST/upload support

mkdir /run/lighttpd/
mkdir /run/lighttpd/upload

chmod go+rw /run/lighttpd/
chmod go+rw /run/lighttpd/upload
chmod go+rw /var/tmp

#httpd -h /home/www
lighttpd -f /etc/lighttpd/lighttpd.conf
