#include "stdio.h"
#include "string.h"
#include "file.h"
static const unsigned short crc_table[256] = {
	0x0000, 0x1189, 0x2312, 0x329b, 0x4624, 0x57ad, 0x6536, 0x74bf, 
	0x8c48, 0x9dc1, 0xaf5a, 0xbed3, 0xca6c, 0xdbe5, 0xe97e, 0xf8f7, 
	0x1081, 0x0108, 0x3393, 0x221a, 0x56a5, 0x472c, 0x75b7, 0x643e, 
	0x9cc9, 0x8d40, 0xbfdb, 0xae52, 0xdaed, 0xcb64, 0xf9ff, 0xe876, 
	0x2102, 0x308b, 0x0210, 0x1399, 0x6726, 0x76af, 0x4434, 0x55bd, 
	0xad4a, 0xbcc3, 0x8e58, 0x9fd1, 0xeb6e, 0xfae7, 0xc87c, 0xd9f5, 
	0x3183, 0x200a, 0x1291, 0x0318, 0x77a7, 0x662e, 0x54b5, 0x453c, 
	0xbdcb, 0xac42, 0x9ed9, 0x8f50, 0xfbef, 0xea66, 0xd8fd, 0xc974, 
	0x4204, 0x538d, 0x6116, 0x709f, 0x0420, 0x15a9, 0x2732, 0x36bb, 
	0xce4c, 0xdfc5, 0xed5e, 0xfcd7, 0x8868, 0x99e1, 0xab7a, 0xbaf3, 
	0x5285, 0x430c, 0x7197, 0x601e, 0x14a1, 0x0528, 0x37b3, 0x263a, 
	0xdecd, 0xcf44, 0xfddf, 0xec56, 0x98e9, 0x8960, 0xbbfb, 0xaa72, 
	0x6306, 0x728f, 0x4014, 0x519d, 0x2522, 0x34ab, 0x0630, 0x17b9, 
	0xef4e, 0xfec7, 0xcc5c, 0xddd5, 0xa96a, 0xb8e3, 0x8a78, 0x9bf1, 
	0x7387, 0x620e, 0x5095, 0x411c, 0x35a3, 0x242a, 0x16b1, 0x0738, 
	0xffcf, 0xee46, 0xdcdd, 0xcd54, 0xb9eb, 0xa862, 0x9af9, 0x8b70, 
	0x8408, 0x9581, 0xa71a, 0xb693, 0xc22c, 0xd3a5, 0xe13e, 0xf0b7, 
	0x0840, 0x19c9, 0x2b52, 0x3adb, 0x4e64, 0x5fed, 0x6d76, 0x7cff, 
	0x9489, 0x8500, 0xb79b, 0xa612, 0xd2ad, 0xc324, 0xf1bf, 0xe036, 
	0x18c1, 0x0948, 0x3bd3, 0x2a5a, 0x5ee5, 0x4f6c, 0x7df7, 0x6c7e, 
	0xa50a, 0xb483, 0x8618, 0x9791, 0xe32e, 0xf2a7, 0xc03c, 0xd1b5, 
	0x2942, 0x38cb, 0x0a50, 0x1bd9, 0x6f66, 0x7eef, 0x4c74, 0x5dfd, 
	0xb58b, 0xa402, 0x9699, 0x8710, 0xf3af, 0xe226, 0xd0bd, 0xc134, 
	0x39c3, 0x284a, 0x1ad1, 0x0b58, 0x7fe7, 0x6e6e, 0x5cf5, 0x4d7c, 
	0xc60c, 0xd785, 0xe51e, 0xf497, 0x8028, 0x91a1, 0xa33a, 0xb2b3, 
	0x4a44, 0x5bcd, 0x6956, 0x78df, 0x0c60, 0x1de9, 0x2f72, 0x3efb, 
	0xd68d, 0xc704, 0xf59f, 0xe416, 0x90a9, 0x8120, 0xb3bb, 0xa232, 
	0x5ac5, 0x4b4c, 0x79d7, 0x685e, 0x1ce1, 0x0d68, 0x3ff3, 0x2e7a, 
	0xe70e, 0xf687, 0xc41c, 0xd595, 0xa12a, 0xb0a3, 0x8238, 0x93b1, 
	0x6b46, 0x7acf, 0x4854, 0x59dd, 0x2d62, 0x3ceb, 0x0e70, 0x1ff9, 
	0xf78f, 0xe606, 0xd49d, 0xc514, 0xb1ab, 0xa022, 0x92b9, 0x8330, 
	0x7bc7, 0x6a4e, 0x58d5, 0x495c, 0x3de3, 0x2c6a, 0x1ef1, 0x0f78
};

