#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2022 Jean-François DEL NERO
#
# Fix files permissions/owner/group
#

source ${TARGET_CONFIG}/config.sh || exit 1

if [[ ! -d "./etc" ]]
then
(
    exit 1
)
fi

# root as default files owner
sudo chown -R root ./*
sudo chgrp -R root ./*
sudo chmod -R go-w  /*

# fix exec & r/w flags
sudo chmod ugo-w   ./home
sudo chmod +x      ./etc/*.sh
sudo chmod +x      ./etc/init.d/rcS
sudo chmod +x      ./etc/rcS.d/*.sh
sudo chmod go-w    ./etc/init.d/rcS
sudo chmod go-w    ./etc/rcS.d/*.sh
sudo chmod go-w    ./etc/*
sudo chmod +x      ./usr/share/udhcpc/*
sudo chmod ugo-rxw ./etc/ssh/*
sudo chmod u+rw    ./etc/ssh/*
sudo chmod go+r    ./etc/ssh/*.pub

# shadow / passwd files access
sudo chmod ugo-rwx ./etc/passwd
sudo chmod u+rw    ./etc/passwd
sudo chmod go+r    ./etc/passwd
sudo chmod ugo-rwx ./etc/shadow
sudo chmod u+rw    ./etc/shadow

# if present, remove backup passwd / shadow files
sudo rm            ./etc/passwd-
sudo rm            ./etc/shadow-
