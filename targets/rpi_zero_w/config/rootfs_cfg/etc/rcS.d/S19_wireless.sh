#!/bin/sh

echo "---> Starting wireless (AP mode)..."

modprobe rfkill
modprobe cfg80211
modprobe brcmutil
modprobe brcmfmac

iw dev wlan0 set power_save off

ifconfig wlan0 192.168.100.1 up
hostapd -d /etc/hostapd.conf &


ping 192.168.100.254 -W 1 >/dev/null &
ping 192.168.100.254 -W 1 >/dev/null &
ping 192.168.100.254 -W 1 >/dev/null &

