#!/bin/bash

export PATH=$PATH:/home/quan/rockchip/rk3399/rk3399_linux_sdk_v2.0/prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin
echo "---------------------- gcc version ---------------------------"
aarch64-linux-gnu-gcc -v
echo "--------------------------------------------------------------"