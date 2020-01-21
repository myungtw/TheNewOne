using System;
using bill.payletter.com.CommonModule;
using bill.payletter.com.Session;

public partial class BaseMasterPage : System.Web.UI.MasterPage
{
    protected UserSession objSes;            //판매 세션

    protected void Page_Load(object sender, EventArgs e)
    {
        //Session 설정
        if (this.Page is PageBase)
        {
            PageBase pageBase = this.Page as PageBase;
            objSes = pageBase.objSes;
        }

    }
}
