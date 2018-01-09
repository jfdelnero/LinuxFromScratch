#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Cross compiler + System base
# GCC + GCC Libs + GLIBC + Kernel
#

source ${BASE_DIR}/scripts/unpack.sh || exit 1

source ${BASE_DIR}/configs/${TARGET_NAME}/config.sh || exit 1

echo "************************************************"
echo "*   Cross Compiler & System base building...   *"
echo "************************************************"

####################################################################
# Binutils build
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BINUTILS:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "*******************"
		echo "*   Binutils...   *"
		echo "*******************"

		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/build/$TARGET_NAME || exit 1
		mkdir -pv binutils
		cd binutils || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${CROSS_COMPILER_TOOLS}" \
				--target=$TGT_MACH \
				--with-sysroot=${TARGET_ROOTFS} \
				--disable-multilib \
				|| exit 1

		make all install || exit 1


		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Kernel headers generation
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_KERNEL:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "************************"
		echo "*   Kernel Header...   *"
		echo "************************"

		unpack ${CUR_PACKAGE} ""

		cd ${BASE_DIR}/sources/${TARGET_NAME} || exit 1
		mv ${TMP_ARCHIVE_FOLDER} linux-kernel  || exit 1
		cd linux-kernel                        || exit 1

		if [ -f ${BASE_DIR}/configs/${TARGET_NAME}/kernel_pre_process.sh ]
		then
		(
			echo Pre process script available... executing it...
			#To apply patchs or anything else
			source ${BASE_DIR}/configs/${TARGET_NAME}/kernel_pre_process.sh || exit 1
		)
		fi

		cd ${BASE_DIR}/sources/${TARGET_NAME}/
		cd ${BASE_DIR}/sources/${TARGET_NAME}/linux-kernel || exit 1

		make ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- mrproper || exit 1
		make ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- distclean || exit 1

		cp ${BASE_DIR}/configs/${TARGET_NAME}/kernel_config .config || exit 1
		make ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- headers_check || exit 1
		make ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- INSTALL_HDR_PATH="${TARGET_ROOTFS}" headers_install || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Bootstrap GCC
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GCC:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "**************"
		echo "*   GCC...   *"
		echo "**************"

		unpack ${CUR_PACKAGE} ""
		CUR_SRC_MAIN_FOLDER=$TMP_ARCHIVE_FOLDER

		cd ${BASE_DIR}/sources/${TARGET_NAME}/${CUR_SRC_MAIN_FOLDER}   || exit 1

		unpack ${SRC_PACKAGE_GCC_MPFR} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpfr || exit 1

		unpack ${SRC_PACKAGE_GCC_GMP} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} gmp || exit 1

		unpack ${SRC_PACKAGE_GCC_MPC} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpc || exit 1

		unpack ${SRC_PACKAGE_GCC_ISL} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} isl || exit 1

		#unpack ${SRC_PACKAGE_GCC_CLOOG} ${CUR_SRC_MAIN_FOLDER}
		#mv -v ${TMP_ARCHIVE_FOLDER} cloog || exit 1

		cd ${BASE_DIR}/build/$TARGET_NAME || exit 1
		mkdir -pv gcc || exit 1
		cd gcc || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${CUR_SRC_MAIN_FOLDER}/configure \
			--prefix="${CROSS_COMPILER_TOOLS}" \
			--target=$TGT_MACH          \
			--enable-languages=c,c++   \
			--disable-multilib         \
			--with-sysroot=${TARGET_ROOTFS} \
			--with-native-system-header-dir=/include \
			--enable-languages=c,c++ \
			${GCC_ADD_CONF} || exit 1

		# To force the fixed limits.h generation...
		echo > ${TARGET_ROOTFS}/include/limits.h
		ln -s ${TARGET_ROOTFS}/include ${TARGET_ROOTFS}/sys-include

		make -j4 all-gcc || exit 1
		make install-gcc|| exit 1

		rm ${TARGET_ROOTFS}/sys-include

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
fi


