#include "afxwin.h"
#include "string"

#ifndef _CHECK_H_
#define _CHECK_H_
int WCharToChar(CHAR *pszDst, int nDstSize, const WCHAR *pszSrc);
int CharToWChar(WCHAR *pszDst, int nDstSize, const CHAR *pszSrc);
int CCharToWChar(WCHAR *pszDst, int nDstSize, const CHAR *pszSrc, int nSrcSize);
int CWCharToChar(CHAR *pszDst, int nDstSize, const WCHAR *pszSrc, int nSrcSize);
std::wstring  MID(std::wstring str, const std::wstring prefix, const std::wstring subfix);
int tchar_to_byte(const TCHAR ch);
TCHAR byte_to_tchar(BYTE hex);
BOOL IsNumberStringW(const wchar_t *);
BOOL IsNumberStringA(const char *);
BOOL IsHexStringW(const wchar_t *);
BOOL IsHexStringA(const char  *);
DWORD intToHexLen(DWORD );
DWORD intToDecLen(DWORD );
BOOL IntStrIncrease(TCHAR *, int spn = 1, TCHAR *strNEW = NULL, int len = 0);
BOOL HexStrIncrease(TCHAR *, int spn = 1, TCHAR *strNEW = NULL, int len = 0);
BOOL HexStrIncreaseA(char *, int spn = 1, char  *strNEW = NULL, int len = 0);
BOOL HexStrIncreaseSkipAlpha(TCHAR *, int spn = 1, TCHAR *strNEW = NULL, int len = 0);
BOOL IntStrIncreaseSkipAlpha(TCHAR *, int spn = 1, TCHAR *strNEW = NULL, int len = 0);
BOOL TrimAndInc(TCHAR *str, const TCHAR *prefix, const TCHAR *subfix, int spn);
BOOL TrimAndIncHex(TCHAR *str, const TCHAR *prefix, const TCHAR *subfix, int spn);
int HEXSTRTOINT(const TCHAR *pIStr);
TCHAR *HEX_TO_WSTRING_GET(const BYTE *buf, int len);
TCHAR *BYTE_TO_WSTRING_GET(const BYTE *buf, int len);
TCHAR *ASTRING_TO_WSTRING_GET(const CHAR *pIStr);
void WSTRING_PUT(TCHAR *pIStr);

CHAR *WSTRING_TO_ASTRING_GET(const TCHAR *pIStr);
void ASTRING_PUT(CHAR *pIStr);
#endif
