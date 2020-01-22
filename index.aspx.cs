using bill.payletter.com.CommonModule;
using System;

public partial class index : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Redirect(UserGlobal.BOQ_LOGIN_URL);
    }
}