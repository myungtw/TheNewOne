using System;

using bill.payletter.com.CommonModule;

///================================================================
/// <summary>
/// FileName       : Logout.aspx
/// Description    : 로그아웃
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author         : tumyeong@payletter.com, 2019-09-03
/// Modify History : Just Created.
/// </summary>
///================================================================
public partial class Logout : System.Web.UI.Page
{
    //-------------------------------------------------------------
    /// <summary>
    /// Name          : Page_Load()
    /// Description   : 페이지 로드
    /// </summary>
    //-------------------------------------------------------------
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            //쿠키 삭제
            UserGlobal.RemoveCookie(UserGlobal.BOQ_DEFAULT_COOKIE);
        }
        catch (Exception pl_objEx)
        {
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace, false);
        }
        finally
        {
            Response.Redirect(UserGlobal.BOQ_LOGIN_URL);
        }
    }
}