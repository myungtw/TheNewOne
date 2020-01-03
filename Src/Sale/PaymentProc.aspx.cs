using System;
using System.Collections.Generic;
using System.Reflection;
using System.Web;

using Newtonsoft.Json;

using bill.payletter.com.CommonModule;

///================================================================
/// <summary>
/// FileName       : PaymentProc.aspx
/// Description    : 결제 및 구매 처리
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author         : tumyeong@payletter.com, 2019-08-26
/// Modify History : Just Created.
/// </summary>
///================================================================
public partial class PaymentProc : PageBase
{
    protected string strResultMsg = string.Empty;

    //-------------------------------------------------------------
    /// <summary>
    /// Name          : Page_Load()
    /// Description   : 페이지 로드
    /// </summary>
    //-------------------------------------------------------------
    protected void Page_Load(object sender, EventArgs e)
    {
        int                        pl_intRetVal             = 0;
        int                        pl_intInnerRetVal        = 0;
        int                        pl_intUserNo             = 0;
        Int16                      pl_intSiteCode           = 0;
        Int64                      pl_intOrderNo            = 0;

        string                     pl_strErrMsg             = string.Empty;
        string                     pl_strInnerErrMsg        = string.Empty;
        string                     pl_strPageMethodName     = string.Empty;
        string                     pl_strRedirectUrl        = string.Empty;
        string                     pl_strPayCompleteFlag    = string.Empty;
        string                     pl_strResultMsg          = string.Empty;
        string                     pl_strTemp               = string.Empty;

        PosLogInfo                 pl_objPosLogInfo         = null;
        PGPayLogInfo               pl_objPGPayLogInfo       = null;
        PGPayResParam              pl_objPGPayResParam      = null;
        Dictionary<string, string> pl_objPGResData          = null;     //PG 응답 데이터 저장

        try
        {
            pl_strPageMethodName = MethodBase.GetCurrentMethod().Name;

            pl_objPosLogInfo    = new PosLogInfo();
            pl_objPGPayLogInfo  = new PGPayLogInfo();
            pl_objPGPayResParam = new PGPayResParam();

            //다음 페이지 설정
            pl_strRedirectUrl = string.Format("{0}?posorderno=", UserGlobal.BOQ_SALE_PAYMENT_RESULT_URL);

            //데이터 수신
            pl_intRetVal = GetData(out pl_intOrderNo, out pl_intSiteCode, out pl_intUserNo, out pl_objPGResData, out pl_strErrMsg);
            if (!pl_intRetVal.Equals(0))
            {
                return;
            }

            if (pl_objPGResData == null)
            {
                pl_intRetVal = -1301;
                pl_strErrMsg = "PG 데이터가 존재하지 않습니다.";
                return;
            }

            //POS 주문 정보 및 PG 결제 로그 조회
            pl_intRetVal = CommonDB.GetPGPayLog(pl_intOrderNo, pl_intSiteCode, pl_intUserNo, pl_objPGPayLogInfo, out pl_strErrMsg);
            if (!pl_intRetVal.Equals(0))
            {
                return;
            }

            //다음 페이지 재 설정
            pl_strRedirectUrl = string.Format("{0}?posorderno={1}", UserGlobal.BOQ_SALE_PAYMENT_URL, pl_objPGPayLogInfo.intPosOrderNo);
            /*
            //PG 결과 확인
            if (pl_objPGPayLogInfo.intPayToolCode.Equals(UserGlobal.BOQ_PAYTOOL_CARD))
            {
                //CheckMobile
                pl_intRetVal = GetCardPGResult(pl_intOrderNo, pl_objPGResData, out pl_objPGPayResParam, out pl_strErrMsg);
            }
            else if (pl_objPGPayLogInfo.intPayToolCode.Equals(UserGlobal.BOQ_PAYTOOL_CASH))
            {
                //KCP
                pl_intRetVal = GetCashPGResult(pl_intOrderNo, pl_objPGResData, out pl_objPGPayResParam, out pl_strErrMsg);
            }
            else
            {
                pl_intRetVal = -1302;
                pl_strErrMsg = "사용 불가한 결제 정보입니다.";
                return;
            }
            if (!pl_intRetVal.Equals(0))
            {
                return;
            }

            //PG 결제 실패 시 
            if (!pl_objPGPayResParam.intPayStateCode.Equals((Int16)UserGlobal.BOQ_PAYSTATE.PGPaySuccess))
            {
                pl_intRetVal = -1303;
                pl_strErrMsg = string.Format("({0}) {1}", pl_objPGPayResParam.strPayRsltCode, pl_objPGPayResParam.strPayRsltMsg);

                //PG 결제 로그 업데이트(PG결제실패) : 실행 결과 무시
                CommonDB.UpdPGPayLog(pl_objPGPayResParam, out pl_strPayCompleteFlag, out pl_strTemp);
                return;
            }

            //금액 확인
            if (!pl_objPGPayLogInfo.intPayAmt.Equals(pl_objPGPayResParam.intPayAmt))
            {
                pl_intRetVal = -1304;
                pl_strErrMsg = "요청 결제 금액이 일치하지 않습니다.";
                return;
            }

            //PG 결제 로그 업데이트(PG결제성공)
            pl_intRetVal = CommonDB.UpdPGPayLog(pl_objPGPayResParam, out pl_strPayCompleteFlag, out pl_strErrMsg);
            if (!pl_intRetVal.Equals(0))
            {
                //메일링
                UtilMail.SendMail("PG 결제 처리 실패", pl_objPGPayLogInfo.intPosOrderNo, pl_objPGPayLogInfo.intOrderNo, pl_intRetVal, pl_strErrMsg);
                pl_strResultMsg = string.Format("PG 결제 처리 실패 : ({0}) {1}", pl_intRetVal, pl_strErrMsg);

                //취소 데이터 추가 세팅
                pl_objPGPayLogInfo.intPayAmt        = pl_objPGPayResParam.intPayAmt;
                pl_objPGPayLogInfo.strTID           = pl_objPGPayResParam.strTID;
                pl_objPGPayLogInfo.strCID           = pl_objPGPayResParam.strCID;
                pl_objPGPayLogInfo.strCashReceiptNo = pl_objPGPayResParam.strCashReceiptNo;
                pl_objPGPayLogInfo.strCardNo        = pl_objPGPayResParam.strCardNo;
                pl_objPGPayLogInfo.intInstallment   = pl_objPGPayResParam.intInstallment;
                pl_objPGPayLogInfo.strApprovalDate  = pl_objPGPayResParam.strApprovalDate;

                //PG 취소 요청
                //pl_objPayCancel = new PayCancel();
                //pl_intInnerRetVal = pl_objPayCancel.PGPayCancelRequest(pl_objPGPayLogInfo, out pl_strInnerErrMsg);
                if (!pl_intInnerRetVal.Equals(0))
                {
                    pl_strResultMsg = string.Format("{0}|PG 결제 취소 실패| [{1}] {2}", pl_strResultMsg, pl_objPGPayLogInfo.intOrderNo, pl_strInnerErrMsg);
                }

                return;
            }

            //모든 결제 완료 시 캐시 충전 및 구매 처리
            if (pl_strPayCompleteFlag.Equals("Y"))
            {
                //다음(결과) 페이지 재 설정
                pl_strRedirectUrl = string.Format("{0}?posorderno={1}", UserGlobal.BOQ_SALE_PAYMENT_RESULT_URL, pl_objPGPayLogInfo.intPosOrderNo);
  
                //구매 처리
                pl_intRetVal = PurchaseItem(pl_objPGPayLogInfo, out pl_strErrMsg);
                if (!pl_intRetVal.Equals(0))
                {
                    //메일링
                    UtilMail.SendMail("구매 처리 실패", pl_objPosLogInfo.intPosOrderNo, pl_intRetVal, pl_strErrMsg);
                    pl_strResultMsg = string.Format("구매 실패 - ({0}) {1}", pl_intRetVal, pl_strErrMsg);
                }
            }
            */
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15310;
            pl_strErrMsg = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
            pl_objPGPayResParam = null;
            pl_objPGPayLogInfo  = null;
            pl_objPosLogInfo    = null;

            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog(pl_strPageMethodName, pl_intRetVal, pl_strErrMsg);
                
                if (string.IsNullOrEmpty(pl_strResultMsg))
                {
                    pl_strResultMsg = string.Format("실패 - ({0}) {1}", pl_intRetVal, pl_strErrMsg);
                }

                //다음 페이지에 메시지 추가 설정
                pl_strRedirectUrl = string.Format("{0}&resultmsg={1}", pl_strRedirectUrl, HttpUtility.UrlEncode(pl_strResultMsg));
            }

            Response.Redirect(pl_strRedirectUrl);
        }
    }

    //-------------------------------------------------------------
    /// <summary>
    /// Name          : GetDate()
    /// Description   : 데이터 수신 (PG 응답 데이터)
    /// </summary>
    //-------------------------------------------------------------
    private int GetData(out Int64 intOrderNo, out Int16 intSiteCode, out int intUserNo, out Dictionary<string, string> objPGResData, out string strErrMsg)
    {
        int    pl_intRetVal         = 0;
        string pl_strEncOrderNo        = string.Empty;
        string pl_strOrderNo        = string.Empty;
        string pl_strSiteCode       = string.Empty;
        string pl_strUserNo        = string.Empty;
        string pl_strPageMethodName = string.Empty;
        
        strErrMsg    = string.Empty;
        intOrderNo   = 0;
        intSiteCode   = 0;
        intUserNo   = 0;
        objPGResData = null;

        try
        {
            pl_strPageMethodName = MethodBase.GetCurrentMethod().Name;

            objPGResData = new Dictionary<string, string>();

            //수신 데이터 로깅
            UtilLog.WriteLog(pl_strPageMethodName, 0, string.Format("[ReqData] {0}", Request.QueryString.ToString()));

            //주문번호
            pl_strEncOrderNo = UserGlobal.GetValue(Request.QueryString["orderno"]);    //주문번호

            //OrderNo 복호화
            //UserGlobal.GetDecryptAesGCM(pl_strEncOrderNo, out pl_strOrderNo, out pl_strSiteCode, out pl_strUserNo);
            Int64.TryParse(pl_strOrderNo, out intOrderNo);
            if (intOrderNo.Equals(0))
            {
                pl_intRetVal = -1311;
                strErrMsg    = "유효하지 않은 POS 주문번호 입니다.";
                return pl_intRetVal;
            }

            //PG 응답 파라미터 세팅(GET)
            foreach (string strKey in Request.QueryString.AllKeys)
            {
                objPGResData.Add(strKey, Request.QueryString[strKey]);
            }
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15311;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog(pl_strPageMethodName, pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    /*
    //-------------------------------------------------------------
    /// <summary>
    /// Name          : GetCardPGResult()
    /// Description   : 신용카드 PG 결과
    /// </summary>
    //-------------------------------------------------------------
    private int GetCardPGResult(Int64 intOrderNo, Dictionary<string, string> objPGResData, out PGPayResParam objPGPayResParam, out string strErrMsg)
    {
        int    pl_intRetVal         = 0;
        string pl_strPGResData      = string.Empty;
        string pl_strPageMethodName = string.Empty;

        CheckMobileResParam pl_objCheckMobileResParam = null;

        strErrMsg        = string.Empty;
        objPGPayResParam = null;

        try
        {
            pl_strPageMethodName = MethodBase.GetCurrentMethod().Name;

            objPGPayResParam          = new PGPayResParam();
            pl_objCheckMobileResParam = new CheckMobileResParam();

            //Json 형태로 재정의 및 세팅
            pl_strPGResData           = JsonConvert.SerializeObject(objPGResData);
            pl_objCheckMobileResParam = JsonConvert.DeserializeObject<CheckMobileResParam>(pl_strPGResData);

            //PG CheckMobile 로그 업데이트(결과) : 실행 결과 무시
            CheckMobile.UpdPGPayLogCheckMobile(intOrderNo, pl_objCheckMobileResParam);

            //PG 결제 응답 데이터 세팅
            objPGPayResParam.intOrderNo      = intOrderNo;
            objPGPayResParam.strPayRsltCode  = pl_objCheckMobileResParam.result;
            objPGPayResParam.strPayRsltMsg   = pl_objCheckMobileResParam.message;

            //결제 요청 결과 확인
            if (!pl_objCheckMobileResParam.result.Equals(CheckMobile.CHECKMOBILE_RESULT_SUCCESS))
            {
                objPGPayResParam.intPayStateCode = Convert.ToInt16(UserGlobal.BOQ_PAYSTATE.PGPayFail);
                return pl_intRetVal;
            }

            objPGPayResParam.intPayStateCode = Convert.ToInt16(UserGlobal.BOQ_PAYSTATE.PGPaySuccess);
            objPGPayResParam.intPayAmt       = Convert.ToDouble(pl_objCheckMobileResParam.tot_amt);
            objPGPayResParam.strPayToolName  = pl_objCheckMobileResParam.cc_name;
            objPGPayResParam.strTID          = pl_objCheckMobileResParam.tno;
            objPGPayResParam.strCID          = pl_objCheckMobileResParam.app_no;
            objPGPayResParam.strApprovalDate = DateTime.ParseExact(pl_objCheckMobileResParam.tx_dt, "yyMMddHHmmss", null).ToString("yyyy-MM-dd HH:mm:ss");
            objPGPayResParam.strCardNo       = pl_objCheckMobileResParam.card_no;
            objPGPayResParam.intInstallment  = Convert.ToInt16(pl_objCheckMobileResParam.ins_mon);
            objPGPayResParam.strEtcInfo      = pl_objCheckMobileResParam.tx_no;
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15312;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
            pl_objCheckMobileResParam = null;

            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog(pl_strPageMethodName, pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    //-------------------------------------------------------------
    /// <summary>
    /// Name          : GetCashPGResult()
    /// Description   : 현금영수증 PG 결과
    /// </summary>
    //-------------------------------------------------------------
    private int GetCashPGResult(Int64 intOrderNo, Dictionary<string, string> objPGResData, out PGPayResParam objPGPayResParam, out string strErrMsg)
    {
        int    pl_intRetVal         = 0;
        string pl_strPGResData      = string.Empty;
        string pl_strPageMethodName = string.Empty;

        KCPPayResParam             pl_objKCPPayResParam = null;

        strErrMsg        = string.Empty;
        objPGPayResParam = null;

        try
        {
            pl_strPageMethodName = MethodBase.GetCurrentMethod().Name;

            objPGPayResParam = new PGPayResParam();

            //Json 형태로 재정의 및 세팅
            pl_strPGResData      = JsonConvert.SerializeObject(objPGResData);
            pl_objKCPPayResParam = JsonConvert.DeserializeObject<KCPPayResParam>(pl_strPGResData);

            //PG 결제 응답 데이터 세팅
            objPGPayResParam.intOrderNo      = intOrderNo;
            objPGPayResParam.strPayRsltCode  = pl_objKCPPayResParam.m_strResCD;
            objPGPayResParam.strPayRsltMsg   = pl_objKCPPayResParam.m_strResMsg;

            //결제 요청 결과 확인
            if (!pl_objKCPPayResParam.m_strResCD.Equals(KCPPay.KCP_RESULT_SUCCESS))
            {
                objPGPayResParam.intPayStateCode = Convert.ToInt16(UserGlobal.BOQ_PAYSTATE.PGPayFail);
                return pl_intRetVal;
            }

            objPGPayResParam.intPayStateCode  = Convert.ToInt16(UserGlobal.BOQ_PAYSTATE.PGPaySuccess);
            objPGPayResParam.intPayAmt        = Convert.ToDouble(pl_objKCPPayResParam.amt_tot);
            objPGPayResParam.strTID           = pl_objKCPPayResParam.cash_no;
            objPGPayResParam.strCID           = pl_objKCPPayResParam.receipt_no;
            objPGPayResParam.strApprovalDate  = DateTime.ParseExact(pl_objKCPPayResParam.app_time, "yyyyMMddHHmmss", null).ToString("yyyy-MM-dd HH:mm:ss");
            objPGPayResParam.intInstallment   = Convert.ToInt16(pl_objKCPPayResParam.tr_code);
            objPGPayResParam.strCashReceiptNo = pl_objKCPPayResParam.id_info;
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15313;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
            pl_objKCPPayResParam = null;

            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog(pl_strPageMethodName, pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    //-------------------------------------------------------------
    /// <summary>
    /// Name          : PurchaseItem()
    /// Description   : Pos 구매(충전) 처리
    /// </summary>
    //-------------------------------------------------------------
    private int PurchaseItem(PGPayLogInfo objPGPayLogInfo, out string strErrMsg)
    {
        int        pl_intRetVal         = 0;
        int        pl_intInnerRetVal    = 0;
        string     pl_strInnerErrMsg    = string.Empty;
        string     pl_strPageMethodName = string.Empty;

        PosLogInfo pl_objPosLogInfo     = null;
        Purchase   pl_objPurchase       = null;
        Lesson     pl_objLesson         = null;

        strErrMsg  = string.Empty;

        try
        {
            pl_strPageMethodName = MethodBase.GetCurrentMethod().Name;

            pl_objPosLogInfo = new PosLogInfo();
            pl_objPurchase   = new Purchase();
            
            //데이터 세팅
            pl_objPosLogInfo.intPosOrderNo = objPGPayLogInfo.intPosOrderNo;
            pl_objPosLogInfo.intSiteCode   = objPGPayLogInfo.intSiteCode;
            pl_objPosLogInfo.intUserNo     = objPGPayLogInfo.intUserNo;
            pl_objPosLogInfo.strUserID     = objPGPayLogInfo.strUserID;
            pl_objPosLogInfo.strStoreCode  = objPGPayLogInfo.strStoreCode;
            
            //구매(충전) 처리
            pl_intRetVal = pl_objPurchase.PurchaseItem(pl_objPosLogInfo, out strErrMsg);
            if (!pl_intRetVal.Equals(0))
            {
                return pl_intRetVal;
            }

            //레슨 모듈 등록 : 실행 결과 무시
            pl_objLesson = new Lesson();
            pl_objLesson.intGChargeNo = pl_objPosLogInfo.intGChargeNo;
            pl_objLesson.intUserNo    = pl_objPosLogInfo.intUserNo;
            pl_objLesson.intProNo     = pl_objPosLogInfo.intProNo;
            pl_objLesson.strStoreCode = pl_objPosLogInfo.strStoreCode;
            pl_intInnerRetVal = pl_objLesson.InsLesson(out pl_strInnerErrMsg);
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15314;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
            pl_objLesson     = null;
            pl_objPurchase   = null;
            pl_objPosLogInfo = null;

            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog(pl_strPageMethodName, pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }
    */

}