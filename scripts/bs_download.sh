#!/bin/bash
#
# Cross compiler and Linux generation scripts
# (c)2014-2018 Jean-François DEL NERO
#
# Package download script
#

source ${TARGET_CONFIG}/config.sh || exit 1

function dowload_list {
	while IFS='' read -r line || [[ -n "$line" ]]; do
	if [[ $line != \#* ]];
	then
		echo "Downloading $line ..."
		wget -c $line --no-check-certificate --no-clobber --directory-prefix=${TARGET_DOWNLOAD}
	fi
	done < "$1"
}

echo "**********************************"
echo "*   Starting Download packages   *"
echo "**********************************"

mkdir -p ${TARGET_HOME}/download || exit 1

set | grep SRC_PACKAGE_ | cut -f2 -d"=" > ${TARGET_DOWNLOAD}/download_list.txt

dowload_list ${TARGET_DOWNLOAD}/download_list.txt

exit 0
