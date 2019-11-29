// DlgItemCmn.cpp : implementation file
//

#include "stdafx.h"
#include "rk_provision_tool.h"
#include "DlgItemCmn.h"
#include "file.h"

// CDlgItemCmn dialog
IMPLEMENT_DYNAMIC(CDlgItemCmn, CDialog)

CDlgItemCmn::CDlgItemCmn(CIniSettingBase &Config, CIniLocalLan &LocalLang, CWnd* pParent /*=NULL*/)
	: CDialog(CDlgItemCmn::IDD, pParent), m_Configs(Config), m_LocalLan(LocalLang)
{
	memset(&m_bHaveUpdateToCtrl, 0, sizeof(m_bHaveUpdateToCtrl));
}

CDlgItemCmn::~CDlgItemCmn()
{
}

void CDlgItemCmn::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_COMBO_TYPE, m_CCombType);
	DDX_Control(pDX, IDC_STATIC_AUDO, m_CGrpAuto);
	DDX_Control(pDX, IDC_STATIC_FILE, m_CGrpFile);
	DDX_Control(pDX, IDC_CHECK_ENABLE, m_CBtnEnable);
	DDX_Control(pDX, IDC_CHECK_HEX, m_CheckHex);
	DDX_Control(pDX, IDC_CHECK_BIN_TEXT, m_CheckBinText);
	DDX_Control(pDX, IDC_CHECK_WHOLE, m_CheckBinFile);
}

BOOL CDlgItemCmn::OnInitDialog()
{
	CDialog::OnInitDialog();

	m_CCombType.InsertString(0, GetLocalString(_T("IDS_MANUAL")).c_str());
	m_CCombType.InsertString(1, GetLocalString(_T("IDS_AUTO")).c_str());
	m_CCombType.InsertString(2, GetLocalString(_T("IDS_FILE")).c_str());
	m_LocalLan.TreeControls(m_hWnd, m_Configs.bDebug_UI ? TRUE : FALSE, this->IDD, false);
	m_CGrpFile.AddIgnoreID(IDC_CHECK_WHOLE);
	m_CurItemSel = 0;
	OnItemSwitch(m_CurItemSel);
	return TRUE;  // return TRUE  unless you set the focus to a control
}

BEGIN_MESSAGE_MAP(CDlgItemCmn, CDialog)
	ON_CBN_SELCHANGE(IDC_COMBO_TYPE, &CDlgItemCmn::OnCbnSelchangeComboType)
	ON_MESSAGE(WM_ITEM_SWITCH, &CDlgItemCmn::OnItemSwitchMessage)
	ON_MESSAGE(WM_SETTING_OK, &CDlgItemCmn::OnSettingOkMessage)
	ON_MESSAGE(WM_ITEM_PRESWITCH, &CDlgItemCmn::OnItemPreSwitchMessage)
	ON_EN_SETFOCUS(IDC_EDIT_ID, &CDlgItemCmn::OnEnSetfocusEditId)
	ON_EN_CHANGE(IDC_EDIT_ID, &CDlgItemCmn::OnEnChangeEditId)
	ON_BN_CLICKED(IDC_CHECK_ENABLE, &CDlgItemCmn::OnBnClickedCheckEnable)
	ON_BN_CLICKED(IDC_BUTTON_BROWFILE, &CDlgItemCmn::OnBnClickedButtonBrowfile)
	ON_BN_CLICKED(IDC_CHECK_WHOLE, &CDlgItemCmn::OnBnClickedCheckWhole)
	ON_BN_CLICKED(IDC_CHECK_BIN_TEXT, &CDlgItemCmn::OnBnClickedCheckBinText)
	ON_BN_CLICKED(IDC_CHECK_HEX, &CDlgItemCmn::OnBnClickedCheckHex)
END_MESSAGE_MAP()

BEGIN_DHTML_EVENT_MAP(CDlgItemCmn)

END_DHTML_EVENT_MAP()



// CDlgItemCmn message handlers

void CDlgItemCmn::OnCbnSelchangeComboType()
{
	item_info * piinfo = &m_iinfo[m_CurItemSel];
	int index = m_CCombType.GetCurSel();

	OnCtrlEnable(-1, index);
	piinfo->iMode = index;

}

