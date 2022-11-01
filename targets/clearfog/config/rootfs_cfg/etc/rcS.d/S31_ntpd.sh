#!/bin/sh

echo "---> Starting ntpd..."

date 2022-01-01

ntpd -p /var/run/ntpd.pid -c /etc/ntp.conf -l /var/log/ntpd.log -g -I eth0 -I eth2 -U 5

