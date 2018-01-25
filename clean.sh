#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Clean up...
#

source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh || exit 1

CROSS_BUILD_SIGN=${CROSS_BUILD_SIGN:-"UNDEF"}

if [ $CROSS_BUILD_SIGN != "CROSS_ENV_SET" ]; then

echo "*******************************"
echo "*    Environment not set !    *"
echo "*   Please call set_env.sh    *"
echo "*******************************"

exit 2

fi

echo Cleanup target ${TARGET_NAME}

rm -Rf build/${TARGET_NAME} sources/${TARGET_NAME} targets/${TARGET_NAME}

