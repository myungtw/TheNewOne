using System;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;

//================================================================
// FileName        : Utilmail.cs
// Description     : 메일 발송 관련 공용 모듈
// Special Logic   : None
// Copyright 2001-2012 by PayLetter Inc. All rights reserved.
// Author          : moondae@payletter.com, 2012-07-31
// Modify History  : Just Created.
//================================================================
namespace bill.payletter.com.CommonModule
{
    ///----------------------------------------------------------------------
    /// <summary>
    /// 메일 발송 관련 공용 함수
    /// </summary>
    ///----------------------------------------------------------------------
    public class UtilMail
    {
        public enum mailType { Order = 1, Charge = 2 }

        /// --------------------------------------------------------------------
        /// <summary>
        /// 메일 발송
        /// </summary>
        /// --------------------------------------------------------------------
        public static void SendMail(string strSubject, Int64 intPosOrderNo, int intRetVal, string strErrMsg, int intMailType = (int)mailType.Order)
        {
            string strMailInfo = string.Empty;
            if (intMailType.Equals((int)mailType.Charge))
            {
                strMailInfo = string.Format("<BR><B>GChargeNo</B><BR>{0}", intPosOrderNo);
            }
            else
            {
                strMailInfo = string.Format("<BR><B>PosOrderNo</B><BR>{0}", intPosOrderNo);
            }
            SendMail(strSubject, "", strMailInfo, intRetVal, strErrMsg);
        }
        public static void SendMail(string strSubject, Int64 intPosOrderNo, Int64 intOrderNo, int intRetVal, string strErrMsg)
        {
            string strMailInfo = string.Empty;
            strMailInfo = string.Format("<BR/><B>PosOrderNo</B><BR/>{0}", intPosOrderNo);
            strMailInfo = string.Format("{0}<BR/><B>OrderNo</B><BR/>{1}", strMailInfo, intOrderNo);
            SendMail(strSubject, "", strMailInfo, intRetVal, strErrMsg);
        }
        public static void SendMail(string strSubject, Int64 intPosOrderNo, Int64 intOrderNo, int intIncompleteSeqNo, int intRetVal, string strErrMsg, int intMailType = (int)mailType.Order)
        {
            string strMailInfo = string.Empty;
            if (intMailType.Equals((int)mailType.Charge))
            {
                strMailInfo = string.Format("<BR><B>GChargeNo</B><BR>{0}", intPosOrderNo);
            }
            else
            {
                strMailInfo = string.Format("<BR><B>PosOrderNo</B><BR>{0}", intPosOrderNo);
            }
            strMailInfo = string.Format("{0}<BR/><B>OrderNo</B><BR/>{1}", strMailInfo, intOrderNo);
            strMailInfo = string.Format("{0}<BR/><B>IncompleteSeqNo</B><BR/>{1}", strMailInfo, intIncompleteSeqNo);
            SendMail(strSubject, "", strMailInfo, intRetVal, strErrMsg);
        }
        public static void SendMail(string strSubject, string strAddMailTo,  string strMailInfo, int intRetVal, string strErrMsg)
        {
            StringBuilder pl_sbMailInfo    = null;
            StringBuilder pl_sbMailBody    = null;
            HttpContext   pl_objCtx        = null;
            MailMessage   pl_objMessage    = null;
            SmtpClient    pl_objClient     = null;

            string        pl_strMailSuject = string.Empty;
            string        pl_strIPAddr     = string.Empty;

            try
            {
                pl_sbMailInfo = new StringBuilder();
                pl_sbMailBody = new StringBuilder();

                pl_objCtx    = HttpContext.Current;
                pl_strIPAddr = UserGlobal.GetClientIP();

                pl_strMailSuject = string.Format("[{0}][{1}][{2}]-{3}", Dns.GetHostName().ToUpper(), "FamilyEvent", strSubject, pl_objCtx.Request.ServerVariables.Get("HTTP_HOST") + pl_objCtx.Request.FilePath.ToString());

                pl_sbMailInfo.Append("<B>Server</B><BR/>");
                pl_sbMailInfo.AppendFormat("ServerName: {0}", pl_objCtx.Request.ServerVariables.Get("HTTP_HOST"));
                pl_sbMailInfo.AppendFormat("<br>ServerIP: {0}", pl_objCtx.Request.ServerVariables.Get("LOCAL_ADDR"));
                pl_sbMailInfo.AppendFormat("<br>RemoteIP: {0}", pl_strIPAddr);
                pl_sbMailInfo.Append("<BR/>");
                if (!string.IsNullOrEmpty(strMailInfo))
                {
                    pl_sbMailInfo.Append(strMailInfo);
                }
                pl_sbMailInfo.Append("<BR/>");
                pl_sbMailInfo.Append("<BR/><B>Error Code</B><BR/>");
                pl_sbMailInfo.Append(intRetVal);
                pl_sbMailInfo.Append("<BR/><B>Error Message</B><BR/>");
                pl_sbMailInfo.Append(strErrMsg);

                // --------------------------------------------------
                // To let the page finish running we clear the error
                // --------------------------------------------------
                pl_sbMailBody.Append("<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01//EN' 'http://www.w3.org/TR/html4/strict.dtd'>");
                pl_sbMailBody.Append("<HTML>");
                pl_sbMailBody.Append("    <HEAD>");
                pl_sbMailBody.Append("        <META HTTP-EQUIV='Content-Type' Content='text/html; charset=ks_c_5601-1987'>");
                pl_sbMailBody.Append("        <STYLE type='text/css'>");
                pl_sbMailBody.Append("          BODY { font: 9pt/12pt Tahoma }");
                pl_sbMailBody.Append("          H1 { font: 13pt/15pt Tahoma }");
                pl_sbMailBody.Append("          H2 { font: 9pt/12pt Tahoma }");
                pl_sbMailBody.Append("          A:link { color: red }");
                pl_sbMailBody.Append("          A:visited { color: maroon }");
                pl_sbMailBody.Append("        </STYLE>");
                pl_sbMailBody.Append("    </HEAD>");
                pl_sbMailBody.Append("    <BODY>");
                pl_sbMailBody.Append("        <TABLE width=500 border=0 cellspacing=10>");
                pl_sbMailBody.Append("            <TR>");
                pl_sbMailBody.Append("                <TD>");
                pl_sbMailBody.Append(pl_sbMailInfo);
                pl_sbMailBody.Append("                </TD>");
                pl_sbMailBody.Append("            </TR>");
                pl_sbMailBody.Append("        </TABLE>");
                pl_sbMailBody.Append("    </BODY>");
                pl_sbMailBody.Append("</HTML>");

                pl_objMessage      = new MailMessage();
                pl_objMessage.From = new MailAddress(UserGlobal.BOQ_ADDRESS_FROM, UserGlobal.BOQ_ADDRESS_FROM);
                pl_objMessage.To.Add(UserGlobal.BOQ_ADDRESS_TO);
                //추가 주소가 있는 경우
                if (!string.IsNullOrEmpty(strAddMailTo))
                {
                    foreach (string pl_strMailTo in strAddMailTo.Split(';'))
                    {
                        pl_objMessage.To.Add(pl_strMailTo);
                    }
                }
                pl_objMessage.BodyEncoding    = Encoding.UTF8;
                pl_objMessage.SubjectEncoding = Encoding.UTF8;
                pl_objMessage.Subject         = pl_strMailSuject;
                pl_objMessage.Body            = pl_sbMailBody.ToString();
                pl_objMessage.IsBodyHtml      = true;
                
                if (string.IsNullOrEmpty(UserGlobal.BOQ_SMTP_ID))
                {
                    pl_objClient = new SmtpClient(UserGlobal.BOQ_SMTP_SERVER);
                }
                else
                {
                    pl_objClient                       = new SmtpClient(UserGlobal.BOQ_SMTP_SERVER);
                    pl_objClient.UseDefaultCredentials = false;
                    pl_objClient.DeliveryMethod        = SmtpDeliveryMethod.Network;
                    pl_objClient.Credentials           = new NetworkCredential(UserGlobal.BOQ_SMTP_ID, UserGlobal.BOQ_SMTP_PWD);
                }
                
                pl_objClient.Send(pl_objMessage);
            }
            catch (SmtpException pl_objEx)
            {
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                pl_sbMailInfo = null;
                pl_sbMailBody = null;
                pl_objCtx = null;

                if (pl_objMessage != null)
                {
                    pl_objMessage.Dispose();
                    pl_objMessage = null;
                }
                  
                if (pl_objClient != null)
                {
                    pl_objClient.Dispose();
                    pl_objClient = null;
                }
            }
        }

