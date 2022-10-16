#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Main entry script
#

CROSS_BUILD_SIGN=${CROSS_BUILD_SIGN:-"UNDEF"}

if [ $CROSS_BUILD_SIGN != "CROSS_ENV_SET" ]; then

echo "*******************************"
echo "*    Environment not set !    *"
echo "*   Please call set_env.sh    *"
echo "*******************************"

exit 2

fi

stage_download="yes"
stage_sysbase="yes"
stage_libraries="yes"
stage_sysshell="yes"
stage_services="yes"
stage_debugdev="yes"
stage_graphicstack="yes"
stage_audiostack="yes"
stage_network="yes"
stage_miscellaneous="yes"
stage_games="yes"
stage_buildtools="yes"
stage_target_compiler="yes"

export build_start_timestamp=`date +"%s"`

source ${COMMON_CONFIG}/config.sh || exit 1
source ${TARGET_CONFIG}/config.sh || exit 1

CROSSCOMPILERONLY_TMP=${CROSSCOMPILERONLY:-"UNDEF"}
CROSSCOMPILERONLY_TMP="${CROSSCOMPILERONLY_TMP##*/}"
if [ "$CROSSCOMPILERONLY_TMP" = "1" ];
then
	stage_download="yes"
	stage_sysbase="yes"
	stage_libraries="no"
	stage_sysshell="no"
	stage_services="no"
	stage_debugdev="no"
	stage_graphicstack="no"
	stage_audiostack="no"
	stage_network="no"
	stage_miscellaneous="no"
	stage_games="no"
	stage_buildtools="no"
	stage_target_compiler="no"
fi

mkdir -p ${TARGET_HOME}/download             || exit 1
mkdir -p ${TARGET_HOME}/build                || exit 1
mkdir -p ${TARGET_HOME}/sources              || exit 1
mkdir -p ${TARGET_ROOTFS}                    || exit 1

####################################################################
# Sources Download...
####################################################################
if [ $stage_download = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_download.sh
) || exit 1

fi

####################################################################
# Build root tree
####################################################################
(
	${SCRIPTS_HOME}/bs_init_rootfs_tree.sh
)

####################################################################
# Local build tools
####################################################################
if [ $stage_buildtools = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_build_tools.sh
) || exit 1
fi

####################################################################
# System Base (Crosscompiler + Glibc + C/C++ libs + kernel)
####################################################################
if [ $stage_sysbase = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_system_base.sh
) || exit 1
fi

####################################################################
# Librairies
####################################################################
if [ $stage_libraries = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_libraries.sh
) || exit 1
fi

####################################################################
# System shell
####################################################################
if [ $stage_sysshell = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_system_shell.sh
) || exit 1
fi

####################################################################
# System services
####################################################################
if [ $stage_services = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_services.sh
) || exit 1
fi

####################################################################
# Network support
####################################################################
if [ $stage_network = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_network.sh
) || exit 1
fi

####################################################################
# Graphic stack
####################################################################
if [ $stage_graphicstack = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_graphic_stack.sh
) || exit 1
fi

####################################################################
# Audio stack
####################################################################
if [ $stage_audiostack = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_audio_stack.sh
) || exit 1
fi

####################################################################
# Miscellaneous
####################################################################
if [ $stage_miscellaneous = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_misc.sh
) || exit 1
fi

####################################################################
# Debug & Dev tools
####################################################################
if [ $stage_debugdev = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_debug_dev.sh
) || exit 1
fi

####################################################################
# Target build system (Binutils + GCC)
####################################################################
if [ $stage_target_compiler = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_target_devtools.sh
) || exit 1
fi

####################################################################
# Games
####################################################################
if [ $stage_games = "yes" ];
then
(
	${SCRIPTS_HOME}/bs_games.sh
) || exit 1
fi

(
	echo "*************************************"
	echo "*************************************"
	echo "**       System build done !       **"
	echo "*************************************"
	echo "*************************************"
	date

	export build_stop_timestamp=`date +"%s"`
	export compile_time=$(($build_stop_timestamp-$build_start_timestamp))
	echo "Compile time : $(($compile_time/60/60))h:$((($compile_time/60) % 60))m:$(($compile_time % 60))s"
)

