#include <stdio.h>
#include <string.h>

#define MAX_CMD_LEN			100
#define MAX_CMD_LIST		50
#define END_MARK_RETURN		1
#define END_MARK_ENTER		2

typedef struct 
{
	uint8_t endMarkReturn[3];
	uint8_t endMarkEnter[2]
}endMarkTypeDef;


typedef unsigned char 		uint8_t;
;

#define PASS				0
#define ERROR				1

// typedef void (*cmd_process)(void);

typedef struct {

	uint8_t cmd_index;
	uint8_t cmd_str[MAX_CMD_LEN];
	uint8_t (*func)(void);
	uint8_t cmd_help[MAX_CMD_LEN];
}cmd_info_formatTypeDef;

extern info_formatTypeDef *ptr_cmd_info;

void cmd_init(void);

uint8_t strAddEndMark(uint8_t * str, uint8_t *endMark);
uint8_t strMerge(uint8_t * dest, uint8_t * src);

cmd_info_formatTypeDef *ptr_cmd_info;
endMarkTypeDef endMarkList;

cmd_info_formatTypeDef cmd_info[MAX_CMD_LIST] = {
	[0] = {
		.cmd_index = 0,
		.func = send_3plus,
		.cmd_str = "+++\r\n",
		.cmd_help = "+++ : first send",
	},
	[1] = {
		.cmd_index = 1,
		.func = send_a,
		.cmd_str = "a",
		.cmd_help = "a: AT cmd start ack",
	},
	[2] = {
		.cmd_index = 2,
		.func = send_AT_E,
		.cmd_str = "AT+E\r\n",
		.cmd_help = "AT+E : AT+E",
	},
	[3] = {
		.cmd_index = 3,
		.func = send_AT_Z,
		.cmd_str = "AT+Z\r\n",
		.cmd_help = "AT+Z : AT+Z",
	},
	[4] = {
		.cmd_index = 4,
		.func = send_AT_VER,
		.cmd_str = "AT+VER\r\n",
		.cmd_help = "AT+VER : AT+VER",
	},
	[5] = {
		.cmd_index = 5,
		.func = send_AT_ENTM,
		.cmd_str = "AT+ENTM\r\n",
		.cmd_help = "AT+ENTM : AT+ENTM",
	},
	[6] = {
		.cmd_index = 6,
		.func = send_AT_RELD,
		.cmd_str = "AT+RELD\r\n",
		.cmd_help = "AT+RELD : AT+RELD",
	},
	[7] = {
		.cmd_index = 7,
		.func = send_AT_MAC,
		.cmd_str = "AT+MAC\r\n",
		.cmd_help = "AT+MAC : AT+MAC",
	},
	[8] = {
		.cmd_index = 8,
		.func = send_AT_USERMAC,
		.cmd_str = "AT+USERMAC\r\n",
		.cmd_help = "AT+USERMAC : AT+USERMAC",
	},
	[9] = {
		.cmd_index = 9,
		.func = send_AT_WEBU,
		.cmd_str = "AT+WEBU\r\n",
		.cmd_help = "AT+WEBU : AT+WEBU",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+WANN",
	},
};

uint8_t
send_StartCmd(void);
uint8_t send_StartAT_CmdAck(void);

void cmd_init(void)
{
	memcpy(endMarkList.endMarkReturn, "\r\n");
	memcpy(endMarkList.endMarkEnter, "\n");

	ptr_cmd_info = &cmd_info[0];
}

uint8_t strAddEndMark(uint8_t *str, uint8_t endMarkType)
{
	// TODO: skip size check
	// char *strcat(char *dest, const char *src);  // in <string.h>
	switch (endMarkType)
	{
	case 1:
		strcat(str, endMarkList.endMarkReturn);
		break;
	case 2:
		strcat(str, endMarkList.endMarkEnter);
		break;
	default:
		break;
	}
}

uint8_t strMerge(uint8_t *dest, uint8_t *src)
{
	char *ret;
	uint8_t checklen = destDataLen = srcDataLen = destFreeLen = srcFreeLen = 0;
	// check len
	if (checklen)
	{
		while (*dest != '\0')
		{
			destDataLen++; // check the data len;
		}
		while ((dest + destDataLen + destFreeLen) != NULL)
		{
			destFreeLen++;
		}
		while (*src != '\0')
		{
			srcDataLen++; // check the data len;
		}
		if (destFreeLen <= srcDataLen)
			return 1;
	}
	ret = strcat(dest, src);
	if (!ret)
		return 1;
	else // pass
		return 0;
}

int main(int argc, char const *argv[])
{
	cmd_init();

	return 0;
}
