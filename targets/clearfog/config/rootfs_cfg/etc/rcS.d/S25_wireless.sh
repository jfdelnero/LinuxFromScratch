#!/bin/sh

echo "---> Starting wireless..."

wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf
hostapd /etc/hostapd.conf &

ifconfig wlan0 192.168.40.1

