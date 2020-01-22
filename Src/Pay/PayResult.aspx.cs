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
    }
}