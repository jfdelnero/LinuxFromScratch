#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Set env script
#

export TARGET_NAME=${1:-"UNDEF"}

if [ $CROSS_BUILD_SIGN = "CROSS_ENV_SET" ]; then

	echo "*****************************"
	echo "* Environment already set ! *"
	echo "*****************************"

else

	if [ -d "${PWD}/configs/${TARGET_NAME}" ]; then

		export BASE_DIR="${PWD}"

		source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh

		export CROSS_BUILD_SIGN="CROSS_ENV_SET"

		export TARGET_ROOTFS="${PWD}/targets/${TARGET_NAME}/root-fs"
		export CROSS_COMPILER_TOOLS="${PWD}/targets/${TARGET_NAME}/cross-tools"

		export PATH="${CROSS_COMPILER_TOOLS}/bin:${PATH}"
		export BUILDMACH=$MACHTYPE

		export NBCORE=-j`nproc`

		clear
		echo "* $TARGET_NAME Environnement set ! *"

		ls *.sh
		echo

		chmod +x ${BASE_DIR}/configs/${TARGET_NAME}/*.sh
		chmod +x ${BASE_DIR}/scripts/*.sh
		chmod +x ${BASE_DIR}/*.sh

		bash

		echo "*******************************************"
		echo "* You leaved the Cross compil Environment *"
		echo "*******************************************"

		exit 0
	else
		echo "********************"
		echo "* Invalid target ! *"
		echo "********************"

		ls ${PWD}/configs
	fi
fi
