#include "at_cmd_table.h"
#include <string.h>

info_formatTypeDef *ptr_cmd_info;
endMarkTypeDef endMarkList;

info_formatTypeDef cmd_info[MAX_CMD_LIST] = {
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
	[11] = {
		.cmd_index = 11,
		.func = send_AT_DNS,
		.cmd_str = "AT+DNS\r\n",
		.cmd_help = "AT+DNS : AT+DNS",
	},
	[12] = {
		.cmd_index = 12,
		.func = send_AT_WEBPORT,
		.cmd_str = "AT+WEBPORT\r\n",
		.cmd_help = "AT+WEBPORT : AT+WEBPORT",
	},
	[13] = {
		.cmd_index = 13,
		.func = send_AT_UART,
		.cmd_str = "AT+UART\r\n",
		.cmd_help = "AT+UART : AT+UART",
	},
	[14] = {
		.cmd_index = 14,
		.func = send_AT_SOCK,
		.cmd_str = "AT+_SOCK\r\n",
		.cmd_help = "AT+_SOCK : AT+_SOCK",
	},
	[15] = {
		.cmd_index = 15,
		.func = send_AT_TCPSE,
		.cmd_str = "AT+TCPSE\r\n",
		.cmd_help = "AT+TCPSE : AT+TCPSE",
	},
	[16] = {
		.cmd_index = 16,
		.func = send_AT_SOCKLK,
		.cmd_str = "AT+SOCKLK\r\n",
		.cmd_help = "AT+SOCKLK : AT+SOCKLK",
	},
	[17] = {
		.cmd_index = 17,
		.func = send_AT_SOCKPORT,
		.cmd_str = "AT+SOCKPORT\r\n",
		.cmd_help = "AT+SOCKPORT : AT+SOCKPORT",
	},
	[18] = {
		.cmd_index = 18,
		.func = send_AT_RFCEN,
		.cmd_str = "AT+RFCEN\r\n",
		.cmd_help = "AT+RFCEN : AT+RFCEN",
	},
	[19] = {
		.cmd_index = 19,
		.func = send_AT_PDTIME,
		.cmd_str = "AT+PDTIME\r\n",
		.cmd_help = "AT+PDTIME : AT+PDTIME",
	},
	[20] = {
		.cmd_index = 20,
		.func = send_AT_REGEN,
		.cmd_str = "AT+REGEN\r\n",
		.cmd_help = "AT+REGEN : AT+REGEN",
	},
	[21] = {
		.cmd_index = 21,
		.func = send_AT_REGTCP,
		.cmd_str = "AT+REGTCP\r\n",
		.cmd_help = "AT+REGTCP : AT+REGTCP",
	},
	//////////////////////////////////////////////////////
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
	[10] = {
		.cmd_index = 10,
		.func = send_AT_WANN,
		.cmd_str = "AT+WANN\r\n",
		.cmd_help = "AT+WANN : AT+Z",
	},
};

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
