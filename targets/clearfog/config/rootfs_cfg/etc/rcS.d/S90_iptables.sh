#!/bin/sh

    pc0if="eth1"
    sfp_wlan="eth2"
    wlan="wlan0"

    export internetif="eth0"

    route add -net 192.168.20.0 netmask 255.255.255.0 gw 192.168.20.1
    route add -net 192.168.40.0 netmask 255.255.255.0 gw 192.168.40.1
    echo "1" >/proc/sys/net/ipv4/ip_forward

    iptables -D INPUT -i $internetif -p icmp -j ICMPTable                
    iptables -t nat -D POSTROUTING -o $internetif -j MASQUERADE  

    iptables -F INPUT
    iptables -F ICMPTable
    iptables -X ICMPTable

    # redefinition
    iptables -N ICMPTable
    iptables -A ICMPTable -p icmp --icmp-type echo-reply -j ACCEPT 
    #iptables -A ICMPTable -p icmp --icmp-type echo-request -m limit --limit 61/min -j ACCEPT

    iptables -A ICMPTable -p icmp --icmp-type source-quench -j ACCEPT
    iptables -A ICMPTable -p icmp --icmp-type destination-unreachable -j ACCEPT 
    iptables -A ICMPTable -p icmp --icmp-type time-exceeded -j ACCEPT
    iptables -A ICMPTable -p icmp --icmp-type parameter-problem -j ACCEPT 
    iptables -A ICMPTable -p icmp -j DROP 

    #iptables -t nat -A PREROUTING -p tcp -i $internetif --dport 666 -j DNAT --to-destination 192.168.20.4:666
    #iptables -t nat -A PREROUTING -p tcp -i $internetif --dport 667 -j DNAT --to-destination 192.168.20.4:667

    iptables -A INPUT -i $internetif -p icmp -j ICMPTable                

    # config NAT
    iptables -t nat -A POSTROUTING -o $internetif -j MASQUERADE     

    iptables -A INPUT -i $internetif -p tcp --dport 80 -j ACCEPT
    iptables -A INPUT -i $internetif -p tcp --dport 20 -j ACCEPT
    iptables -A INPUT -i $internetif -p tcp --dport 21 -j ACCEPT #-m limit --limit 10/min -j ACCEPT
    iptables -A INPUT -i $internetif -p tcp --destination-port 10090:10100 -j ACCEPT

    iptables -A INPUT -i $internetif -p tcp --dport 22 -j ACCEPT
    iptables -A INPUT -i $internetif -p tcp --dport 666 -j ACCEPT
    iptables -A INPUT -i $internetif -p tcp --dport 667 -j ACCEPT 
    iptables -A INPUT -i $internetif -m state --state ESTABLISHED,RELATED -j ACCEPT

    iptables -A OUTPUT -p udp -o $internetif --dport 53 --sport 1024:65535 -j ACCEPT
    iptables -A INPUT  -p udp -i $internetif --sport 53 --dport 1024:65535 -j ACCEPT

    iptables -A INPUT -i $internetif -p tcp -j DROP
    iptables -A INPUT -i $internetif -p udp -j DROP

    ifconfig $internetif up
    ifconfig $sfp_wlan   up
    
    udhcpc -n -i $internetif &
    udhcpc -n -i $sfp_wlan 
    dhcpd

