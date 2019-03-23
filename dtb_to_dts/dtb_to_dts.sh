#!/bin/bash

function usage()
{
    echo "------------------------------------------------------------------"
    echo "  ./dtb_to_dts.sh <kernel dir path> <dtb file path>"
    echo "      Example: "
    echo "  ./dtb_to_dts.sh  android_7.0/kernel  /arch/arm/boot/dts/rk3288-evb-android-act8846.dtb"
    echo "  Note: "
    echo "          dts file will be stored in curennt path dtb_compiled_dts folder"
    echo "------------------------------------------------------------------"

if [ $# != 1 -o $# != 2 ]
then
    usage()
    exit 1
fi

CUR_PATH=`pwd`
FOLDER_NAME=dtb_compiled_dts
DATE=$(date  +%Y%m%d.%H%M)
DTB_FILE=`$1`

if [ -d "${CUR_PATH}/${FOLDER_NAME}" ]
then
    # touch ${CUR_PATH}/${FOLDER_NAME}/${DATE}_dts.dts
else
    mkdir ${CUR_PATH}/${FOLDER_NAME}
    # touch ${CUR_PATH}/${FOLDER_NAME}/${DATE}_dts.dts
fi

echo "---> current path is ${CUR_PATH}"
echo "---> dtb file is: ${DTB_FILE}"
./$1/scripts/dtc/dtc -I dtb -O dts $1$2 ${CUR_PATH}/${FOLDER_NAME}/${DATE}_dts.dts



