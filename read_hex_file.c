#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define dbg_msg(fmt, args...)  printf("READ_HEX_FILE: " fmt "\n", ##args)

#define BUFF_LEN		6

// #define ETHERNET_STORE_PATH		"ethernet_mac_address.txt"
#define ETHERNET_STORE_PATH		"/data/ethernet_mac_address.txt"

unsigned char addr_buff[BUFF_LEN] = {0x00};



void usage(void)
{
	dbg_msg("\n---------------------- USAGE ----------------------");
	dbg_msg("./read_hex_file <read file path>");
	dbg_msg("---------------------------------------------------");
}

int file_exsit(char * file_path)
{
	FILE *fp = NULL;
	fp = fopen(file_path, "r");
	if(NULL == fp){
		dbg_msg("error: file not exsit <%s>\n", file_path);
		return 0;
	}
	fclose(fp);
	return 1;
}

int covert_hex_to_string(unsigned char *string_buff, unsigned char input_hex)
{
	unsigned char high_bit = 0x00;
	unsigned char low_bit = 0x00;
	
	low_bit = input_hex & (0x0f);
	high_bit = (input_hex >> 4) & (0x0f);

    // printf("H: 0X%02X, L:0X%02X\n", high_bit, low_bit);
	sprintf((char *)string_buff, "%x%x", high_bit, low_bit);
    return 0;
}

int store_read_info_to_file(char * store_file_name)
{
	FILE *fp = NULL;

	char write_buff[(10 * BUFF_LEN)]= {'\0'};
	char *ptr;
	unsigned char conv_buf[3];

	fp = fopen(store_file_name, "w+");
	if(NULL == fp) {
		dbg_msg("error: open file <%s>", store_file_name);
		return -1;
	}

	int write_offset = 0;

	for(int loop_index = 0; loop_index < BUFF_LEN; loop_index++){
		memset(conv_buf, 0, sizeof(conv_buf)/sizeof(unsigned char));
		covert_hex_to_string(conv_buf, addr_buff[loop_index]);
		// dbg_msg("conv_buf: %s, len:%ld, write_offset: %d", conv_buf, strlen((char *)conv_buf), write_offset);
		snprintf(write_buff + write_offset, strlen((char *)conv_buf) + 1, "%s", conv_buf);
		snprintf(write_buff + 2 + write_offset, 2, "%s", ":");
		// ignore '\0' position
		write_offset = 2 + write_offset + 1;
	}

	
	/////////////////////////////////////////////////////////////////////
	// for(int loop_index = 0; loop_index < BUFF_LEN; loop_index++){
	// 	sprintf(write_buff + write_offset, "%02X", addr_buff[loop_index]);
	// 	sprintf(write_buff + 2 + write_offset, "%c", ':');
	// 	write_offset = 2 + write_offset + 1;
	// 	// fseek( fp, loop_index + 1, SEEK_SET );
	// }
	// TODO: replace last : to \n
	snprintf(write_buff + write_offset - 1, 2, "%s", "\n");
	
	dbg_msg("format: addr is : %s", write_buff);

	fwrite(write_buff, strlen(write_buff), 1, fp);
	fclose(fp);
	return 0;
}

int main(int argc, char **argv)
{
	int read_ret;
	char * file_name;
	int ret_val = -1;

	if(argc != 2) {
		usage();
		return 0;
	}
	dbg_msg("read file: %s\n", argv[1]);
	file_name = argv[1];
	
	FILE *fp_in;
	fp_in = fopen(file_name, "rb");
	if (fp_in == NULL) {
		dbg_msg("open test failed\n");
		return -1;
	}
	
	read_ret = fread(addr_buff ,(BUFF_LEN * sizeof(unsigned char)), 1, fp_in);
	if(read_ret < 1) {
		dbg_msg("read error, read_ret: %d\n", read_ret);
		fclose(fp_in);
		return -1;
	}

	ret_val = store_read_info_to_file(ETHERNET_STORE_PATH);
	if(ret_val < 0) {
		dbg_msg("error: store file");
		fclose(fp_in);
		return -1;
	}

	for(int index = 0; index < BUFF_LEN; index++) {
		printf("0X%02X, ", addr_buff[index]);
	}

	printf("\n");
	fclose(fp_in);
	return 0;
}