void calculatecrc(unsigned char* buffer, unsigned long size, unsigned short* crc)
{
	unsigned short tempCrc = 0xFFFF;
	int i = 0;

	do {
		tempCrc = (tempCrc >> 8) ^ crc_table[(tempCrc & 255) ^ *buffer++];
	}
	while (--size);
	tempCrc = ((tempCrc & 0x00ff) << 8) | (tempCrc >> 8);
	tempCrc = ((tempCrc & 0x0f0f) << 4) | ((tempCrc & 0xf0f0) >> 4);
	tempCrc = ((tempCrc & 0x3333) << 2) | ((tempCrc & 0xcccc) >> 2);
	tempCrc = ((tempCrc & 0x5555) << 1) | ((tempCrc & 0xaaaa) >> 1);
	*crc = tempCrc;
}

int storestructdata(char *filename, void *buf, int size, unsigned short *pcrc)
{
	FILE *f;
	size_t w;
	unsigned short crc;
	int r = -1;

	if (NULL == buf || 0 == size) {
		return r;
	}
	calculatecrc((unsigned char*)buf, size, &crc);
	if(pcrc)
		*pcrc = crc;
	f = fopen (filename, "w");
	if (!f) {
		return r;
	}
	w = fwrite ( buf, 1, size, f);
	if(w != size)
		goto store_exit;
	w = fwrite ( &crc, sizeof(crc), 1, f);
	if(w != 1)
		goto store_exit;
	r = 0;
store_exit:
	if (f) {
	fclose(f);
	}
	return r;
}

int loadstructdata(char *filename, void *buf, int size, unsigned short *pcrc)
{
	FILE *f;
	size_t w;
	unsigned short rcrc, ccrc;
	int r = -1;

	if (NULL == buf || 0 == size) {
		return r;
	}

	f = fopen (filename, "r");
	if (!f) {
		return r;
	}
	w = fread (buf, 1, size, f);
	if (w != size)
		goto load_exit;
	w = fread (&rcrc, sizeof(rcrc), 1, f);
	if (w != 1) {
		goto load_exit;
	}
	calculatecrc((unsigned char*)buf, size, &ccrc);
	if (rcrc != ccrc) {
		goto load_exit;
	}
	if (pcrc) {
		*pcrc = ccrc;
	}
	r = 0;
load_exit:
	if (f) {
		fclose(f);
	}
	return r;
}

int __readstr(FILE *pFile, char *pBuf, int iLen, long int offset)
{
	int ir = -1;
	char Magic[5] = { 0 };
	char *p;
	int fr;

	fr = fseek (pFile, offset, SEEK_SET);
	if (fr)
		goto __read_exit;
	if ( 0 ==  offset ) {
		if (fgets( Magic, 5, pFile)) {
			if ((char)0xef == Magic[0] &&(char)0xbb == Magic[1] &&(char)0xbf == Magic[2]){  
				fr = fseek(pFile , 3, SEEK_SET);
				offset +=3;
			} else if ( 0xff == Magic[0] && 0xfe == Magic[1]) {
				fr = fseek(pFile, offset, SEEK_SET);
				goto __read_exit;
			} else {
				fr = fseek(pFile, offset, SEEK_SET);
			}
			if (fr)
				goto __read_exit;
		} else {
			goto __read_exit;
		}
	}
	p = fgets(pBuf, iLen, pFile);
	if (p)
		ir = strlen(pBuf);
	else {
		if(feof(pFile)) {
			ir = 0;/* end of file */
		}
	}
__read_exit:
	return ir;
}

