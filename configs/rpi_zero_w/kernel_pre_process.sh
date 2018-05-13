#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Raspberry pi 3 target kernel compilation
# pre process
#

source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh || exit 1

#PREEMPT RT patchs
#zcat ${BASE_DIR}/configs/${TARGET_NAME}/patchs/patch-4.9.61-rt52-rc2.patch.gz | patch -p1  || exit 1
#patch -i ${BASE_DIR}/configs/${TARGET_NAME}/patchs/usb-dwc_otg-fix-system-lockup-when-interrupts-are-threaded.patch -p1 || exit 1
