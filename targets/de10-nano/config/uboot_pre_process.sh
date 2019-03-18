#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2019 Jean-François DEL NERO
#
# DE10-Nano uboot patches
#

source ${TARGET_CONFIG}/config.sh || exit 1

patch -i ${TARGET_CONFIG}/patchs/0001-arm-socfpga-Move-CONFIG_EXTRA_ENV_SETTINGS-to-common.patch -p1 || exit 1
patch -i ${TARGET_CONFIG}/patchs/0002-arm-socfpga-Update-DE0-Nano-SoC-to-support-distro-bo.patch -p1 || exit 1
patch -i ${TARGET_CONFIG}/patchs/0003-arm-socfpga-add-support-for-Terasic-DE10-Nano-board.patch -p1 || exit 1
patch -i ${TARGET_CONFIG}/patchs/0004-Add-HDMI-init-to-de10-env.patch -p1 || exit 1
patch -i ${TARGET_CONFIG}/patchs/0005-Add-DE10-Nano-HDMI-configuration-and-debug-apps.patch -p1 || exit 1
patch -i ${TARGET_CONFIG}/patchs/0006-arm-socfpga-fix-issue-with-warm-reset-when-CSEL-is-0.patch -p1 || exit 1
cp ${TARGET_CONFIG}/patchs/socfpga_de10_nano.h include/configs/

