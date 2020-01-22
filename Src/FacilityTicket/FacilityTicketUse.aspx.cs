using System;
using bill.payletter.com.CommonModule;

public partial class FacilityTicketUse : PageBase
{
    protected string AjaxTicket
    {
        get
        {
            return UserGlobal.GetAjaxTicket(Request);
        }
    }
    protected string FacilityTicketNo
    {
        get
        {
            return Request.QueryString["facilityticketno"];
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