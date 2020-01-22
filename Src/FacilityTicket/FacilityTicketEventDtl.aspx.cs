using bill.payletter.com.CommonModule;
using System;
///================================================================
/// <summary>
/// FileName       : FacilityTicketEventDtl.aspx
/// Description    : 해당 이벤트 보유내역조회
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author         : ysjee@payletter.com, 2020-01-14
/// Modify History : Just Created.
/// </summary>
///================================================================
public partial class FacilityTicketEventDtl : PageBase
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
    protected void Page_Load(object sender, EventArgs e)
    {
        ((BaseMasterPage)Page.Master).mainTitle = "경조사 관리";
        ((BaseMasterPage)Page.Master).subTitle  = "나의 경조사";
    }
}