int CDlgItemCmn::ClacFileInfo(CString strFileName, long *FileItemCount, unsigned short *FileItemCrc, long *pSize)
{
	CHAR *szFileName = NULL;
	int iRet = -1;

	if (strFileName.IsEmpty()) {
		return -1;
	}
	szFileName = WSTRING_TO_ASTRING_GET((LPCTSTR)strFileName);
	if (!szFileName) {
		return -1;
	}
	if (FileItemCrc) {
		if (cal_crc(szFileName, FileItemCrc, pSize)) {
			goto calc_exit;
		}
	}
	if (FileItemCount) {
		*FileItemCount = cal_count(szFileName);
		if (*FileItemCount < 0) {
			goto calc_exit;
		}
	}
	iRet = 0;
calc_exit:
	if (szFileName)
		ASTRING_PUT(szFileName);
	return iRet;

}
BOOL CDlgItemCmn::OnCheckFileItem(int iCurSel)
{
	item_info *piinfo = &m_iinfo[iCurSel];
	unsigned short FileItemCrc;
	long FileItemCount, FileSize;

	if (ClacFileInfo(piinfo->strFileName.c_str(), NULL, &FileItemCrc, &FileSize)) {
		return FALSE;
	}
	if (FileItemCrc == piinfo->FileItemCrc)
		return TRUE;
	if (piinfo->bFileItemOne) {
		FileItemCount = FileSize;
		if (FileItemCount >= VENDOR_MAX_LEN) {
			return FALSE; 
		}
	} else {
		if (ClacFileInfo(piinfo->strFileName.c_str(), &FileItemCount, NULL, &FileSize)) {
			return FALSE;
		}
	}
	piinfo->FileItemUsed = 0;
	piinfo->FileItemOff = 0;
	piinfo->FileItemCrc = FileItemCrc;
	piinfo->FileItemCount = FileItemCount;
	return TRUE;
}

BOOL CDlgItemCmn::OnCheckAutoItem(int iCurSel)
{
	item_info *piinfo = &m_iinfo[iCurSel];
	CString strPrompt;
	size_t len;

	/* save result */
	if (!piinfo->strItemStart.empty()) {
		if (piinfo->check/* &&(!piinfo->check(piinfo->strItemStart.c_str(), 1)) */) {
			if(!piinfo->check(piinfo->strItemStart.c_str(), 1)) {
				strPrompt.Format(GetLocalString(_T("IDS_ERROR_SS_INVALID")).c_str(), piinfo->name);
				AfxMessageBox(strPrompt);
				return FALSE;
			}
		}
	} else {
		strPrompt.Format(GetLocalString(_T("IDS_ERROR_SS_INVALID")).c_str(), piinfo->name);
		AfxMessageBox(strPrompt);
		return FALSE;
	}
	
	if (!piinfo->strPrefix.empty()) {
		if ( 0 != piinfo->strItemStart.find(piinfo->strPrefix)){
			strPrompt.Format(GetLocalString(_T("IDS_ERROR_SS_PRE_INVALID")).c_str(), piinfo->name);
			AfxMessageBox(strPrompt);
			return FALSE;
		}
	}

	if (!piinfo->strSuffix.empty()) {
		len = piinfo->strItemStart.length() - piinfo->strSuffix.length();
		if (len != piinfo->strItemStart.rfind(piinfo->strSuffix)){
			strPrompt.Format(GetLocalString(_T("IDS_ERROR_SS_SUF_INVALID")).c_str(), piinfo->name);
			AfxMessageBox(strPrompt);
			return FALSE;
		}
	}

	if (piinfo->nItemCount < 0 && piinfo->nItemCount !=  0) {
		strPrompt.Format(GetLocalString(_T("IDS_ERROR_SS_CNT_INVALID")).c_str(), piinfo->name);
		AfxMessageBox(strPrompt);
		return FALSE;
	}

	return TRUE;
}

