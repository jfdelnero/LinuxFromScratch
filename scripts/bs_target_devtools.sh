#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2026 Jean-François DEL NERO
#
# Target compiler
# Binutils + GCC + GCC Libs
#

source ${SCRIPTS_HOME}/unpack.sh || exit 1
source ${SCRIPTS_HOME}/utils.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

echo "******************"
echo "*   Target GCC   *"
echo "******************"

####################################################################
# Binutils build
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_TARGET_BINUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE ]
	then
	(
		echo "**************************"
		echo "*   Target Binutils...   *"
		echo "**************************"

		create_src_dir
		create_build_dir

		mkdir ${TMP_SRC_FOLDER}/target_devtools
		unpack ${CUR_PACKAGE} "target_devtools"

		unset PKG_CONFIG_LIBDIR

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv binutils_target
		cd binutils_target || exit 1

		${TMP_SRC_FOLDER}/target_devtools/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}/usr" \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				--with-sysroot=${TARGET_ROOTFS} \
				--disable-multilib \
				|| exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Bootstrap GCC
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_TARGET_GCC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE ]
	then
	(
		echo "*********************"
		echo "*   Target GCC...   *"
		echo "*********************"

		create_src_dir
		create_build_dir

		mkdir ${TMP_SRC_FOLDER}/target_devtools
		unpack ${CUR_PACKAGE} "target_devtools"

		unset PKG_CONFIG_LIBDIR

		CUR_SRC_MAIN_FOLDER=target_devtools/$TMP_ARCHIVE_FOLDER

		cd ${TMP_SRC_FOLDER}/target_devtools/${TMP_ARCHIVE_FOLDER}   || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_MPFR##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpfr || exit 1

		#TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_GMP##*/}"
		#unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		#mv -v ${TMP_ARCHIVE_FOLDER} gmp || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_MPC##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpc || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_ISL##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} isl || exit 1

		#TMP_PACKAGE="${SRC_PACKAGE_TARGET_GCC_CLOOG##*/}"
		#unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		#mv -v ${TMP_ARCHIVE_FOLDER} cloog || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv target_gcc || exit 1
		cd target_gcc || exit 1

		TMP_ARCHIVE_FOLDER=$CUR_SRC_MAIN_FOLDER

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}/usr" \
				--host=$TGT_MACH \
				--target=$TGT_MACH          \
				--disable-multilib         \
				--with-sysroot=${TARGET_ROOTFS} \
				--with-native-system-header-dir=/include \
				--with-gmp-lib=${TARGET_ROOTFS}/lib \
				--with-gmp-include=${TARGET_ROOTFS}/include \
				--enable-languages=c,c++ \
				${GCC_ADD_CONF} || exit 1

		# To force the fixed limits.h generation...
		# echo > ${TARGET_ROOTFS}/include/limits.h
		# ln -s ${TARGET_ROOTFS}/include ${TARGET_ROOTFS}/sys-include

		make ${MAKE_FLAGS} ${NBCORE} all-gcc || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install-gcc|| exit 1

		# rm ${TARGET_ROOTFS}/sys-include

		# Install the GCC libraries
		cp  -aR  ${TARGET_CROSS_TOOLS}/lib/gcc/${TGT_MACH} ${TARGET_ROOTFS}/usr/lib/gcc/

		echo "********************"
		echo "*   GCC Libs ...   *"
		echo "********************"

		cd  ${TMP_BUILD_FOLDER}/target_gcc || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all-target-libgcc || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install-target-libgcc || exit 1

		echo "************************"
		echo "*   GCC C++ Libs ...   *"
		echo "************************"

		cd  ${TMP_BUILD_FOLDER}/target_gcc || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all   || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install   || exit 1

		#FIXME ! C++ libs not in the root fs ?
		#cp  -aR  ${TARGET_CROSS_TOOLS}/${TGT_MACH}/lib64/*   ${TARGET_ROOTFS}/lib
		#cp  -aR  ${TARGET_CROSS_TOOLS}/${TGT_MACH}/lib/*   ${TARGET_ROOTFS}/lib

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Target Binutils cross-compiler
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_TARGET_CROSS_BINUTILS:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_CROSS_DONE ]
	then
	(
		echo "*****************************************"
		echo "*   Target Binutils cross-compiler...   *"
		echo "****************************************"

		create_src_dir
		create_build_dir

		mkdir ${TMP_SRC_FOLDER}/target_devtools
		mkdir ${TMP_SRC_FOLDER}/target_devtools/crosscompiler
		unpack ${CUR_PACKAGE} "target_devtools/crosscompiler"

		unset PKG_CONFIG_LIBDIR

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv binutils_cross_target
		cd binutils_cross_target || exit 1

		${TMP_SRC_FOLDER}/target_devtools/crosscompiler/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}/usr" \
				--host=$TGT_MACH \
				--target=$CROSS_TGT_MACH \
				--disable-werror \
				--disable-interwork \
				--with-sysroot=${TARGET_ROOTFS} \
				--disable-multilib \
				|| exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_CROSS_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Target GCC cross-compiler
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_TARGET_CROSS_GCC:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_CROSS_DONE ]
	then
	(
		echo "***********************************"
		echo "*   Target GCC cross-compiler...  *"
		echo "***********************************"

		create_src_dir
		create_build_dir

		mkdir ${TMP_SRC_FOLDER}/target_devtools
		mkdir ${TMP_SRC_FOLDER}/target_devtools/crosscompiler
		unpack ${CUR_PACKAGE} "target_devtools/crosscompiler"

		unset PKG_CONFIG_LIBDIR

		CUR_SRC_MAIN_FOLDER=target_devtools/crosscompiler/$TMP_ARCHIVE_FOLDER

		cd ${TMP_SRC_FOLDER}/target_devtools/crosscompiler/${TMP_ARCHIVE_FOLDER}   || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_CROSS_GCC_MPFR##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpfr || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_CROSS_GCC_GMP##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} gmp || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_CROSS_GCC_MPC##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpc || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_TARGET_CROSS_GCC_ISL##*/}"
		unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} isl || exit 1

		#TMP_PACKAGE="${SRC_PACKAGE_TARGET_CROSS_GCC_CLOOG##*/}"
		#unpack ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		#mv -v ${TMP_ARCHIVE_FOLDER} cloog || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv target_cross_gcc || exit 1
		cd target_cross_gcc || exit 1

		TMP_ARCHIVE_FOLDER=$CUR_SRC_MAIN_FOLDER

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}/usr" \
				--host=$TGT_MACH                \
				--target=$CROSS_TGT_MACH        \
				--disable-libada                \
				--disable-libsanitizer          \
				--disable-multilib              \
				--disable-bootstrap             \
				--disable-libssp                \
				--disable-libgomp               \
				--disable-libmudflap            \
				--disable-multilib              \
				--disable-libphobos             \
				--disable-decimal-float         \
				--disable-libffi                \
				--disable-libmudflap            \
				--disable-libquadmath           \
				--disable-libquadmath-support   \
				--disable-libssp                \
				--disable-libstdcxx-pch         \
				--disable-nls                   \
				--disable-shared                \
				--disable-threads               \
				--disable-tls                   \
				--disable-werror                \
				--disable-interwork             \
				--disable-libvtv                \
				--disable-decimal-float         \
				--disable-fixed-point           \
				--with-gnu-as                   \
				--with-gnu-ld                   \
				--with-cpu=$CROSS_TGT_CPU       \
				--with-mode=$CROSS_TGT_CPUMODE  \
				--without-headers               \
				--enable-target-optspace        \
				--with-float=soft               \
				--enable-languages=c    || exit 1

		# dumpspecs bypass... create a dummy cross compiler:
		if [ ! -f ${TARGET_CROSS_TOOLS}/bin/${CROSS_TGT_MACH}-gcc ];
		then
			echo > ${TARGET_CROSS_TOOLS}/bin/${CROSS_TGT_MACH}-gcc
			chmod +x ${TARGET_CROSS_TOOLS}/bin/${CROSS_TGT_MACH}-gcc

			make ${MAKE_FLAGS} ${NBCORE} all-gcc || exit 1
			make ${MAKE_FLAGS} ${NBCORE} install-gcc|| exit 1

			rm ${TARGET_CROSS_TOOLS}/bin/${CROSS_TGT_MACH}-gcc
		else

			make ${MAKE_FLAGS} ${NBCORE} all-gcc || exit 1
			make ${MAKE_FLAGS} ${NBCORE} install-gcc|| exit 1

		fi

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_CROSS_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# Make
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_TARGET_MAKE:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE ]
	then
	(
		echo "**********************"
		echo "*   Target Make...   *"
		echo "**********************"

		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv make_target
		cd make_target || exit 1

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
				--prefix="${TARGET_ROOTFS}/usr" \
				--host=$TGT_MACH \
				--target=$TGT_MACH \
				|| exit 1

		make ${MAKE_FLAGS} all install || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE
	) || exit 1
	fi

) || exit 1
fi