####################################################################
# Glibc headers
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GLIBC:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE ]
	then
	(
		echo "************************"
		echo "*   GlibC Headers...   *"
		echo "************************"

		unpack ${CUR_PACKAGE} ""
		CUR_SRC_MAIN_FOLDER=$TMP_ARCHIVE_FOLDER

		cd ${BASE_DIR}/build/$TARGET_NAME || exit 1
		mkdir -pv glibc || exit 1
		cd glibc || exit 1

		${BASE_DIR}/sources/${TARGET_NAME}/${CUR_SRC_MAIN_FOLDER}/configure \
				--prefix="/" \
				--build=$MACHTYPE \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--with-headers="${TARGET_ROOTFS}/include" \
				--disable-multilib \
				libc_cv_forced_unwind=yes \
				libc_cv_c_cleanup=yes || exit 1

		make install_root=${TARGET_ROOTFS} install-bootstrap-headers=yes install-headers  || exit 1
		make install_root=${TARGET_ROOTFS} -j4 csu/subdir_lib                             || exit 1
		install csu/crt1.o csu/crti.o csu/crtn.o "${TARGET_ROOTFS}/lib"                   || exit 1

		${TGT_MACH}-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o "${TARGET_ROOTFS}/lib/libc.so"
		touch ${TARGET_ROOTFS}/include/gnu/stubs.h

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Gcc lib
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GCC:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_LIB_DONE ]
	then
	(
		echo "********************"
		echo "*   GCC Libs ...   *"
		echo "********************"

		cd  ${BASE_DIR}/build/$TARGET_NAME/gcc || exit 1

		make -j4 all-target-libgcc || exit 1
		make install-target-libgcc || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_LIB_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Standard C libraries
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GCC:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_LIBC_DONE ]
	then
	(
		echo "*************"
		echo "*   GlibC   *"
		echo "*************"

		cd  ${BASE_DIR}/build/$TARGET_NAME/glibc || exit 1

		make install_root=${TARGET_ROOTFS} -j4       || exit 1
		make install_root=${TARGET_ROOTFS} install   || exit 1

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_LIBC_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Standard GCC C++ libraries
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_GCC:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_LIBCPP_DONE ]
	then
	(
		echo "************************"
		echo "*   GCC C++ Libs ...   *"
		echo "************************"

		cd  ${BASE_DIR}/build/$TARGET_NAME/gcc || exit 1

		make -j4 all   || exit 1
		make install   || exit 1

		#FIXME ! C++ libs not in the root fs ?
		cp  -aR  ${CROSS_COMPILER_TOOLS}/${TGT_MACH}/lib64/*   ${TARGET_ROOTFS}/lib
		cp  -aR  ${CROSS_COMPILER_TOOLS}/${TGT_MACH}/lib/*   ${TARGET_ROOTFS}/lib

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_LIBCPP_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Build kernel
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_KERNEL:-"UNDEF"}
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_KERNEL_DONE ]
	then
	(
		cd ${BASE_DIR}/sources/${TARGET_NAME}/linux-kernel || exit 1

		#make ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- menuconfig

		make ${KERNEL_IMAGE_TYPE} modules dtbs ARCH=${KERNEL_ARCH} CROSS_COMPILE=${TGT_MACH}- ${KERNEL_ADD_OPTIONS} || exit 1
		make modules_install ARCH=${KERNEL_ARCH}  INSTALL_MOD_PATH=${TARGET_ROOTFS} || exit 1
		#make ARCH=${KERNEL_ARCH} INSTALL_PATH=${TARGET_ROOTFS}/boot install

		if [ -f ${BASE_DIR}/configs/${TARGET_NAME}/kernel_post_process.sh ]
		then
		(
			echo Post process script available... executing it...
			#To prepare the kernel image or anything else
			${BASE_DIR}/configs/${TARGET_NAME}/kernel_post_process.sh || exit 1
		)
		fi

		echo "" > ${BASE_DIR}/build/${TARGET_NAME}/${CUR_PACKAGE}_KERNEL_DONE

	) || exit 1
	fi
) || exit 1
fi
