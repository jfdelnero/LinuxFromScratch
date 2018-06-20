#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Clean up...
#

CROSS_BUILD_SIGN=${CROSS_BUILD_SIGN:-"UNDEF"}

if [ $CROSS_BUILD_SIGN != "CROSS_ENV_SET" ]; then

echo "*******************************"
echo "*    Environment not set !    *"
echo "*   Please call set_env.sh    *"
echo "*******************************"

exit 2

fi

source ${TARGET_CONFIG}/config.sh || exit 1

echo Cleanup target ${TARGET_NAME}

rm -Rf ${TARGET_BUILD} ${TARGET_SOURCES} ${TARGET_HOME}/cross-tools ${TARGET_HOME}/root-fs