####################################################################
# CMAKE
####################################################################

CUR_PACKAGE=${SRC_PACKAGE_TARGET_CMAKE:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE ]
	then
	(
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/ || exit 1

		export CC=${TGT_MACH}-gcc
		export LD=${TGT_MACH}-ld
		export AS=${TGT_MACH}-as
		export AR=${TGT_MACH}-ar
		export DESTDIR=${TARGET_ROOTFS}

		cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_SYSTEM_PREFIX_PATH=${TARGET_ROOTFS} -DCMAKE_INSTALL_PREFIX=/usr/ -DCMAKE_CROSSCOMPILING=1 .

		make ${MAKE_FLAGS} ${NBCORE} clean DESTDIR=${TARGET_ROOTFS} prefix=${TARGET_ROOTFS} || exit 1

		make ${MAKE_FLAGS} ${NBCORE} DESTDIR=${TARGET_ROOTFS} prefix=${TARGET_ROOTFS} CMAKE_CROSSCOMPILING=1  || exit 1
		make ${MAKE_FLAGS} ${NBCORE} DESTDIR=${TARGET_ROOTFS} prefix=${TARGET_ROOTFS} preinstall  CMAKE_CROSSCOMPILING=1 CMAKE_INSTALL_PREFIX=/usr/ || exit 1
		#make ${MAKE_FLAGS} ${NBCORE} DESTDIR=${TARGET_ROOTFS} prefix=${TARGET_ROOTFS} install  CMAKE_CROSSCOMPILING=1  || exit 1
		cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -P cmake_install.cmake -DCMAKE_INSTALL_PREFIX=/usr/ || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${TARGET_BUILD}/${CUR_PACKAGE}_TARGET_DONE

	) || exit 1
	fi
) || exit 1
fi

