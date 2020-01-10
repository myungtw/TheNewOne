<%@ WebHandler Language="C#" Class="FamilyEventHandler" %>

using Dapper;
using System;
using System.Data;

using bill.payletter.com.CommonModule;
using bill.payletter.com.handler;
using BOQv7Das_Net;

///================================================================
/// <summary>
/// FileName        : FamilyEventHandler.ashx
/// Description     : 가족 이벤트 이벤트 처리기
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author          : tumyeong@payletter.com, 2020-01-15
/// Modify History  : just create.
/// </summary>
///================================================================
public class FamilyEventHandler : AshxBaseHandler
{
    #region 가족 이벤트
    //-------------------------------------------------------------
    /// <summary>
    /// 가족 이벤트 보유 내역 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Everyone, strRepresentMsg = strDefaultMsg)]
    private int GetFamilyEventHoldList(GetFamilyEventHoldListReqParam objReqParam, DefaultListResParam objResParam, out string strErrMsg)
    {
        int  pl_intRetVal = 0;

        DynamicParameters pl_objParam         = null;
        DapperWrapper     pl_objDapperWrapper = null;
        DapperResult      pl_objResult        = null;

        strErrMsg = string.Empty;

        try
        {
            pl_objResult        = new DapperResult();
            pl_objDapperWrapper = new DapperWrapper(UserGlobal.BOQ_DB_CONN);

            pl_objParam = new DynamicParameters();
            pl_objParam.Add("pi_intUserNo",     objReqParam.intUserNo);
            pl_objParam.Add("po_intRecordCnt",  dbType: DbType.Int32,   direction: ParameterDirection.Output,   size: 0);

            pl_objResult = pl_objDapperWrapper.QuerySP("dbo.UP_FAMILY_EVENT_HOLD_UR_LST", pl_objParam);
            if (!pl_objResult.intErrCode.Equals(0))
            {
                pl_intRetVal = pl_objResult.intErrCode;
                strErrMsg    = pl_objResult.strErrMsg;
                return pl_intRetVal;
            }
            
            objResParam.intRowCnt = pl_objResult.intCount;
            objResParam.objDT     = pl_objResult.objDT;
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15214;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog("GetFamilyEventHoldList", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // 가족 이벤트 보유 내역 조회 요청 클래스
    public class GetFamilyEventHoldListReqParam : DefaultReqParam
    {
        public int      intUserNo { get; set; }
    }


    #endregion
}