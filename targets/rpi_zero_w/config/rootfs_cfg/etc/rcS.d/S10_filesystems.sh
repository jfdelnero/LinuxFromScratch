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
mkdir /home/data

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

#######################################
# Test the data partition presence
#######################################

SIZELEN=`sfdisk /dev/mmcblk0p3 -F -s 2>/dev/null | wc -m`
if [ $SIZELEN == 0 ]; then
   #/usr/sbin/splash_screen /data/pauline_splash_bitmaps/prep_data_disk.bmp
   echo "Partition 3 not defined... Add it"

   # Add a partition (vfat) - (2097152 sectors -> keep/reserved the first 1GB for the system partitions)
   echo 'start=2097152,type=c' | sfdisk /dev/mmcblk0 -f -N 3

   # And restart the system...
   #/usr/sbin/splash_screen /data/pauline_splash_bitmaps/rebooting.bmp
   reboot
fi

#######################################
# Data partition mount / initialization
#######################################
mount -o fmask=0000,dmask=0000 /dev/mmcblk0p3 /home/data
ret=$?

if [ $ret -ne 0 ]; then

   # TODO !!! Ask the user before doing this !!!

   MNTLEN=`grep mmcblk0p3 /proc/mounts | wc -m`
   if [ $MNTLEN == 0 ]; then
      #/usr/sbin/splash_screen /data/pauline_splash_bitmaps/formatting_data_disk.bmp
      echo "Formating the data partition !"
      mkfs.vfat /dev/mmcblk0p3
      sync
      #/usr/sbin/splash_screen /data/pauline_splash_bitmaps/starting.bmp

      reboot
   fi
fi

mount -o fmask=0000,dmask=0000 /dev/mmcblk0p3 /home/data

#######################################
# Test and copy the data folders
#######################################

#if [ ! -d "/home/data/Tools" ] ; then
#	mkdir "/home/data/Tools"
#	cp -ar /data/Tools/* /home/data/Tools
#fi

#if [ /data/Tools/pc_hxc_tool/HxCFloppyEmulator.exe -nt /home/data/Tools/pc_hxc_tool/HxCFloppyEmulator.exe ]
#then
#	cp -ar /data/Tools/* /home/data/Tools
#fi

#if [ ! -d "/home/data/Documentations" ] ; then
#	mkdir "/home/data/Documentations"
#	cp -ar /data/Documentations/* /home/data/Documentations
#fi

#if [ ! -f "/home/data/Settings/drives_script_base.txt" ] ; then
#	cp -ar /data/Settings/drives.script /home/data/Settings/drives_script_base.txt
#fi

#######################################
# Cache : 
# Push to the disk the dirty data after 1 second !
#######################################

echo 100 > /proc/sys/vm/dirty_expire_centisecs
echo 100 > /proc/sys/vm/dirty_writeback_centisecs

#######################################
# ramdisk
#######################################

mount -t tmpfs -o size=64m  tmpfs /ramdisk
cp -aR /ramdisk/* /mnt
mount --move /mnt /ramdisk

mount -a
