#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Clean up...
#

CROSS_BUILD_SIGN=${CROSS_BUILD_SIGN:-"UNDEF"}

if [ $CROSS_BUILD_SIGN != "CROSS_ENV_SET" ]; then

	FIRSTPARAM=${1:-"UNDEF"}
	FIRSTPARAM="${FIRSTPARAM##*/}"

	if [ $FIRSTPARAM = "CLEAN_ALL" ] || [ $FIRSTPARAM = "MRPROPER" ]; then

		cd ..

		for file in ./targets/*
		do
			target=`echo $file | sed s#./targets/##g`
			echo $target
			./set_env.sh $target $FIRSTPARAM
		done

		exit 0

	else

		echo "*******************************"
		echo "*    Environment not set !    *"
		echo "*   Please call set_env.sh    *"
		echo "*******************************"

		exit 2

	fi

fi

source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

echo Cleanup target ${TARGET_NAME}

rm -Rf ${TARGET_BUILD} ${TARGET_SOURCES} ${TARGET_HOME}/cross-tools ${TARGET_HOME}/root-fs ${TARGET_HOME}/fs_mirror ${TARGET_HOME}/output_objects

FIRSTPARAM=${1:-"UNDEF"}
FIRSTPARAM="${FIRSTPARAM##*/}"

if [ $FIRSTPARAM = "MRPROPER" ]; then
	rm -Rf ${TARGET_HOME}/download ${TARGET_HOME}/mount_point
fi

delete_tmprootfs_dir
delete_build_dir
delete_src_dir

