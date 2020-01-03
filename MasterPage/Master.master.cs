using System;

using bill.payletter.com.CommonModule;
using bill.payletter.com.Session;

///================================================================
/// <summary>
/// FileName       : Master.aspx
/// Description    : 마스터 페이지
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author         : tumyeong@payletter.com, 2019-09-03
/// Modify History : Just Created.
/// </summary>
///================================================================
public partial class Master : System.Web.UI.MasterPage
{
    protected string AjaxTicket
    {
        get
        {
            return UserGlobal.GetAjaxTicket(Request);
        }
    }
    protected string strLogoutUrl                   //로그아웃 Url
    {
        get
        {
            return UserGlobal.BOQ_LOGOUT_URL;
        }
    }
    protected string strSaleIndexUrl                //판매 Index Url
    {
        get
        {
            return UserGlobal.BOQ_SALE_INDEX_URL;
        }
    }
    protected string strRefundIndexUrl              //환불 Index Url
    {
        get
        {
            return UserGlobal.BOQ_REFUND_INDEX_URL;
        }
    }
    protected string strFreeItemIndexUrl            //관리자지급 Index Url
    {
        get
        {
            return UserGlobal.BOQ_FREEITEM_INDEX_URL;
        }
    }


    protected UserSession    objSes;          //로그인 세션
    protected string         strOnClass   = string.Empty;   //Navi (Left) css 설정용
    protected int            intAuthCode;

    //-------------------------------------------------------------
    /// <summary>
    /// Name          : Page_Load()
    /// Description   : 페이지 로드
    /// </summary>
    //-------------------------------------------------------------
    protected void Page_Load(object sender, EventArgs e)
    {
        string pl_strCurPage = string.Empty;

        try
        {
            //Navi (Left) css 설정
            pl_strCurPage = Request.CurrentExecutionFilePath.ToLower();
            if(pl_strCurPage.IndexOf("/src/freeitem") > -1)
            {
                strOnClass = "manager";
            }
            else if(pl_strCurPage.IndexOf("/src/refund") > -1)
            {
                strOnClass = "refund";
            }
            else if(pl_strCurPage.IndexOf("/src/sale") > -1)
            {
                strOnClass = "sell";
            }

            //Session 설정
            if (this.Page is PageBase)
            {
                PageBase pageBase = this.Page as PageBase;
                objSes = pageBase.objSes;
                //intAuthCode   = pageBase.intAuthCode;
            }
        }
        catch (Exception pl_objEx)
        {
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace, false);
        }
    }
}
