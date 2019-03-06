#!/bin/bash
CUR_DIR=`pwd`
LOG_FOLDER=log
LOG_DIR=${CUR_DIR}/${LOG_FOLDER}
LOG_FILE=${LOG_DIR}/kernel_lichee_build.log
KERNEL_BUILD=${CUR_DIR}/lichee

echo "-----> current path : ${CUR_DIR}"
echo "-----> set log file path : ${LOG_DIR}"
echo "-----> set log file name : ${LOG_FILE}"

if [ ! -d "/${LOG_FOLDER}" ]
then
    echo "clean kernel build log"
    rm -vf ${LOG_FILE}
    touch ${LOG_FILE}
else
    echo "create log dir"
    mkdir ${LOG_DIR}
    touch ${LOG_FILE}
fi

echo "------> before build kernel make sure kernel has been configurated"
echo "             if not using param 'config' to configrate kernel"
cd ${KERNEL_BUILD}

if [ $? -eq 0 ];then
    if [ "$1" = "config"];then
        ./build.sh config | tee -a ${LOG_FILE}
    elif [ "" = "$1" ];then
        ./build.sh | tee -a ${LOG_FILE}
    else
        echo "----> command error"
        exit
    fi
fi
    


