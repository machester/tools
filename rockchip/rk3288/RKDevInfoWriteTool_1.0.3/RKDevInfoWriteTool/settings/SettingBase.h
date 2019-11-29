#ifndef _SETTINGBASE_H_
#define _SETTINGBASE_H_
#define APP_VERSION " V1.0.3"
#include "inifile.h"
#include <vector>

TCHAR calc_imei_sp(INT64 nImei);
bool check_sn(const TCHAR *str, unsigned char flag);
bool check_mac (const TCHAR *str, unsigned char flag);
bool check_imei (const TCHAR *str, unsigned char flag);
bool check_custx (const TCHAR *str, unsigned char flag);

#define nof(x) (sizeof(x) / sizeof(x[0]))

#define VENDOR_FIXED_ID (1 << 31)
#define VENDOR_SN_ID 1 /* serialno */
#define VENDOR_WIFI_MAC_ID 2 /* wifi mac */
#define VENDOR_LAN_MAC_ID 3 /* lan mac */
#define VENDOR_BLUETOOTH_ID 4 /* bluetooth mac */
#define VENDOR_IMEI_ID 5 /* imei */
#define VENDOR_CUST1_ID 12
//#define VENDOR_CUST2_ID 7

#define VENDOR_MAX_LEN 256

/* all item decsript in thie tool is
 * referenced by this index
 * change to device vendor id using: INDEX_ID_MAP[index]::id
 */
#define ITEM_SN 0
#define ITEM_WIFI 1
#define ITEM_LAN 2
#define ITEM_BT 3
#define ITEM_IMEI 4
// #define ITEM_FIX 5
#define ITEM_CUST1 5
//#define ITEM_CUST2 6
#define ITEM_COUNT 6


#define MODE_MANUAL 0
#define MODE_AUTO 1
#define MODE_FILE 2

#define TYPE_NON -1
#define TYPE_TXT 0
#define TYPE_BIN 1

#define TYPE_STR 0
#define TYPE_DEC 1
#define TYPE_HEX 2

typedef bool (*PFITEMCHECK)(const TCHAR *str ,unsigned char  flag);
typedef struct _INDEX_ID_MAP_ {
	const TCHAR *name;
	unsigned int id;
	int str_int_hex; /* type 0:str 1:decimal 2:hex*/
	PFITEMCHECK check;
} INDEX_ID_MAP;

extern const INDEX_ID_MAP index_id_map[ITEM_COUNT];

typedef struct _item_info_{
	/* configs from INDEX_ID_MAP */
	const TCHAR *name;
	PFITEMCHECK check;
	BOOL bFixId;
	/* int Length; */

	BOOL bEnable;
	/* auto increase */
	std::wstring strPrefix;
	std::wstring strSuffix;
	BOOL bForcingWrite;
	int iMode; /* MODE_MANUAL:0 MODE_AUTO:1 MODE_FILE:2 */
	std::wstring strItemStart;
	int nItemCount;
	std::wstring strItemCurrent;
	int nRemainCount;
	/* increase type when in auto mode
	 * TYPE_DEC: decimal type increase
	 * TYPE_HEX: hex type increase
	 */
	int bHexDecInc;
	/* auto end */

	/* file */
	std::wstring strFileName;
	long FileItemCount;
	long FileItemUsed;
	long FileItemOff;
	long FileItemOffTemp;
	unsigned short FileItemCrc;
	int bFileItemOne;
	/* file end */

	/* TYPE_TXT:null terminate steing store in vendor storage
	 * TYPE_BIN:binary code store in vendor storage  
	 */
	int bBinOrText;  /* 0102030405 in binary mode == 0x01 0x02 0x03 0x04 0x05 */
	int VendorId;
} item_info, *PITEMINFO;

#define FLAG_UNSD               TEXT("0")
#define FLAG_BUSY               TEXT("2")
#define FLAG_USED               TEXT("1")


#define IMEI_LEN                15
#define MAC_LEN                 6