####################################################################
# Host GCCGO
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_GCCGO:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_GO_BUILD_DONE ]
	then
	(
		echo "**************"
		echo "*  GCCGO...  *"
		echo "**************"

		create_src_dir
		create_build_dir

		unpack_buildtools ${CUR_PACKAGE} ""

		unset PKG_CONFIG_LIBDIR

		CUR_SRC_MAIN_FOLDER=$TMP_ARCHIVE_FOLDER

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}   || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_MPFR##*/}"
		unpack_buildtools ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpfr || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_GMP##*/}"
		unpack_buildtools ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} gmp || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_MPC##*/}"
		unpack_buildtools ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} mpc || exit 1

		TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_ISL##*/}"
		unpack_buildtools ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		mv -v ${TMP_ARCHIVE_FOLDER} isl || exit 1

		#TMP_PACKAGE="${SRC_PACKAGE_BUILD_GCC_CLOOG##*/}"
		#unpack_buildtools ${TMP_PACKAGE} ${CUR_SRC_MAIN_FOLDER}
		#mv -v ${TMP_ARCHIVE_FOLDER} cloog || exit 1

		cd ${TMP_BUILD_FOLDER} || exit 1
		mkdir -pv gccgo_local || exit 1
		cd gccgo_local || exit 1

		TMP_ARCHIVE_FOLDER=$CUR_SRC_MAIN_FOLDER

		${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/configure \
			--prefix="${BUILDTOOLS_HOME}/opt/gccgo" \
			--disable-multilib \
			--enable-languages=c,c++,go  ${GCC_ADD_CONF}  \
			|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} all-gcc || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install-gcc|| exit 1

		make ${MAKE_FLAGS} ${NBCORE} all-target-libgcc || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install-target-libgcc || exit 1

		make ${MAKE_FLAGS} ${NBCORE} all   || exit 1
		make ${MAKE_FLAGS} ${NBCORE} install   || exit 1

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_GO_BUILD_DONE

	) || exit 1
	fi

) || exit 1
fi

