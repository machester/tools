#!/bin/bash
echo "------------- process start --------------"
if [ $# -eq 2 ]
then
    echo "ready to download code to 8.1 dir"
    echo "command is ${0} ${1} ${2}"
else
    echo "usage ./shell.sh folder_name fetch_project"
    exit
fi
PROJECT_FLODER=`echo $1`
PROJECT=`echo $2`
PATH_DIR=/home/jiangq/work/jiangq/8.1
LOG_DIR=${PATH_DIR}/${PROJECT_FLODER}/fetch_log

cd ${PATH_DIR}
# if current dir equal PATH_DIR
if [ "$(pwd)" != "${PATH_DIR}" ]
then
    echo "---> change to work dir error"
    exit
else
    echo "moved in ---> " $(pwd)
fi
if [ ! -d "/${PROJECT_FLODER}" ]
then
    echo ${PROJECT_FLODER}" DIR has been exist,  ready to remove"
    rm -rf ${PROJECT_FLODER}
    echo "---> remove dir" ${PROJECT_FLODER}
    mkdir ${PROJECT_FLODER}
    mkdir ${PROJECT_FLODER}/fetch_log
    if [ $? -eq 0 ]
    then
        echo ${PROJECT_FLODER} " dir created"
    else
        echo ${PROJECT_FLODER} " dir create falied"
        exit
    fi
else
    mkdir ${PROJECT_FLODER}
    mkdir ${PROJECT_FLODER}/fetch_log
    if [ $? -eq 0 ]
    then
        echo "dir created"
    else
        echo "dir creat falied..."
        exit
    fi
fi
echo "file store in " ${PATH_DIR}"/"${PROJECT_FLODER}
echo "log store in " ${LOG_DIR}
echo "---> ready to procceed. Download " ${PROJECT} " to "${PATH_DIR}/${PROJECT_FLODER}
sleep 5s
#-------------------------------------------------------------------
cd ${PATH_DIR}/${PROJECT_FLODER}
echo "move in "$(pwd)
echo "---------------------------------------------------------------"
fetch ${PROJECT} | tee ${LOG_DIR}/fetch.log
if [ $? -eq 0 ]
then 
    echo "---> fetch succeed." | tee -a ${LOG_DIR}/fetch.log
else
    echo "---> fetch failed." | tee -a ${LOG_DIR}/fetch.log
    exit
fi
cd ${PATH_DIR}/${PROJECT_FLODER}/alps
echo "--------------------------------------------------------------"
echo "---> switch brach to work_branch"
repo branch | tee -a ${LOG_DIR}/fetch.log
repo forall -c git checkout -b work_branch | tee -a ${LOG_DIR}/fetch.log

echo "----------------- succeed ------------------"
exit