int cal_crc(const char *filename, unsigned short *CRC, long *pSize)
{
	int iRet = -1, reallen, index, exit = 0, FileSize = 0;
	unsigned short tempCrc = 0xFFFF;
	FILE *pFile;
	char pBuf[512];

	if (!CRC) {
		goto cal_crc_exit;
	}
	pFile = fopen (filename, "rb" );
	if (NULL == pFile) {
		goto cal_crc_exit;
	}
	iRet = fseek (pFile, 0, SEEK_SET);
	if (iRet) {
		goto cal_crc_exit;
	}
	do {
		reallen = fread(pBuf, 1, sizeof(pBuf), pFile);
		FileSize += reallen;
		if (reallen != sizeof(pBuf)) {
			if (feof (pFile)) {
				exit = 1;
			} else {
				goto cal_crc_exit;
			}
		}
		if (reallen > 0) {
			index = 0;
			do {
				tempCrc = (tempCrc >> 8) ^ crc_table[(tempCrc & 255) ^ pBuf[index]];
				index ++;
			} while(--reallen);	
		}
	} while(!exit);
	iRet = 0;
	tempCrc = ((tempCrc & 0x00ff) << 8) | (tempCrc >> 8);
	tempCrc = ((tempCrc & 0x0f0f) << 4) | ((tempCrc & 0xf0f0) >> 4);
	tempCrc = ((tempCrc & 0x3333) << 2) | ((tempCrc & 0xcccc) >> 2);
	tempCrc = ((tempCrc & 0x5555) << 1) | ((tempCrc & 0xaaaa) >> 1);
	*CRC = tempCrc;
	if (pSize) {
		*pSize = FileSize;
	}
cal_crc_exit:
	if (pFile)
		fclose(pFile);
	return iRet;
}

int cal_count(const char *filename)
{
	int ir = -1, count = 0, iLen = 512;
	long int offset = 0;
	FILE *pFile;
	char pBuf[512];

	pFile = fopen (filename, "rb" );
	if (NULL == pFile) {
		return ir;
	}
	do {
		ir = __readstr(pFile, pBuf, iLen, offset);
		if (ir < 0) { /* read error */
			break;
		}
		if ( 0 == ir) { /* end of file */
			break;
		}
		offset = ftell(pFile);
		if ( -1 == offset) {
			ir = -1;
			break;
		}
		if(ir > 0) {
			if (pBuf[0] == '#' || pBuf[0] == '!') {
				continue;
			}
			if (pBuf[ir - 1] == '\r' ||  pBuf[ir - 1] == '\n') {
				pBuf[ir - 1] = '\0';
				ir --;
			}
		}
		if (ir > 0) {
			if (pBuf[ir - 1] == '\r' ||  pBuf[ir - 1] == '\n') {
				pBuf[ir - 1] = '\0';
				ir --;
			}
		}
		if (ir == 0) { /* get a null line, continue read */
			continue;
		}
		count ++;
	} while (1);
	if (pFile)
		fclose(pFile);
	if (ir >= 0 ) {
		return count;
	}
	return ir;
}

