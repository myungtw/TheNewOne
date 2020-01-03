<%@ WebHandler Language="C#" Class="LoginHandler" %>

using System;

using bill.payletter.com.CommonModule;
using bill.payletter.com.handler;

///================================================================
/// <summary>
/// FileName        : LoginHandler.ashx
/// Description     : 로그인 이벤트 처리기
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author          : tumyeong@payletter.com, 2019-08-28
/// Modify History  : just create.
/// </summary>
///================================================================
public class LoginHandler : AshxBaseHandler
{

    #region 로그인
    //-------------------------------------------------------------
    /// <summary>
    /// 로그인
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = false, pageType = PageAccessType.Everyone)]
    private int VerifyLogin(VerifyLoginReqParam objReqParam, VerifyLoginResParam objResParam, out string strErrMsg)
    {
        int    pl_intRetVal     = 0;
        int    pl_intUserNo     = 0;
        string pl_strUserName   = string.Empty;
        string pl_strCookieInfo = string.Empty;

        strErrMsg = string.Empty;

        try
        {
            //패스워드 확인 (임시 비번 체크 : ID <> PW)
            if (objReqParam.strP.Equals(objReqParam.strI))
            {
                pl_intRetVal = 1101;
                strErrMsg    = "아이디 또는 비밀번호를 확인해 주세요.";
                return pl_intRetVal;
            }

            //사용자 정보
            pl_intRetVal = GetUserInfo(objReqParam.strI, out pl_intUserNo, out pl_strUserName, out strErrMsg);
            if (!pl_intRetVal.Equals(0))
            {
                return pl_intRetVal;
            }

            //응답 데이터 세팅
            objResParam.intSiteCode = objReqParam.intSiteCode.Equals(0) ? UserGlobal.DEFAULT_SITECODE : objReqParam.intSiteCode;
            objResParam.strUserID   = objReqParam.strI;
            objResParam.intUserNo   = pl_intUserNo;
            objResParam.strUserName = pl_strUserName;

            //쿠키 정보
            pl_strCookieInfo = string.Format("{0}/{1}/{2}/{3}/{4}", objResParam.intSiteCode, objResParam.intUserNo, objResParam.strUserID, objResParam.strUserName, DateTime.Now.ToString("yyyyMMddHHmmss"));

            //쿠키 생성
            UserGlobal.SetCookie(UserGlobal.BOQ_DEFAULT_COOKIE, UserGlobal.GetEncryptStr(pl_strCookieInfo));

            //로그인 아이디 저장 여부에 따라 쿠키 생성
            if (objReqParam.blnSave)
            {
                UserGlobal.SetCookie(UserGlobal.BOQ_SAVEID_COOKIE, objResParam.strUserID, 30);
            }
            else
            {
                UserGlobal.RemoveCookie(UserGlobal.BOQ_SAVEID_COOKIE);
            }
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = 1100;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {

        }

        return pl_intRetVal;
    }

    //로그인 요청 클래스
    public class VerifyLoginReqParam : DefaultReqParam
    {
        public Int16    intSiteCode     { get; set; }
        public string   strI            { get; set; }
        public string   strP            { get; set; }
        public bool     blnSave         { get; set; }
    }

    //로그인 응답 클래스
    public class VerifyLoginResParam : DefaultResParam
    {
        public Int16    intSiteCode     { get; set; }
        public int      intUserNo       { get; set; }
        public string   strUserID       { get; set; }
        public string   strUserName     { get; set; }
    }


    //사용자 정보
    private int GetUserInfo(string strUserID, out int intUserNo, out string strUserName, out string strErrMsg)
    {
        int pl_intRetVal = 0;

        intUserNo   = 0;
        strUserName = string.Empty;
        strErrMsg   = string.Empty;

        //사용자 정보
        switch (strUserID.ToLower())
        {
            case "test":
                intUserNo   = 999;
                strUserName = "테스트";
                break;
            case "tumyeong":
                intUserNo   = 3;
                strUserName = "명태우";
                break;
            default:
                pl_intRetVal = 1102;
                strErrMsg    = "사용자 정보가 없습니다.";
                break;
        }

        return pl_intRetVal;
    }
    #endregion
}