#!/bin/sh

# Init the various file systems.
# The main idea here is to use tmpfs where the write support is needed.

echo "---> Init file systems..."

mount -o remount,ro /dev/root /

mount -t proc none  /proc
mount -t sysfs none /sys

mount -t tmpfs -o size=256m tmpfs /root
chmod go-r /root

mount -t tmpfs -o size=64m  tmpfs /tmp
mount -t tmpfs -o size=64m  tmpfs /var

# Populate /var
mkdir /var/log
mkdir /var/db
touch /var/db/dhcpd.leases
mkdir /var/ftp
mkdir /var/empty
mkdir /var/run
mkdir /var/run/wpa_supplicant
mkdir /var/run/hostapd
mkdir /var/log/lastlog
mkdir /var/tmp
mkdir /var/local
mkdir /var/lib
mkdir /var/lock
mkdir /var/spool
mkdir /var/spool/cron
mkdir /var/spool/cron/crontabs
mkdir /var/state
mkdir /var/mail

#######################################
# /dev
#######################################

# Done by devtmpfs...
#mount -t tmpfs -o size=64m  tmpfs /mnt
#cp -aR /dev/* /mnt
#mount --move /mnt /dev

# video / drm device
if [ ! -f "/dev/dri/card0" ]
then
	mkdir       /dev/dri
	mknod       /dev/dri/card0 c 226 0
	mknod       /dev/dri/controlD64 c 226 64
	mknod       /dev/dri/renderD128 c 226 128
fi
chgrp video /dev/dri/card0
chgrp video /dev/dri/controlD64
chgrp video /dev/dri/renderD128
chmod g+wr  /dev/dri/card0
chmod g+wr  /dev/dri/controlD64
chmod g+wr  /dev/dri/renderD128

mkdir /dev/pts
mount devpts /dev/pts -t devpts
chmod go+rw  /dev/null
chmod go+r   /dev/random
chmod go+r   /dev/urandom
chmod ugo+rw /dev/tty

#######################################

#######
# /home
mount -t tmpfs -o size=64m  tmpfs /mnt
cp -aR /home/* /mnt
mount --move /mnt /home

#######
# /run
mount -t tmpfs -o size=64m  tmpfs /mnt
cp -aR /run/* /mnt 2> /dev/null
mount --move /mnt /run

#######
# /etc
mount -t tmpfs -o size=64m  tmpfs /mnt
cp -aR /etc/* /mnt
mount --move /mnt /etc

mount -a
