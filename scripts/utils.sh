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
		mkdir ${BUILD_TMP_OBJ_BASEFOLDER}/LinuxFromScratch/tmp_src/ -pv
		ln -s ${BUILD_TMP_OBJ_BASEFOLDER}/LinuxFromScratch/tmp_src/ ${TMP_SRC_FOLDER}
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
		rm -rf ${BUILD_TMP_OBJ_BASEFOLDER}/LinuxFromScratch/tmp_src
	fi
}

function create_build_dir {
	MODE=${BUILD_MODE:-"UNDEF"}
	MODE="${MODE##*/}"
	if [ "$MODE" == "BUILD_MODE_SHM" ]
	then
		export TMP_BUILD_FOLDER=${TARGET_BUILD}/tmp
		mkdir ${BUILD_TMP_OBJ_BASEFOLDER}/LinuxFromScratch/tmp_build/ -pv
		ln -s ${BUILD_TMP_OBJ_BASEFOLDER}/LinuxFromScratch/tmp_build/ ${TMP_BUILD_FOLDER}
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
		rm -rf ${BUILD_TMP_OBJ_BASEFOLDER}/LinuxFromScratch/tmp_build
	fi
}

function create_tmprootfs_dir {
	MODE=${BUILD_MODE:-"UNDEF"}
	MODE="${MODE##*/}"
	if [ "$MODE" == "BUILD_MODE_SHM" ]
	then
		export TARGET_ROOTFS_MIRROR=${TARGET_BUILD}/tmp_rootfs

		if [ -d "$TARGET_ROOTFS_MIRROR" ]
		then
			cd ${TARGET_ROOTFS_MIRROR}
			cd ..
			rm -rf tmp_rootfs
			rm -rf ${BUILD_TMP_OBJ_BASEFOLDER}/LinuxFromScratch/tmp_rootfs
		fi

		mkdir ${BUILD_TMP_OBJ_BASEFOLDER}/LinuxFromScratch/tmp_rootfs/ -pv
		ln -s ${BUILD_TMP_OBJ_BASEFOLDER}/LinuxFromScratch/tmp_rootfs/ ${TARGET_ROOTFS_MIRROR}
	else
		export TARGET_ROOTFS_MIRROR=${TARGET_BUILD}/tmp_rootfs

		if [ -d "$TARGET_ROOTFS_MIRROR" ]
		then
			cd ${TARGET_ROOTFS_MIRROR}
			cd ..
			rm -rf tmp_rootfs
			rm -rf ${BUILD_TMP_OBJ_BASEFOLDER}/LinuxFromScratch/tmp_rootfs
		fi

		mkdir ${TARGET_BUILD}/tmp_rootfs -pv || exit 1
	fi

	cd ${TARGET_ROOTFS_MIRROR} || exit 1
}

function delete_tmprootfs_dir {
	MODE=${BUILD_MODE:-"UNDEF"}
	MODE="${MODE##*/}"
	if [ "$MODE" == "BUILD_MODE_SHM" ]
	then
		cd ${TARGET_ROOTFS_MIRROR} || exit 1
		cd ..  || exit 1
		rm -rf tmp_rootfs
		rm -rf ${BUILD_TMP_OBJ_BASEFOLDER}/LinuxFromScratch/tmp_rootfs
	fi
}

function create_meson_crossfile {
	echo "[binaries]"                          > $1
	echo "c = '${TGT_MACH}-gcc'"              >> $1
	echo "cpp = '${TGT_MACH}-g++'"            >> $1
	echo "ar = '${TGT_MACH}-ar'"              >> $1
	#echo "windres = '${TGT_MACH}-windres'"   >> $1
	echo "strip = '${TGT_MACH}-strip'"        >> $1
	echo "pkg-config = 'pkg-config'"          >> $1
	echo "cmake = 'cmake'"                    >> $1

	#echo "exe_wrapper = 'wine64'"            >> $1

	echo "[host_machine]"                     >> $1
	echo "system = 'linux'"                   >> $1
	echo "cpu_family = 'x86_64'"              >> $1
	echo "cpu = 'x86_64'"                     >> $1
	echo "endian = 'little'"                  >> $1

	echo "[properties]"                       >> $1
	echo "needs_exe_wrapper = false"          >> $1
}