BOOL CDlgItemCmn::OnItemPreSwitch(int iCurSel)
{
	CString strTmp, strPrompt;
	int index;
	item_info * piinfo;
	int iCount;
	BOOL bNeedAuto = FALSE;

	/* save result */
	piinfo = &m_iinfo[iCurSel];
	index = m_CCombType.GetCurSel();
	piinfo->iMode = index;
	if (BST_CHECKED == (m_CBtnEnable.GetCheck()&BST_CHECKED)) {
		piinfo->bEnable = TRUE;
	} else {
		piinfo->bEnable = FALSE;
	}
	if (BST_CHECKED == (m_CheckHex.GetCheck()&BST_CHECKED)) {
		piinfo->bHexDecInc = TYPE_HEX;
	} else {
		piinfo->bHexDecInc = TYPE_DEC;
	}

	if (!piinfo->bFixId) {
		if (BST_CHECKED == (m_CheckBinText.GetCheck()&BST_CHECKED)) {
			piinfo->bBinOrText = TYPE_BIN;
		} else {
			piinfo->bBinOrText = TYPE_TXT;
		}
	}

	if (!piinfo->bFixId) {
		GetDlgItem(IDC_EDIT_ID)->GetWindowText(strTmp);
		piinfo->VendorId = _ttoi((LPCTSTR)strTmp);
		if (piinfo->VendorId <= VENDOR_IMEI_ID) {
			strPrompt.Format(GetLocalString(_T("IDS_ERROR_SS_ID_INVALID")).c_str(), piinfo->name);
			AfxMessageBox(strPrompt);
			return FALSE;
		}
	}

	/* auto increase */
	GetDlgItem(IDC_EDIT_START)->GetWindowText(strTmp);
	if(strTmp.Compare(piinfo->strItemStart.c_str())) {
		bNeedAuto = TRUE;
	}
	piinfo->strItemStart =  (LPCTSTR)strTmp;

	GetDlgItem(IDC_EDIT_PREFIX)->GetWindowText(strTmp);
	piinfo->strPrefix =  (LPCTSTR)strTmp;

	GetDlgItem(IDC_EDIT_SUFFIX)->GetWindowText(strTmp);
	piinfo->strSuffix = (LPCTSTR)strTmp;

	GetDlgItem(IDC_EDIT_COUNT)->GetWindowText(strTmp);
	iCount = _ttoi((LPCTSTR)strTmp);
	if (iCount != piinfo->nItemCount) {
		bNeedAuto = TRUE;
		piinfo->nItemCount = iCount;
	}

	if (bNeedAuto) {
		piinfo->strItemCurrent = piinfo->strItemStart;
		piinfo->nRemainCount = iCount;
	}

	if (piinfo->bEnable && MODE_AUTO == piinfo->iMode) {
		if (!OnCheckAutoItem(iCurSel))
			return FALSE;
	}

	/* read from file */
	if (!piinfo->bFixId) {
		if (BST_CHECKED == (((CButton *)GetDlgItem(IDC_CHECK_WHOLE))->GetCheck()&BST_CHECKED)) {
			piinfo->bFileItemOne = TRUE;
		} else {
			piinfo->bFileItemOne = FALSE;
		}
	}
	GetDlgItem(IDC_EDIT_FILE)->GetWindowText(strTmp);
	piinfo->strFileName = (LPCTSTR)strTmp;
	if (piinfo->bEnable && MODE_FILE == piinfo->iMode) {
		if (!OnCheckFileItem(iCurSel)) {
			strPrompt.Format(GetLocalString(_T("IDS_ERROR_SS_FILE_INVALID")).c_str(), piinfo->name);
			AfxMessageBox(strPrompt);
			return FALSE;
		}
	}
	return TRUE;
}

std::wstring CDlgItemCmn::GetLocalString(std::wstring strKey)
{
	return m_LocalLan.GetLanStr(strKey);
}

BOOL CDlgItemCmn::DoConfigsCopy(PITEMINFO dst, PITEMINFO src, BOOL bDump)
{
	if ((!dst)|| (!src))
		return FALSE;
    if (bDump) {/* configs from INDEX_ID_MAP, no need to save */
		dst->bFixId = src->bFixId;
		dst->name = src->name;
		dst->check = src->check;
	}
	/* audo increase config */
	dst->strItemStart = src->strItemStart;
	dst->strPrefix = src->strPrefix;
	dst->strSuffix = src->strSuffix;
	dst->strItemCurrent = src->strItemCurrent;
	dst->strSuffix = src->strSuffix;
	dst->nItemCount = src->nItemCount;
	dst->nRemainCount = src->nRemainCount;
	dst->VendorId = src->VendorId;
	dst->bHexDecInc = src->bHexDecInc;

	/* file mode config */
	dst->strFileName = src->strFileName;
	dst->FileItemCount = src->FileItemCount;
	dst->FileItemUsed = src->FileItemUsed;
	dst->FileItemOff = src->FileItemOff;
	dst->FileItemCrc = src->FileItemCrc;
	dst->bFileItemOne = src->bFileItemOne;

	/* common config */
	dst->bBinOrText = src->bBinOrText;
	dst->bEnable = src->bEnable;
	dst->iMode = src->iMode;
	return TRUE;
}

