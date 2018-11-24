#!/bin/sh

ifconfig wlan0 192.168.40.1 down
hostapd -d /etc/hostapd.conf &
ifconfig wlan0 192.168.40.1 up

ping 192.168.40.2 >/dev/null &
ping 192.168.40.3 >/dev/null &
