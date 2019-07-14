#!/bin/bash
usage()
{
    echo "USAGE: [-o] [-u] [-v VERSION_NAME]"
    echo "No ARGS means use default build option"
    echo "WHERE: -o = generate ota package       "
    echo "       -u = generate update.img        "
    echo "       -v = set build version name for output image folder"
    echo "       -U = build u-boot"
    echo "       -K = build kernel"
    echo "       -A = build android "
    exit 1
}

BUILD_UBOOT=false
BUILD_KERNEL=false
BUILD_ANDROID=false
BUILD_UPDATE_IMG=false
BUILD_OTA=false
BUILD_VARIANT=userdebug

CUR_PATH=`pwd`
LOG_FLD=$CUR_PATH/LOG
UBOOT_LOG_FILE=$LOG_FLD/uboot.log
KERNEL_LOG_FILE=$LOG_FLD/kernel.log
PACKAGE_LOG_FILE=$LOG_FLD/pack.log
ANDROID_LOG_FILE=$LOG_FLD/android.log
UBOOT_LOG=`echo "tee -a $UBOOT_LOG_FILE"`
KERNEL_LOG=`echo "tee -a $KERNEL_LOG_FILE"`
ANDROID_LOG=`echo "tee -a $ANDROID_LOG_FILE"`
PACKAGE_LOG=`echo "tee -a $PACKAGE_LOG_FILE"`
####################### start: create log file ##################
function log_create() {
    echo "--> current path: $CUR_PATH"
    if [   -d "$LOG_FLD" ]; then
        echo "---> clean log"
        rm -rvf $LOG_FLD/*
    else
        echo "---> create log folder"
        mkdir $LOG_FLD
    fi
        touch $UBOOT_LOG_FILE
        touch $UBOOT_LOG_FILE
        touch $UBOOT_LOG_FILE
        touch $PACKAGE_LOG_FILE
}
####################### end: create log file ####################
# check pass argument
while getopts "UKAouv:" arg
do
    case $arg in
        U)
            echo "will build u-boot"
            BUILD_UBOOT=true
            ;;
        K)
            echo "will build kernel"
            BUILD_KERNEL=true
            ;;
        A)
            echo "will build android"
            BUILD_ANDROID=true
            ;;
        o)
            echo "will build ota package"
            BUILD_OTA=true
            ;;
        u)
            echo "will build update.img"
            BUILD_UPDATE_IMG=true
            ;;
        v)
            BUILD_VARIANT=$OPTARG
            ;;
        ?)
            usage ;;
    esac
done
log_create
source build/envsetup.sh >/dev/null && setpaths
TARGET_PRODUCT=`get_build_var TARGET_PRODUCT`
# TARGET_PRODUCT=rk3288_box
#set jdk version
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar
# source environment and chose target product
DEVICE=`get_build_var TARGET_PRODUCT`
# DEVICE=rk3288_r100u_box
# DEVICE=rk3288_box
UBOOT_DEFCONFIG=rk3288_secure_defconfig
# KERNEL_DEFCONFIG=rockchip_defconfig
KERNEL_DEFCONFIG=rockchip_r100u_defconfig
KERNEL_DTS=rk3288-r100u-android
# KERNEL_DTS=rk3288-evb-android-rk808-edp
echo "KERNEL_DTS : $KERNEL_DTS"


 
PACK_TOOL_DIR=RKTools/linux/Linux_Pack_Firmware
IMAGE_PATH=rockdev/Image-$TARGET_PRODUCT
export PROJECT_TOP=`gettop`

########### start: copy build.prop for FOTA package ###############
BUILD_PROP_FILE=out/target/product/$DEVICE/system/build.prop
########### end: copy build.prop for FOTA package ###############

lunch $DEVICE-$BUILD_VARIANT | $ANDROID_LOG

PLATFORM_VERSION=`get_build_var PLATFORM_VERSION`
DATE=$(date  +%Y%m%d.%H%M)
STUB_PATH=Image/"$KERNEL_DTS"_"$PLATFORM_VERSION"_"$DATE"_RELEASE_TEST_$BUILD_VARIANT
STUB_PATH="$(echo $STUB_PATH | tr '[:lower:]' '[:upper:]')"
export STUB_PATH=$PROJECT_TOP/$STUB_PATH
export STUB_PATCH_PATH=$STUB_PATH/PATCHES

# build uboot
if [ "$BUILD_UBOOT" = true ] ; then
echo "start build uboot" | $UBOOT_LOG
cd u-boot && make clean | $UBOOT_LOG
make $UBOOT_DEFCONFIG | $UBOOT_LOG
./mkv7.sh | $UBOOT_LOG
cd -
if [ $? -eq 0 ]; then
    echo "Build uboot ok!" | $UBOOT_LOG
else
    echo "Build uboot failed!" | $UBOOT_LOG
    exit 1
fi
fi

# build kernel
if [ "$BUILD_KERNEL" = true ] ; then
echo "Start build kernel" | $KERNEL_LOG
cd kernel && make clean | $KERNEL_LOG
make ARCH=arm $KERNEL_DEFCONFIG | $KERNEL_LOG
make ARCH=arm $KERNEL_DTS.img -j24 | $KERNEL_LOG
cd -
if [ $? -eq 0 ]; then
    echo "Build kernel ok!" | $KERNEL_LOG
else
    echo "Build kernel failed!" | $KERNEL_LOG
    exit 1
fi
fi

# build android
if [ "$BUILD_ANDROID" = true ] ; then
echo "start build android" | $ANDROID_LOG

make installclean -j8 | $ANDROID_LOG
make -j24 | $ANDROID_LOG
if [ $? -eq 0 ]; then
    echo "Build android ok!" | $ANDROID_LOG
else
    echo "Build android failed!" | $ANDROID_LOG
    exit 1
fi
fi

if [ "$BUILD_VARIANT" = user ] ; then
    if [ -e $PROJECT_TOP/build_back/system/build.prop ] ; then
        echo "restore system/build.prop"
        cp $PROJECT_TOP/build_back/system/build.prop $OUT/system/
    else
        echo "backup system/build.prop"
        mkdir -p $PROJECT_TOP/build_back/system
        cp $OUT/system/build.prop $PROJECT_TOP/build_back/system/build.prop
    fi
    if [ -e $PROJECT_TOP/build_back/system/etc/prop.default ] ; then
        echo "restore system/etc/prop.default"
        cp $PROJECT_TOP/build_back/system/etc/prop.default $OUT/system/etc/
    else
        echo "backup system/etc/prop.default"
        mkdir -p $PROJECT_TOP/build_back/system/etc
        cp $OUT/system/etc/prop.default $PROJECT_TOP/build_back/system/etc/prop.default
    fi
    if [ -e $PROJECT_TOP/build_back/vendor/build.prop ] ; then
        echo "restore vendor/build.prop"
        cp $PROJECT_TOP/build_back/vendor/build.prop $OUT/vendor/
    else
        echo "backup vendor/build.prop"
        mkdir -p $PROJECT_TOP/build_back/vendor
        cp $OUT/vendor/build.prop $PROJECT_TOP/build_back/vendor/build.prop
    fi
    if [ -e $PROJECT_TOP/build_back/vendor/default.prop ] ; then
        echo "restore vendor/default.prop"
        cp $PROJECT_TOP/build_back/vendor/default.prop $OUT/vendor/
    else
        echo "backup vendor/default.prop"
        mkdir -p $PROJECT_TOP/build_back/vendor
        cp $OUT/vendor/default.prop $PROJECT_TOP/build_back/vendor/default.prop
    fi
fi

# mkimage.sh
echo "make and copy android images" | $PACKAGE_LOG
./mkimage.sh | $PACKAGE_LOG 
if [ $? -eq 0 ]; then
    echo "Make image ok!" | $PACKAGE_LOG
else
    echo "Make image failed!" | $PACKAGE_LOG
    exit 1
fi

# build ota_package
if [ "$BUILD_OTA" = true ] ; then
    INTERNAL_OTA_PACKAGE_OBJ_TARGET=obj/PACKAGING/target_files_intermediates/$TARGET_PRODUCT-target_files-*.zip
    INTERNAL_OTA_PACKAGE_TARGET=$TARGET_PRODUCT-ota-*.zip
    echo "generate ota package"
    make otapackage -j8
    ./mkimage.sh ota
    cp $OUT/$INTERNAL_OTA_PACKAGE_TARGET $IMAGE_PATH/
    cp $OUT/$INTERNAL_OTA_PACKAGE_OBJ_TARGET $IMAGE_PATH/
fi

# build update_image
if [ "$BUILD_UPDATE_IMG" = true ] ; then
	mkdir -p $PACK_TOOL_DIR/rockdev/Image/ | $PACKAGE_LOG
	cp -f $IMAGE_PATH/* $PACK_TOOL_DIR/rockdev/Image/ | $PACKAGE_LOG

	echo "Make update.img" | $PACKAGE_LOG
	cd $PACK_TOOL_DIR/rockdev && ./mkupdate.sh | $PACKAGE_LOG
	if [ $? -eq 0 ]; then
		echo "Make update image ok!" | $PACKAGE_LOG
	else
		echo "Make update image failed!" | $PACKAGE_LOG
		exit 1
	fi

	cd -
	mv $PACK_TOOL_DIR/rockdev/update.img $IMAGE_PATH/ | $PACKAGE_LOG
	rm $PACK_TOOL_DIR/rockdev/Image -rf | $PACKAGE_LOG
fi

mkdir -p $STUB_PATH | $PACKAGE_LOG
####################### start: get file change patch #############################
#Generate patches
# make patch
# mkdir -p $STUB_PATCH_PATH && .repo/repo/repo forall -c "git diff > local_diff.patch" && (find . -name local_diff.patch -type f -size 0c| xargs rm) && (find . -path ./IMAGE -prune -o -name local_diff.patch | cpio -pdv $STUB_PATCH_PATH/)
# if [ -d $STUB_PATCH_PATH/IMAGE ]; then
#     rm $STUB_PATCH_PATH/IMAGE -rf
# fi

#Copy stubs
# cp commit_id.xml $STUB_PATH/manifest_${DATE}.xml
####################### end: get file change patch #############################
mkdir -p $STUB_PATH/kernel | $PACKAGE_LOG
cp kernel/.config $STUB_PATH/kernel | $PACKAGE_LOG
cp kernel/vmlinux $STUB_PATH/kernel | $PACKAGE_LOG
# copy build.prop file for fota
cp -vf $BUILD_PROP_FILE $STUB_PATH/ | $PACKAGE_LOG

mkdir -p $STUB_PATH/IMAGES/
cp $IMAGE_PATH/* $STUB_PATH/IMAGES/ | $PACKAGE_LOG
cp build.sh $STUB_PATH/build.sh | $PACKAGE_LOG
#Save build command info
echo "UBOOT:  defconfig: $UBOOT_DEFCONFIG" >> $STUB_PATH/build_cmd_info | $PACKAGE_LOG
echo "KERNEL: defconfig: $KERNEL_DEFCONFIG, dts: $KERNEL_DTS" >> $STUB_PATH/build_cmd_info | $PACKAGE_LOG
echo "ANDROID:$DEVICE-$BUILD_VARIANT" >> $STUB_PATH/build_cmd_info | $PACKAGE_LOG