BOOL CDlgItemCmn::OnSettingOk()
{
	int i;

	for (i = 0; i < ITEM_COUNT; i++) {
		if (m_bHaveUpdateToCtrl[i]) {
			DoConfigsCopy(&m_Configs.iinfo[i], &m_iinfo[i], FALSE);
		}
	}
	return TRUE;
}

BOOL CDlgItemCmn::OnItemSwitch(int iCurSel)
{
	TCHAR strTmp[64];
	item_info *piinfo;

	if (!m_bHaveUpdateToCtrl[iCurSel]) {
		/* copy configs to tmp(m_iinfo[iCurSel]) */
		DoConfigsCopy(&m_iinfo[iCurSel], &m_Configs.iinfo[iCurSel], TRUE);
		m_bHaveUpdateToCtrl[iCurSel] = TRUE;
	}
	piinfo = &m_iinfo[iCurSel];

	/* auto increase */
	GetDlgItem(IDC_EDIT_START)->SetWindowText(piinfo->strItemStart.c_str());
	GetDlgItem(IDC_EDIT_PREFIX)->SetWindowText(piinfo->strPrefix.c_str());
	GetDlgItem(IDC_EDIT_SUFFIX)->SetWindowText(piinfo->strSuffix.c_str());
	GetDlgItem(IDC_EDIT_CURRENT)->SetWindowText(piinfo->strItemCurrent.c_str());
	wsprintf(strTmp, _T("%d"), piinfo->nItemCount);
	GetDlgItem(IDC_EDIT_COUNT)->SetWindowText(strTmp);
	wsprintf(strTmp, _T("%d"), piinfo->nRemainCount);
	GetDlgItem(IDC_EDIT_LEFT)->SetWindowText(strTmp);
	wsprintf(strTmp, _T("%d"), piinfo->VendorId);
	GetDlgItem(IDC_EDIT_ID)->SetWindowText(strTmp);
	m_CheckHex.SetCheck((TYPE_HEX == piinfo->bHexDecInc) ? BST_CHECKED : BST_UNCHECKED);
	/* auto end */

	/* file */
	GetDlgItem(IDC_EDIT_FILE)->SetWindowText(piinfo->strFileName.c_str());
	wsprintf(strTmp, _T("%d"), piinfo->FileItemCount);
	GetDlgItem(IDC_STATIC_FILECOUNT)->SetWindowText(strTmp);
	wsprintf(strTmp, _T("%d"), piinfo->FileItemUsed);
	GetDlgItem(IDC_STATIC_FILEUSED)->SetWindowText(strTmp);
	wsprintf(strTmp, _T("%04X"), piinfo->FileItemCrc);
	GetDlgItem(IDC_STATIC_FILECRC)->SetWindowText(strTmp);
	m_CheckBinFile.SetCheck(piinfo->bFileItemOne ? BST_CHECKED : BST_UNCHECKED);
	/* file end  */

	m_CheckBinText.SetCheck((TYPE_BIN == piinfo->bBinOrText) ? BST_CHECKED : BST_UNCHECKED);
	m_CBtnEnable.SetCheck(piinfo->bEnable ? BST_CHECKED : BST_UNCHECKED);
	m_CCombType.SetCurSel(piinfo->iMode);
	/* OnSwitchType(piinfo->iMode); */
	OnCtrlEnable(piinfo->bEnable ? 1 : 0, piinfo->iMode);

	return TRUE;
}

/* iItemEnable:
 * 0  disabled
 * 1  enable
 * -1 no modify
 */
