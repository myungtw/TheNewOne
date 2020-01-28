using System;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Collections.Specialized;
using System.Configuration;
using System.Text;
using System.Text.RegularExpressions;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

using bill.payletter.com.Session;

//================================================================
// FileName        : CommonModule.cs
// Description     : 공용 모듈
// Copyright       : 2013 by PayLetter Inc. All rights reserved.
// Author          : moondae@payletter.com, 2013-02-06
// Modify History  : Just Created.
//================================================================
namespace bill.payletter.com.CommonModule
{
    ///----------------------------------------------------------------------
    /// <summary>
    /// Page 속성 정의    
    /// </summary>
    ///----------------------------------------------------------------------
    public class PageBase : System.Web.UI.Page
    {
        public UserSession      objSes;
        public PageAccessType   _pageAccessType;

        ///----------------------------------------------------------------------
        /// <summary>
        /// Page_Init 메소드를 재정의 한다
        /// </summary>
        /// Author         : moondae@payletter.com, 2007-08-10
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        protected override void OnInit(EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.Now.AddYears(-1));

            Page.Title = UserGlobal.PAGE_TITLE;
            Page.ClientScript.GetPostBackEventReference(this, "");

            _pageAccessType = PageAccessType.Everyone;

            base.OnInit(e);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Page_Load 메소드를 재정의 한다
        /// </summary>
        /// Author         : moondae@payletter.com, 2007-08-10
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        protected override void OnLoad(EventArgs e)
        {
            string pl_strErrMsg = string.Empty;
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.Now.AddYears(-1));

            objSes = new UserSession();

            // 로그인 체크
            switch (_pageAccessType)
            {
                case PageAccessType.Login:
                    if (!objSes.isLogin)
                    {
                        objSes.GoLogin(Page.Request.Url.ToString());
                    }
                    break;

                default:
                    break;
            }

