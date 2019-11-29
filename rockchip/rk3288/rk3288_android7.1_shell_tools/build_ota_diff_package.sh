#!/bin/bash
####################################################################################
#./build/tools/releasetools/ota_from_target_files -v -i OTA_PACKAGE/rk3288-target_files-eng.old_jiangq.zip -p out/host/linux-x86 -k build/target/product/security/testkey OTA_PACKAGE/rk3288-target_files-eng.new_jiangq.zip  OTA_PACKAGE/rk3288-target_files-ota_diff-eng.zip
#
#####################################################################################
CUR_PATH=`PWM`
BUILD_PROP_PATH=$CUR_PATH/out/target/product/rk3288/system
function format()
{
	echo "-----------------------------------------------------------"
	echo "	./build_ota_diff_package.sh <ota_package_new> <ota_package_old>"
	echo "-----------------------------------------------------------"
}

echo "---------------- start build ota diff package ------------------------"
if [ $# -neq 2 ]; then
	format
echo "current folder dir: $CUR_PATH"

# mkimage.sh
echo "make and copy android images"
./mkimage.sh
if [ $# -neq 0 ]; then
    echo "Make image ok!"
else
    echo "Make image failed!"
    exit 1
fi

build.prop

echo "------------------------------ end -----------------------------------"