#!/bin/sh

echo "---> Starting Network (router mode)..."

ifconfig lo 127.0.0.1 up

ifconfig eth0 192.168.100.1
ifconfig eth0 up

dhcpd

