#include "at_cmd_table.h"
#include <string.h>

info_formatTypeDef *ptr_cmd_info;
endMarkTypeDef endMarkList;

info_formatTypeDef cmd_info[MAX_CMD_LIST] = {
	cmd_info[0] = {
		.cmd_index = 0,
		.func      = send_StartCmd,
		.cmd_str   = "+++\r\n",
		.cmd_help  = "+++ : first send",
	},
	cmd_info[1] = {
		.cmd_index = 1,
		.func      = send_StartAT_CmdAck,
		.cmd_str   = "a",
		.cmd_help  = "a: AT cmd start ack",
	},
	cmd_info[2] = {
		.cmd_index = 2,
		.func      = sendAT_E,
		.cmd_str   = "AT+E\r\n",
		.cmd_help  = "AT+E : AT+E",
	},
	cmd_info[3] = {
		.cmd_index = 3,
		.func      = sendAT_Z,
		.cmd_str   = "AT+Z\r\n",
		.cmd_help  = "AT+Z : AT+Z",
	},
}

uint8_t
send_StartCmd(void);
uint8_t send_StartAT_CmdAck(void);

void CMD_Init(void)
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
	if(checklen) {
		while(*dest != '\0') {
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
	if(!ret)
		return 1;
	else	// pass
		return 0;
}
