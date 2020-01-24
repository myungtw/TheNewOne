using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using bill.payletter.com.CommonModule;

public partial class MyFamilyEvent : PageBase
{
    protected string AjaxTicket
    {
        get
        {
            return UserGlobal.GetAjaxTicket(Request);
        }
    }

    protected string strFamilyEventIndexUrl
    {
        get
        {
            return UserGlobal.BOQ_FAMILYEVENT_INDEX_URL;
        }
    }

    protected string strLoginUrl
    {
        get
        {
            return UserGlobal.BOQ_LOGIN_URL;
        }
    }

    protected int intUserNo
    {
        get
        {
            return objSes.intUserNo;
        }
    }

    protected Int64  intFamilyEventNo       = 0;
    
    protected string strEncFamilyEventNo
    {
        get
        {
            return UserGlobal.GetEncryptStr(Request.QueryString["familyeventno"]);
        }
    }

    ///-----------------------------------------------------
    /// <summary>
    /// Name          : Page_Init()
    /// Description   : 페이지 초기화
    /// </summary>
    ///-----------------------------------------------------
    private void Page_Init(object sender, EventArgs e)
    {
        _pageAccessType = PageAccessType.Login;
        ((BaseMasterPage)Page.Master).mainTitle = "이벤트 관리";
        ((BaseMasterPage)Page.Master).subTitle  = "나의 이벤트";
        return;
    }

    ///-----------------------------------------------------
    /// <summary>
    /// Name          : Page_Load()
    /// Description   : 페이지 로드
    /// </summary>
    ///-----------------------------------------------------
    protected void Page_Load(object sender, EventArgs e)
    {
        string strFamilyEventNo = string.Empty;

        strFamilyEventNo = UserGlobal.GetValue(Request.QueryString["familyeventno"]);
        Int64.TryParse(strFamilyEventNo, out intFamilyEventNo);
    }
}