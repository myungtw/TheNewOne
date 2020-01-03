using System;

using bill.payletter.com.CommonModule;

///================================================================
/// <summary>
/// FileName       : index.aspx
/// Description    : 인덱스 페이지
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author         : tumyeong@payletter.com, 2019-09-03
/// Modify History : Just Created.
/// </summary>
///================================================================
public partial class index : PageBase
{
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
        try
        {



        }
        catch (Exception pl_objEx)
        {
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace, false);
        }
    }
}