
#!/bin/bash
CUR_DIR=`pwd`
LOG_FOLDER=log

KERNEL_DIR=${CUR_DIR}/lichee

cd ${KERNEL_DIR}
CUR_TIME="`date +%Y-%m-%d,%H:%m:%s`"

if [ $? -eq 0 ];then
        cd ${KERNEL_DIR}/linux-4.9
        echo "---------------- `pwd` ---------------------------"
        git config --global core.autocrlf input
        git config --global core.safecrlf warn 
        sleep 1s 

        cd ${KERNEL_DIR}/tools
        echo "---------------- `pwd` ---------------------------"
        git config --global core.autocrlf input
        git config --global core.safecrlf warn 
        sleep 1s
        
        cd ${KERNEL_DIR}/buildroot 
        echo "---------------- `pwd` ---------------------------"
        git config --global core.autocrlf input
        git config --global core.safecrlf warn 
        sleep 1s
        
        cd ${KERNEL_DIR}/brandy
        echo "---------------- `pwd` ---------------------------"
        git config --global core.autocrlf input
        git config --global core.safecrlf warn 
        sleep 1s
        
        cd ${KERNEL_DIR}/bootloader
        echo "---------------- `pwd` ---------------------------"
        git config --global core.autocrlf input
        git config --global core.safecrlf warn 
fi
