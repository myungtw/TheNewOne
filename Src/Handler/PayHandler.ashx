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

    // 이벤트 결제내역 조회요청 클래스
    public class EventPayReqParam : DefaultReqParam
    {
        public int   intFamilyEventNo     { get; set; }
    }
}