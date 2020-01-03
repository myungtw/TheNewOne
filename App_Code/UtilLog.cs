using System;
using System.Collections.Specialized;
using System.Text;
using System.Web;

//================================================================
// FileName        : UtilLog.cs
// Description     : 로그 관련 공용 모듈
// Special Logic   : None
// Copyright       : 2017 by PayLetter Inc. All rights reserved.
// Author          : mskim@payletter.com, 2017-08-01
// Modify History  : Just Created.
//================================================================
namespace bill.payletter.com.CommonModule
{
    ///----------------------------------------------------------------------
    /// <summary>
    /// 로그 관련 공용 함수
    /// </summary>
    ///----------------------------------------------------------------------
    public class UtilLog
    {
        ///----------------------------------------------------------------------
        /// <summary>
        /// 로그 파일 포맷
        /// </summary>
        ///----------------------------------------------------------------------
        public static void WriteCommonLog(string strMethodName, string strLogName, string strLogMsg)
        {
            string pl_strLogName    = string.Empty;
            string pl_strRetString  = string.Empty;
            string pl_strRemoteAddr = HttpContext.Current.Request.ServerVariables.Get("REMOTE_ADDR");
            string pl_strFilePath   = HttpContext.Current.Request.FilePath;

            pl_strLogName   = string.Format("{0}_{1}.txt", strLogName, DateTime.Now.ToString("yyyyMMdd"));
            pl_strRetString = string.Format("[{0}] [{1}] [{2}] LogMsg : {3}", pl_strFilePath, strMethodName, pl_strRemoteAddr,  strLogMsg);

            FormatLog(UserGlobal.BOQ_COMMON_LOGPATH, pl_strLogName, pl_strRetString);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// 로그 파일 포맷
        /// </summary>
        ///----------------------------------------------------------------------
        public static void WriteLog(string strMethodName, int intRetVal, string strLogMsg)
        {
            string pl_strLogName    = string.Empty;
            string pl_strLogPath    = string.Empty;
            string pl_strRetString  = string.Empty;
            string pl_strRemoteAddr = HttpContext.Current.Request.ServerVariables.Get("REMOTE_ADDR");
            string pl_strFilePath   = HttpContext.Current.Request.FilePath;
            
            pl_strLogName   = string.Format("Log_{0}.txt", DateTime.Now.ToString("yyyyMMdd_HH"));
            pl_strLogPath   = string.Format("{0}{1}\\", UserGlobal.BOQ_GDRPOS_LOGPATH, DateTime.Now.ToString("yyyyMMdd"));
            pl_strRetString = string.Format("[{0}] [{1}] [{2}] LogMsg({3}) : {4}", pl_strRemoteAddr, pl_strFilePath, strMethodName, intRetVal, strLogMsg);

            FormatLog(pl_strLogPath, pl_strLogName, pl_strRetString);
        }

        ///----------------------------------------------------------------------
        /// <summary>
        /// Exception 로그 파일 포맷
        /// </summary>
        ///----------------------------------------------------------------------
        public static void WriteExceptionLog(string strMethodName, string strLogName, string strLogMsg, bool blnSendMailFlag = true)
        {
            string pl_strLogName    = string.Empty;
            string pl_strRetString  = string.Empty;
            string pl_strRemoteAddr = HttpContext.Current.Request.ServerVariables.Get("REMOTE_ADDR");
            string pl_strFilePath   = HttpContext.Current.Request.FilePath;
            
            pl_strLogName   = string.Format("{0}_{1}.txt", strLogName, DateTime.Now.ToString("yyyyMMdd"));
            pl_strRetString = string.Format("[{0}] [{1}] [{2}] LogMsg : {3}", pl_strRemoteAddr, pl_strFilePath, strMethodName, strLogMsg);

            FormatLog(UserGlobal.BOQ_EXCEPTION_LOGPATH, pl_strLogName, pl_strRetString);

            if (blnSendMailFlag)
            {
                UtilMail.SendExceptionMail(strLogMsg, "");
            }
        }
        public static void WriteExceptionLog(string strMessage, string strStackTrace, bool blnSendMailFlag = true)
        {
            StringBuilder pl_objSB       = new StringBuilder();
            NameValueCollection pl_objSV = HttpContext.Current.Request.ServerVariables;
            string pl_strLogName         = string.Empty;
            string pl_strFilePath        = HttpContext.Current.Request.FilePath;

            pl_objSB.AppendLine("HTTP_USER_AGENT : " + pl_objSV.Get("HTTP_USER_AGENT"));
            pl_objSB.AppendLine("REMOTE_ADDR : " + pl_objSV.Get("REMOTE_ADDR"));
            pl_objSB.AppendLine(string.Format("PAGE : {0} {1}", pl_objSV.Get("REQUEST_METHOD"), pl_objSV.Get("URL")));
            pl_objSB.AppendLine("Exception Time : " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
            pl_objSB.AppendLine("Exception Messase : " + strMessage);
            pl_objSB.AppendLine("Exception StackTrace : ");
            pl_objSB.AppendLine(strStackTrace);
            pl_objSB.AppendLine();
            
            pl_strLogName   = string.Format("Exception_{0}.txt", DateTime.Now.ToString("yyyyMMdd"));

            FormatLog(UserGlobal.BOQ_EXCEPTION_LOGPATH, pl_strLogName, pl_objSB.ToString());

            if (blnSendMailFlag)
            {
                UtilMail.SendExceptionMail(strMessage, strStackTrace);
            }
        }

        ///------------------------------------------------------------
        /// <summary>
        /// 파일에 로그 기록
        /// </summary>
        ///------------------------------------------------------------
        public static void FormatLog(string strLogPath, string strLogName, string strLogText)
        {
            System.IO.FileInfo log4netFile = new System.IO.FileInfo(HttpContext.Current.Request.ServerVariables["APPL_PHYSICAL_PATH"] + "log4net.config");
            log4net.GlobalContext.Properties["LogPath"] = strLogPath;
            log4net.GlobalContext.Properties["LogName"] = strLogName;

            log4net.Config.XmlConfigurator.Configure(log4netFile);
            log4net.ILog objLog = log4net.LogManager.GetLogger("FileLog");
            objLog.Info(strLogText);
        }

    }
}

