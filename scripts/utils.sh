#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2023 Jean-François DEL NERO
#
# Utils
#

function create_src_dir {
	MODE=${BUILD_MODE:-"UNDEF"}
	MODE="${MODE##*/}"
	if [ "$MODE" == "BUILD_MODE_SHM" ]
	then
		export TMP_SRC_FOLDER=${TARGET_SOURCES}/tmp
		mkdir /dev/shm/LinuxFromScratch/tmp_src/ -pv
		ln -s /dev/shm/LinuxFromScratch/tmp_src/ ${TMP_SRC_FOLDER}
		cd ${TMP_SRC_FOLDER} || exit 1
	else
		export TMP_SRC_FOLDER=${TARGET_SOURCES}
	fi
}

function delete_src_dir {
	MODE=${BUILD_MODE:-"UNDEF"}
	MODE="${MODE##*/}"
	if [ "$MODE" == "BUILD_MODE_SHM" ]
	then
		cd ${TMP_SRC_FOLDER} || exit 1
		cd ..  || exit 1
		rm -rf ${TMP_SRC_FOLDER}
		rm -rf /dev/shm/LinuxFromScratch/tmp_src
	fi
}

function create_build_dir {
	MODE=${BUILD_MODE:-"UNDEF"}
	MODE="${MODE##*/}"
	if [ "$MODE" == "BUILD_MODE_SHM" ]
	then
		export TMP_BUILD_FOLDER=${TARGET_BUILD}/tmp
		mkdir /dev/shm/LinuxFromScratch/tmp_build/ -pv
		ln -s /dev/shm/LinuxFromScratch/tmp_build/ ${TMP_BUILD_FOLDER}
		cd ${TMP_BUILD_FOLDER} || exit 1
	else
		export TMP_BUILD_FOLDER=${TARGET_BUILD}
	fi
}

function delete_build_dir {
	MODE=${BUILD_MODE:-"UNDEF"}
	MODE="${MODE##*/}"
	if [ "$MODE" == "BUILD_MODE_SHM" ]
	then
		cd ${TMP_BUILD_FOLDER} || exit 1
		cd ..  || exit 1
		rm -rf ${TMP_BUILD_FOLDER}
		rm -rf /dev/shm/LinuxFromScratch/tmp_build
	fi
}
