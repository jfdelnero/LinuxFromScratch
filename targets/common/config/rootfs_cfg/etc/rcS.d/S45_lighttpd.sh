#! /bin/sh

echo Starting lighttpd...

#httpd -h /home/www
lighttpd -f /etc/lighttpd/lighttpd.conf
