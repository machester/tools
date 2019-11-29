#pragma once
#include "afxwin.h"
#include "GroupControl.h"
#include ".\settings\SettingBase.h"
#include "CmCheck.h"
#ifdef _WIN32_WCE
#error "CDHtmlDialog is not supported for Windows CE."
#endif 
#define WM_ITEM_PRESWITCH WM_USER + 1
#define WM_ITEM_SWITCH WM_USER + 2
#define WM_SETTING_OK WM_USER + 3
// CDlgItemCmn dialog

class CDlgItemCmn : public CDialog
{
	DECLARE_DYNCREATE(CDlgItemCmn)

public:
	CDlgItemCmn(CIniSettingBase &Config, CIniLocalLan &LocalLang, CWnd* pParent = NULL);
	virtual ~CDlgItemCmn();
// Overrides
	HRESULT OnButtonOK(IHTMLElement *pElement);
	HRESULT OnButtonCancel(IHTMLElement *pElement);

// Dialog Data
	enum { IDD = IDD_ITEM_CMN, IDH = IDR_HTML_DLGITEMCMN };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	virtual BOOL OnInitDialog();

	DECLARE_MESSAGE_MAP()
	DECLARE_DHTML_EVENT_MAP()
public:
	BOOL m_bHaveUpdateToCtrl[ITEM_COUNT];
	item_info m_iinfo[ITEM_COUNT];
	int m_CurItemSel;
	int iFileChg[ITEM_COUNT];
	CComboBox m_CCombType;
	CIniSettingBase &m_Configs;
	CIniLocalLan &m_LocalLan;
	BOOL DoConfigsCopy(PITEMINFO dst, PITEMINFO src, BOOL bDump = TRUE);
	BOOL OnItemSwitch(int iCurSel);
	BOOL OnItemPreSwitch(int iCurSel);
	BOOL OnSettingOk();
    BOOL OnCtrlEnable(int iItemEnable, int iCurModeSel);
	BOOL OnCheckAutoItem(int iCurSel);
	BOOL OnCheckFileItem(int iCurSel);
	int ClacFileInfo(CString strFileName, long *FileItemCount, unsigned short *FileItemCrc, long *pSize);
	std::wstring GetLocalString(std::wstring strKey);
	BOOL SetConfigs(CIniSettingBase *Config, CIniLocalLan *LocalLang);
	afx_msg LRESULT OnItemSwitchMessage(WPARAM wParam, LPARAM lParam);
	afx_msg LRESULT OnItemPreSwitchMessage(WPARAM wParam, LPARAM lParam);
	afx_msg LRESULT OnSettingOkMessage(WPARAM wParam, LPARAM lParam);
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	afx_msg void OnCbnSelchangeComboType();
	CGroupControl m_CGrpAuto;
	afx_msg void OnEnSetfocusEditId();
	afx_msg void OnEnChangeEditId();
	afx_msg void OnBnClickedCheckEnable();
	CGroupControl m_CGrpFile;
	CButton m_CBtnEnable;
	CButton m_CheckHex;
	CButton m_CheckBinText;
	afx_msg void OnBnClickedButtonBrowfile();
	afx_msg void OnBnClickedCheckWhole();
	afx_msg void OnBnClickedCheckBinText();
	afx_msg void OnBnClickedCheckHex();
	CButton m_CheckBinFile;
};
