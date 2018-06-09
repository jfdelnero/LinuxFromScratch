#! /bin/sh

ifconfig lan0 hw ether 00:50:43:00:00:01

ifconfig lo 127.0.0.1 up
ifconfig lan0 up

udhcpc -i lan0 &
