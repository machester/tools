#!/bin/bash

echo "---> start build"

CUR_DIR=`pwd`

IMG_DIR_NAME=IMAGES
LOG_DIR_NAME=log
LOG_FILE_NAME=log_build.log
LOG_FILE_PATH=$CUR_DIR/$LOG_DIR_NAME/$LOG_FILE_NAME

# BUILD_TYPE=user
BUILD_TYPE=userdebug
BUILD_PROJECT=op300_1h10_go2g
# BUILD_PROJECT=op300_1h10_go2g_nosec
# GMS_TYPE=gms
GMS_TYPE=native

BUILD_CORES=20

needCleanModule=false
VAR_NUM=$#
echo "input param: $VAR_NUM"

sleep 1s

# function check_param()
# {
#     echo "input param: $VAR_NUM"
#     if [ $# -eq 1 ]; then
    
#     fi
# }



function ErrorMsg()
{
    if [ $# -ne 1 ]; then
        echo "no param transfred in error msg"
    else
        echo -e "\e[1;31m ERROR: $1 \e[0m"
    fi
}

function PassMsg()
{
    if [ $# -ne 1 ]; then
        echo "no param transfred in pass msg"
    else
        echo -e "\e[1;36m PASS: $1 \e[0m"
    fi
}

function DebugMsg()
{
    if [ $# -ne 1 ]; then
        echo "no param transfred in debug msg"
    else
        echo -e "\e[1;33m DEBUG: $1 \e[0m"
    fi
}

function CreateLogDir()
{
    if [ ! -d $LOG_DIR_NAME ]; then
        DebugMsg "$LOG_DIR_NAME Not exsit"
        DebugMsg "$creat log dir: LOG_DIR_NAME"
        mkdir $CUR_DIR/$LOG_DIR_NAME
        touch $CUR_DIR/$LOG_DIR_NAME/$LOG_FILE_NAME
    else
        DebugMsg "Clean $CUR_DIR/$LOG_DIR_NAME/"
        echo "" > $CUR_DIR/$LOG_DIR_NAME/$LOG_FILE_NAME
    fi
}

function CreateImgDir()
{
    if [ ! -d $IMG_DIR_NAME ]; then
        DebugMsg "$IMG_DIR_NAME not exsit"
        mkdir $CUR_DIR/$IMG_DIR_NAME
    fi
}

function FindCopyImage()
{
    CurTime=$(date +%Y-%m-%d_%H-%M-%S)
    DebugMsg "TIME: $CurTime"

    PAC_FILE_PATH=`find out -name *.pac`
    if [ "$PAC_FILE_PATH" == "" ]; then
        ErrorMsg "Miss pac file: $PAC_FILE_PATH"
        exit 1
    else
        DebugMsg "Found pac file: $PAC_FILE_PATH"
    fi

    mkdir tmpDir
    cp -vf $PAC_FILE_PATH tmpDir

    cd tmpDir
    
    rename -v 's/\.pac/'_$CurTime'\.pac/g' *.pac
    IMAGE_NAME=`ls *.pac`
    mv $IMAGE_NAME $CUR_DIR/$IMG_DIR_NAME
    cd -
    
    DebugMsg "clean build pac files"
    rm -vf $PAC_FILE_PATH
    rm -rf tmpDir

    PassMsg "image stored in path $CUR_DIR/$IMG_DIR_NAME/$IMAGE_NAME"
}

function CleanModules()
{
    DebugMsg " start clean out modules"
    # rm -rvf `find out/target/product/$BUILD_PROJECT/vendor/ -name libparam*.so`
    DebugMsg " finished modules"
}

function IsBuildPass()
{
    DebugMsg "check if build pass"

}

function CleanKernelFiles()
{
    DebugMsg "Clean dts"
    rm -vf `find bsp/out -name "*.dtb*"`
}

function BuildAll()
{
    PassMsg "ready to start build all"

    # clean module
    if [ "true" == "$needCleanModule" ]; then
        CleanModules
    fi

    source build/envsetup.sh

    echo "lunch $BUILD_PROJECT-$BUILD_TYPE-$GMS_TYPE"

    lunch $BUILD_PROJECT-$BUILD_TYPE-$GMS_TYPE

    make -j$BUILD_CORES | tee -a $LOG_FILE_PATH
    # make -j$BUILD_CORES
    retValue=${PIPESTATUS[0]}
    echo "---> make PIPESTATUS[0]: $retValue"
    if [ "$retValue" -ne "0" ]; then
        ErrorMsg "make build failed"
        exit 1
    fi

    cp_sign | tee -a $LOG_FILE_PATH
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        ErrorMsg "cp_sign failed"
        exit 1
    fi

    makepac | tee -a $LOG_FILE_PATH
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        ErrorMsg "makepac failed"
        exit 1
    fi
}

if [ "$1" == "module_clean" ]; then
    DebugMsg "module clean selected"
    needCleanModule=true
fi

# start build project
CreateLogDir
CleanKernelFiles
BuildAll

if [ $? -eq 0 ]; then
    DebugMsg "image prepare"
    CreateImgDir
fi

if [ $? -eq 0 ]; then
    DebugMsg "find and copy image file"
    FindCopyImage
fi
