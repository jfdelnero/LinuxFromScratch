#!/bin/sh

	export wlan="wlan0"
	export internetif="eth0"

    ifconfig $internetif down

    ifconfig $wlan down
	ifconfig $internetif 192.168.105.1
	ifconfig $wlan 192.168.106.1

    route add -net 192.168.105.0 netmask 255.255.255.0 gw 192.168.105.1
    route add -net 192.168.106.0 netmask 255.255.255.0 gw 192.168.106.1

    echo "1" >/proc/sys/net/ipv4/ip_forward
    ifconfig $internetif up
	ifconfig $wlan up

#    udhcpc -n -i $internetif &

    dhcpd
