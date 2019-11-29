#!/bin/bash

CURPATH=`pwd`
BUILD_DATE=$(date +"%Y%m%d_%H%M%S")

SD_FACTORY_IMG_NAME=factory_test-$BUILD_DATE
SD_FACTORY_IMG_DIR=SD_FACTORY_IMG_DIR
TARGET_PRODUCT=rk3288
DEVICE=rk3288
BUILD_VARIANT=userdebug
SD_FACTORY_TOOL_PATCH=$CURPATH/RKTools/sd_card_factory_test_tools
IMAGE_PATH=rockdev/Image-$TARGET_PRODUCT
SD_FACTORY_TOOL_PATCH=$CURPATH/RKTools/sd_card_factory_test_tools
echo "------------------------------ start ------------------------------"
echo "current path = $CURPATH"
echo "time is: $BUILD_DATE"
mkdir -p $CURPATH/$SD_FACTORY_IMG_DIR
mkdir -p $CURPATH/$SD_FACTORY_IMG_DIR/$CUR_TIME
mkdir -p $SD_FACTORY_TOOL_PATCH/Image

cp -vf $IMAGE_PATH/* $SD_FACTORY_TOOL_PATCH/Image
cd $SD_FACTORY_TOOL_PATCH

echo "start to make factory_test.img..."
if [ ! -f "Image/parameter" -a ! -f "Image/parameter.txt" ]; then
	echo "Error:No found parameter!"
	exit 1
fi
if [ ! -f "package-file" ]; then
	echo "Error:No found package-file!"
	exit 1
fi
./afptool -pack ./ Image/$SD_FACTORY_IMG_NAME.img
./rkImageMaker -RK32 Image/MiniLoaderAll.bin Image/$SD_FACTORY_IMG_NAME.img $SD_FACTORY_IMG_NAME.img -os_type:androidos || pause
echo "Making factory_test.img"

if [ $? -eq 0 ]; then
    echo "---> Make factory_test image ok!"
else
    echo "---> Make factory_test image failed!"
    exit 1
fi
cp -vf $SD_FACTORY_TOOL_PATCH/$SD_FACTORY_IMG_NAME.img $CURPATH/$SD_FACTORY_IMG_DIR/$CUR_TIME
rm -rvf $SD_FACTORY_TOOL_PATCH/Image
rm -vf $SD_FACTORY_TOOL_PATCH/$SD_FACTORY_IMG_NAME.img
cd $CURPATH
echo "------------------------------ end ------------------------------"