int read_whole_file(const char *filename, char *pBuf, int *iLen)
{
	int iRet = -1, file_size;
	FILE *pFile;

	pFile = fopen(filename, "rb" );
	if (!pFile)
		return iRet;
	fseek(pFile, 0, SEEK_END);
	file_size = ftell(pFile);
	fseek(pFile, 0, SEEK_SET);
	if (file_size <= 0)
		goto read_exit;
	if (!pBuf) {
		if (iLen) {
			*iLen = file_size;
			iRet = 0;
			goto read_exit;
		} else {
			goto read_exit;
		}
	}
	if (*iLen != file_size) {
		goto read_exit;
	}
	file_size = fread(pBuf, 1, *iLen, pFile);
	if (file_size == *iLen) {
		iRet = 0;
	}
read_exit:
	if (pFile)
		fclose(pFile);
	return iRet;
}

int readstr(const char *filename, char *pBuf, int iLen, long int *poffset)
{
	int ir = -1;
	long int offset;
	FILE *pFile;

	if(iLen <= 0 || !pBuf)
		return ir;
	pFile = fopen (filename, "rb" );
	if (NULL == pFile) {
		return ir;
	}
	offset = *poffset;
	do {
		ir = __readstr(pFile, pBuf, iLen, offset);
		if (ir < 0) { /* read error */
			break;
		}
		if ( 0 == ir) { /* end of file */
			break;
		}
		offset = ftell(pFile);
		if ( -1 == offset) {
			ir = -1;
			break;
		}
		if (ir > 0) {
			if (pBuf[0] == '#' || pBuf[0] == '!') {
				continue;
			}
			if (pBuf[ir - 1] == '\r' ||  pBuf[ir - 1] == '\n') {
				pBuf[ir - 1] = '\0';
				ir --;
			}
		}
		if (ir > 0) {
			if (pBuf[ir - 1] == '\r' ||  pBuf[ir - 1] == '\n') {
				pBuf[ir - 1] = '\0';
				ir --;
			}
		}
		if (ir == 0) { /* get a null line, continue read */
			continue;
		}
		*poffset = offset;
		break;
	} while (1);
	if(pFile)
		fclose(pFile);
	return ir;
}

int writestr(const char *filename, char *str)
{
	int iw = -1;
	FILE *pFile;

	if (!str)
		return iw;
	pFile = fopen ( filename, "a");
	if (NULL == pFile) {
		return iw;
	}
	iw = fputs(str, pFile);
	iw = fputs("\r\n", pFile);
	fclose(pFile);
	return iw;
};



#pragma pack(1)/* 1 byte align */

#define VENDOR_PART_NUM			4
#define VENDOR_TAG			0x524B5644

#define EMMC_VENDOR_PART_START		(1024 * 7)
#define EMMC_VENDOR_PART_SIZE		128
#define EMMC_VENDOR_ITEM_NUM		126
#define	EMMC_VENDOR_PART_END		\
	(EMMC_VENDOR_PART_START + EMMC_VENDOR_PART_SIZE * VENDOR_PART_NUM - 1)

#define	FLASH_VENDOR_PART_START		8
#define FLASH_VENDOR_PART_SIZE		8
#define FLASH_VENDOR_ITEM_NUM		62
#define	FLASH_VENDOR_PART_END		\
	(FLASH_VENDOR_PART_START + FLASH_VENDOR_PART_SIZE * VENDOR_PART_NUM - 1)



struct vendor_item {
	uint16  id;
	uint16  offset;
	uint16  size;
	uint16  flag;
};

struct flash_vendor_info {
	uint32	tag;
	uint32	version;
	uint16	next_index;
	uint16	item_num;
	uint16	free_offset;
	uint16	free_size;
	struct	vendor_item item[FLASH_VENDOR_ITEM_NUM]; /* 62 * 8*/
	uint8	data[FLASH_VENDOR_PART_SIZE * 512 - 512 - 8];
	uint32	hash;
	uint32	version2;
};

#pragma pack()

static struct flash_vendor_info g_flash_vendor = {
	VENDOR_TAG, /* tag */
	1, /* version */
	0, /* next_index */
	0, /* item_num */
	0, /* free_offset */
	sizeof(g_flash_vendor.data)/* free_size */
};