        /// --------------------------------------------------------------------
        /// <summary>
        /// Exception 메일 발송
        /// </summary>
        /// --------------------------------------------------------------------
        public static void SendExceptionMail(string strErrMsg, string strErrStackTrace)
        {
            StringBuilder pl_sbMailInfo    = null;
            StringBuilder pl_sbMailBody    = null;
            HttpContext   pl_objCtx        = null;
            MailMessage   pl_objMessage    = null;
            SmtpClient    pl_objClient     = null;

            string        pl_strMailSuject = string.Empty;
            string        pl_strIPAddr     = string.Empty;

            try
            {
                pl_sbMailInfo = new StringBuilder();
                pl_sbMailBody = new StringBuilder();

                pl_objCtx    = HttpContext.Current;
                pl_strIPAddr = UserGlobal.GetClientIP();

                pl_strMailSuject = string.Format("[{0}][{1}][Exception error]-{2}", Dns.GetHostName().ToUpper(), "FamilyEvent", pl_objCtx.Request.ServerVariables.Get("HTTP_HOST") + pl_objCtx.Request.FilePath.ToString());

                pl_sbMailInfo.Append("<B>Server</B><BR/>");
                pl_sbMailInfo.AppendFormat("ServerName: {0}", pl_objCtx.Request.ServerVariables.Get("HTTP_HOST"));
                pl_sbMailInfo.AppendFormat("<br>ServerIP: {0}", pl_objCtx.Request.ServerVariables.Get("LOCAL_ADDR"));
                pl_sbMailInfo.AppendFormat("<br>RemoteIP: {0}", pl_strIPAddr);
                pl_sbMailInfo.Append("<BR><BR>");
                pl_sbMailInfo.Append("<B>Error Message</B><BR>");
                pl_sbMailInfo.Append(strErrMsg);
                pl_sbMailInfo.Append("<BR><BR>");
                pl_sbMailInfo.Append("<B>Browser</B><BR>");
                pl_sbMailInfo.Append(pl_objCtx.Request.UserAgent);
                pl_sbMailInfo.Append("<BR><BR>");
                pl_sbMailInfo.Append("<B>Offending URL</B><BR>");
                pl_sbMailInfo.Append(pl_objCtx.Request.Url.ToString());
                pl_sbMailInfo.Append("<BR><BR>");
                pl_sbMailInfo.Append("<B>Stack trace</B><BR>");
                pl_sbMailInfo.Append(strErrStackTrace);

                // --------------------------------------------------
                // To let the page finish running we clear the error
                // --------------------------------------------------
                pl_sbMailBody.Append("<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01//EN' 'http://www.w3.org/TR/html4/strict.dtd'>");
                pl_sbMailBody.Append("<HTML>");
                pl_sbMailBody.Append("    <HEAD>");
                pl_sbMailBody.Append("        <META HTTP-EQUIV='Content-Type' Content='text/html; charset=ks_c_5601-1987'>");
                pl_sbMailBody.Append("        <STYLE type='text/css'>");
                pl_sbMailBody.Append("          BODY { font: 9pt/12pt Tahoma }");
                pl_sbMailBody.Append("          H1 { font: 13pt/15pt Tahoma }");
                pl_sbMailBody.Append("          H2 { font: 9pt/12pt Tahoma }");
                pl_sbMailBody.Append("          A:link { color: red }");
                pl_sbMailBody.Append("          A:visited { color: maroon }");
                pl_sbMailBody.Append("        </STYLE>");
                pl_sbMailBody.Append("    </HEAD>");
                pl_sbMailBody.Append("    <BODY>");
                pl_sbMailBody.Append("        <TABLE width=500 border=0 cellspacing=10>");
                pl_sbMailBody.Append("            <TR>");
                pl_sbMailBody.Append("                <TD>");
                pl_sbMailBody.Append(pl_sbMailInfo);
                pl_sbMailBody.Append("                </TD>");
                pl_sbMailBody.Append("            </TR>");
                pl_sbMailBody.Append("        </TABLE>");
                pl_sbMailBody.Append("    </BODY>");
                pl_sbMailBody.Append("</HTML>");

                pl_objMessage      = new MailMessage();
                pl_objMessage.From = new MailAddress(UserGlobal.BOQ_ADDRESS_FROM, UserGlobal.BOQ_ADDRESS_FROM);
                pl_objMessage.To.Add(UserGlobal.BOQ_ADDRESS_TO);
                pl_objMessage.BodyEncoding    = Encoding.UTF8;
                pl_objMessage.SubjectEncoding = Encoding.UTF8;
                pl_objMessage.Subject         = pl_strMailSuject;
                pl_objMessage.Body            = pl_sbMailBody.ToString();
                pl_objMessage.IsBodyHtml      = true;
                
                if (string.IsNullOrEmpty(UserGlobal.BOQ_SMTP_ID))
                {
                    pl_objClient = new SmtpClient(UserGlobal.BOQ_SMTP_SERVER);
                }
                else
                {
                    pl_objClient                       = new SmtpClient(UserGlobal.BOQ_SMTP_SERVER);
                    pl_objClient.UseDefaultCredentials = false;
                    pl_objClient.DeliveryMethod        = SmtpDeliveryMethod.Network;
                    pl_objClient.Credentials           = new NetworkCredential(UserGlobal.BOQ_SMTP_ID, UserGlobal.BOQ_SMTP_PWD);
                }
                
                pl_objClient.Send(pl_objMessage);
            }
            catch (SmtpException pl_objEx)
            {
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace, false);
            }
            finally
            {
                pl_sbMailInfo = null;
                pl_sbMailBody = null;
                pl_objCtx = null;

                if (pl_objMessage != null)
                {
                    pl_objMessage.Dispose();
                    pl_objMessage = null;
                }
                  
                if (pl_objClient != null)
                {
                    pl_objClient.Dispose();
                    pl_objClient = null;
                }
            }
        }

    }
}