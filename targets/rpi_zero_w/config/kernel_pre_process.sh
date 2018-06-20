#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Raspberry pi 3 target kernel compilation
# pre process
#

source ${TARGET_CONFIG}/config.sh || exit 1

#PREEMPT RT patchs
#zcat ${TARGET_CONFIG}/patchs/patch-4.9.61-rt52-rc2.patch.gz | patch -p1  || exit 1
#patch -i ${TARGET_CONFIG}/patchs/usb-dwc_otg-fix-system-lockup-when-interrupts-are-threaded.patch -p1 || exit 1
