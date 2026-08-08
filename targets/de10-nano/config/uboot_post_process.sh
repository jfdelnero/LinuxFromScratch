#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# DE10-Nano uboot patches
#

source ${TARGET_CONFIG}/config.sh || exit 1

cp ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/u-boot.img ${TARGET_HOME}/output_objects/  || exit 1
cp ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/u-boot-with-spl.sfp ${TARGET_HOME}/output_objects/  || exit 1

