#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Package download script
#

source ${TARGET_CONFIG}/config.sh || exit 1

function download_list {
	while IFS='' read -r line || [[ -n "$line" ]]; do
	if [[ $line != \#* ]];
	then
		echo "Downloading $line ..."
		wget -c $line --no-check-certificate --no-clobber --directory-prefix=$2
	fi
	done < "$1"
}

echo "**********************************"
echo "*   Starting Download packages   *"
echo "**********************************"

mkdir -p ${TARGET_HOME}/download || exit 1
echo >${TARGET_DOWNLOAD}/download_list.txt
set | grep SRC_PACKAGE_ | grep -v "@COMMON@" | cut -f2 -d"=" > ${TARGET_DOWNLOAD}/download_list.txt
download_list ${TARGET_DOWNLOAD}/download_list.txt ${TARGET_DOWNLOAD}

mkdir -p ${COMMON_HOME}/download || exit 1
echo >${COMMON_DOWNLOAD}/download_list.txt
set | grep SRC_PACKAGE_ | grep "@COMMON@" | sed s#@COMMON@##g | cut -f2 -d"=" > ${COMMON_DOWNLOAD}/download_list.txt
download_list ${COMMON_DOWNLOAD}/download_list.txt ${COMMON_DOWNLOAD}

exit 0
