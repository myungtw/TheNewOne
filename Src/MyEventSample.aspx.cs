using bill.payletter.com.CommonModule;
using System;

public partial class Src_MyEventSample : PageBase
{
    protected string strInvitationUrl
    {
        get
        {
            return string.Format("{0}?encfamilyeventno={1}", UserGlobal.BOQ_LOGIN_URL, UserGlobal.GetEncryptStr(Request.QueryString["familyeventno"]));
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {

    }
}