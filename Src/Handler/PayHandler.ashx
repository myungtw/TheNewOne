<%@ WebHandler Language="C#" Class="PayHandler" %>

using System;
using System.Data;

using bill.payletter.com.CommonModule;
using bill.payletter.com.handler;
using BOQv7Das_Net;

///================================================================
/// <summary>
/// FileName        : PayHandler.ashx
/// Description     : 결제관련 처리기
/// Copyright 2020 by PayLetter Inc. All rights reserved.
/// Author          : ysjee@payletter.com, 2020-01-14
/// Modify History  : just create.
/// </summary>
///================================================================
public class PayHandler : AshxBaseHandler
{
    //-------------------------------------------------------------
    /// <summary>
    /// 결제수단 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Everyone, strRepresentMsg = strDefaultMsg)]
    private int PaytoolLst(DefaultReqParam objReq, DefaultListResParam objRes, out string strErrMsg)
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

            pl_objDas.SetQuery("dbo.UP_PAYTOOL_UR_LST");

            objRes.intRowCnt = pl_objDas.RecordCount;
            objRes.objDT     = pl_objDas.objDT;
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
        }

        return pl_intRetVal;
    }

    //-------------------------------------------------------------
    /// <summary>
    /// 이벤트 결제내역 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login, strRepresentMsg = strDefaultMsg)]
    private int EventPayList(EventPayReqParam objReq, DefaultListResParam objRes, out string strErrMsg)
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

            pl_objDas.AddParam("@pi_intUserNo",         DBType.adInteger,   objSes.intUserNo,        0, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intFamilyEventNo",  DBType.adBigInt,    objReq.intFamilyEventNo, 0, ParameterDirection.Input);
            pl_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger,   DBNull.Value,            0, ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_EVENT_PAY_UR_LST");

            objRes.intRowCnt = Convert.ToInt32(pl_objDas.GetParam("@po_intRecordCnt"));
            objRes.objDT     = pl_objDas.objDT;
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
        }

        return pl_intRetVal;
    }

    //-------------------------------------------------------------
    /// <summary>
    /// 회원 별 결제 내역 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login, strRepresentMsg = strDefaultMsg)]
    private int GetUserPayList(PayListReqParam objReq, DefaultListResParam objRes, out string strErrMsg)
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

            pl_objDas.AddParam("@pi_intUserNo",    DBType.adInteger, objSes.intUserNo,   0, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_dtFromYMD",    DBType.adVarChar, "",                 8, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_dtToYMD",      DBType.adVarChar, "",                 8, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intSeqNo",     DBType.adBigInt,  0,                  0, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intPageNo",    DBType.adInteger, 1,                  0, ParameterDirection.Input);

            pl_objDas.AddParam("@pi_intPageSize",  DBType.adInteger, objReq.intPageSize, 0, ParameterDirection.Input);
            pl_objDas.AddParam("@po_intRecordCnt", DBType.adInteger, DBNull.Value,       0, ParameterDirection.Output);
            pl_objDas.SetQuery("dbo.UP_USER_PAY_UR_LST");

            objRes.intRowCnt = Convert.ToInt32(pl_objDas.GetParam("@po_intRecordCnt"));
            objRes.objDT     = pl_objDas.objDT;
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
        }

        return pl_intRetVal;
    }


    //-------------------------------------------------------------
    /// <summary>
    /// 회원별 받은 내역조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login, strRepresentMsg = strDefaultMsg)]
    private int GetReceiveList(PayListReqParam objReq, DefaultListResParam objRes, out string strErrMsg)
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

            pl_objDas.AddParam("@pi_intUserNo",    DBType.adInteger, objSes.intUserNo,   0, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_dtFromYMD",    DBType.adVarChar, "",                 8, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_dtToYMD",      DBType.adVarChar, "",                 8, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intPageNo",    DBType.adInteger, 1,                  0, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intPageSize",  DBType.adInteger, objReq.intPageSize, 0, ParameterDirection.Input);

            pl_objDas.AddParam("@po_intRecordCnt", DBType.adInteger, DBNull.Value,       0, ParameterDirection.Output);
            pl_objDas.SetQuery("dbo.UP_RECEIVE_UR_LST");

            objRes.intRowCnt = Convert.ToInt32(pl_objDas.GetParam("@po_intRecordCnt"));
            objRes.objDT     = pl_objDas.objDT;
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
        }

        return pl_intRetVal;
    }

    //-------------------------------------------------------------
    /// <summary>
    /// 환전 가능 금액 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login, strRepresentMsg = strDefaultMsg)]
    private int GetReceiveTotalPrice(DefaultReqParam objReq, DefaultListResParam objRes, out string strErrMsg)
    {
        int  pl_intRetVal = 0;
        IDas pl_objDas    = null;
        strErrMsg         = string.Empty;

        try
        {
            pl_objDas = new IDas();
            pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage = 0;

            pl_objDas.AddParam("@pi_intUserNo",             DBType.adInteger, objSes.intUserNo,   0, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intJoinMstCategory",    DBType.adInteger, 0,                  0, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intJoinSubCategory",    DBType.adInteger, 0,                  0, ParameterDirection.Input);
            
            pl_objDas.SetQuery("dbo.UP_RECEIVE_PRICE_NT_GET");

            objRes.objDT = pl_objDas.objDT;
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
        }

        return pl_intRetVal;
    }

    //-------------------------------------------------------------
    /// <summary>
    /// 환전 내역 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login, strRepresentMsg = strDefaultMsg)]
    private int GetRefundList(DefaultReqParam objReq, DefaultListResParam objRes, out string strErrMsg)
    {
        int  pl_intRetVal = 0;
        IDas pl_objDas    = null;
        strErrMsg         = string.Empty;

        try
        {
            pl_objDas = new IDas();
            pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage = 0;

            pl_objDas.AddParam("@pi_intUserNo",    DBType.adInteger, objSes.intUserNo,   0, ParameterDirection.Input);
            pl_objDas.AddParam("@po_intRecordCnt", DBType.adInteger, DBNull.Value,       0, ParameterDirection.Output);
            
            pl_objDas.SetQuery("dbo.UP_EXCHANGE_UR_LST");

            objRes.intRowCnt = Convert.ToInt32(pl_objDas.GetParam("@po_intRecordCnt"));
            objRes.objDT     = pl_objDas.objDT;
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
        }

        return pl_intRetVal;
    }

    //-------------------------------------------------------------
    /// <summary>
    /// 환전
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login, strRepresentMsg = strDefaultMsg)]
    private int TXExchange(ExchangeReqParam objReqParam, ExchangeResParam objResParam, out string strErrMsg)
    {
        int  pl_intRetVal = 0;
        IDas pl_objDas    = null;
        strErrMsg         = string.Empty;

        try
        {
            pl_objDas = new IDas();
            pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage = 0;

            pl_objDas.AddParam("@pi_intUserNo",      DBType.adInteger,  objSes.intUserNo,             0,   ParameterDirection.Input);
            pl_objDas.AddParam("@pi_strUserID",      DBType.adVarChar,  objReqParam.strUserID,        50,  ParameterDirection.Input);
            pl_objDas.AddParam("@pi_dblExchangeAmt", DBType.adDouble,   objReqParam.dblExchangeAmt,   0,   ParameterDirection.Input);
            pl_objDas.AddParam("@pi_dblReqAmt",      DBType.adDouble,   0,                            0,   ParameterDirection.Input);
            pl_objDas.AddParam("@pi_dblReqFee",      DBType.adDouble,   0,                            0,   ParameterDirection.Input);

            pl_objDas.AddParam("@pi_strBankCode",    DBType.adVarChar,  "004",                        20,  ParameterDirection.Input);
            pl_objDas.AddParam("@pi_strBankAcctNo",  DBType.adVarChar,  "08400104161933",             200, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_strBankName",    DBType.adVarWChar, "국민은행",                   200, ParameterDirection.Input);
            pl_objDas.AddParam("@po_intExchangeNo",  DBType.adInteger,  DBNull.Value,                 0,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_strErrMsg",      DBType.adVarChar,  DBNull.Value,                 256, ParameterDirection.Output);

            pl_objDas.AddParam("@po_intRetVal",      DBType.adInteger,  DBNull.Value,                 0,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_strDBErrMsg",    DBType.adVarChar,  DBNull.Value,                 256, ParameterDirection.Output);
            pl_objDas.AddParam("@po_intDBRetVal",    DBType.adInteger,  DBNull.Value,                 0,   ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_EXCHANGE_TX_INS");

            objResParam.intRetVal     = Convert.ToInt32(pl_objDas.GetParam("@po_intRetVal"));
            objResParam.strErrMsg     = pl_objDas.GetParam("@po_strErrMsg");
            objResParam.intExchangeNo = Convert.ToInt64(pl_objDas.GetParam("@po_intExchangeNo"));
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
        }

        return pl_intRetVal;
    }

    public class ExchangeReqParam : DefaultReqParam
    {
        public string strUserID { get; set; }
        public double dblExchangeAmt { get; set; }
    }

    public class ExchangeResParam : DefaultResParam
    {
        public Int64 intExchangeNo { get; set; }
    }

    // 이벤트 결제내역 조회요청 클래스
    public class EventPayReqParam : DefaultReqParam
    {
        public int   intFamilyEventNo     { get; set; }
    }

    public class PayListReqParam : DefaultReqParam
    {
        public int intPageSize { get; set; }
    }
}