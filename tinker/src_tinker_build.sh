#!/bin/bash

echo "---------------> tinker board s kernel build start ------------------------" | tee ./build.log
echo "---------------> rm build.log" | tee -a ./build.log
sudo rm -f build.log
cd debian_kernel

echo "---------------> current dir = "$(pwd) | tee -a ../build.log
echo "---------------> clean : make distclean"  | tee -a ../build.log
sudo make distclean | tee -a ../build.log
sleep 3s
echo "---------------> make miniarm-rk3288_defconfig ARCH=arm -j2"
sudo make miniarm-rk3288_defconfig ARCH=arm -j2 | tee -a ../build.log

echo "---------------> make zImage ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j2" | tee -a ../build.log
sudo make zImage ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j2 | tee -a ../build.log | tee -a ../build.log

echo "---------------> make modules ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j2 CFLAGS_MODULE=-Wno-misleading-indentation" | tee -a ../build.log
sudo make modules ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j2 CFLAGS_MODULE=-Wno-misleading-indentation | tee -a ../build.log

echo "---------------> make rk3288-miniarm.dtb ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j2" | tee -a ../build.log
sudo make rk3288-miniarm.dtb ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j2 | tee -a ../build.log

echo "---------------> make rk3288-miniarm.dtb ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j2" | tee -a ../build.log
sudo make dtbs ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j2 | tee -a ../build.log

