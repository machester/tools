#ifndef _FILE_H_
#define _FILE_H_

#ifdef __cplusplus
extern "C" {
#endif
typedef		unsigned char		        uint8;
typedef		unsigned char		        u8;
typedef		unsigned short	            uint16;
typedef		unsigned short	            u16;
typedef		unsigned int			    uint32;
typedef		unsigned int			    u32;
int storestructdata(char *filename, void *buf, int size, unsigned short *crc);
int loadstructdata(char *filename, void *buf, int size, unsigned short *crc);
int readstr(const char *filename, char *pBuf, int iLen, long int *poffset);
int writestr(const char *filename, char *str);
int cal_count(const char *filename);
int cal_crc(const char *filename, unsigned short *CRC, long *pSize);
int read_whole_file(const char *filename, char *pBuf, int *iLen);

int flash_vendor_storage_write(const char *DevName, uint32 id, void *pbuf, uint32 size);
int flash_vendor_storage_read(const char *DevName, uint32 id, void *pbuf, uint32 size);

#ifdef __cplusplus
}
#endif

#endif
