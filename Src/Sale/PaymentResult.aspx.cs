using System;
using System.Web;

using bill.payletter.com.CommonModule;

///================================================================
/// <summary>
/// FileName       : PaymentResult.aspx
/// Description    : 결제 결과 페이지
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author         : tumyeong@payletter.com, 2019-09-03
/// Modify History : Just Created.
/// </summary>
///================================================================
public partial class PaymentResult : PageBase
{
    protected string AjaxTicket
    {
        get
        {
            return UserGlobal.GetAjaxTicket(Request);
        }
    }
    protected string strSaleIndexUrl            //판매 Index Url
    {
        get
        {
            return UserGlobal.BOQ_SALE_INDEX_URL;
        }
    }
    protected string strFreeItemIndexUrl        //관리자 지급 Index Url
    {
        get
        {
            return UserGlobal.BOQ_FREEITEM_INDEX_URL;
        }
    }

    protected Int64  intPosOrderNo       = 0;                   //Pos 주문번호
    protected string strResultMsg        = string.Empty;        //결제 결과 메시지
    protected string strPaymentUrl       = string.Empty;        //결제 페이지 Url

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

    //-------------------------------------------------------------
    /// <summary>
    /// Name          : Page_Load()
    /// Description   : 페이지 로드
    /// </summary>
    //-------------------------------------------------------------
    protected void Page_Load(object sender, EventArgs e)
    {
        string pl_strPosOrderNo = string.Empty;
        string pl_strGChargeNo  = string.Empty;

        try
        {
            //수신 데이터
            strResultMsg     = UserGlobal.GetValue(HttpUtility.UrlDecode(Request.QueryString["resultmsg"]));    //결제 결과 메시지
            pl_strPosOrderNo = UserGlobal.GetValue(Request.QueryString["posorderno"]);                          //Pos 주문번호
            Int64.TryParse(pl_strPosOrderNo, out intPosOrderNo);

            //결제 페이지 설정
            strPaymentUrl       = string.Format("{0}?posorderno={1}", UserGlobal.BOQ_SALE_PAYMENT_URL, pl_strPosOrderNo);
        }
        catch (Exception pl_objEx)
        {
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace, false);
        }
    }

}