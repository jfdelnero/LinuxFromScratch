#!/bin/sh

echo "---> Starting system services..."

hostname HxC2001

udevd &

klogd
syslogd

crond
crontab /etc/crontab

#hd-idle -a sda -i 720
