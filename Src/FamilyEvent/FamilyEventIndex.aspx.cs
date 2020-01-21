using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using bill.payletter.com.CommonModule;

public partial class FamilyEventIndex : PageBase
{
    protected string AjaxTicket
    {
        get
        {
            return UserGlobal.GetAjaxTicket(Request);
        }
    }
    protected string strMyFamilyEventUrl
    {
        get
        {
            return UserGlobal.BOQ_FAMILYEVENT_MYEVENT_URL;
        }
    }
    protected int intUserNo = 0;

    ///-----------------------------------------------------
    /// <summary>
    /// Name          : Page_Init()
    /// Description   : 페이지 초기화
    /// </summary>
    ///-----------------------------------------------------
    private void Page_Init(object sender, EventArgs e)
    {
        _pageAccessType = PageAccessType.Login;
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
        //PL_DEBUG : 로그인 아이디 필요
        intUserNo = 1;

    }
}