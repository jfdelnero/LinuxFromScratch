#!/bin/sh

echo "---> Starting wireless (AP mode)..."

modprobe rfkill
modprobe cfg80211
modprobe brcmutil
modprobe brcmfmac

iw dev wlan0 set power_save off

#wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf

hostapd /etc/hostapd.conf &

#ifconfig wlan0 192.168.40.1

#ping 192.168.100.254 -W 1 >/dev/null &
#ping 192.168.100.254 -W 1 >/dev/null &
#ping 192.168.100.254 -W 1 >/dev/null &
