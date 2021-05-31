#!/bin/sh

echo "---> Starting Network (station mode)..."

if grep -q "Raspberry Pi 3 Model A"  /proc/cpuinfo; then
    printf "%s" "No internal ethernet port..."
    return
fi

printf "%s" "waiting for eth0 ..."
while ! ifconfig -a | grep eth0 &> /dev/null
do
    printf "%c" "."
done
printf "\n%s\n"  "eth0..."

ifconfig lo 127.0.0.1 up

ifconfig eth0 up

udhcpc &

