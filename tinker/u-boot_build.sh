cd debian_u-boot
echo "------------ start --------------"
sleep 2s
make CROSS_COMPILE=arm-linux-gnueabihf- O=miniarm-rk3288 tinker-rk3288_defconfig all
./miniarm-rk3288/tools/mkimage -n rk3288 -T rksd -d miniarm-rk3288/spl/u-boot-spl-dtb.bin u-boot.img
cat miniarm-rk3288/u-boot.bin >> u-boot.img
