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
    /// 가족 이벤트 세부 소속 조회
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

            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog("PaytoolLst", pl_intRetVal, strErrMsg);
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
    private int GetUserPayList(DefaultReqParam objReq, DefaultListResParam objRes, out string strErrMsg)
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

            pl_objDas.SetQuery("dbo.UP_USER_PAY_UR_LST");

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

            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog("GetUserPayList", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }
}