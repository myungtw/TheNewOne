using System;
using System.Web;

using bill.payletter.com.CommonModule;
using BOQv7Das_Net;
using System.Data;

//================================================================
// FileName        : UserSession.cs
// Description     : Manager(User) Cookie Decrypt & Check.
// Copyright 2008 by PayLetter Inc. All rights reserved.
// Author          : roya@payletter.com,    2008-05-02
// Modify History  : Just Created.
//================================================================
namespace bill.payletter.com.Session
{
    ///----------------------------------------------------------------------
    /// <summary>
    /// UserSession Class
    /// </summary>
    ///----------------------------------------------------------------------
    public class UserSession
    {
        #region private Variables
        private bool   _isLogin      = false;
        private int    _intUserNo    = 0;
        private string _strUserID    = string.Empty;
        private string _strUserName  = string.Empty;
        private string _strPhoneNo   = string.Empty;
        private Int16  _intUserAuth  = 0;
        private Int16  _intStateCode = 0;

        #endregion

        public UserSession()
        {
            string      pl_strErrMsg     = string.Empty;
            string      pl_strCookieInfo = string.Empty;
            string[]    pl_arrCookieInfo = null;
            HttpCookie  pl_objCookie     = null;
            
            _isLogin = false;

            try
            {
                pl_objCookie = HttpContext.Current.Request.Cookies[UserGlobal.BOQ_DEFAULT_COOKIE];
                if (pl_objCookie == null)
                {
                    pl_strErrMsg = "쿠키 " + UserGlobal.BOQ_DEFAULT_COOKIE + " 조회 실패";
                    _isLogin = false;
                    return;
                }
                else if(string.IsNullOrEmpty(pl_objCookie.Value))
                {
                    pl_strErrMsg = "쿠키 " + UserGlobal.BOQ_DEFAULT_COOKIE + " 조회 - 빈값";
                    _isLogin = false;
                    return;
                }

                pl_strCookieInfo = UserGlobal.GetDecryptStr(pl_objCookie.Value);
                if (string.IsNullOrEmpty(pl_strCookieInfo))
                {
                    pl_strErrMsg = "쿠키 " + UserGlobal.BOQ_DEFAULT_COOKIE + " 정보 조회 실패";
                    _isLogin = false;
                    return;
                }

                pl_arrCookieInfo = pl_strCookieInfo.Split('/');
                if (!pl_arrCookieInfo.Length.Equals(6))
                {
                    pl_strErrMsg = "쿠키 " + UserGlobal.BOQ_DEFAULT_COOKIE + " 상세 정보 조회 실패";
                    _isLogin = false;
                    return;
                }

                Int32.TryParse(pl_arrCookieInfo[0], out _intUserNo);
                _strUserID   = pl_arrCookieInfo[1];
                _strUserName = pl_arrCookieInfo[2];
                _strPhoneNo  = pl_arrCookieInfo[3];
                Int16.TryParse(pl_arrCookieInfo[4], out _intUserAuth);
                Int16.TryParse(pl_arrCookieInfo[5], out _intStateCode);

                if (!_intUserNo.Equals(0) && !string.IsNullOrEmpty(_strUserID))
                {
                    _isLogin = true;

                    var encFamilyEventNo = HttpContext.Current.Request.QueryString["encfamilyeventno"];

                    if (!string.IsNullOrWhiteSpace(encFamilyEventNo))
                    {
                        Int64 intDecFamilyEventNo = Convert.ToInt64(UserGlobal.GetDecryptStr(encFamilyEventNo));

                        InsFamilyEventJoin(_intUserNo, intDecFamilyEventNo, out pl_strErrMsg);
                    }
                }
            }
            catch (Exception pl_objEx)
            {
                //사용자 정보 초기화
                LogOut();
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                pl_objCookie = null;
                if (!_isLogin)
                {
                    LogOut();
                    UtilLog.WriteCommonLog("UserSession", "UserSession", pl_strErrMsg);

                    Uri referrer = HttpContext.Current.Request.UrlReferrer;
                    if(referrer != null)
                    {
                        UtilLog.WriteCommonLog("UserSession", "UserSession", "요청위치: " + referrer.OriginalString.ToLower());
                    }
                }
            }

            return;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Go to Login page
        /// </summary>
        /// <param name="strURL">로그인 후 돌아갈 원 페이지</param>
        ///----------------------------------------------------------------------
        public void GoLogin(string strURL)
        {
            HttpContext.Current.Response.Write("<script>location.href='" + string.Format("{0}?retUrl={1}", UserGlobal.BOQ_LOGIN_URL, strURL) + "'</script>");
            HttpContext.Current.Response.End();
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 로그아웃을 한다.
        /// </summary>
        /// Author         : moondae@payletter.com, 2007-07-03
        /// 
        /// Modify History : Just Created.
        /// 
        ///----------------------------------------------------------------------
        public void LogOut()
        {
            //쿠키 제거
            UserGlobal.RemoveCookie(UserGlobal.BOQ_DEFAULT_COOKIE);

            //사용자 정보 초기화
            ClearUserInfo();
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 사용자 정보 초기화
        /// </summary>
        ///----------------------------------------------------------------------
        public void ClearUserInfo()
        {
            _isLogin     = false;
            _intUserNo   = 0;
            _strUserID   = string.Empty;
            _strUserName = string.Empty;
            _strPhoneNo  = string.Empty;

            _intUserAuth = 0;
            _intStateCode = 0;

            return;
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
                pl_objDas.AddParam("@pi_intUserRole",       DBType.adTinyInt, 3,                0,      ParameterDirection.Input);
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

        ///----------------------------------------------------------------------
        /// <summary>
        /// Get User number 
        /// </summary>
        ///----------------------------------------------------------------------
        public bool isLogin
        {
            get { return _isLogin; }
        }
        public int intUserNo
        {
            get { return _intUserNo; }
        }
        public string strUserID
        {
            get { return _strUserID; }
        }
        public string strUserName
        {
            get { return _strUserName; }
        }
        public string strPhoneNo
        {
            get { return _strPhoneNo; }
        }
        public Int16 intUserAuth
        {
            get { return _intUserAuth; }
        }
        public Int16 intStateCode
        {
            get { return _intStateCode; }
        }
    }
}
