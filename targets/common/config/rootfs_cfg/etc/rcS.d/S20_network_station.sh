#!/bin/sh

echo "---> Starting Network (station mode)..."

ifconfig lo 127.0.0.1 up

ifconfig eth0 up

udhcpc &