static int vendor_ops(const char *filename, uint8 *buffer, uint32 n_sec, int write)
{
	FILE * f;
	int iRet = 0;
	long size = 0;

	if (!write) {
		f = fopen (filename, "rb");
		if (f) {
			fseek (f, 0, SEEK_END);
			size = ftell (f);
			fclose (f);
		}
		if (512*FLASH_VENDOR_PART_SIZE != size) {
			f = fopen (filename, "wb");
			if (f) {
				fseek ( f, 0, SEEK_SET);
				size = fwrite(buffer, 512, n_sec, f);
				if(size == n_sec*512) {
					iRet = 0;
				}
				fclose (f);
			}
		} else {
			f = fopen (filename, "rb");
			if (f) {
				fseek ( f, 0, SEEK_SET);
				size = fread (buffer, 512, n_sec, f);
				if (size == n_sec*512) {
					iRet = 0;
				}
				fclose (f);
			}
		}
	} else {
		f = fopen (filename, "wb");
		if (f) {
			fseek ( f, 0, SEEK_SET);
			size = fwrite(buffer, 512, n_sec, f);
			if(size == FLASH_VENDOR_PART_SIZE)
				iRet = 0;
			fclose (f);
		}
	}
	return iRet;
}

int flash_vendor_storage_read(const char *DevName, uint32 id, void *pbuf, uint32 size)
{
	uint32 i;

	if (!vendor_ops(DevName, (uint8 *)&g_flash_vendor, FLASH_VENDOR_PART_SIZE, 0)) {
		for (i = 0; i < g_flash_vendor.item_num; i++) {
			if (g_flash_vendor.item[i].id == id) {
				if (size > g_flash_vendor.item[i].size) 
				size = g_flash_vendor.item[i].size;
				memcpy(pbuf, &g_flash_vendor.data[g_flash_vendor.item[i].offset], size);
				return size;
			}
		}
	}
	return (-1);
}

int flash_vendor_storage_write(const char *DevName, uint32 id, void *pbuf, uint32 size)
{
	uint32 i, next_index, algin_size;
	struct vendor_item *item;

	next_index = g_flash_vendor.next_index;
	algin_size = (size + 0x3F) & (~0x3F);

	for (i = 0; i < g_flash_vendor.item_num; i++) {
		if (g_flash_vendor.item[i].id == id) {
			if (size > algin_size)
				return -1;
			memcpy(&g_flash_vendor.data[g_flash_vendor.item[i].offset], pbuf, size);
			g_flash_vendor.item[i].size = size;
			g_flash_vendor.version++;
			g_flash_vendor.version2 = g_flash_vendor.version;
			g_flash_vendor.next_index++;
			if (g_flash_vendor.next_index >= VENDOR_PART_NUM)
				g_flash_vendor.next_index = 0;
			vendor_ops(DevName, (uint8 *)&g_flash_vendor, FLASH_VENDOR_PART_SIZE, 1);
			return 0;
		}
	}

	if (g_flash_vendor.free_size >= algin_size) {
		item = &g_flash_vendor.item[g_flash_vendor.item_num];
		item->id = id;
		item->offset = g_flash_vendor.free_offset;
		item->size = size;
		g_flash_vendor.free_offset += algin_size;
		g_flash_vendor.free_size -= algin_size;
		memcpy(&g_flash_vendor.data[item->offset], pbuf, size);
		g_flash_vendor.item_num++;
		g_flash_vendor.version++;
		g_flash_vendor.next_index++;
		g_flash_vendor.version2 = g_flash_vendor.version;
		if (g_flash_vendor.next_index >= VENDOR_PART_NUM)
			g_flash_vendor.next_index = 0;
		vendor_ops(DevName, (uint8 *)&g_flash_vendor, FLASH_VENDOR_PART_SIZE, 1);
		return 0;
	}
	return(-1);
}
