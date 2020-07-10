/*************************************************************************************************
#include <string.h>
#include <stdio.h>
 
int main () {
   char str[80] = "This is - www.runoob.com - website";
   const char s[2] = "-";
   char *token;
   
   // 获取第一个子字符串
   token = strtok(str, s);
   
   // 继续获取其他的子字符串
   while( token != NULL ) {
      printf( "%s\n", token );
    
      token = strtok(NULL, s);
   }
   
   return(0);
}
让我们编译并运行上面的程序，这将产生以下结果：

This is 
 www.runoob.com 
 website
**********************************************************************************************/

// <CR> --> '\r' --> 0X0D
// <LF> --> '\n' --> 0X0A

#include <stdio.h>
#include <string.h>

#define MAX_CMD_LEN			100
#define MAX_CMD_LIST		50
#define END_MARK_RETURN		1
#define END_MARK_ENTER		2
#define CMD_ACK_HEAD_LEN	10


typedef unsigned char 		uint8_t;

#define PASS				0
#define ERROR				1

typedef struct {
	uint8_t k6_AckOk[CMD_ACK_HEAD_LEN];
	uint8_t k6_AckError[CMD_ACK_HEAD_LEN];
}k6_AckMsgHead;

// function pointer
typedef uint8_t (*func_ptr)(uint8_t);

typedef struct 
{
	uint8_t endMarkReturn[3];
	uint8_t endMarkEnter[2];
}endMarkTypeDef;

typedef struct {

	uint8_t cmd_index;
	uint8_t cmd_str[MAX_CMD_LEN];
	func_ptr	func;
	uint8_t cmd_help[MAX_CMD_LEN];
}cmd_info_formatTypeDef;

cmd_info_formatTypeDef *ptr_cmd_info;
endMarkTypeDef endMarkList;

void cmd_init(void);
uint8_t * strAddMarkOnEnd(uint8_t * dest, uint8_t *endMark);
uint8_t* findMarkInStr(uint8_t * str, uint8_t* mark);
uint8_t * getStrAfterMark(uint8_t * str, uint8_t *mark);
uint8_t compareStr(uint8_t * str, uint8_t * src);

uint8_t processSendStr(uint8_t index);
uint8_t processRecStr(uint8_t index);

k6_AckMsgHead K6_AckHead = {
	.k6_AckOk = "\r\n+OK",
	.k6_AckError = "\r\n+ERR",
};

cmd_info_formatTypeDef cmd_info[MAX_CMD_LIST] = {
	[0] = {
		.cmd_index = 0,
		.func = processSendStr,
		.cmd_str = "+++\r\n",
		.cmd_help = "+++ : first send",
	},
	[1] = {
		.cmd_index = 1,
		.func = processSendStr,
		.cmd_str = "a",
		.cmd_help = "a: AT cmd start ack",
	},
	[2] = {
		.cmd_index = 2,
		.func = processSendStr,
		.cmd_str = "AT+E\r",
		.cmd_help = "AT+E : AT+E",
	},
	[3] = {
		.cmd_index = 3,
		.func = processSendStr,
		.cmd_str = "AT+Z\r",
		.cmd_help = "AT+Z : AT+Z",
	},
	[4] = {
		.cmd_index = 4,
		.func = processSendStr,
		.cmd_str = "AT+VER\r",
		.cmd_help = "AT+VER : AT+VER",
	},
	[5] = {
		.cmd_index = 5,
		.func = processSendStr,
		.cmd_str = "AT+ENTM\r",
		.cmd_help = "AT+ENTM : AT+ENTM",
	},
	[6] = {
		.cmd_index = 6,
		.func = processSendStr,
		.cmd_str = "AT+RELD\r",
		.cmd_help = "AT+RELD : AT+RELD",
	},
	[7] = {
		.cmd_index = 7,
		.func = processSendStr,
		.cmd_str = "AT+MAC\r",
		.cmd_help = "AT+MAC : AT+MAC",
	},
	[8] = {
		.cmd_index = 8,
		.func = processSendStr,
		.cmd_str = "AT+USERMAC\r",
		.cmd_help = "AT+USERMAC : AT+USERMAC",
	},
	[9] = {
		.cmd_index = 9,
		.func = processSendStr,
		.cmd_str = "AT+WEBU\r",
		.cmd_help = "AT+WEBU : AT+WEBU",
	},
	[10] = {
		.cmd_index = 10,
		.func = processSendStr,
		.cmd_str = "AT+WANN\r",
		.cmd_help = "AT+WANN : AT+WANN",
	},

};

uint8_t processSendStr(uint8_t index)
{
	printf("in processSendStr: %s\n", ptr_cmd_info[index].cmd_str);
	return 0;
}
uint8_t processRecStr(uint8_t index)
{
	return 0;
}

void cmd_init(void)
{
	memcpy(endMarkList.endMarkReturn, "\r\n", 2);
	memcpy(endMarkList.endMarkEnter, "\n", 1);

	ptr_cmd_info = &cmd_info[0];
}

uint8_t * strAddMarkOnEnd(uint8_t * dest, uint8_t *endMark)
{
	return strcat(dest, endMark);
}

uint8_t* findMarkInStr(uint8_t * str, uint8_t* mark)
{
	// this will return a new string after and include mark
	return strpbrk(str, mark);
}


uint8_t * getStrAfterMark(uint8_t * str, uint8_t *mark)
{
	return strstr(str, mark);
}

uint8_t * setCmdForSet(uint8_t *str)
{
	return strcat(str, "=");
}


int main(int argc, char const *argv[])
{
	uint8_t testStr[MAX_CMD_LEN] = "for +OK string at+cmd test AT+ENTM";
	uint8_t testStr2[MAX_CMD_LEN] = "test str2.\r\n";
	uint8_t testStarString[MAX_CMD_LEN] = "a";

	cmd_init();

	printf("%s\n", getStrAfterMark(testStr, "string"));
	printf("after getStrAfterMark, testStr len = %ld\n", sizeof(testStr)/sizeof(uint8_t));
	if(findMarkInStr(testStr, "+OK")) {
		cmd_info[2].func(2);

	}
	printf("%s\n", strAddMarkOnEnd(testStr, "\r\n--->\r\n--->Mark\n"));
	

	
	printf("---------------------------------------------------------------------------------\n");

	return 0;
}


/******************************* RUN OUTPUT ********************************************
string at+cmd test AT+ENTM
after getStrAfterMark, testStr len = 100
in processSendStr: AT+E

for +OK string at+cmd test AT+ENTM
--->
--->Mark

---------------------------------------------------------------------------------

***************************************************************************************/