#define COL_WOID                0
#define MAX_COLUMN              100

/********** DEBUG_LEVEL ***********/
#define DLEVEL_DEBUG            0
#define DLEVEL_INFO             1
#define DLEVEL_WARNING          2
#define DLEVEL_ERROR            3
#define DLEVEL_NONE             4
class CSettingBase
{
private:
    CIniSection *pCurSection;
    CIniSection *pOldSection;
protected:
    CIniFile    *pIniFile;


    std::wstring APPNAME;
    std::wstring szFileName;
    std::wstring strModulePath;
public:
    CSettingBase()
    {
        pIniFile    = NULL;
        pCurSection = NULL;
    };
    static std::string wstr2str(const std::wstring& arg)
    {
    	int requiredSize;
    	requiredSize = WideCharToMultiByte(CP_ACP,0,arg.c_str(),arg.length(),NULL,0,NULL,NULL);
    	std::string res;
    	if (requiredSize<=0) {
    		res = "";
    		return res;
    	}
    	res.assign(requiredSize,'\0');
    	WideCharToMultiByte(CP_ACP,0,arg.c_str(),arg.length(),const_cast<char*>(res.data()),requiredSize,NULL,NULL);
    	return res;
    }
    static std::wstring str2wstr(const std::string& arg)
    {
    	int requiredSize;
    	requiredSize = MultiByteToWideChar(CP_ACP,0,arg.c_str(),arg.length(),NULL,0);
    	std::wstring res;
    	if (requiredSize<=0) {
    		res = L"";
    		return res;
    	}
    	res.assign(requiredSize,L'\0');
    	MultiByteToWideChar(CP_ACP,0,arg.c_str(),arg.length(),const_cast<wchar_t *>(res.data()),requiredSize);
    	return res;
    }
	virtual ~CSettingBase(){};
    virtual bool SaveToolSetting(std::wstring strConfig) = 0;
    virtual bool LoadToolSetting(std::wstring strConfig) = 0;
    virtual std::wstring GetStr(std::wstring &key) = 0;
    virtual std::wstring GetStr(const wchar_t *key) = 0;
    virtual bool SetStr(std::wstring &key,std::wstring &value) = 0;
    virtual bool SetStr(const wchar_t *key,const wchar_t * value) = 0;
    bool    IsPathFileExists(const std::wstring strFilaName);
    bool    CreateFolder(std::wstring strDir);

    std::wstring int2str(int i)
    {
        wchar_t szTmep[32] = {0};
        swprintf(szTmep,32,TEXT("%d"),i);
        return szTmep;
    }

    CIniSection * GetCurSection(){
        return pCurSection;
    }

    void SetCurSection(CIniSection * pSec)
    {
        if(pCurSection) pOldSection = pCurSection;
        pCurSection = pSec;
    }
    void ResumeSection()
    {
        CIniSection *pSec;
        if(pOldSection) {
            pSec        = pCurSection;
            pCurSection = pOldSection;
            pOldSection = pSec;
        }
    }

};

class CIniSettingBase:public CSettingBase
{
public:
    CIniSettingBase():lan_info(NULL),lan_info_cnt(0)
    {
		memset(&iinfo, 0, sizeof(iinfo));
    };
	virtual ~CIniSettingBase();
    virtual bool SaveToolSetting(std::wstring strConfig) ;
    virtual bool LoadToolSetting(std::wstring strConfig) ;

    virtual std::wstring GetStr(std::wstring &key);
    virtual std::wstring GetStr(const wchar_t *key);
    virtual bool SetStr(std::wstring &key,std::wstring &value);
    virtual bool SetStr(const wchar_t *key,std::wstring &value);
    virtual bool SetStr(const wchar_t *key,const wchar_t * value);

