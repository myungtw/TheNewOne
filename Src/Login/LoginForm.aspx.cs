using System;

using bill.payletter.com.CommonModule;

///================================================================
/// <summary>
/// FileName       : LoginForm.aspx
/// Description    : 로그인 폼
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author         : tumyeong@payletter.com, 2019-09-03
/// Modify History : Just Created.
/// </summary>
///================================================================
public partial class LoginForm : PageBase
{
    protected string AjaxTicket
    {
        get
        {
            return UserGlobal.GetAjaxTicket(Request);
        }
    }
    protected string strUserCookie                      //사용자 쿠키
    {
        get
        {
            return UserGlobal.BOQ_DEFAULT_COOKIE;
        }
    }
    protected string strSaveIDCookie                    //로그인 아이디 저장 쿠키
    {
        get
        {
            return UserGlobal.BOQ_SAVEID_COOKIE;
        }
    }
    protected string strIndexUrl                        //인덱스 Url
    {
        get
        {
            return UserGlobal.BOQ_INDEX_URL;
        }
    }

    ///-----------------------------------------------------
    /// <summary>
    /// Name          : Page_Init()
    /// Description   : 페이지 초기화
    /// </summary>
    ///-----------------------------------------------------
    private void Page_Init(object sender, EventArgs e)
    {
        _pageAccessType = PageAccessType.Everyone;
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

    }

}

