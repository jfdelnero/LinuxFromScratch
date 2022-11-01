#!/bin/sh

testwlan=`ifconfig wlan0 2>&1 >/dev/null |grep "Device not found"`

if [ -z "$testwlan"  ]; then
	echo "Ok Wlan card detected :) ..."
else
	echo "Wlan card not detected... Rebooting"
	reboot -f
fi

echo "---> Starting Network (router mode)..."

ifconfig lo 127.0.0.1 up

ifconfig eth0 hw ether 00:50:43:1F:1E:2D
ifconfig eth1 hw ether 00:50:43:E4:9C:2A
ifconfig eth2 hw ether 00:50:43:39:9C:E4

brctl addbr br0

brctl addif br0 lan1
brctl addif br0 lan2
brctl addif br0 lan3
brctl addif br0 lan4
brctl addif br0 lan5
brctl addif br0 lan6

ifup -a

echo "0" >/var/log/reconnect
echo "6" >/var/log/reconnect2

ifconfig lan1 up
ifconfig lan2 up
ifconfig lan3 up
ifconfig lan4 up
ifconfig lan5 up
ifconfig lan6 up

echo "---> Starting Network (station mode)..."