    void    ParseIntegers(std::wstring s, double *pInt, int *pLen);
    void    ParseIntegers(std::wstring s, int *pInt, int *nLen);
    void    ParseIntegers(std::wstring s, float *pInt, int *pLen);
    void    ParseStr(std::wstring s, std::wstring *pInt, int *pLen);
    void    ParseIp(std::wstring s, unsigned int *IPV4);
    void    ParseBools(std::wstring s, bool *pBool, int *pLen);
    static int MemoryCompare(std::wstring &s2,std::wstring &s1)
    {
        return s2.compare(s1);
    }

    std::wstring EncryptPassWord(std::wstring plaintext);
    std::wstring DecryptPassWord(std::wstring ciphertext);
    //unsigned int GetIpv4()
    //{
    //    unsigned int IPV4;
    //    ParseIp(strServer,&IPV4);
    //    return IPV4;
    //}
    //void SetIpv4(unsigned int IPV4)
    //{
    //    TCHAR strIP[32] = {0};
    //    unsigned char ip0 = IPV4&0xff;
    //    unsigned char ip1 = (IPV4>>8)&0xff;
    //    unsigned char ip2 = (IPV4>>16)&0xff;
    //    unsigned char ip3 = (IPV4>>24)&0xff;
    //    swprintf(strIP,32,TEXT("%d.%d.%d.%d"),ip3,ip2,ip1,ip0);
    //    strServer = strIP;
    //}
public:
    std::wstring strLanPath;
    int lan_info_cnt;
    typedef struct _s_lan_info_ {
        std::wstring LangFile;
        std::wstring LangFontName;
        std::wstring LangFontSize;
    } s_lan_info;
    s_lan_info *lan_info;
    int nCurLan;

    /* log */
	int nLogLevel;
    std::wstring strLogPath;

    /* write method */
    BOOL bSingle;
	BOOL bSetLoader;
    std::wstring strLoaderPath;
	BOOL bDebug;
	BOOL bDebug_UI;

	BOOL bForceMskrom;
	BOOL bCompatRw;
	BOOL bRebootDevice;
	BOOL bRPMB;
	BOOL bLockConfig;
    /* item info */
    int nItemCnt;
	item_info iinfo[ITEM_COUNT];

	/* APP RUNNING STATUS */
	int iRunCount;
	int iSuccess;
	int iReadRunCount;
	int iReadSuccess;
};

class CIniLocalLan:public CSettingBase
{
private:
    CIniSection  *pLanSec;
    bool         bLanLoadOK;
public:
    CIniLocalLan():pLanSec(NULL),bLanLoadOK(false)
    {
    }
	virtual ~CIniLocalLan()
    {
        if(pIniFile) {
            delete pIniFile;
            /* pIniFile = NULL; **/
        }
    }
    virtual bool SaveToolSetting(std::wstring strConfig);
    virtual bool LoadToolSetting(std::wstring strConfig) ;

    virtual std::wstring GetStr(std::wstring &key,std::wstring default);
    virtual std::wstring GetStr(std::wstring &key);
    virtual std::wstring GetStr(const wchar_t *key);

    virtual bool SetStr(std::wstring &key,std::wstring &value);
    virtual bool SetStr(const wchar_t *key,const wchar_t * value);


    std::wstring GetLanStr(std::wstring key);
    void    SetListViewString(HWND pWnd,TCHAR *strKey);
    void    GetListViewString(HWND pWnd,TCHAR *strKey);
public:
    bool    SetStringProc (void *pParam,void* lParam );
    bool    GetStringProc (void * pParam,void* lParam );
    bool    TreeControls(void * pParam,BOOL bSvae,int DlgId,bool bVer = false);
    void    TreeMenu(void * pParam,std::wstring strMainKeyPart);
};
/*
 * Encode a buffer into base64 format
 */
int base64_encode( unsigned char *dst, unsigned int *dlen,
                   const unsigned char *src, unsigned int slen );
/*
 * Decode a base64-formatted buffer
 */
int base64_decode( unsigned char *dst, unsigned int *dlen,
                   const unsigned char *src, unsigned int slen );
#endif
