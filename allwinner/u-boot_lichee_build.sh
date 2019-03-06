#!/bin/bash
CUR_DIR=`pwd`
LOG_FOLDER=log
LOG_DIR=${CUR_DIR}/${LOG_FOLDER}
LOG_FILE=${LOG_DIR}/u-boot_lichee_build.log
UBOOT_DIR=${CUR_DIR}/lichee/brandy

echo "-----> current path : ${CUR_DIR}"
echo "-----> set log file path : ${LOG_DIR}"
echo "-----> set log file name : ${LOG_FILE}"

if [ ! -d "/${LOG_FOLDER}" ]
then
    echo "clean u-boot build log"
    rm -vf ${LOG_FILE}
    touch ${LOG_FILE}
else
    echo "create log dir"
    mkdir ${LOG_DIR}
    touch ${LOG_FILE}
fi

cd ${UBOOT_DIR}
sleep 1s
if [ $? -eq 0 ]
then
    ./build.sh -p sun8iw15p1_axp2231 | tee -a ${LOG_FILE} 
else
    exit
fi
    


