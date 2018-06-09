#! /bin/sh

udevd &

klogd
syslogd

#crond
#crontab /etc/crontab

#hd-idle -a sda -i 720
