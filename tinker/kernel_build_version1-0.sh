#!/bin/bash
###############################################################################
# shell param cannot store shell cmd
#		like var=(tee -a log.log) is not allowed
# `shell cmd` and $(shell cmd) are the same meaning.
#		using to set param value with `shell cmd` answer
###############################################################################
############################# var definition start ############################
CUR_PATH=`pwd`
LOG_DIR=log
LOG_FILE=kernel_build.log
SRC_DIR=debian_kernel
SRC_PATH=${CUR_PATH}/${SRC_DIR}
LOG_PATH=${CUR_PATH}/${LOG_DIR}
LOG=${LOG_PATH}/${LOG_FILE}

CMD=(kernel clean dtbs help)
var=`echo "$1"`
############################# var definition end  ############################
############################ function definition start ##############################

function cmd_check()
{
	# length check
	if [ $# -lt 2 ]
	then
		echo "command length checked"
	else
		echo "command format error"
		echo "usage: [./[filename].sh cmd]"
		exit
	fi
	# command check
	flag=0
	for temp_var in ${CMD[@]}
	do
		echo "---> ${temp_var}"
		if [ "${temp_var}" = "${var}" ]
		then
			echo "cmmand checked"
			flag=1
			break
		fi
	done
	# no parameter
	if [ "" = "${var}" ]
	then
		flag=1
	fi
	########################################
	if [ ${flag} -eq 1 ]
	then
		echo "cmd check successed"
		echo "cmd : [$0] <${var}>"
	else
		echo "cmd check faild. run ./kernel_build.sh help"
		exit
	fi
}

function shell_identiffy()
{
	echo $SHELL
}

function cmd_help()
{
	echo "--------------- cmd list ---------------"
	# get arry length ${#CMD[@]} or ${#CMD[*]}
	for var in ${CMD[@]}
	do
		echo "...... ${var} "
	done
	echo "----------------------------------------"
}

function clean()
{
	echo "------> distclean" |  tee -a ${LOG}
	make distclean | tee -a ${LOG}
}

function set_environment()
{
	if [ ! -d "/{LOG_DIR}" ]
	then
		echo "---> ${LOG_DIR} has been exist, clean log"
		rm -rf ${LOG_PATH}/${LOG_FILE}
		touch ${LOG}
	else
		echo "---> createe -a ${LOG} log dir"
		mkdir ${LOG_PATH}
		touch ${LOG}
	fi

	if [ $? -ne 0 ]
	then
		echo "log dir create failed, exit"
		exit
	else
		echo "---> log created"
	fi

	echo "---> current path is ${CUR_PATH}" | tee -a ${LOG} 
	echo "---> kernel path is ${SRC_PATH}"  | tee -a ${LOG}
	echo "---> set log path is ${LOG_PATH}" | tee -a ${LOG}
	echo "---> set build log file is ${LOG_FILE}" | tee -a ${LOG}

	# echo "move in kernel src path ${SRC_PATH}" | tee -a ${LOG}
	# cd ${SRC_PATH}
	# echo "------------ ready to build tinker board kernel -----------------" | tee -a ${LOG}
	# echo "---> current path is $(pwd)" | tee -a ${LOG}
	echo "------> start to build at 3 second" | tee -a ${LOG}
	echo `sleep 3s`
}


function build_kernel()
{
	make miniarm-rk3288_defconfig ARCH=arm |  tee -a ${LOG}

	echo "------> make zImage ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-" |  tee -a ${LOG}
	make zImage ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- | tee -a ${LOG}

	echo "------> make modules ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-  CFLAGS_MODULE=-Wno-misleading-indentation" |  tee -a ${LOG}
	make modules ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- CFLAGS_MODULE=-Wno-misleading-indentation | tee -a ${LOG}
}

function build_dtbs()
{
	echo "------> make rk3288-miniarm.dtb ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-" |  tee -a ${LOG}
	make rk3288-miniarm.dtb ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- | tee -a ${LOG}

	echo "------> make dtbs ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-" |  tee -a ${LOG}
	make dtbs ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- | tee -a ${LOG}
}
############################ function definition end ##############################
######################## build cmmand start #########################

shell_identiffy
cmd_check


if [ "$1" = "help" ]
then
	cmd_help
elif [ "$1" = "clean" ]
then
	cd ${SRC_PATH}
	clean
elif [ "$1" = "kernel" ]
then
	set_environment
	cd ${SRC_PATH}
	build_kernel
	build_dtbs
elif [ "$1" = "dtbs" ]
then
	set_environment
	cd ${SRC_PATH}
	build_dtbs
elif [ "$1" = "" ]
then
	set_environment
	cd ${SRC_PATH}
	build_kernel
	build_dtbs
else
	echo "---- input command error ------"
	cmd_help
fi




