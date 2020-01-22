using bill.payletter.com.CommonModule;
using BOQv7Das_Net;
using System;
using System.Data;

public partial class PayResult : PageBase
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
        ((BaseMasterPage)Page.Master).mainTitle = "결제관리";
        ((BaseMasterPage)Page.Master).subTitle  = "결제 결과 확인";
    }
}