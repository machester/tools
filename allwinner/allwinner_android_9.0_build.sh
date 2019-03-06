!/bin/bash
##############################################################################
# android kernel build
# usage
#   
##############################################################################

CUR_DIR=`pwd`
LOG_FOLDER=log
LOG_DIR=${CUR_DIR}/${LOG_FOLDER}
LOG_FILE=${LOG_DIR}/allwinner_android_build.log
ANDROID_KERNEL_DIR=${CUR_DIR}/android

function android_kernel_build
{
    echo "--------------------> source envsetup.sh" | tee -a ${LOG_FILE}
    source build/envsetup.sh | tee -a ${LOG_FILE}
    echo "--------------------> lunch venus_a3-userdebug" | tee -a ${LOG_FILE}
    lunch venus_a3-userdebug | tee -a ${LOG_FILE}
    echo "--------------------> extract-bsp" | tee -a ${LOG_FILE}
    extract-bsp | tee -a allwinner_android_build.log | tee -a ${LOG_FILE}
    echo "--------------------> make installclean" | tee -a ${LOG_FILE}
    make installclean | tee -a allwinner_android_build.log | tee -a ${LOG_FILE}
    echo "--------------------> make -j22" | tee -a ${LOG_FILE}
    make -j22 | tee -a allwinner_android_build.log | tee -a ${LOG_FILE}

}

function pack_image
{
    pack -b p105p
}


echo "-----> current path : ${CUR_DIR}"
echo "-----> android kernel  path : ${ANDROID_KERNEL_DIR}"
echo "-----> set log file path : ${LOG_DIR}"

if [ ! -d "/${LOG_FOLDER}" ]
then
    echo "clean android kernel  build log"
    rm -vf ${LOG_FILE}
    touch ${LOG_FILE}
else
    echo "create log dir"
    mkdir ${LOG_DIR}
    echo `touch ${LOG_FILE}`
fi


cd ${ANDROID_KERNEL_DIR}

if [ $? -eq 0 ] 
then
    android_kernel_build
    if [ $? -eq 0 ]
    then
        echo "-------> android kernel build success, packe image in 3 seconds"
        sleep 3s
       # pack_image
    else
        echo "-------> android kernel build failed"
        exit
    fi
fi


