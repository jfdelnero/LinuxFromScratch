#!/bin/sh

echo "---> Starting ntpd..."

date 2023-09-01

#ntpdate -u -p 1 3.fr.pool.ntp.org

{ ntpd -g -x -q 3.fr.pool.ntp.org ; ntpd -p /var/run/ntpd.pid -c /etc/ntp.conf -l /var/log/ntpd.log -g -I eth0 -U 5 ; } &