####################################################################
# GO boostrap
####################################################################
CUR_PACKAGE=${SRC_PACKAGE_BUILD_GO:-"UNDEF"}
CUR_PACKAGE="${CUR_PACKAGE##*/}"
if [ "$CUR_PACKAGE" != "UNDEF" ]
then
(
	if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_GO_BUILD_DONE ]
	then
	(
		echo "**************"
		echo "*  GO...     *"
		echo "**************"

		mkdir -p  $BUILDTOOLS_HOME/go_bootstrap/ || exit 1

		export BAK_PATH=$PATH
		export PATH=${BUILDTOOLS_HOME}/opt/gccgo/bin:$PATH

		export BOOTSTRAP_CNT=1

		exitloop=0

		while : ; do
			export CUR_BOOTSTRAP_CNT="SRC_PACKAGE_BUILD_GO_BOOTSTRAP_"$(printf "%03d" $BOOTSTRAP_CNT)

			if [ "$exitloop" -ne 0 ]; then
				break
			fi

			if [[ -v $CUR_BOOTSTRAP_CNT ]]
			then
				echo $CUR_BOOTSTRAP_CNT

				#export CUR_PACKAGE=`eval "echo \${$CUR_BOOTSTRAP_CNT}"`
				CUR_PACKAGE=$( eval "echo \$$CUR_BOOTSTRAP_CNT" )
				CUR_PACKAGE="${CUR_PACKAGE##*/}"

				echo Building $CUR_PACKAGE ...
				create_src_dir
				create_build_dir

				unpack ${CUR_PACKAGE} ""

				cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/ || exit 1

				cat VERSION || exit 1

				export BOOTSTRAP_PATH=$BUILDTOOLS_HOME/go_bootstrap/$(printf "%03d" $BOOTSTRAP_CNT)

				export GOROOT=$BOOTSTRAP_PATH
				export GOPATH=$BOOTSTRAP_PATH
				export GOROOT_BOOTSTRAP=$(go env GOROOT)

				if [ ! -f ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_GO_BOOTSTRAP_BUILD_DONE ]
				then
				(
					rm -rf $BOOTSTRAP_PATH
					mkdir -p $BOOTSTRAP_PATH || exit 1
					cp -a . $BOOTSTRAP_PATH || exit 1

					cd $BOOTSTRAP_PATH || exit 1
					cd src || exit 1

					./make.bash || exit 1

					echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_GO_BOOTSTRAP_BUILD_DONE
				) || exit 1
				fi

				export PATH=$BOOTSTRAP_PATH/bin:$BAK_PATH

				go version

				delete_build_dir
				delete_src_dir
			else
				 exitloop=1
			fi

			BOOTSTRAP_CNT=$((BOOTSTRAP_CNT + 1))

			if [ "$BOOTSTRAP_CNT" -gt 99 ]; then
				break
			fi

		done

		CUR_PACKAGE=${SRC_PACKAGE_BUILD_GO:-"UNDEF"}
		CUR_PACKAGE="${CUR_PACKAGE##*/}"

		echo Building $CUR_PACKAGE ...
		create_src_dir
		create_build_dir

		unpack ${CUR_PACKAGE} ""

		cd ${TMP_SRC_FOLDER}/${TMP_ARCHIVE_FOLDER}/ || exit 1

		cat VERSION || exit 1

		export BOOTSTRAP_PATH=$BUILDTOOLS_HOME/opt/go

		export GOROOT=$BOOTSTRAP_PATH
		export GOPATH=$BOOTSTRAP_PATH
		export GOROOT_BOOTSTRAP=$(go env GOROOT)

		rm -rf $BOOTSTRAP_PATH
		mkdir -p $BOOTSTRAP_PATH || exit 1
		cp -a . $BOOTSTRAP_PATH || exit 1

		cd $BOOTSTRAP_PATH || exit 1
		cd src || exit 1

		./make.bash || exit 1

		go version

		delete_build_dir
		delete_src_dir

		echo "" > ${BUILDTOOLS_BUILD}/${CUR_PACKAGE}_GO_BUILD_DONE

	) || exit 1
	fi

) || exit 1
fi

