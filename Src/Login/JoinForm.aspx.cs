﻿using System;

using bill.payletter.com.CommonModule;

///================================================================
/// <summary>
/// FileName       : JoinForm.aspx
/// Description    : 회원가입 폼
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author         : tumyeong@payletter.com, 2019-09-03
/// Modify History : Just Created.
/// </summary>
///================================================================
public partial class JoinForm : PageBase
{
    protected string AjaxTicket
    {
        get
        {
            return UserGlobal.GetAjaxTicket(Request);
        }
    }
    protected string strLoginUrl                        //로그인 Url
    {
        get
        {
            return UserGlobal.BOQ_LOGIN_URL;
        }
    }
    protected string strIndexUrl                        //인덱스 Url
    {
        get
        {
            return UserGlobal.BOQ_INDEX_URL;
        }
    }
    protected string EncFamilyEventNo
    {
        get
        {
            return Request.QueryString["encfamilyeventno"];
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

