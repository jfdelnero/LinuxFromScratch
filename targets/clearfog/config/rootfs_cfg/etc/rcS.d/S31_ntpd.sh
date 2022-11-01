#!/bin/sh

echo "---> Starting ntpd..."

ntpd -p /var/run/ntpd.pid -c /etc/ntp.conf -l /var/log/ntpd.log -g -I eth0 -I eth2 -U 5

