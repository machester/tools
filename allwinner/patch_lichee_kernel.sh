#!/bin/bash
CUR_DIR=`pwd`
LOG_FOLDER=log

KERNEL_DIR=${CUR_DIR}/lichee
LOG_DIR=${CUR_DIR}/${LOG_FOLDER}

KERNEL_PATCH_LOG=${LOG_DIR}/kernel_patch_log.log
KERNEL_COMMIT_LOG=${LOG_DIR}/kernel_commit_log.log
KERNEL_PATCH_FILE=${LOG_DIR}/kernel_patch.patch

function help
{
    echo "----------- help -----------"
    echo "./<file name> patch"
    echo "./<file name> commit"
    echo "----------- end -----------"
}

function clean_log
{
    if [ "$1" = "patch" ] || [ "" = "$1" ];then
        if [ ! -d "/${LOG_FOLDER}" ];then
            echo "clean kernel patch log"
            rm -vf ${KERNEL_PATCH_FILE} ${KERNEL_PATCH_LOG}
            touch ${KERNEL_PATCH_FILE} ${KERNEL_PATCH_LOG} 
        else
            echo "create log dir"
            mkdir ${LOG_DIR}
            touch ${KERNEL_PATCH_FILE} ${KERNEL_PATCH_LOG} 
        fi
    echo "-----> current path : `pwd`"                          | tee -a ${KERNEL_PATCH_LOG}
    echo "-----> set patch file path : ${KERNEL_PATCH_FILE}"    | tee -a ${KERNEL_PATCH_LOG}
    echo "-----> set log file path : ${KERNEL_PATCH_LOG}"       | tee -a ${KERNEL_PATCH_LOG}

    elif [ "$1" = "commit" ];then
        if [ ! -d "/${LOG_FOLDER}" ];then
            echo "clean kernel commit log"
            rm -vf ${KERNEL_COMMIT_LOG} 
            touch ${KERNEL_COMMIT_LOG} 
        else
            echo "create log dir"
            mkdir ${LOG_DIR}
            touch ${KERNEL_COMMIT_LOG} 
        fi
        echo "-----> current path : `pwd`"                          | tee -a ${KERNEL_COMMIT_LOG}
        echo "-----> set log file path : ${KERNEL_COMMIT_LOG}"      | tee -a ${KERNEL_COMMIT_LOG}
    else
        help
    fi
}

cd ${KERNEL_DIR}
CUR_TIME="`date +%Y-%m-%d,%H:%m:%s`"

if [ $? -eq 0 ];then
    if [ "$1" = "patch" ] || [ "" = "$1" ];then
        clean_log
        
        cd ${KERNEL_DIR}/linux-4.9 
        echo "`pwd`" | tee -a ${KERNEL_PATCH_LOG}
        git diff . >> ${KERNEL_PATCH_FILE} | tee -a ${KERNEL_PATCH_LOG}
        sleep 1s
        echo "------------------------------------------------------------------------------" | tee -a ${KERNEL_PATCH_LOG}
        cd ${KERNEL_DIR}/tools
        echo "`pwd`" | tee -a ${KERNEL_PATCH_LOG}
        git diff . >> ${KERNEL_PATCH_FILE} | tee -a ${KERNEL_PATCH_LOG}
        sleep 1s
        echo "------------------------------------------------------------------------------" | tee -a ${KERNEL_PATCH_LOG}
        cd ${KERNEL_DIR}/buildroot 
        echo "`pwd`" | tee -a ${KERNEL_PATCH_LOG}
        git diff . >> ${KERNEL_PATCH_FILE} | tee -a ${KERNEL_PATCH_LOG}
        sleep 1s
        echo "------------------------------------------------------------------------------" | tee -a ${KERNEL_PATCH_LOG}
        cd ${KERNEL_DIR}/brandy
        echo "`pwd`" | tee -a ${KERNEL_PATCH_LOG}
        git diff . >> ${KERNEL_PATCH_FILE} | tee -a ${KERNEL_PATCH_LOG}
        sleep 1s
        echo "------------------------------------------------------------------------------" | tee -a ${KERNEL_PATCH_LOG}
        cd ${KERNEL_DIR}/bootloader
        echo "`pwd`" | tee -a ${KERNEL_PATCH_LOG}
        git diff . >> ${KERNEL_PATCH_FILE} | tee -a ${KERNEL_PATCH_LOG}
        
    elif [ "$1" = "commit" ];then
        clean_log
        
        cd ${KERNEL_DIR}/linux-4.9 | tee -a ${KERNEL_COMMIT}
        git add .
        git commit -m "commit kernel ${CUR_TIME}" | tee -a ${KERNEL_COMMIT}
        sleep 1s
        echo "------------------------------------------------------------------------------" | tee -a ${KERNEL_COMMIT}
        cd ${KERNEL_DIR}/tools | tee -a ${KERNEL_COMMIT}
        git add .
        git commit -m "commit kernel ${CUR_TIME}" | tee -a ${KERNEL_COMMIT}
        sleep 1s
        echo "------------------------------------------------------------------------------" | tee -a ${KERNEL_COMMIT}
        cd ${KERNEL_DIR}/buildroot | tee -a ${KERNEL_COMMIT}
        git add .
        git commit -m "commit kernel ${CUR_TIME}" | tee -a ${KERNEL_COMMIT}
        sleep 1s
        echo "------------------------------------------------------------------------------" | tee -a ${KERNEL_COMMIT}
        cd ${KERNEL_DIR}/brandy | tee -a ${KERNEL_COMMIT}
        git add .
        git commit -m "commit kernel ${CUR_TIME}" | tee -a ${KERNEL_COMMIT}
        sleep 1s
        echo "------------------------------------------------------------------------------" | tee -a ${KERNEL_COMMIT}
        cd ${KERNEL_DIR}/bootloader  | tee -a ${KERNEL_COMMIT}
        git add .
        git commit -m "commit kernel ${CUR_TIME}" | tee -a ${KERNEL_COMMIT}
        sleep 1s
        
    else
        echo "----> command error"
        help
        exit
    fi
fi
    


