#!/bin/bash

CUR_PATH=`pwd`
EVN_VAR=TEMPLATECONF
EVN_PATH=$CUR_PATH/meta/meta-mediatek-mt8183/conf/base/aiv8183m1v2_64b
IMAGE_SOURCE_PATH=$CUR_PATH/build/tmp/deploy/images/aiv8183m1v2_64b
BUILD_KERNEL=false
BUILD_LK=false
BUILD_ALL=false
BUILD_CLEAN=false
BUILD_APP=false
PACK_IMAGE=false
PACK_FLD=$CUR_PATH/IMAGE
LOG_FLD=$CUR_PATH/LOG
LOG_FILE_NAME=build.log
ADD_LOG=`echo "tee -a $LOG_FLD/$LOG_FILE_NAME"`

function log_create() {
    echo "--> current path: $CUR_PATH"
    if [   -d "$LOG_FLD" ]; then
        echo "---> clean log"
        rm -rvf $LOG_FLD/*
    else
        echo "---> create log folder"
        mkdir $LOG_FLD
    fi
        touch $LOG_FLD/$LOG_FILE_NAME
}

function pack_folde_create()
{
    echo "--> current path: $CUR_PATH"
    if [   -d "$PACK_FLD" ]; then
        echo "---> pack folder exit"
    else
        echo "---> create pack folder"
        mkdir -p $PACK_FLD
    fi
}

function usage()
{
    echo "       -L = build lk"
    echo "       -K = build kernel"
    echo "       -A = build all"
    echo "       -C = clean"
    echo "       -P = pack image"
    exit
} 

if [ "$1" = "forceclean" ]; then
    echo "---> start manual force clean protocal"
    rm -rvf build/tmp
    exit 1
fi

while getopts "lkamcp" arg
do
    case $arg in
        l)
            echo "will build LK"
            BUILD_LK=true
            ;;
        k)
            echo "will build kernel"
            BUILD_KERNEL=true
            ;;
        a)
            echo "build all"
            BUILD_ALL=true
            ;;
        m)
            echo "build appmainprog"
            BUILD_APP=true
            ;;
        c)
            echo "build clean"
            BUILD_CLEAN=true
            ;;
        p)
            echo "package image"
            PACK_IMAGE=true
            ;;
        ?)
            usage ;;
    esac
done

log_create

echo "------------ start ------------------------------" | $ADD_LOG
echo " current path = $CUR_PATH" | $ADD_LOG
echo "---> set enviorment" | $ADD_LOG
# clean old TEMPLATECONF var
sed -i "/$EVN_VAR/d" ~/.profile
# set current project var
echo "$EVN_VAR=$EVN_PATH" >> ~/.profile
# echo current var
FIND_VAR=`cat ~/.profile | grep TEMPLATECONF`
echo $FIND_VAR | $ADD_LOG
source ~/.profile
echo "----------------------------------------"
source meta/poky/oe-init-build-env
echo "----------------------------------------"
sleep 3s
# bitbake mtk-image-openmm-aiv 2>&1 | tee build_log.log
echo "---> moved in $`pwd`"
if [ "$BUILD_LK" == true ] ; then
    echo "---> no finied yes" | $ADD_LOG
fi 
if [ "$BUILD_KERNEL" == true ] ; then
    echo "---> start build kernel" | $ADD_LOG
    bitbake virtual/kernel -c cleansstate | $ADD_LOG
    bitbake virtual/kernel -f | $ADD_LOG
fi
if [ "$BUILD_ALL" == true ] ; then
    echo "---> start build all" | $ADD_LOG
    bitbake mtk-image-openmm-aiv 2>&1 | $ADD_LOG
    # bitbake mtk-image-openmm-aiv -vDD 2>&1 | tee build_log.log
fi
if [ "$BUILD_APP" == true ] ; then
    echo "---> start build app" | $ADD_LOG
    bitbake appmainprog | $ADD_LOG
    # bitbake mtk-image-openmm-aiv -vDD 2>&1 | tee build_log.log
fi
if [ "$BUILD_CLEAN" == true ] ; then
    echo "---> start clean all" | $ADD_LOG
    bitbake mtk-image-openmm-aiv -c cleanall  | $ADD_LOG
fi
if [ "$PACK_IMAGE" == true ] ; then
    echo "---> start pack image" | $ADD_LOG
    pack_folde_create | $ADD_LOG
    sleep 1s
    DATE=$(date  +%Y%m%d_%H%M%S)
    IMAGE_FLD=IMAGE-$DATE
    mkdir -p $PACK_FLD/$IMAGE_FLD
    cp -raf $IMAGE_SOURCE_PATH $PACK_FLD/$IMAGE_FLD
    echo "---> start pack image finished" | $ADD_LOG
fi
echo "-------------- end ------------------------------"