BOOL CDlgItemCmn::OnCtrlEnable(int iItemEnable, int iCurModeSel)
{
	item_info *piinfo = &m_iinfo[m_CurItemSel];
	BOOL bFixId = piinfo->bFixId;

	if (0 == iItemEnable) {
		m_CCombType.EnableWindow(FALSE);
		m_CGrpAuto.EnableWindow(FALSE);
		m_CGrpFile.EnableWindow(FALSE);
		/* Item with fix id can not change those options */
		GetDlgItem(IDC_EDIT_ID)->EnableWindow(FALSE);
		m_CheckBinFile.EnableWindow(FALSE);
	} else if (1 == iItemEnable) {
		m_CCombType.EnableWindow(TRUE);
		if (bFixId) { /* only cust can change id */
			m_CheckBinText.EnableWindow(FALSE);
			GetDlgItem(IDC_EDIT_ID)->EnableWindow(FALSE);
		} else {
			m_CheckBinText.EnableWindow(TRUE);
			GetDlgItem(IDC_EDIT_ID)->EnableWindow(TRUE);
		}
		if (MODE_MANUAL == iCurModeSel) {
			m_CGrpAuto.EnableWindow(FALSE);
			m_CGrpFile.EnableWindow(FALSE);
			m_CheckBinFile.EnableWindow(FALSE);
		}
		if (MODE_AUTO == iCurModeSel) {
			m_CGrpAuto.EnableWindow(TRUE);
			if (VENDOR_IMEI_ID == piinfo->VendorId) { /* imei just decimal */
				GetDlgItem(IDC_CHECK_HEX)->EnableWindow(FALSE);		
			} else {
				GetDlgItem(IDC_CHECK_HEX)->EnableWindow(TRUE);	
			}
			m_CGrpFile.EnableWindow(FALSE);
			m_CheckBinFile.EnableWindow(FALSE);
		}
		if(MODE_FILE == iCurModeSel) {
			m_CGrpAuto.EnableWindow(FALSE);
			m_CGrpFile.EnableWindow(TRUE);
			if (bFixId) {
				m_CheckBinFile.EnableWindow(FALSE);
			} else {
				m_CheckBinFile.EnableWindow(TRUE);
			}
		}
	} else { /* only change iCurModeSel */
		if (MODE_MANUAL == iCurModeSel) {
			m_CGrpAuto.EnableWindow(FALSE);
			m_CGrpFile.EnableWindow(FALSE);
			m_CheckBinFile.EnableWindow(FALSE);
		}
		if (MODE_AUTO == iCurModeSel) {
			m_CGrpAuto.EnableWindow(TRUE);
			if (VENDOR_IMEI_ID == piinfo->VendorId) { /* imei just decimal */
				GetDlgItem(IDC_CHECK_HEX)->EnableWindow(FALSE);
			} else {
				GetDlgItem(IDC_CHECK_HEX)->EnableWindow(TRUE);	
			}
			m_CGrpFile.EnableWindow(FALSE);
			m_CheckBinFile.EnableWindow(FALSE);
		}
		if (MODE_FILE == iCurModeSel) {
			m_CGrpAuto.EnableWindow(FALSE);
			m_CGrpFile.EnableWindow(TRUE);
			if (bFixId) {
				m_CheckBinFile.EnableWindow(FALSE);
			} else {
				m_CheckBinFile.EnableWindow(TRUE);
			}
		}

	}
	return TRUE;
}

BOOL CDlgItemCmn::SetConfigs(CIniSettingBase *Config, CIniLocalLan *LocalLang)
{
	return TRUE;
}

LRESULT  CDlgItemCmn::OnItemSwitchMessage(WPARAM wParam, LPARAM lParam)
{
	m_CurItemSel = (int) lParam;
	OnItemSwitch(m_CurItemSel);
	return FALSE;
}

LRESULT  CDlgItemCmn::OnItemPreSwitchMessage(WPARAM wParam, LPARAM lParam)
{
	if(OnItemPreSwitch(m_CurItemSel)) {
		return TRUE;
	}
	return FALSE;
}

LRESULT  CDlgItemCmn::OnSettingOkMessage(WPARAM wParam, LPARAM lParam)
{
	if(OnSettingOk()) {
		return TRUE;
	}
	return FALSE;
}

void CDlgItemCmn::OnEnSetfocusEditId()
{
	// TODO: Add your control notification handler code here
	/* MessageBox(_T(""));*/
}

void CDlgItemCmn::OnEnChangeEditId()
{
	// TODO:  If this is a RICHEDIT control, the control will not
	// send this notification unless you override the CDialog::OnInitDialog()
	// function and call CRichEditCtrl().SetEventMask()
	// with the ENM_CHANGE flag ORed into the mask.

}

void CDlgItemCmn::OnBnClickedCheckEnable()
{
	item_info * piinfo = &m_iinfo[m_CurItemSel];
	int index = m_CBtnEnable.GetState();

	if(BST_CHECKED == (m_CBtnEnable.GetCheck()&BST_CHECKED)) {
		OnCtrlEnable(1, piinfo->iMode);
		piinfo->bEnable = TRUE;
	} else {
		OnCtrlEnable(0, -1);
		piinfo->bEnable = FALSE;
	}
}

