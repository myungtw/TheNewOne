using bill.payletter.com.CommonModule;
using System;
using System.Web.UI;

///================================================================
/// <summary>
/// FileName       : RefundList.aspx
/// Description    : 환전 내역조회
/// </summary>
///================================================================
public partial class RefundList: PageBase
{
    protected string AjaxTicket
    {
        get
        {
            return UserGlobal.GetAjaxTicket(Request);
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        ((BaseMasterPage)Page.Master).mainTitle = "내역 관리";
        ((BaseMasterPage)Page.Master).subTitle  = "환전내역";
    }
}