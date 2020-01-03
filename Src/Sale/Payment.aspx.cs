using System;
using System.Web;

using bill.payletter.com.CommonModule;

///================================================================
/// <summary>
/// FileName       : Payment.aspx
/// Description    : 결제 페이지
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author         : tumyeong@payletter.com, 2019-09-03
/// Modify History : Just Created.
/// </summary>
///================================================================
public partial class Payment : PageBase
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
    protected Int64  intCashPayTool             //PayToolCode(현금)
    {
        get
        {
            return (Int16)UserGlobal.BOQ_PAYTOOL_CASH;
        }
    }
    protected Int64  intCardPayTool             //PayToolCode(카드)
    {
        get
        {
            return (Int16)UserGlobal.BOQ_PAYTOOL_CARD;
        }
    }
    protected string strCashPGCode              //PGCode(현금)
    {
        get
        {
            return UserGlobal.BOQ_PGCODE_POS_CASH;
        }
    }
    protected string strCardPGCode              //PGCode(카드)
    {
        get
        {
            return UserGlobal.BOQ_PGCODE_POS_CARD;
        }
    }

    protected Int64  intPosOrderNo       = 0;                   //Pos 주문번호
    protected string strResultMsg        = string.Empty;        //결제 결과 메시지
    protected string strPaymentUrl       = string.Empty;        //결제 페이지 Url
    protected string strPaymentResultUrl = string.Empty;        //결제/구매 결과 페이지 Url

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

        try
        {
            //수신 데이터
            strResultMsg     = UserGlobal.GetValue(HttpUtility.UrlDecode(Request.QueryString["resultmsg"]));    //결제 결과 메시지
            pl_strPosOrderNo = UserGlobal.GetValue(Request.QueryString["posorderno"]);                          //Pos 주문번호
            Int64.TryParse(pl_strPosOrderNo, out intPosOrderNo);

            //페이지 설정
            strPaymentUrl       = string.Format("{0}?posorderno={1}&resultmsg=", UserGlobal.BOQ_SALE_PAYMENT_URL, pl_strPosOrderNo);
            strPaymentResultUrl = string.Format("{0}?posorderno={1}", UserGlobal.BOQ_SALE_PAYMENT_RESULT_URL, pl_strPosOrderNo);

            //쿠키 만료 기간 갱신
            if (!intPosOrderNo.Equals(0))
            {
                UserGlobal.RenewalCookie(UserGlobal.BOQ_DEFAULT_COOKIE);
            }
        }
        catch (Exception pl_objEx)
        {
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace, false);
        }
    }

}