BOOL CDlgItemCmn::PreTranslateMessage(MSG* pMsg)
{
	if ((pMsg->message == WM_KEYDOWN) && (pMsg->wParam == VK_RETURN || pMsg->wParam == VK_ESCAPE)) {
		return TRUE;
	}
	return CDialog::PreTranslateMessage(pMsg);

}

void CDlgItemCmn::OnBnClickedButtonBrowfile()
{
	item_info *piinfo = &m_iinfo[m_CurItemSel];
	CString strFileName, strOldFileName, strFilePath;
	CString strPrompt, strCRC;
	unsigned short FileItemCrc, OldFileCrc;
	long FileItemCount, FileSize;
	TCHAR strTmp[64] = {_T("binary\0*.txt\0")};
    CFileDialog OpenDlg(TRUE);

	GetDlgItem(IDC_EDIT_FILE)->GetWindowText(strOldFileName);
	if (!strOldFileName.IsEmpty()) {
		strFilePath = strOldFileName.Left(strOldFileName.ReverseFind(_T('\\'))+1);
		if (!strFilePath.IsEmpty()) {
			OpenDlg.m_ofn.lpstrInitialDir = strFilePath;
		}
		GetDlgItem(IDC_STATIC_FILECRC)->GetWindowText(strCRC);
		OldFileCrc = HEXSTRTOINT((LPCTSTR)strCRC);
	} else {
		OldFileCrc = 0;
	}
	OpenDlg.m_ofn.lpstrTitle = _T("Open File");
	OpenDlg.m_ofn.lpstrFilter = strTmp;
	if (IDOK == OpenDlg.DoModal()) {
		strFileName = OpenDlg.GetPathName();
		if (!ClacFileInfo(strFileName, NULL, &FileItemCrc, &FileSize) ) {
			if (FileItemCrc == OldFileCrc) {
				/* file no changed */
				return;
			}
		} else {
			strPrompt.Format(GetLocalString(_T("IDS_ERROR_SS_FILE_INVALID")).c_str(), piinfo->name);
			AfxMessageBox(strPrompt);
			return;
		}
		if (BST_CHECKED == (m_CheckBinFile.GetCheck()&BST_CHECKED)) {
			FileItemCount = FileSize;
		} else {
			if (ClacFileInfo(strFileName, &FileItemCount, NULL, NULL)) {
				GetDlgItem(IDC_EDIT_FILE)->SetWindowText(_T(""));
				strPrompt.Format(GetLocalString(_T("IDS_ERROR_SS_FILE_INVALID")).c_str(), piinfo->name);
				AfxMessageBox(strPrompt);
				return;
			}
		}
		if (FileItemCount <= 0) {
			GetDlgItem(IDC_EDIT_FILE)->SetWindowText(_T(""));
			strPrompt.Format(GetLocalString(_T("IDS_ERROR_SS_FILE_INVALID")).c_str(), piinfo->name);
			AfxMessageBox(strPrompt);
			return;
		}
		GetDlgItem(IDC_EDIT_FILE)->SetWindowText(strFileName);
		wsprintf(strTmp, _T("%d"), FileItemCount);
		GetDlgItem(IDC_STATIC_FILECOUNT)->SetWindowText(strTmp);
		wsprintf(strTmp, _T("%d"), 0);
		GetDlgItem(IDC_STATIC_FILEUSED)->SetWindowText(strTmp);
		wsprintf(strTmp, _T("%04X"), FileItemCrc);
		GetDlgItem(IDC_STATIC_FILECRC)->SetWindowText(strTmp);
	}
}

void CDlgItemCmn::OnBnClickedCheckWhole()
{
	GetDlgItem(IDC_EDIT_FILE)->SetWindowText(_T(""));
	GetDlgItem(IDC_STATIC_FILECOUNT)->SetWindowText(_T(""));
	GetDlgItem(IDC_STATIC_FILEUSED)->SetWindowText(_T(""));
	GetDlgItem(IDC_STATIC_FILECRC)->SetWindowText(_T(""));
	if (BST_CHECKED == (m_CheckBinFile.GetCheck()&BST_CHECKED)) {
		
	} else {
		
	}
}

void CDlgItemCmn::OnBnClickedCheckBinText()
{
	// TODO: Add your control notification handler code here
}

void CDlgItemCmn::OnBnClickedCheckHex()
{
	// TODO: Add your control notification handler code here
}
