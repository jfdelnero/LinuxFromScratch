#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2022 Jean-François DEL NERO
#
# Fix files permissions/owner/group
#

source ${TARGET_CONFIG}/config.sh || exit 1

cd ${TARGET_HOME}/output_objects/tmp_mount_point/ || exit 1

if [[ ! -d "./etc" ]]
then
(
    exit 1
)
fi

# root as default files owner
sudo chown -R root ./*
sudo chgrp -R root ./*
sudo chmod -R go-w ./*

# fix exec & r/w flags
sudo chmod ugo-w   ./home
sudo chmod ugo-w   ./home/anonymous
sudo chmod go-rxw  ./home/*
sudo chmod +x      ./bin/*.sh
sudo chmod +x      ./etc/*.sh
sudo chmod +x      ./etc/init.d/rcS
sudo chmod +x      ./etc/rcS.d/*.sh
sudo chmod +x      ./usr/share/udhcpc/*
sudo chmod ugo-rxw ./etc/ssh/*
sudo chmod u+rw    ./etc/ssh/*
sudo chmod go+r    ./etc/ssh/*.pub
sudo chmod go-rxw  ./etc/samba/private/*
sudo chmod 0700    ./etc/samba/private/msg.sock

# shadow / passwd files access
sudo chmod ugo-rwx ./etc/passwd
sudo chmod u+rw    ./etc/passwd
sudo chmod go+r    ./etc/passwd
sudo chmod ugo-rwx ./etc/shadow
sudo chmod u+rw    ./etc/shadow

# hostapd / wpa_supplicant
sudo chmod ugo-rwx ./etc/wpa_supplicant.conf
sudo chmod u+rw    ./etc/wpa_supplicant.conf
sudo chmod ugo-rwx ./etc/hostapd.conf
sudo chmod u+rw    ./etc/hostapd.conf

sudo chown 1001    ./ramdisk # 1001 - ramdisk
sudo chgrp 1001    ./ramdisk # 1001 - ramdisk
sudo chmod u+rwx   ./ramdisk
sudo chmod o-rwx   ./ramdisk
sudo chmod g-rwx   ./ramdisk

# if present, remove backup passwd / shadow files
sudo rm            ./etc/passwd-
sudo rm            ./etc/shadow-
