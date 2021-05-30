#!/bin/sh

echo "---> Starting Network (station mode)..."

printf "%s" "waiting for eth0 ..."
while ! ifconfig -a | grep eth0 &> /dev/null
do
    printf "%c" "."
done
printf "\n%s\n"  "eth0..."

ifconfig lo 127.0.0.1 up

ifconfig eth0 up

udhcpc &

