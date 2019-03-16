#!/bin/sh

echo "---> Starting ntpd..."

#ntpdate -u -p 1 3.fr.pool.ntp.org

date 2019-01-01

ntpd -p /var/run/ntpd.pid -c /etc/ntp.conf -l /var/log/ntpd.log -g -I eth0 -U 5
