using bill.payletter.com.CommonModule;
using System;

public partial class SaleItem : PageBase
{
    protected string strProductTypeOption = string.Empty;

    protected string AjaxTicket
    {
        get
        {
            return UserGlobal.GetAjaxTicket(Request);
        }
    }

    protected string strSalePaymentUrl = string.Empty;

    ///----------------------------------------------------------------------
    /// <summary>
    /// Name : Page_Init
    /// </summary>    
    ///----------------------------------------------------------------------    
    protected void Page_Init(object sender, EventArgs e)
    {
        _pageAccessType = PageAccessType.Login;
    }


    ///----------------------------------------------------------------------
    /// <summary>
    /// Name  : Page_Load
    /// </summary>    
    ///----------------------------------------------------------------------    
    protected void Page_Load(object sender, EventArgs e)
    {
        strSalePaymentUrl = string.Format("{0}?posorderno=", UserGlobal.BOQ_SALE_PAYMENT_URL);
        PrintDDLB();
    }


    ///----------------------------------------------------------------------
    /// <summary>
    /// Name          : PrintDDLB()
    /// Description   : 드랍다운 리스트를 출력한다.
    /// Special Logic : NONE    
    /// </summary>    
    ///----------------------------------------------------------------------    
    private void PrintDDLB()
    {
        strProductTypeOption = DDLB.PrintProductTypeDDLB(false, DDLB.HtmlType.saleProductType); //카테고리 아이템타입
    }
}