using bill.payletter.com.CommonModule;
using System;

public partial class UserControl : System.Web.UI.UserControl
{
    protected string AjaxTicket
    {
        get
        {
            return UserGlobal.GetAjaxTicket(Request);
        }
    }
    protected string strOnClass              = string.Empty;
    protected string strSelectMemberTypeHtml = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        string pl_strCurPage = Request.CurrentExecutionFilePath.ToLower();

        // PageBase를 상속받은곳이라면, 판매자 쿠키삭제
        if (this.Page is PageBase)
        {
            PageBase pageBase = this.Page as PageBase;
            
        }

        strSelectMemberTypeHtml = "<li><input type='radio' name='member' id='select_type01'><label for='select_type01'>비회원</label></li><li><input type='radio' name='member' id='select_type02' checked='checked'><label for='select_type02'>회원</label></li>";
        if (pl_strCurPage.IndexOf("/src/freeitem") > -1)
        {
            strOnClass              = "manager";
            strSelectMemberTypeHtml = "<li><input type='radio' name='member' id='select_type02' checked='checked'><label for='select_type02'>회원</label></li>";
        }
        else if (pl_strCurPage.IndexOf("/src/refund") > -1)
        {
            strOnClass = "refund";
        }
        else if (pl_strCurPage.IndexOf("/src/sale") > -1)
        {
            strOnClass = "sell";
        }
    }


    protected string strReturnURL;
    public string ReturnURL {
        set { strReturnURL = value; }
        get { return strReturnURL; }
    }
}