using bill.payletter.com.CommonModule;
using System;

public partial class POQ : PageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        form1.Method = "POST";
        form1.Action = Request.UrlReferrer.AbsoluteUri;
        foreach(string key in Request.Form.AllKeys)
        {
            if(!key.ToLower().Contains("_view"))
                lblForm.Text += "<input type='hidden' name='"+key+"' value='"+Request.Form[key]+"'/>";
        }
    }
}