            base.OnLoad(e);
        }
    }

    ///================================================================================
    /// <summary>
    /// 페이지 접근 권한 체크 방식    
    ///  Login        : 로그인 필요
    ///  Login : 매니저 로그인 후 담당프로 선택
    ///  Everyone            : 모든사람 접근가능
    /// </summary>
    ///================================================================================
    public enum PageAccessType
    {
        Everyone = 1,
        Login    = 2,
    }
    
    ///----------------------------------------------------------------------
    /// <summary>
    /// UserGlobal Class
    /// </summary>
    ///----------------------------------------------------------------------
    public class UserGlobal
    {
        #region 기본 정보
        public const  string    PAGE_TITLE                  = "FamilyEvent";
        public const  int       BOQ_DEFAULT_CHARSET         = 65001;

        public const  Int16     DEFAULT_SITECODE            = 1;
        public const  string    DEFAULT_SITE_ENC_KEY        = "bill";

        public const  string    BOQ_DEFAULT_SUCCESS_CODE    = "0000";

        //기본 페이지 사이즈
        public const  int       BOQ_DEFAULT_PAGESIZE        = 10;
        public const  int       BOQ_DEFAULT_PAGENAVSIZE     = 10;

        //환경 정보 (PAY, DEV, QA, LIVE)
        public static string    SERVER_TYPE                 = ConfigurationManager.AppSettings["SERVER_TYPE"];
        public static string    BOQ_DEFAULT_DOMAIN          = string.Empty;

        public const  string    BOQ_AJAX_TICKET_KEY         = "ED2BC0A3982F22C3018BEF4A94BBD2E8";                                   //Ajax Handler 통신 시 보안을 위한 값
        public static string    BOQ_SHA256_REQ_KEY          = "1FCC34E1976C8980A398C771EA490C3A";                                   //Sha256 암호화 키
        public const  string    BOQ_AES_GCM_OKEY            = "8bdd5fdd4fb166402b98f90fe9fef2f9f1ec8991eedcba37e6f0478baf43125c";   //암호화 키(자동생성값)

        //Delimiter Type
        public const  char      BOQ_DELIMITER_TYPE1         = '^'; 
        public const  char      BOQ_DELIMITER_TYPE2         = (char) 2;                 // ''; 구분자 ㄱ 
        public const  char      BOQ_DELIMITER_TYPE3         = (char) 3;                 // 구분자 ㄴ

        // 데몬 정보
        public static string    BOQ_HOST_DAS                = string.Empty;             //빌링 DAS 정보
        #endregion
        
        #region 로그 경로
        public static string    BOQ_DEFAULT_LOGPATH         = string.Concat(HttpContext.Current.Request.ServerVariables["APPL_PHYSICAL_PATH"].ToString(), "..\\WebLogs\\User\\");
        public static string    BOQ_COMMON_LOGPATH          = string.Concat(BOQ_DEFAULT_LOGPATH, "CommonLog\\");
        public static string    BOQ_GDRPOS_LOGPATH          = string.Concat(BOQ_DEFAULT_LOGPATH, "Log\\");
        public static string    BOQ_EXCEPTION_LOGPATH       = string.Concat(BOQ_DEFAULT_LOGPATH, "Exception\\");
        #endregion

        #region 메일 발송
        public const  string    BOQ_ADDRESS_FROM            = "billuser@payletter.com";
        public static string    BOQ_ADDRESS_TO              = string.Empty;
        public static string    BOQ_SMTP_SERVER             = string.Empty;
        public static string    BOQ_SMTP_ID                 = string.Empty;
        public static string    BOQ_SMTP_PWD                = string.Empty;
        
        public static string[]  BOQ_NOTSENDERRMAIL_LIST     = null;                     //메일 수신을 원하지 않는 에러 코드 정의
        #endregion

        #region 쿠키 정보
        public const  string    BOQ_COOKIE_DOMAIN           = ".payletter.co.kr";              //기본 쿠키 도메인
        public static string    BOQ_DEFAULT_COOKIE          = "billuser_sid";           //기본 쿠키
        public static string    BOQ_SAVEID_COOKIE           = "save_sid";               //아이디 저장 용 쿠키
        #endregion

        #region Url 정보
        //인덱스 Url
        public static string    BOQ_INDEX_URL               = "/Src/FamilyEvent/FamilyEventIndex.aspx";                 //인덱스 페이지

        //로그인 관련 Url
        public static string    BOQ_LOGIN_URL               = "/Src/Login/LoginForm.aspx";                              //로그인 폼 페이지
        public static string    BOQ_LOGOUT_URL              = string.Empty;                                             //로그아웃 페이지

        //이벤트 관련 Url
        public static string    BOQ_FAMILYEVENT_INDEX_URL       = "/Src/FamilyEvent/FamilyEventIndex.aspx";             //이벤트 Index 페이지
        public static string    BOQ_FAMILYEVENT_MYEVENT_URL     = "/Src/FamilyEvent/MyFamilyEvent.aspx";                //내 이벤트 페이지
        public static string    BOQ_FACILITY_TICKET_HOLD_URL    = "/Src/FacilityTicket/FacilityTicketHoldList.aspx";    //보유 시설 이용권 페이지
        public static string    BOQ_FACILITY_TICKET_USE_URL     = "/Src/FacilityTicket/FacilityTicketUse.aspx";         //시설 이용권 사용 페이지
        public static string    BOQ_RECEIVE_LIST_URL            = "/Src/List/ReceiveList.aspx";                         //받은 내역 페이지
        public static string    BOQ_PAY_INFO_INS_URL            = "/Src/Pay/PayInfoIns.aspx";                           //결제 정보 입력 페이지
        #endregion

        static UserGlobal()
        {
            BOQ_NOTSENDERRMAIL_LIST = ConfigurationManager.AppSettings["BOQ_NOTSENDERRMAIL_LIST"].Split(',');

            switch (SERVER_TYPE)
            {
                //페이레터 로컬
                case "LOCAL" :
                    #region 쿠키 명
                    BOQ_DEFAULT_COOKIE          = string.Concat("local", BOQ_DEFAULT_COOKIE );
                    BOQ_SAVEID_COOKIE           = string.Concat("local", BOQ_SAVEID_COOKIE );
                    #endregion

                    BOQ_DEFAULT_DOMAIN          = "http://local.familyevent.payletter.co.kr";
                    BOQ_LOGIN_URL               = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_LOGIN_URL);
                    BOQ_LOGOUT_URL              = string.Concat(BOQ_DEFAULT_DOMAIN, "/Src/Login/Logout.aspx");
                    
                    BOQ_FAMILYEVENT_INDEX_URL   = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_FAMILYEVENT_INDEX_URL);
                    BOQ_FAMILYEVENT_MYEVENT_URL = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_FAMILYEVENT_MYEVENT_URL);
                    BOQ_FACILITY_TICKET_HOLD_URL = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_FACILITY_TICKET_HOLD_URL);
                    BOQ_FACILITY_TICKET_USE_URL = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_FACILITY_TICKET_USE_URL);
                    BOQ_RECEIVE_LIST_URL        = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_RECEIVE_LIST_URL);
                    BOQ_PAY_INFO_INS_URL        = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_PAY_INFO_INS_URL);
                    #region DB(데몬) 정보
                    BOQ_HOST_DAS                = GetDecryptStr(ConfigurationManager.AppSettings["BOQDAS_HOST_PAY"]);
                    BOQ_SHA256_REQ_KEY          = GetDecryptStr(ConfigurationManager.AppSettings["BOQ_SHA256_REQ_KEY_PAY"]);
                    #endregion

                    #region 메일 발송
                    BOQ_SMTP_SERVER             = ConfigurationManager.AppSettings["BOQ_SMTP_SERVER_PAY"];
                    BOQ_SMTP_ID                 = ConfigurationManager.AppSettings["BOQ_SMTP_ID_PAY"];
                    BOQ_SMTP_PWD                = ConfigurationManager.AppSettings["BOQ_SMTP_PWD_PAY"];
                    BOQ_ADDRESS_TO              = ConfigurationManager.AppSettings["BOQ_ADMIN_EMAIL_PAY"];
                    #endregion
                    break;

                //개발 서버
                case "DEV" :
                    #region 쿠키 명
                    BOQ_DEFAULT_COOKIE          = string.Concat("dev", BOQ_DEFAULT_COOKIE );
                    BOQ_SAVEID_COOKIE           = string.Concat("dev", BOQ_SAVEID_COOKIE );
                    #endregion
                    
                    BOQ_DEFAULT_DOMAIN          = "http://dev.familyevent.payletter.co.kr";
                    BOQ_LOGIN_URL               = string.Concat(BOQ_DEFAULT_DOMAIN, "/Src/Login/LoginForm.aspx");       //retUrl= : 로그인 후 돌아올 현재 페이지
                    BOQ_LOGOUT_URL              = string.Concat(BOQ_DEFAULT_DOMAIN, "/Src/Login/Logout.aspx");
                    
                    BOQ_FAMILYEVENT_INDEX_URL   = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_FAMILYEVENT_INDEX_URL);
                    BOQ_FAMILYEVENT_MYEVENT_URL = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_FAMILYEVENT_MYEVENT_URL);
                    BOQ_FACILITY_TICKET_HOLD_URL = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_FACILITY_TICKET_HOLD_URL);
                    BOQ_FACILITY_TICKET_USE_URL = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_FACILITY_TICKET_USE_URL);
                    BOQ_RECEIVE_LIST_URL        = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_RECEIVE_LIST_URL);
                    BOQ_PAY_INFO_INS_URL        = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_PAY_INFO_INS_URL);

                    #region DB(데몬) 정보
                    BOQ_HOST_DAS                = GetDecryptStr(ConfigurationManager.AppSettings["BOQDAS_HOST_PAY"]);
                    BOQ_SHA256_REQ_KEY          = GetDecryptStr(ConfigurationManager.AppSettings["BOQ_SHA256_REQ_KEY_PAY"]);
                    #endregion

                    #region 메일 발송
                    BOQ_SMTP_SERVER             = ConfigurationManager.AppSettings["BOQ_SMTP_SERVER_PAY"];
                    BOQ_SMTP_ID                 = ConfigurationManager.AppSettings["BOQ_SMTP_ID_PAY"];
                    BOQ_SMTP_PWD                = ConfigurationManager.AppSettings["BOQ_SMTP_PWD_PAY"];
                    BOQ_ADDRESS_TO              = ConfigurationManager.AppSettings["BOQ_ADMIN_EMAIL_PAY"];
                    #endregion
                    break;

                //실 서버
                case "REAL":
                    #region 쿠키 명
                    //BOQ_DEFAULT_COOKIE          = BOQ_DEFAULT_COOKIE;
                    //BOQ_SAVEID_COOKIE           = BOQ_SAVEID_COOKIE;
                    #endregion
                    
                    BOQ_DEFAULT_DOMAIN          = "http://familyevent.payletter.co.kr";
                    BOQ_LOGIN_URL               = string.Concat(BOQ_DEFAULT_DOMAIN, "/Src/Login/LoginForm.aspx");       //retUrl= : 로그인 후 돌아올 현재 페이지
                    BOQ_LOGOUT_URL              = string.Concat(BOQ_DEFAULT_DOMAIN, "/Src/Login/Logout.aspx");
                    
                    BOQ_FAMILYEVENT_INDEX_URL   = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_FAMILYEVENT_INDEX_URL);
                    BOQ_FAMILYEVENT_MYEVENT_URL = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_FAMILYEVENT_MYEVENT_URL);
                    BOQ_FACILITY_TICKET_HOLD_URL = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_FACILITY_TICKET_HOLD_URL);
                    BOQ_FACILITY_TICKET_USE_URL = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_FACILITY_TICKET_USE_URL);
                    BOQ_RECEIVE_LIST_URL        = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_RECEIVE_LIST_URL);
                    BOQ_PAY_INFO_INS_URL        = string.Concat(BOQ_DEFAULT_DOMAIN, BOQ_PAY_INFO_INS_URL);

                    #region DB(데몬) 정보
                    BOQ_HOST_DAS                = GetDecryptStr(ConfigurationManager.AppSettings["BOQDAS_HOST_REAL"]);
                    BOQ_SHA256_REQ_KEY          = GetDecryptStr(ConfigurationManager.AppSettings["BOQ_SHA256_REQ_KEY_REAL"]);
                    #endregion

                    #region 메일 발송
                    BOQ_SMTP_SERVER             = ConfigurationManager.AppSettings["BOQ_SMTP_SERVER_REAL"];
                    BOQ_SMTP_ID                 = ConfigurationManager.AppSettings["BOQ_SMTP_ID_REAL"];
                    BOQ_SMTP_PWD                = ConfigurationManager.AppSettings["BOQ_SMTP_PWD_REAL"];
                    BOQ_ADDRESS_TO              = ConfigurationManager.AppSettings["BOQ_ADMIN_EMAIL_REAL"];
                    #endregion
                    break;

                default: 
                    throw new Exception(string.Format("Please check the domain. [{0}]", HttpContext.Current.Request.ServerVariables.Get("SERVER_NAME")));
            }
        }

        /// ----------------------------------------------------------------------
        /// <summary>
        /// Referrer Page 확인
        /// shshin@payletter.com 2017-09-12
        /// </summary>
        /// <param name="objRequest"></param>
        /// <returns></returns>
        /// ----------------------------------------------------------------------
        public static bool GetUrlReferrer(HttpRequest objRequest, out string strRefererUrl)
        {
            bool pl_isRefereUrl = false;
            strRefererUrl = string.Empty;

            try
            {
                strRefererUrl = objRequest.UrlReferrer.AbsoluteUri.Replace("#", "");
                pl_isRefereUrl = true;
            }
            catch
            {
                pl_isRefereUrl = false;
            }

            return pl_isRefereUrl;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Ajax Ticket 생성
        /// shshin@payletter.com 2017-09-12
        /// </summary>
        /// <returns></returns>
        ///----------------------------------------------------------------------
        public static string GetAjaxTicket(HttpRequest objRequest)
        {
            string pl_strPageName   = string.Empty;
            string pl_strAjaxTicket = string.Empty;

            pl_strPageName   = objRequest.Url.AbsoluteUri.Replace("#", "").Replace(":" + objRequest.Url.Port, "");
            pl_strAjaxTicket = GetEncryptStr(string.Format("{0}|{1}", pl_strPageName, BOQ_AJAX_TICKET_KEY));

            return pl_strAjaxTicket;
        }

        /// ----------------------------------------------------------------------
        /// <summary>
        /// Ajax Ticket 유효성 검사
        /// shshin@payletter.com 2017-09-12
        /// </summary>
        /// <returns></returns>
        /// ----------------------------------------------------------------------
        public static bool VerifyAjaxTicket(string pl_strRefererUrl, string strCipherTextAjaxTicket)
        {
            string pl_strCipherTextAjaxTicket = string.Empty;

            pl_strCipherTextAjaxTicket = GetEncryptStr(string.Format("{0}|{1}", pl_strRefererUrl.Replace("#", ""), BOQ_AJAX_TICKET_KEY));
            if (!pl_strCipherTextAjaxTicket.Equals(strCipherTextAjaxTicket))
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 컨트롤에 입력이나 선택된 값 또는 null을 반환한다.
        /// </summary>
        /// <param name="strVal">컨트롤 값(TextBox.Text/DropDownList.SelectedValue)</param>
        /// <returns></returns>
        /// Author         : moondae@payletter.com, 2007-07-09
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public static string GetValue(string strVal)
        {
            if (strVal == null)
            {
                return null;
            }
            else
            {
                return RequestParam(strVal).Equals("") ? null : RequestParam(strVal);
            }
        }

        public static string RequestParam(string strRev)
        {
            strRev = strRev.Replace("'", "");
            strRev = strRev.Replace("\"", "");
            //strRev = strRev.Replace(")", "");  minus by jjung
            strRev = strRev.Replace("#", "");
            strRev = strRev.Replace("||", "");
            strRev = strRev.Replace("+", "");
            strRev = strRev.Replace(">", "");

            return strRev;
        }

        public static DateTime GetDateTime(string strVal)
        {
            DateTime dt = DateTime.Now;

            return dt;
        }

        public static string ConvertCash(object money)
        {
            string currency_money;
            double cmoney;

            cmoney = Convert.ToDouble(money);

            currency_money = string.Format("{0:n2}", cmoney);

            return currency_money;
        }
        
        public static string GetString(string strVal)
        {
            return Convert.ToString(GetValue(strVal));
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 리스트 페이지의 반환된 데이터 갯수 정보를 출력한다.
        /// </summary>
        /// <param name="lintRecordCnt"></param>
        /// <param name="lintCurrPage"></param>
        /// <param name="lintPageCnt"></param>
        /// <param name="lintMode"></param>
        /// <returns></returns>
        /// Author         : moondae@payletter.com, 2007-07-03
        /// Modify History : nopine@payletter.com, 2008-05-16
        ///----------------------------------------------------------------------
        public static string GetPageInfo(int lintRecordCnt, int lintCurrPage, int lintPageCnt, int lintMode)
        {
            StringBuilder sb = new StringBuilder();

            if (lintRecordCnt == 0)
            {
                lintCurrPage = 0;
            }

            sb.Append("\n<table width='100%' border='0' cellspacing='0' cellpadding='0'>");
            sb.Append("\n<tr height='25'>");

            if (lintMode == 1)
            {
                sb.Append("\n<td align='left'><b>Tip.</b><font color='blue'><BLINK>취소된 거래는 <font color='red'><s>strike</s></font> 처리되어 보여집니다.</font></BLINK></font>");
            }

            sb.Append("\n<td  align='right'><img src='/images/blt_01.gif' />  Total Record : <font color='#006699'>");
            sb.Append(lintRecordCnt.ToString("###,##0") + "</font>&nbsp;");
            sb.Append("\n<img src='/images/blt_01.gif' />  Page : <font color='#006699'>" + lintCurrPage.ToString("###,##0") + "</font>");
            sb.Append("\n / " + lintPageCnt.ToString("###,##0") + "</td></tr>");
            sb.Append("\n</table>");

            return sb.ToString();
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 페이지 네비게이션을 출력한다.
        /// </summary>
        /// <param name="lintCurrPage"></param>
        /// <param name="lintPageCnt"></param>
        /// <returns></returns>
        /// Author         : inchonjin@payletter.com, 2009-09-22
        /// Modify History : Jhwjang@payletter.com, 2018-03-21, lintVerNo 추가 1:golfzon paging css 무, 2:golfzon paging css 유
        ///----------------------------------------------------------------------
        public static string GetPageNavi(int lintCurrPage, int lintPageCnt, int lintVerNo)
        {
            StringBuilder sb = new StringBuilder();

            int lintCurrStartPage;          //Current Page
            int lintPrevStartPage;          //Previous Page
            int lintNextStartPage;          //Next Page

            string pl_strPageNavi = string.Empty;


            if (lintCurrPage <= 0)
            {
                return pl_strPageNavi;
            }

            if (lintPageCnt <= 0)
            {
                return pl_strPageNavi;
            }

            if (lintPageCnt > 0)
            {
                lintCurrStartPage = (int)Math.Floor((lintCurrPage - 1) / (double)UserGlobal.BOQ_DEFAULT_PAGENAVSIZE) * UserGlobal.BOQ_DEFAULT_PAGENAVSIZE + 1;
                lintPrevStartPage = lintCurrStartPage - UserGlobal.BOQ_DEFAULT_PAGENAVSIZE;
                lintNextStartPage = lintCurrStartPage + UserGlobal.BOQ_DEFAULT_PAGENAVSIZE;
                
               
                switch(lintVerNo)
                {
                    case 1:
                        if (1 <= lintPrevStartPage)
                        {
                            sb.Append("\n<a class='prev_pageGroup' href=javascript:fnGoPage('1');><img alt='이전' src='https://o.gzcdn.net/images/v3/com/btn_prev.gif' width='41' height='23'></a>");
                        }

                        while (lintCurrStartPage < lintNextStartPage && lintCurrStartPage <= lintPageCnt)
                        {
                            if (lintCurrPage == lintCurrStartPage)
                            {
                                sb.Append("\n <a class='ui-state-active' href=javascript:fnGoPage('");
                                sb.Append(lintCurrStartPage);
                                sb.Append("');>");
                                sb.Append(lintCurrStartPage);
                                sb.Append("</a> ");
                            }
                            else
                            {
                                sb.Append("\n <a class='ui-state-default' href=javascript:fnGoPage('");
                                sb.Append(lintCurrStartPage);
                                sb.Append("'); >");
                                sb.Append(lintCurrStartPage);
                                sb.Append("</a> ");
                            }
                            lintCurrStartPage++;
                        }

                        if (lintNextStartPage <= lintPageCnt)
                        {
                            sb.Append("\n<a class='next_pageGroup' href=javascript:fnGoPage('");
                            if ((lintCurrPage + UserGlobal.BOQ_DEFAULT_PAGENAVSIZE) <= lintPageCnt)
                            {
                                sb.Append(lintCurrPage + UserGlobal.BOQ_DEFAULT_PAGENAVSIZE);
                            }
                            else
                            {
                                sb.Append(lintPageCnt);
                            }
                            sb.Append("');><img alt='다음' src='https://o.gzcdn.net/images/v3/com/btn_next.gif' width='41' height='23'/> </a>");
                        }
                        break;
                    case 2:

                        sb.Append("\n<a class='btn_prev' href=javascript:fnMovePage('1');>&lt;</a>");

                        while (lintCurrStartPage < lintNextStartPage && lintCurrStartPage <= lintPageCnt)
                        {
                            if (lintCurrPage == lintCurrStartPage)
                            {
                                sb.Append("\n <a class='on' href=javascript:fnMovePage('");
                                sb.Append(lintCurrStartPage);
                                sb.Append("');>");
                                sb.Append(lintCurrStartPage);
                                sb.Append("</a> ");
                            }
                            else
                            {
                                sb.Append("\n <a class='' href=javascript:fnMovePage('");
                                sb.Append(lintCurrStartPage);
                                sb.Append("');>");
                                sb.Append(lintCurrStartPage);
                                sb.Append("</a> ");
                            }
                            lintCurrStartPage++;
                        }

                        //if (lintNextStartPage <= lintPageCnt)
                        //{
                            sb.Append("\n <a class='btn_prev' href=javascript:fnMovePage('");
                            if ((lintCurrPage + UserGlobal.BOQ_DEFAULT_PAGENAVSIZE) <= lintPageCnt)
                            {
                                sb.Append(lintCurrPage + UserGlobal.BOQ_DEFAULT_PAGENAVSIZE);
                            }
                            else
                            {
                                sb.Append(lintPageCnt);
                            }
                            sb.Append("');>&gt;</a>");
                        //}
                        break;

                    default:
                        break;
                }
                
            }

            return sb.ToString();
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 페이지 네비게이션을 출력한다.
        /// </summary>
        /// <param name="lintCurrPage">현재 페이지</param>
        /// <param name="lintPageCnt">총 페이지 수</param>
        /// <returns></returns>
        /// Author         : shshin@payletter.com, 2017-08-18
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public static string GetPageNaviV2(int lintCurrPage, int lintPageCnt)
        {
            StringBuilder sb = new StringBuilder();
            string pl_strPageNavi = string.Empty;

            if (lintCurrPage <= 0)
            {
                return pl_strPageNavi;
            }

            if (lintPageCnt <= 0)
            {
                return pl_strPageNavi;
            }

            if (lintCurrPage > 1)
            {
                sb.Append("\n<a class='prev_pageGroup' href=javascript:fnGoPage('");
                sb.Append(lintCurrPage - 1);
                sb.Append("');><img alt='이전' src='https://o.gzcdn.net/images/v3/com/btn_prev.gif' width='41' height='23'></a>");
            }

            if (lintCurrPage < lintPageCnt)
            {
                sb.Append("\n<a class='prev_pageGroup' href=javascript:fnGoPage('");
                sb.Append(lintCurrPage + 1);
                sb.Append("');><img alt='다음' src='https://o.gzcdn.net/images/v3/com/btn_next.gif' width='41' height='23'/> </a>");
            }

            return sb.ToString();
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 에레 메세지를 보여주고 작업을 종료한다.
        /// </summary>
        /// <param name="p">this</param>
        /// <param name="intRetVal">에러코드</param>
        /// <param name="strErrMsg">에러메세지</param>
        /// <returns></returns>
        /// Author         : moondae@payletter.com, 2007-07-19
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public static void SystemErrorAlert(Page p, int intRetVal, string strErrMsg)
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("<script type=\"text/javascript\">");
            sb.Append("alert(\"System Error.(" + intRetVal.ToString() + "," + strErrMsg + ")\");");
            sb.Append("\nif (opener) self.close();");  // release by jjung            
            //sb.Append("history.go(-1);"); minus by jjung
            sb.Append("</script>");

            p.ClientScript.RegisterClientScriptBlock(p.GetType(), "SystemErrorAlert", sb.ToString());
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// HTTP 프로토콜 타입을 확인한다.
        /// </summary>
        /// Author         : moondae@payletter.com, 2007-07-03
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public static string GetProtocolStr(Page p)
        {
            string strVal;
            string strRetVal;

            strVal = p.Request.ServerVariables.Get("HTTPS");
            if (strVal == "off" || strVal == null || strVal.Equals(""))
            {
                strRetVal = "http";
            }
            else
            {
                strRetVal = "https";
            }

            return strRetVal;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Admin ID 의 Grade Name 리턴
        /// </summary>
        /// <param name="GradeNo">string Grade</param>
        /// <returns>string Grade Name</returns>
        /// Author         : roya@payletter.com, 2007-10-26
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public static string GetGradeName(string GradeNo)
        {
            string retVal = null;

            switch (GradeNo)
            {
                case ("1"):
                    retVal = "Super User";
                    break;

                case ("4"):
                    retVal = "Content Provider";
                    break;

                case ("6"):
                    retVal = "Super User X";
                    break;
                default:
                    break;
            }
            return retVal;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 입력받은 문자열이 숫자형식 인지 검사.
        /// </summary>
        /// <param name="number">검사할 Number 문자열</param>
        /// Author         : roya@payletter.com, 2007-10-26
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public static bool isNumeric(string number)
        {
            string strRegEx = @"[0-9]+$";
            RegexStringValidator regex = new RegexStringValidator(strRegEx);

            try
            {
                regex.Validate(number);
                return true;
            }
            catch
            {
                return false;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 결과 처리후 Alert 메세지를 뿌려준다.         
        /// </summary>
        /// Author         : roya@payletter.com,2008-11-26
        /// Modify History : Just Created.
        ///---------------------------------------------------------------------- 
        public static void DisplayResult4AJAX(Page p, int intRetVal, object strErrMsg)
        {
            strErrMsg = Convert.ToString(strErrMsg);
            if (intRetVal == 0)
                strErrMsg = "Working succeeded!";
            else
                strErrMsg = "Working failed.(" + intRetVal.ToString() + " , " + strErrMsg + ")";

            ScriptManager.RegisterStartupScript(p, p.GetType(), "s1", "ShowAlertMessage(\"" + strErrMsg + "\");", true);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 결과 처리후 Alert 메세지를 뿌려준다.(창 닫음 )      
        /// </summary>
        /// Author         : roya@payletter.com,2008-11-26
        /// Modify History : Just Created.
        ///---------------------------------------------------------------------- 
        public static void DisplayResult4AJAX(Page p, int intRetVal, string strErrMsg, bool closeWin)
        {

            if (intRetVal == 0)
                strErrMsg = "Working succeeded!";
            else
                strErrMsg = "Working failed.(" + intRetVal.ToString() + " , " + strErrMsg + ")";


            if (closeWin == true)
                ScriptManager.RegisterStartupScript(p, p.GetType(), "ShowAlertMessage2", "ShowAlertMessage2(\"" + strErrMsg + "\");", true);
            else
                ScriptManager.RegisterStartupScript(p, p.GetType(), "s1", "ShowAlertMessage(\"" + strErrMsg + "\");", true);

        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 팝업창에서 결과 처리후 Alert 메세지를 뿌려준다. ( 페이지 리로드 )
        /// </summary>
        /// Author         : roya@payletter.com, 2007-10-26
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------        
        public static void DisplayWorkResult(Page p, int intRetVal, string strErrMsg)
        {
            StringBuilder sb = new StringBuilder();

            string strRetMsg;

            if (intRetVal == 0)

                strRetMsg = "작업이 성공하였습니다.";
            else
                strRetMsg = "작업이 실패하였습니다.(" + intRetVal.ToString() + " , " + strErrMsg + ")";

            sb.Append("\n   <script type=\"text/javascript\">");
            sb.Append("\n       ShowAlertMessage(\"" + strRetMsg + "\");");
            sb.Append("\n");
            sb.Append("\n       var control_name;");
            sb.Append("\n       var control_id;");
            sb.Append("\n       if( opener )");
            sb.Append("\n       {");
            sb.Append("\n           if( opener.__postBackControlObjID != null ) {");
            sb.Append("\n               control_id = opener.document.getElementById( opener.__postBackControlObjID );");
            sb.Append("\n               control_name = control_id.name");
            sb.Append("\n               opener.__doPostBack(control_name,'');");
            sb.Append("\n           }");
            sb.Append("\n           else {");
            sb.Append("\n               opener.location.reload();");
            sb.Append("\n           }");

            sb.Append("\n           self.close();");
            sb.Append("\n       }");
            sb.Append("\n       else");
            sb.Append("\n       {");
            sb.Append("\n           location.reload();");
            sb.Append("\n       }");
            sb.Append("\n   </script>");

            Literal resultBlock = null;

            resultBlock = (Literal)p.FindControl("DisplayResult");
            resultBlock.Text = sb.ToString();

        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 팝업창에서 결과 처리후 Alert 메세지를 뿌려준다. (부모 페이지 리로드 )     
        /// </summary>
        /// Author         : nopine@payletter.com, 2008-05-26
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------        
        public static void DisplayCancelWorkResult(Page p, int intRetVal, string strErrMsg)
        {
            StringBuilder sb = new StringBuilder();

            string strRetMsg;

            if (intRetVal == 0)
                strRetMsg = "작업이 성공하였습니다.";
            else
                strRetMsg = "작업이 실패하였습니다.(" + intRetVal.ToString() + " , " + strErrMsg + ")";

            sb.Append("\n   <script type=\"text/javascript\">");
            sb.Append("\n       ShowAlertMessage(\"" + strRetMsg + "\");");
            sb.Append("\n");
            sb.Append("\n       var control_name;");
            sb.Append("\n       var control_id;");
            sb.Append("\n       if( opener )");
            sb.Append("\n       {");
            sb.Append("\n           if( opener.__postBackControlObjID != null ) {");
            sb.Append("\n               control_id = document.getElementById(__postBackControlObjID);");
            sb.Append("\n               control_name = control_id.name");
            sb.Append("\n               opener.__doPostBack(control_name,'');");
            sb.Append("\n           }");
            sb.Append("\n           else {");
            sb.Append("\n               opener.location.reload();");
            sb.Append("\n           }");

            sb.Append("\n           self.close();");
            sb.Append("\n       }");
            sb.Append("\n       else");
            sb.Append("\n       {");
            sb.Append("\n           location.reload();");
            sb.Append("\n       }");
            sb.Append("\n   </script>");

            Literal resultBlock = null;

            resultBlock = (Literal)p.FindControl("DisplayResult");
            resultBlock.Text = sb.ToString();

        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 팝업창에서 결과 처리후 Alert 메세지를 뿌려준다.( 페이지 리로드 없슴 )
        /// </summary>
        ///----------------------------------------------------------------------  
        public static void DisplayWorkResult(Page p, int intRetVal, string strErrMsg, bool reload)
        {

            StringBuilder sb = new StringBuilder();

            string strRetMsg;
            string url;

            url = p.Request.ServerVariables.Get("SCRIPT_NAME");
            url += "?" + p.Request.ServerVariables.Get("QUERY_STRING");

            if (intRetVal == 0)
                strRetMsg = "working succeeded.";
            else
                strRetMsg = "working failed.(" + intRetVal.ToString() + " , " + strErrMsg + ")";

            sb.Append("\n   <script type=\"text/javascript\">");
            sb.Append("\n       ShowAlertMessage(\"" + strRetMsg + "\");");

            if (reload == true)
            {
                sb.Append("\n   location.href='" + url + "';");
            }

            sb.Append("\n   </script>");

            Literal resultBlock = null;

            resultBlock = (Literal)p.FindControl("DisplayResult");
            resultBlock.Text = sb.ToString();
        }

        public static void DisplayWorkResult(Page p, int intRetVal, string strErrMsg, bool reload, string linkName)
        {
            if (reload == false)
            {
                linkName = linkName.Replace('_', '$');
                StringBuilder sb = new StringBuilder();

                string strRetMsg;
                string url;

                url = p.Request.ServerVariables.Get("SCRIPT_NAME");
                url += "?" + p.Request.ServerVariables.Get("QUERY_STRING");

                if (intRetVal == 0)
                    strRetMsg = "working succeeded.";
                else
                    strRetMsg = "working failed.(" + intRetVal.ToString() + " , " + strErrMsg + ")";

                sb.Append("\n   <script type=\"text/javascript\">");
                sb.Append("\n       ShowAlertMessage(\"" + strRetMsg + "\");");

                sb.Append("\n       __doPostBack('" + linkName + "','');");

                sb.Append("\n   </script>");

                Literal resultBlock = null;

                resultBlock = (Literal)p.FindControl("DisplayResult");
                resultBlock.Text = sb.ToString();

            }
        }

        public static void DebuggingString(Page p, object str)
        {
            Literal resultBlock = null;

            resultBlock = (Literal)p.Master.FindControl("DisplayResult");
            resultBlock.Text = str.ToString();
        }

        /// <summary>
        ///  Decrypt
        /// </summary>
        /// <returns></returns>
        public static string GetDecryptStr(string strEncString)
        {
            string            strDecString = string.Empty;
            BOQV5BILLLib.Bill pl_objBOQV5  = null;

            try
            {
                pl_objBOQV5          = new BOQV5BILLLib.Bill();    //create instance billing component
                pl_objBOQV5.SiteCode = DEFAULT_SITE_ENC_KEY;
                strDecString         = pl_objBOQV5.Decrypt(strEncString);
            }
            catch
            {
                strDecString = string.Empty;
            }
            finally
            {
                if (pl_objBOQV5 != null)
                {
                    pl_objBOQV5.UnInitialize();
                    pl_objBOQV5 = null;
                }
            }

            return strDecString;
        }

        /// <summary>
        ///  Encrypt
        /// </summary>
        /// <returns></returns>
        public static string GetEncryptStr(string strDecString)
        {
            string            strEncString = string.Empty;
            BOQV5BILLLib.Bill pl_objBOQV5  = null;

            try
            {
                pl_objBOQV5          = new BOQV5BILLLib.Bill();
                pl_objBOQV5.SiteCode = UserGlobal.DEFAULT_SITE_ENC_KEY;
                strEncString         = pl_objBOQV5.Encrypt(strDecString);
            }
            catch
            {
                strEncString = string.Empty;
            }
            finally
            {
                if (pl_objBOQV5 != null)
                {
                    pl_objBOQV5.UnInitialize();
                    pl_objBOQV5 = null;
                }
            }

            return strEncString;
        }

        /// <summary>
        ///  Decrypt
        /// </summary>
        /// <returns></returns>
        public static string GetFieldVal(string lstrEncString, string lstrkey)
        {
            string            strDecString = string.Empty;
            BOQV5BILLLib.Bill pl_objBOQV5  = null;

            try
            {
                pl_objBOQV5          = new BOQV5BILLLib.Bill();
                pl_objBOQV5.SiteCode = UserGlobal.DEFAULT_SITE_ENC_KEY;
                pl_objBOQV5.CodePage = 65001;
                strDecString         = pl_objBOQV5.GetFieldVal(lstrEncString, lstrkey);
            }
            catch
            {
                strDecString = string.Empty;
            }
            finally
            {
                if (pl_objBOQV5 != null)
                {
                    pl_objBOQV5.UnInitialize();
                    pl_objBOQV5 = null;
                }
            }

            return strDecString;
        }
        
        ///----------------------------------------------------------------------
        /// <summary>
        ///  MD5 Hash 생성
        /// </summary>
        ///----------------------------------------------------------------------
        public static string GetMD5Hash(string strString)
        {
            string            pl_strMD5Hash = string.Empty;
            BOQV5BILLLib.Bill pl_objBOQV5   = null;

            try
            {
                pl_objBOQV5          = new BOQV5BILLLib.Bill();
                pl_objBOQV5.SiteCode = UserGlobal.DEFAULT_SITE_ENC_KEY;
                pl_objBOQV5.CodePage = 0;
                pl_strMD5Hash        = pl_objBOQV5.GetMD5(strString);
            }
            catch (Exception pl_objEx)
            {
                pl_strMD5Hash = string.Empty;
                UtilLog.WriteExceptionLog(pl_objEx.StackTrace, pl_objEx.Message);
            }
            finally
            {
                if (pl_objBOQV5 != null)
                {
                    pl_objBOQV5.UnInitialize();
                    pl_objBOQV5 = null;
                }
            }

            return pl_strMD5Hash;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// SHA256 Hash 생성
        /// </summary>
        ///----------------------------------------------------------------------
        public static string GetSHA256(string strString)
        {
            int    pl_intloop      = 0;
            string pl_strSHA256    = string.Empty;
            string pl_strTmpString = string.Empty;

            byte[] pl_arrSetBytes    = null;
            byte[] pl_arrOutputBytes = null;

            SHA256Managed pl_objSHA256 = null;

            try
            {
                pl_objSHA256      = new SHA256Managed();                            // SHA256 생성
                pl_arrSetBytes    = Encoding.UTF8.GetBytes(strString);              // 텍스트 Byte 변환
                pl_arrOutputBytes = pl_objSHA256.ComputeHash(pl_arrSetBytes);       // SHA256 해시값 계산

                for (pl_intloop = 0; pl_intloop < pl_arrOutputBytes.Length; pl_intloop++)
                {
                    pl_strTmpString = String.Format("{0}{1:X2}", pl_strTmpString, pl_arrOutputBytes[pl_intloop]);
                }

                pl_strSHA256 = pl_strTmpString;
            }
            catch (Exception pl_objEx)
            {
                pl_strSHA256 = string.Empty;
                UtilLog.WriteExceptionLog(pl_objEx.StackTrace, pl_objEx.Message);
            }
            finally
            {
                pl_arrOutputBytes = null;
                pl_arrSetBytes    = null;

                if (pl_objSHA256 != null)
                {
                    pl_objSHA256.Dispose();
                    pl_objSHA256 = null;
                }
            }

            return pl_strSHA256;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// GetHexEncToByte 생성
        /// </summary>
        ///----------------------------------------------------------------------
        public static byte[] GetHexEncToByte(string strHexEncKey)
        {
            int    pl_intHexEncKeyLen = 0;
            byte[] pl_bytValue        = null;

            try
            {
                if (strHexEncKey == null || strHexEncKey.Length % 2 != 0)
                {
                    return null;
                }

                pl_intHexEncKeyLen = strHexEncKey.Length;
                pl_bytValue        = new byte[pl_intHexEncKeyLen / 2];

                for (int i = 0; i < pl_intHexEncKeyLen; i += 2)
                {
                    pl_bytValue[i / 2] = Convert.ToByte(strHexEncKey.Substring(i, 2), 16);
                }
            }
            catch (Exception pl_objEx)
            {
                pl_bytValue = null;
                UtilLog.WriteExceptionLog(pl_objEx.StackTrace, pl_objEx.Message);
            }

            return pl_bytValue;
        }

        ///---------------------------------------------------------------------
        /// <summary>
        ///  오늘 날짜 반환.
        /// </summary>
        /// <returns></returns>
        ///---------------------------------------------------------------------
        public static void GetBeginDate(TextBox txtbox)
        {
            string today = string.Format("{0:yyyy}{0:MM}{0:dd}", DateTime.Now);
            txtbox.Text = today;
            return;

        }

        ///---------------------------------------------------------------------
        /// <summary>
        ///  오늘 날자의 기간(이전,이후)을 정해서 날자 반환. 
        /// </summary>
        /// <returns></returns>
        ///---------------------------------------------------------------------
        public static void GetBeginDate(TextBox txtbox, double period)
        {
            string today = string.Format("{0:yyyy}{0:MM}{0:dd}", DateTime.Now.AddDays(period));
            txtbox.Text = today;
            return;
        }

        ///---------------------------------------------------------------------
        /// <summary>
        ///  달의 첫 날짜 반환. 
        /// </summary>
        /// <returns></returns>
        ///---------------------------------------------------------------------
        public static void GetBeginMonth(TextBox txtbox)
        {
            txtbox.Text = string.Format("{0:yyyy}{0:MM}01", DateTime.Now);
            return;
        }

        ///---------------------------------------------------------------------
        /// <summary>
        ///  일년 전 날짜 반환. 
        /// </summary>
        /// <returns></returns>
        ///---------------------------------------------------------------------
        public static void GetOneYearsAgo(TextBox txtbox)
        {
            txtbox.Text = string.Format("{0:yyyy}{0:MM}{0:dd}", DateTime.Now.AddYears(-1));
        }

        ///---------------------------------------------------------------------
        /// <summary>
        ///  달 반환. 
        /// </summary>
        /// <returns></returns>
        ///---------------------------------------------------------------------
        public static void GetMonth(DropDownList drlist)
        {
            drlist.SelectedValue = string.Format("{0:MM}", DateTime.Now);
        }

        ///---------------------------------------------------------------------
        /// <summary>
        ///  년도 반환. 
        /// </summary>
        /// <returns></returns>
        ///---------------------------------------------------------------------
        public static void GetYear(DropDownList drlist)
        {
            drlist.SelectedValue = string.Format("{0:yyyy}", DateTime.Now);
        }

        public static void GrvwRowDataBound(GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes.Add("onmouseover", "MouseOver(this)");
                e.Row.Attributes.Add("onmouseout", "MouseOut(this)");
            }
        }

        public static void ChkPostBackDATA()
        {

            foreach (string s in HttpContext.Current.Request.Form)
                HttpContext.Current.Response.Write(s + " : " + HttpContext.Current.Request.Form[s] + "<br/>");
        }

        public static string GetLastMonth(string strYMD)
        {
            string strRetMonth;
            string strYear;
            string strMonth;

            strYear = strYMD.Substring(0, 4);
            strMonth = strYMD.Substring(4, 2);

            if (strMonth.Equals("01"))
            {
                strMonth = "12";
                strYear = Convert.ToString(Convert.ToInt32(strYear) - 1);
            }
            else
            {
                strMonth = Convert.ToString(Convert.ToInt32(strMonth) - 1);
                if (strMonth.Length < 2)
                    strMonth = "0" + strMonth;
            }


            strRetMonth = strYear + strMonth;

            return strRetMonth;

        }

        ///----------------------------------------------------------------------
        /// HTML Code Encode 기능
        /// Author         : filemk@payletter.com, 2008-10-21
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        #region HTML Encode SQL Injection
        /// <summary>
        /// HTML Encode
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static string SQLEncode(string str)
        {
            //str = str.Replace("&lt;P&gt;", "");
            //str = str.Replace("&lt;/P&gt;", "chr(13)");
            //str = str.Replace("&amp;nbsp;", " ");
            //str = str.Replace("<br>", "chr(13)");
            //str = str.Replace("'", "''");
            //str = str.Replace("&", "&amp;");
            str = str.Replace("<", "&lt;");
            str = str.Replace(">", "&gt;");
            str = str.Replace("\"", "&quot;");
            str = str.Replace("'", "&apos;");
            //str = str.Replace("&#34;", "chr(34)");

            return str;
        }

        /// <summary>
        /// HTML Decode
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static string SQLDecode(string str)
        {
            //str = str.Replace("", "&lt;P&gt;");
            //str = str.Replace("chr(13)", "&lt;/P&gt;");
            //str = str.Replace(" ", "&amp;nbsp;");
            //str = str.Replace("chr(13)", "<br>");
            //str = str.Replace("''", "'");
            //str = str.Replace("&amp;", "&");
            str = str.Replace("&lt;", "<");
            str = str.Replace("&gt;", ">");
            str = str.Replace("&quot;", "\"");
            str = str.Replace("&apos;", "'");
            //str = str.Replace("chr(34)", "&#34;");

            return str;
        }
        #endregion

        ///----------------------------------------------------------------------
        /// FileUpload 기능
        /// Author         : filemk@payletter.com, 2008-10-21
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        #region FileUpload
        /// <summary>
        /// 파일 업로드에 대한 Error Code
        /// </summary>
        /// <param name="strType"></param>
        /// <returns></returns>
        public static string GetFileUploadErrorType(string strType)
        {
            string retValue;

            switch (strType)
            {
                case "0":
                    retValue = "첨부된 파일이 없습니다.";
                    break;
                case "1":
                    retValue = "지정된 MIMEType이 아닙니다.";
                    break;
                case "2":
                    retValue = "지정된 File Size보다 큽니다.";
                    break;
                default:
                    retValue = strType;
                    break;
            }

            return retValue;
        }

        /// <summary>
        /// MIMETypeCheck
        /// </summary>
        /// <param name="strMIMEType"></param>
        /// <param name="intMIMEType"></param>
        /// <returns></returns>
        public static bool GetMIMEType(string strMIMEType, int intMIMEType)
        {
            bool bResult = true;

            switch (intMIMEType)
            {
                //intMIMEType => 0 이미지(jpeg, gif, pjpeg)
                case 0:
                    if (strMIMEType != "images/jpeg" && strMIMEType != "images/gif" && strMIMEType != "images/pjpeg")
                    {
                        bResult = false;
                    }

                    break;
                //intMIMEType => 1 엑셀(xls)
                case 1:
                    if (strMIMEType != "application/vnd.ms-excel")
                    {
                        bResult = false;
                    }
                    break;
                default:
                    bResult = false;
                    break;
            }

            return bResult;
        }

        /// <summary>
        /// 파일 업로드
        /// </summary>
        /// <param name="fl">FileUpload WebForm Control</param>
        /// <param name="strPath">파일경로</param>
        /// <param name="strFileName">파일명</param>
        /// <param name="intMIMEType">파일 MIMEType</param>
        /// <param name="intFileByte">파일 제한 사이즈</param>
        /// <returns></returns>
        public static string GetFileUpload(FileUpload fl, string strPath, string strFileName, int intMIMEType, int intFileByte)
        {
            string retValue;

            //File첨부 여부 Check
            if (fl.HasFile == true)
            {
                //파일 확장자명을 구한다.
                string strFileExtension = System.IO.Path.GetExtension(fl.FileName).ToLower();
                strFileName += strFileExtension;

                //MIMEType를 가져온다.
                string strMIMEType = fl.PostedFile.ContentType;

                //MIMEType를 Check한다.
                if (GetMIMEType(strMIMEType, intMIMEType) == true)
                {
                    //파일크기를 Check한다.
                    if (fl.PostedFile.ContentLength > intFileByte)
                    {
                        retValue = "2";  //FileSize 에러
                    }
                    else
                    {
                        retValue = strFileName;

                        strPath += strFileName;

                        fl.SaveAs(strPath);
                    }
                }
                else
                {
                    retValue = "1";      //MIMEType 에러
                }
            }
            else
            {
                retValue = "0";          //첨부파일이 없다
            }

            return retValue;
        }

        /// <summary>
        /// 파일 업로드 수정
        /// </summary>
        /// <param name="fl">FileUpload WebForm Control</param>
        /// <param name="strPath">파일경로</param>
        /// <param name="strFileName">파일명</param>
        /// <param name="strOldFileName">수정파일명</param>
        /// <param name="intMIMEType">파일 MIMEType</param>
        /// <param name="intFileByte">파일 제한 사이즈</param>
        /// <returns></returns>
        public static string GetFileUpload(FileUpload fl, string strPath, string strFileName, string strOldFileName, int intMIMEType, int intFileByte)
        {
            string retValue;

            //File첨부 여부 Check
            if (fl.HasFile == true)
            {
                //파일 확장자명을 구한다.
                string strFileExtension = System.IO.Path.GetExtension(fl.FileName).ToLower();
                strFileName += strFileExtension;

                //MIMEType를 가져온다.
                string strMIMEType = fl.PostedFile.ContentType;

                //MIMEType를 Check한다.
                if (GetMIMEType(strMIMEType, intMIMEType) == true)
                {
                    //파일크기를 Check한다.
                    if (fl.PostedFile.ContentLength > intFileByte)
                    {
                        retValue = "2";  //FileSize 에러
                    }
                    else
                    {
                        //기존 파일을 삭제한다.
                        string strOldFile = strPath + strOldFileName;

                        FileInfo file_Old = new FileInfo(strOldFile);

                        if (file_Old.Exists)
                        {
                            file_Old.Delete();
                        }

                        retValue = strFileName;

                        strPath += strFileName;

                        fl.SaveAs(strPath);
                    }
                }
                else
                {
                    retValue = "1";      //MIMEType 에러
                }
            }
            else
            {
                retValue = "0";          //첨부파일이 없다
            }

            return retValue;
        }

        /// <summary>
        /// 파일 삭제로직
        /// return => 0:성공, 1:실패 및 파일없음
        /// </summary>
        /// <param name="strPath"></param>
        /// <param name="strFileName"></param>
        /// <returns></returns>
        public static string GetFileDelete(string strPath, string strFileName)
        {
            string retValue;

            string strDeleteFile = strPath + strFileName;

            FileInfo file_Del = new FileInfo(strDeleteFile);

            //파일이 존재할 때 삭제한다.
            if (file_Del.Exists)
            {
                file_Del.Delete();

                retValue = "0";
            }
            else
            {
                retValue = "1";
            }

            return retValue;
        }

        #endregion

        ///----------------------------------------------------------------------
        /// <summary>
        /// CallWebRequest
        /// </summary>
        ///----------------------------------------------------------------------
        public static int CallWebRequest(string strRequest, string strURL, out string strResponse, out string strErrMsg, string strMethod = WebRequestMethods.Http.Post)
        {
            return CallWebRequest(strRequest, strURL, "", "", "", out strResponse, out strErrMsg, strMethod);
        }
        public static int CallWebRequest(string strRequest, string strURL, string strReqType, out string strResponse, out string strErrMsg, string strMethod = WebRequestMethods.Http.Post)
        {
            return CallWebRequest(strRequest, strURL, strReqType, "", "", out strResponse, out strErrMsg, strMethod);
        }
        public static int CallWebRequest(string strRequest, string strURL, string strReqType, string strHeaderKey, string strHeaderVal, out string strResponse, out string strErrMsg, string strMethod = WebRequestMethods.Http.Post)
        {
            int    pl_intRetVal  = 0;
            byte[] pl_arrRequest = null;

            HttpWebRequest  pl_objRequest       = null;
            HttpWebResponse pl_objResponse      = null;
            Stream          pl_objRequestStream = null;
            StreamReader    pl_objStreamReader  = null;

            strResponse = string.Empty;
            strErrMsg   = "OK";

            try
            {
                //로깅
                UtilLog.WriteLog("CallWebService", 0, "[request]\nstrURL : " + strURL + "\nstrRequest : " + strRequest);

                if(WebRequestMethods.Http.Get.Equals(strMethod.ToUpper()))
                {
                    pl_objRequest        = (HttpWebRequest)HttpWebRequest.Create(string.Format("{0}{1}", strURL, strRequest));
                    pl_objRequest.Method = WebRequestMethods.Http.Get;
                    //Header 설정
                    if (!string.IsNullOrEmpty(strHeaderKey))
                    {
                        pl_objRequest.Headers.Add(strHeaderKey, strHeaderVal);
                    }
                }
                else
                {
                    pl_objRequest               = (HttpWebRequest)HttpWebRequest.Create(strURL);
                    pl_arrRequest               = Encoding.UTF8.GetBytes(strRequest);
                    pl_objRequest.KeepAlive     = false;
                    pl_objRequest.Method        = WebRequestMethods.Http.Post;
                    pl_objRequest.ContentLength = pl_arrRequest.Length;
                    pl_objRequest.ContentType   = strReqType.ToUpper().Equals("JSON") ? "application/json" : "application/x-www-form-urlencoded";
                    pl_objRequest.ServicePoint.Expect100Continue = false;

                    // 골프존 API의 DEV/QA 서버 인증서 처리
                    if(SERVER_TYPE.Equals("LOCAL") || SERVER_TYPE.Equals("PAY") || SERVER_TYPE.Equals("DEV") || SERVER_TYPE.Equals("QA"))
                    {
                        ServicePointManager.ServerCertificateValidationCallback =
                        delegate(Object obj, X509Certificate certificate, X509Chain chain, SslPolicyErrors errors)
                        {
                            return true;
                        };
                    }

                    //Header 설정
                    if (!string.IsNullOrEmpty(strHeaderKey))
                    {
                        pl_objRequest.Headers.Add(strHeaderKey, strHeaderVal);
                    }

                    pl_objRequestStream = pl_objRequest.GetRequestStream();
                    pl_objRequestStream.Write(pl_arrRequest, 0, pl_arrRequest.Length);
                }

                pl_objRequest.Timeout = 60000;

                pl_objResponse = (HttpWebResponse)pl_objRequest.GetResponse();
                if (pl_objResponse.StatusCode != HttpStatusCode.OK)
                {
                    pl_intRetVal = 2109;
                    strErrMsg    = string.Format("CallWebRequest failed. Received HTTP {0}", pl_objResponse.StatusCode);
                    return pl_intRetVal;
                }

                pl_objStreamReader = new StreamReader(pl_objResponse.GetResponseStream());
                strResponse        = pl_objStreamReader.ReadToEnd();

                //로깅
                UtilLog.WriteLog("CallWebService", 0, "[response]\nstrResponse : " + strResponse);
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -21005;
                strErrMsg    = "Fail to WebRequest";
                strResponse  = string.Empty;
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                pl_arrRequest       = null;
                pl_objRequest       = null;
                pl_objResponse      = null;
                pl_objRequestStream = null;
                pl_objStreamReader  = null;
            }

            return pl_intRetVal;
        }

        ///--------------------------------------------------------------------------------------------
        /// Function Name  : GetClientIP
        /// Description    : REMOTE_ADDR 또는 HTTP_X_FORWARDED_FOR 응답 헤더 값을 조회하는 공용 메서드
        /// </summary>
        /// Author         : bae1222@payletter.com, 2015-03-05
        /// Modify History : Just Created.
        ///--------------------------------------------------------------------------------------------
        public static string GetClientIP()
        {
            string strIPAddr = string.Empty;

            try
            { 
                strIPAddr = HttpContext.Current.Request.ServerVariables.Get("HTTP_X_FORWARDED_FOR");
                if (string.IsNullOrEmpty(strIPAddr))
                {
                    strIPAddr = HttpContext.Current.Request.ServerVariables.Get("REMOTE_ADDR");
                }        
            }
            catch
            {
                strIPAddr = "";
            }

            return strIPAddr;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 연결자 objList[0]^objList[1]^objList[2].. 반환
        /// </summary>
        /// <param name="objList"></param>
        /// <returns></returns>
        ///----------------------------------------------------------------------
        public static string GetConcatList(IEnumerable objList)
        {
            string strResult = string.Empty;
            int    pl_intCnt = 0;

            foreach(string strValue in objList)
            {
                if (pl_intCnt.Equals(0))
                {
                    strResult += strValue;
                }
                else
                {
                    strResult += UserGlobal.BOQ_DELIMITER_TYPE1 + strValue;
                }
                pl_intCnt++;
            }

            return strResult;
        }
        
        ///----------------------------------------------------------------------
        /// <summary>
        /// QueryToDic  : Request URL의 데이터를 읽어서 nabmevalue로 리턴한다.
        /// </summary>
        /// Author         : mskim@payletter.com, 2014-06-02
        /// Modify History : Just Created.
        ///----------------------------------------------------------------------
        public static NameValueCollection QueryToDic(string queryString)
        {
            NameValueCollection obj = new NameValueCollection();
            try
            {
                if (string.IsNullOrEmpty(queryString))
                {
                    return obj;
                }
                string[] querySegments = queryString.Split('&');
                foreach (string segment in querySegments)
                {
                    string[] parts = segment.Split('=');
                    if (parts.Length > 0)
                    {
                        string key = parts[0].Trim(new char[] { '?', ' ' });
                        string val = parts[1].Trim();
                        obj.Add(key, val);
                    }
                }
            }
            catch (Exception pl_objEx)
            {
                UtilLog.WriteExceptionLog(pl_objEx.StackTrace, pl_objEx.Message);
            }

            return obj;
        }
        
        ///--------------------------------------------------------------------------------------------
        /// <summary>
        /// 현재 접속기기가 모바일앱인지 확인한다
        /// </summary>
        ///--------------------------------------------------------------------------------------------
        public static bool IsMobileApp()
        {
            Regex  regex        = new Regex(@"com.golfzon.ios|com.golfzon.android");
            string strUserAgent = HttpContext.Current.Request.UserAgent;

            if (regex.IsMatch(strUserAgent))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 객체를 Serialize하게 변경 (변수명1=변수1&변수명2=변수2...)
        /// </summary>
        ///----------------------------------------------------------------------
        public static string GetSerializeString<T>(T objReq)
        {
            string strResult = string.Empty;
            int    pl_intCNT = 0;

            foreach(var prop in typeof(T).GetProperties())
            {
                if (pl_intCNT.Equals(0))
                {
                    strResult = prop.Name + "=" + prop.GetValue(objReq, null);
                }
                else
                {
                    strResult += "&" + prop.Name + "=" + prop.GetValue(objReq, null);
                }
                pl_intCNT++;
            }
            return strResult;
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 메일 발송 여부 확인
        /// </summary>
        ///----------------------------------------------------------------------
        public static bool GetSendErrorMailFlag(int intErrCode)
        {
            int    pl_intNotSendErrMailList = 0;

            try
            {
                for (int pl_intIndex = 0; pl_intIndex < BOQ_NOTSENDERRMAIL_LIST.Length; pl_intIndex++)
                {
                    int.TryParse(BOQ_NOTSENDERRMAIL_LIST[pl_intIndex], out pl_intNotSendErrMailList);
                    if (intErrCode.Equals(pl_intNotSendErrMailList))
                    {
                        return false;
                    }
                }
            }
            catch (Exception pl_objEx)
            {
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace, false);
            }

            return true;
        }

        //-------------------------------------------------------------
        /// Name          : SetCookie()
        /// Description   : 쿠키 생성
        //-------------------------------------------------------------
        public static void SetCookie(string strCookieName, string strValue, int intDay = 1)
        {
            string     pl_strCookieDomain = string.Empty;
            HttpCookie pl_objCookie       = null;

            try
            {
                pl_strCookieDomain = HttpContext.Current.Request.ServerVariables.Get("SERVER_NAME");

                //쿠키 여부 체크
                if (HttpContext.Current.Request.Cookies[strCookieName] != null)
                {
                    //쿠키 삭제
                    RemoveCookie(strCookieName);
                }

                //쿠키 생성
                pl_objCookie = new HttpCookie(strCookieName);
                pl_objCookie.Domain  = pl_strCookieDomain;
                pl_objCookie.Value   = strValue;
                pl_objCookie.Expires = DateTime.Now.AddDays(intDay);
                HttpContext.Current.Response.Cookies.Add(pl_objCookie);
            }
            catch (Exception pl_objEx)
            {
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                pl_objCookie = null;
            }

            return;
        }
    
        //-------------------------------------------------------------
        /// Name          : RemoveCookie()
        /// Description   : 쿠키 삭제
        //-------------------------------------------------------------
        public static void RemoveCookie(string strCookieName)
        {
            string     pl_strCookieDomain = string.Empty;
            HttpCookie pl_objCookie       = null;

            try
            {
                pl_strCookieDomain = HttpContext.Current.Request.ServerVariables.Get("SERVER_NAME");

                pl_objCookie       = HttpContext.Current.Request.Cookies[strCookieName];
                if (pl_objCookie != null)
                {
                    //쿠키 삭제
                    pl_objCookie.Domain  = pl_strCookieDomain;
                    pl_objCookie.Value   = null;
                    pl_objCookie.Expires = DateTime.Now.AddDays(-1);
                    HttpContext.Current.Response.Cookies.Add(pl_objCookie);
                }
            }
            catch (Exception pl_objEx)
            {
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                pl_objCookie = null;
            }
        }
    
        //-------------------------------------------------------------
        /// Name          : RenewalCookie()
        /// Description   : 쿠키 갱신
        //-------------------------------------------------------------
        public static void RenewalCookie(string strCookieName)
        {
            string     pl_strCookieDomain = string.Empty;
            HttpCookie pl_objCookie       = null;

            try
            {
                pl_strCookieDomain = HttpContext.Current.Request.ServerVariables.Get("SERVER_NAME");

                pl_objCookie       = HttpContext.Current.Request.Cookies[strCookieName];
                if (pl_objCookie != null)
                {
                    //쿠키 갱신
                    pl_objCookie.Domain  = pl_strCookieDomain;
                    pl_objCookie.Expires = DateTime.Now.AddDays(1);
                    HttpContext.Current.Response.Cookies.Add(pl_objCookie);
                }
            }
            catch (Exception pl_objEx)
            {
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                pl_objCookie = null;
            }
        }
    }


    ///----------------------------------------------------------------------
    /// <summary>
    /// Pos 결제 정보 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class PosLogInfo
    {
        public Int64    intPosOrderNo           { get; set; }
        public Int16    intSiteCode             { get; set; }
        public int      intUserNo               { get; set; }
        public string   strUserID               { get; set; }
        public int      intStaffNo              { get; set; }
        public string   strStaffID              { get; set; }
        public int      intProNo                { get; set; }
        public string   strBrandCode            { get; set; }
        public string   strStoreCode            { get; set; }
        public double   intTotalOriginPrice     { get; set; }
        public double   intTotalDiscountAmt     { get; set; }
        public double   intTotalPurchasePrice   { get; set; }
        public double   intPayProcessAmt        { get; set; }
        public double   intPayRemainAmt         { get; set; }
        public string   strPayYMD               { get; set; }
        public string   strPosRsltCode          { get; set; }
        public string   strPosRsltMsg           { get; set; }
        public Int16    intPosStateCode         { get; set; }
        public Int64    intGChargeNo            { get; set; }
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// PG 결제 정보 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class PGPayLogInfo
    {
        public Int64    intOrderNo              { get; set; }
        public Int64    intPosOrderNo           { get; set; }
        public Int16    intPaySeqNo             { get; set; }
        public Int16    intSiteCode             { get; set; }
        public int      intUserNo               { get; set; }

        public string   strUserID               { get; set; }
        public string   strBrandCode            { get; set; }
        public string   strStoreCode            { get; set; }
        public Int16    intPayToolCode          { get; set; }
        public string   strPGCode               { get; set; }

        public string   strMallID               { get; set; }
        public double   intPayAmt               { get; set; }
        public string   strPayToolName          { get; set; }
        public string   strTID                  { get; set; }
        public string   strCID                  { get; set; }

        public Int16    intInstallment          { get; set; }
        public string   strCashReceiptNo        { get; set; }
        public string   strCardNo               { get; set; }
        public string   strEtcInfo              { get; set; }
        public string   strPayYMD               { get; set; }

        public string   strApprovalDate         { get; set; }
        public string   strPayRsltCode          { get; set; }
        public string   strPayRsltMsg           { get; set; }
        public Int16    intPayStateCode         { get; set; }
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// PG 결제 요청 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class PGPayReqParam
    {
        public Int64    intPosOrderNo           { get; set; }
        public Int64    intOrderNo              { get; set; }
        public string   strDeviceID             { get; set; }
        public Int16    intSiteCode             { get; set; }
        public int      intUserNo               { get; set; }

        public string   strUserID               { get; set; }
        public string   strUserName             { get; set; }
        public string   strBrandCode            { get; set; }
        public string   strStoreCode            { get; set; }
        public string   strProductName          { get; set; }

        public Int16    intPayToolCode          { get; set; }
        public string   strPGCode               { get; set; }
        public double   intPayAmt               { get; set; }
        public string   strPayToolName          { get; set; }
        public Int16    intInstallment          { get; set; }

        public string   strIdInfo               { get; set; }
        public string   strEtcInfo              { get; set; }
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// PG 결제 처리 응답 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class PGPayResParam
    {
        public Int64    intOrderNo              { get; set; }
        public double   intPayAmt               { get; set; }
        public string   strPayToolName          { get; set; }
        public string   strTID                  { get; set; }
        public string   strCID                  { get; set; }
        
        public Int16    intInstallment          { get; set; }
        public string   strCashReceiptNo        { get; set; }
        public string   strCardNo               { get; set; }
        public string   strEtcInfo              { get; set; }
        public string   strApprovalDate         { get; set; }

        public string   strPayRsltCode          { get; set; }
        public string   strPayRsltMsg           { get; set; }
        public Int16    intPayStateCode         { get; set; }
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 환불캐시 정보 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class RefundInfo
    {
        public Int64  intGChargeNo      { get; set; } 
        public int    intRefundFeeRate  { get; set; }
        public Int16  intSiteCode       { get; set; }
        public int    intUserNo         { get; set; }
        public int    intManagerNo      { get; set; }
        public string strManagerID      { get; set; }
        public string strManagerName    { get; set; }
        public string strStoreCode      { get; set; }
    }

    ///----------------------------------------------------------------------
    /// <summary>
    /// 환불 요청 클래스
    /// </summary>
    ///----------------------------------------------------------------------
    public class RefundReqParam
    {
        public Int64  intOrderNo        { get; set; } 
        public Int16  intPayToolCode    { get; set; }
        public string strPGCode         { get; set; }
        public string strTID            { get; set; }
        public int    intPayAmt         { get; set; }
        public int    intReqAmt         { get; set; }   // 환불 요청금액
        public int    intRefundAvailAmt { get; set; }
        public bool   blnPartialFlag    { get; set; }   // 부분취소 여부
        public string strApprovalDate   { get; set; }   // 원 거래 시각
        public string strStoreCode      { get; set; }
    }

}
