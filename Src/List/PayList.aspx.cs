using bill.payletter.com.CommonModule;
using System;

///================================================================
/// <summary>
/// FileName       : PayList.aspx
/// Description    : 결제내역 조회
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author         : ysjee@payletter.com, 2020-01-22
/// Modify History : Just Created.
/// </summary>
///================================================================
public partial class PayList : PageBase
{
    protected string AjaxTicket
    {
        get
        {
            return UserGlobal.GetAjaxTicket(Request);
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        ((BaseMasterPage)Page.Master).mainTitle = "내역 관리";
        ((BaseMasterPage)Page.Master).subTitle  = "결제 내역조회";
    }
}