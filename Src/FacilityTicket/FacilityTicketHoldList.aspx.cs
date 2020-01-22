using System;
using bill.payletter.com.CommonModule;

public partial class FacilityTicketHoldList : PageBase
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
            return Request.QueryString["familyeventno"];
        }
    }
    protected string FacilityTicketUseUrl
    {
        get
        {
            return UserGlobal.BOQ_FACILITY_TICKET_USE_URL;
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
        return;
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
}