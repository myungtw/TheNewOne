<%@ WebHandler Language="C#" Class="LoginHandler" %>

using System;
using System.Data;

using bill.payletter.com.CommonModule;
using bill.payletter.com.handler;
using BOQv7Das_Net;

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
        int    pl_intRetVal         = 0;
        int    pl_intUserNo         = 0;
        string pl_strUserName       = string.Empty;
        string pl_strPhoneNo        = string.Empty;
        Int16  pl_intUserAuth       = 0;
        Int16  pl_intStateCode      = 0;
        string pl_strCookieInfo     = string.Empty;
        string pl_strCurrEncryptPwd = string.Empty;

        strErrMsg = string.Empty;

        try
        {
            //패스워드 조회
            pl_intRetVal = GetUserCurrentPwd(objReqParam.strI, out pl_strCurrEncryptPwd, out strErrMsg);
            if (!pl_intRetVal.Equals(0))
            {
                return pl_intRetVal;
            }
            //패스워드 비교
            pl_intRetVal = CheckUserPwd(objReqParam.strP, pl_strCurrEncryptPwd, out strErrMsg);
            if (!pl_intRetVal.Equals(0))
            {
                return pl_intRetVal;
            }

            //사용자 정보
            pl_intRetVal = GetUserInfo(objReqParam.strI, out pl_intUserNo, out pl_strUserName, out pl_strPhoneNo, out pl_intUserAuth, out pl_intStateCode, out strErrMsg);
            if (!pl_intRetVal.Equals(0))
            {
                return pl_intRetVal;
            }

            //응답 데이터 세팅
            objResParam.intRetVal = pl_intRetVal;
            objResParam.strErrMsg = strErrMsg;

            //쿠키 정보
            pl_strCookieInfo = string.Format("{0}/{1}/{2}/{3}/{4}/{5}", pl_intUserNo, objReqParam.strI, pl_strUserName, pl_strPhoneNo, pl_intUserAuth, pl_intStateCode);

            //쿠키 생성
            UserGlobal.SetCookie(UserGlobal.BOQ_DEFAULT_COOKIE, UserGlobal.GetEncryptStr(pl_strCookieInfo));

            //로그인 아이디 저장 여부에 따라 쿠키 생성
            if (objReqParam.blnSave)
            {
                UserGlobal.SetCookie(UserGlobal.BOQ_SAVEID_COOKIE, objReqParam.strI, 30);
            }
            else
            {
                UserGlobal.RemoveCookie(UserGlobal.BOQ_SAVEID_COOKIE);
            }

            if(!string.IsNullOrWhiteSpace(objReqParam.strEncFamilyEventNo))
            {
                Int64 intDecFamilyEventNo = Convert.ToInt64(UserGlobal.GetDecryptStr(objReqParam.strEncFamilyEventNo));

                InsFamilyEventJoin(pl_intUserNo, intDecFamilyEventNo, out strErrMsg);
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
        public Int16    intSiteCode         { get; set; }
        public string   strI                { get; set; }
        public string   strP                { get; set; }
        public bool     blnSave             { get; set; }
        public string   strEncFamilyEventNo { get; set; }
    }

    //로그인 응답 클래스
    public class VerifyLoginResParam : DefaultResParam
    {
    }


    //사용자 정보
    private int GetUserInfo(string strUserID, out int intUserNo, out string strUserName, out string strPhoneNo, out Int16 intUserAuth, out Int16 intStateCode, out string strErrMsg)
    {
        int  pl_intRetVal = 0;
        IDas pl_objDas    = null;

        intUserNo    = 0;
        strUserName  = string.Empty;
        strPhoneNo   = string.Empty;
        intUserAuth  = 0;
        intStateCode = 0;
        strErrMsg    = string.Empty;
        try
        {
            //사용자 정보 조회        
            pl_objDas = new IDas();
            pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage = 0;

            pl_objDas.AddParam("@pi_strUserID",     DBType.adVarChar,  strUserID,      50,  ParameterDirection.Input);
            pl_objDas.AddParam("@po_intUserNo",     DBType.adInteger,  DBNull.Value,   0,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_strUserName",   DBType.adVarWChar, DBNull.Value,   100, ParameterDirection.Output);
            pl_objDas.AddParam("@po_strUserPhoneNo",DBType.adVarChar,  DBNull.Value,   100, ParameterDirection.Output);
            pl_objDas.AddParam("@po_intUserAuth",   DBType.adTinyInt,  DBNull.Value,   0,   ParameterDirection.Output);

            pl_objDas.AddParam("@po_intStateCode",  DBType.adTinyInt,  DBNull.Value,   0,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_strErrMsg",     DBType.adVarChar,  DBNull.Value,   256, ParameterDirection.Output);
            pl_objDas.AddParam("@po_intRetVal",     DBType.adInteger,  DBNull.Value,   4,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_strDBErrMsg",   DBType.adVarChar,  DBNull.Value,   256, ParameterDirection.Output);
            pl_objDas.AddParam("@po_intDBRetVal",   DBType.adInteger,  DBNull.Value,   4,   ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_LOGIN_USER_INFO_NT_GET");

            pl_intRetVal = Convert.ToInt32(pl_objDas.GetParam("@po_intRetVal"));
            if (pl_intRetVal.Equals(0))
            {
                intUserNo    = Convert.ToInt32(pl_objDas.GetParam("@po_intUserNo"));
                strUserName  = Convert.ToString(pl_objDas.GetParam("@po_strUserName"));
                strPhoneNo   = Convert.ToString(pl_objDas.GetParam("@po_strUserPhoneNo"));
                intUserAuth  = Convert.ToInt16(pl_objDas.GetParam("@po_intUserAuth"));
                intStateCode = Convert.ToInt16(pl_objDas.GetParam("@po_intStateCode"));
            }
            else
            {
                pl_intRetVal = 1103;
                strErrMsg    = "회원 정보 조회에 실패하였습니다.";
            }
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15213;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
            if (pl_objDas != null)
            {
                pl_objDas.Close();
                pl_objDas = null;
            }

            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog("GetUserCurrentPwd", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    //비밀번호 조회
    private int GetUserCurrentPwd(string strUserID, out string strCurrPassword, out string strErrMsg)
    {
        int  pl_intRetVal = 0;
        IDas pl_objDas    = null;
        strErrMsg         = string.Empty;
        strCurrPassword   = string.Empty;

        try
        {
            //사용자 정보 조회        
            pl_objDas = new IDas();
            pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage = 0;

            pl_objDas.AddParam("@pi_strUserID",   DBType.adVarChar, strUserID,      50,  ParameterDirection.Input);
            pl_objDas.AddParam("@po_strUserPwd",  DBType.adVarChar, DBNull.Value,   100, ParameterDirection.Output);
            pl_objDas.AddParam("@po_strErrMsg",   DBType.adVarChar, DBNull.Value,   256, ParameterDirection.Output);
            pl_objDas.AddParam("@po_intRetVal",   DBType.adInteger, DBNull.Value,   4,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_strDBErrMsg", DBType.adVarChar, DBNull.Value,   256, ParameterDirection.Output);

            pl_objDas.AddParam("@po_intDBRetVal", DBType.adInteger, DBNull.Value,   4,   ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_PWD_NT_GET");

            pl_intRetVal = Convert.ToInt32(pl_objDas.GetParam("@po_intRetVal"));
            if (pl_intRetVal.Equals(0))
            {
                strCurrPassword = Convert.ToString(pl_objDas.GetParam("@po_strUserPwd"));
            }
            else
            {
                //strErrMsg = Convert.ToString(pl_objDas.GetParam("@po_strErrMsg"));
                pl_intRetVal = 1101;
                strErrMsg    = "아이디 또는 비밀번호를 확인해 주세요.";
            }
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15213;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
            if (pl_objDas != null)
            {
                pl_objDas.Close();
                pl_objDas = null;
            }

            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog("GetUserCurrentPwd", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    //비밀번호 비교
    private int CheckUserPwd(string strUserPwd, string pl_strCurrEncryptPwd, out string strErrMsg)
    {
        int    pl_intRetVal         = 0;
        string pl_strCurrDecryptPwd = string.Empty;
        strErrMsg = string.Empty;

        try
        {
            pl_strCurrDecryptPwd = UserGlobal.GetDecryptStr(pl_strCurrEncryptPwd);
            if(!strUserPwd.Equals(pl_strCurrDecryptPwd))
            {
                pl_intRetVal = 1102;
                strErrMsg    = "아이디 또는 비밀번호를 확인해 주세요.";
            }
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15213;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog("CheckUserPwd", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    //이벤트 입력
    private int InsFamilyEventJoin(int intUserNo, Int64 intFamilyEventNo, out string strErrMsg)
    {
        int  pl_intRetVal = 0;
        IDas pl_objDas    = null;
        strErrMsg         = string.Empty;

        try
        {
            //사용자 정보 조회        
            pl_objDas = new IDas();
            pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage = 0;

            pl_objDas.AddParam("@pi_intUserNo",         DBType.adInteger, intUserNo,        0,      ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intFamilyEventNo",  DBType.adBigInt,  intFamilyEventNo, 0,      ParameterDirection.Input);
            pl_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar, DBNull.Value,     256,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intRetVal",         DBType.adInteger, DBNull.Value,     4,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar, DBNull.Value,     256,    ParameterDirection.Output);

            pl_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger, DBNull.Value,     4,      ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_FAMILY_EVENT_JOIN_TX_INS");

            pl_intRetVal = Convert.ToInt32(pl_objDas.GetParam("@po_intRetVal"));
            strErrMsg    = Convert.ToString(pl_objDas.GetParam("@po_strErrMsg"));
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15213;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
            if (pl_objDas != null)
            {
                pl_objDas.Close();
                pl_objDas = null;
            }

            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog("GetUserCurrentPwd", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }
    #endregion
}