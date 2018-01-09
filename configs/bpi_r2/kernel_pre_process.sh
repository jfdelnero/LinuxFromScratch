#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Banana pi R2 target kernel compilation
# pre process
#

source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh || exit 1

cd ..

mv linux-kernel MT-linux-kernel

ln -s MT-linux-kernel/linux-mt linux-kernel
