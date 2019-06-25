#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <limits.h>
#include <linux/input.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <dirent.h>
#include <inttypes.h>
#include <errno.h>
#include <hardware/sensors.h>
#include <fcntl.h>
#include <errno.h>
#include <dirent.h>
#include <math.h>
#include <poll.h>
#include <pthread.h>
#include <linux/input.h>
#include <dirent.h>

#define usr_debug(fmt)											\
				do {											\
						printf("<BUILD OTA DIFF PATCH>" fmt "\n"); 	\
				} while(0)

void format(void)
{
	usr_debug("-------------------------------------------------------------------");
	usr_debug("./build_ota_diff_package.sh <ota_package_new> <ota_package_old>");
	sr_debug("--------------------------------------------------------------------");
}

int find_dir(const char * name)
{
struct dirent **name_list;
int n = scandir(path,&name_list,0,alphasort);
	if(n < 0)
	{ 
	 	printf( "scandir return %d \n",n);
	}
	else
	{
		int index=0;
		while(index < n)
    	{
   			printf("name: %s\n", name_list[index]->d_name);
    		free(name_list[index++]);
    	}
    	free(name_list);
    }
}

int maint(int argc, char **argv)
{
	if(2 != argc) {
		format();
		exit(1);
	}





	return 0;
}


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