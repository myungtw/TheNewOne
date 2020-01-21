using bill.payletter.com.CommonModule;
using System;

///================================================================
/// <summary>
/// FileName       : PayInfoIns.aspx
/// Description    : 결제정보 세팅페이지
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author         : ysjee@payletter.com, 2020-01-14
/// Modify History : Just Created.
/// </summary>
///================================================================
public partial class PayInfoIns : PageBase
{

    protected string AjaxTicket
    {
        get
        {
            return UserGlobal.GetAjaxTicket(Request);
        }
    }
    protected string FamilyEventNo
    {
        get
        {
            return Request["familyeventno"];
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
        _pageAccessType = PageAccessType.Everyone;
        return;
    }

    //-------------------------------------------------------------
    /// <summary>
    /// Name          : Page_Load()
    /// Description   : 페이지 로드
    /// </summary>
    //-------------------------------------------------------------
    protected void Page_Load(object sender, EventArgs e)
    {

    }

}