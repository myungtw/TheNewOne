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
    #endregion
    #region 가족 이벤트 세부 소속 조회
    //-------------------------------------------------------------
    /// <summary>
    /// 가족 이벤트 세부 소속 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Everyone, strRepresentMsg = strDefaultMsg)]
    private int SubCategoryLst(ReqFamilyEventDtl objReq, DefaultListResParam objRes, out string strErrMsg)
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

            pl_objDas.AddParam("@pi_intEventNo",        DBType.adBigInt,  objReq.intEventNo,        0,      ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intMasterCategory", DBType.adTinyInt, objReq.intMasterCategory, 0,      ParameterDirection.Input);
            pl_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger, DBNull.Value,             0,    ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_FAMILY_EVENTDTL_UR_LST");

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
                UtilLog.WriteLog("GetUserCurrentPwd", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // 가족 이벤트 보유 내역 조회 요청 클래스
    public class GetFamilyEventHoldListReqParam : DefaultReqParam
    {
        public int      intUserNo { get; set; }
    }

    // 가족 이벤트 보유 내역 조회 요청 클래스
    public class ReqFamilyEventDtl : DefaultReqParam
    {
        public Int64 intEventNo        { get; set; }
        public Int16 intMasterCategory { get; set; }
    }

    #endregion
}