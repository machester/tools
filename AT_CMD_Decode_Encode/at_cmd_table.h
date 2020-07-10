#ifndef __AT_CMD_TABLE
#define __AT_CMD_TABLE

#define MAX_CMD_LEN			100
#define MAX_CMD_LIST		50
#define END_MARK_RETURN		1
#define END_MARK_ENTER		2

typedef struct 
{
	uint8_t endMarkReturn[3];
	uint8_t endMarkEnter[2]
}endMarkTypeDef;



#define PASS				0
#define ERROR				1

// typedef void (*cmd_process)(void);

typedef struct {

	uint8_t cmd_index;
	uint8_t cmd_str[MAX_CMD_LEN];
	uint8_t (*func)(void);
	uint8_t cmd_help[MAX_CMD_LEN];
}cmd_info_formatTypeDef;

extern info_formatTypeDef cmd_info[MAX_CMD_LIST];
extern info_formatTypeDef *ptr_cmd_info;

void CMD_Init(void);

uint8_t strAddEndMark(uint8_t * str, uint8_t *endMark);
uint8_t strMerge(uint8_t * dest, uint8_t * src);

#endif
