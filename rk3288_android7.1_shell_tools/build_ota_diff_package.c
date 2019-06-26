#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <dirent.h>
#include <inttypes.h>
#include <errno.h>
#include <fcntl.h>
#include <errno.h>
#include <dirent.h>
#include <math.h>
#include <poll.h>
#include <pthread.h>
// for folder access
#include <dirent.h>
// acces file change time
#include <utime.h>
// get file priproty
#include <sys/stat.h>



#define usr_debug(fmt)											\
				do {											\
						printf("<BUILD OTA DIFF PATCH>" fmt "\n"); 	\
				} while(0)
                
                
// struct utimbuf {
//     time_t actime;
//     time_t modtime;
// };

struct stat file_stat;
                

void format(void)
{
	usr_debug("-------------------------------------------------------------------");
	usr_debug("./build_ota_diff_package.sh <ota_package_new> <ota_package_old>");
	usr_debug("--------------------------------------------------------------------");
}


int find_dir(char * target_path, char * dir_name)
{
    int index, numbers;
    struct dirent **dir_list;
    DIR *dir = opendir(target_path);
    if(NULL == dir) {
        perror("target path cannot access");
        return -1;
    }
    // move in target path
    chdir(target_path);
    // get dir list
    numbers = scandir(".",&dir_list, NULL, NULL);
	if(numbers < 0)
	{ 
	 	perror("scandir");
         exit(EXIT_FAILURE);
	}
    for(index = 0; index < numbers; index++) {
        printf("|\n");
        printf("|");
        printf("--- %s\n", dir_list[index]->d_name);
    }
    // -------------------------------------------------------------------------------
    // find folder
    for(index = 0; index < numbers; index++) {
        if(!strcmp(dir_list[index]->d_name, dir_name)) {
            printf("target folder found in dir_list[%d]->d_name: %s\n", index, dir_list[index]->d_name);
        }
    }
    return 0;
}

int main(int argc, char **argv)
{
	// if(2 != argc) {
	// 	format();
	// 	exit(1);
	// }
    printf("current path: ");
    system("pwd");
    find_dir(".", "xfm10213_driver");




	return 0;
}
