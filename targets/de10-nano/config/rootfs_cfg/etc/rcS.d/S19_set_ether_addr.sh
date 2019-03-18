#!/bin/sh

echo "---> Set ethernet address..."

ifconfig eth0 hw ether 80:00:0B:AB:CD:EF

