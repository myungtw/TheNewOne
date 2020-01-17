<%@ WebHandler Language="C#" Class="FamilyEventHandler" %>

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
        IDas pl_objDas    = null;

        strErrMsg = string.Empty;

        try
        {
            pl_objDas = new IDas();
            pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage = 0;

            pl_objDas.AddParam("@pi_intUserNo",     DBType.adInteger,   objReqParam.intUserNo,  0,  ParameterDirection.Input);
            pl_objDas.AddParam("@po_intRecordCnt",  DBType.adInteger,   DBNull.Value,           0,  ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_FAMILY_EVENT_HOLD_UR_LST");

            if (!pl_objDas.LastErrorCode.Equals(0))
            {
                pl_intRetVal = pl_objDas.LastErrorCode;
                strErrMsg    = pl_objDas.LastErrorMessage;
                return pl_intRetVal;
            }

            objResParam.intRowCnt = pl_objDas.RecordCount;
            objResParam.objDT     = pl_objDas.objDT;
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15214;
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
                UtilLog.WriteLog("GetFamilyEventHoldList", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // 가족 이벤트 보유 내역 조회 요청 클래스
    public class GetFamilyEventHoldListReqParam : DefaultReqParam
    {
        public int intUserNo { get; set; }
    }

    //-------------------------------------------------------------
    /// <summary>
    /// 가족 이벤트 정보 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Everyone, strRepresentMsg = strDefaultMsg)]
    private int GetFamilyEventInfo(GetFamilyEventInfoReqParam objReqParam, GetFamilyEventInfoResParam objResParam, out string strErrMsg)
    {
        int  pl_intRetVal = 0;
        IDas pl_objDas    = null;

        strErrMsg = string.Empty;

        try
        {
            pl_objDas = new IDas();
            pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage = 0;

            pl_objDas.AddParam("@pi_intFamilyEventNo",      DBType.adBigInt,    objReqParam.intFamilyEventNo,   0,      ParameterDirection.Input);
            pl_objDas.AddParam("@po_intFamilyEventCode",    DBType.adTinyInt,   DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_strFamilyEventName",    DBType.adVarWChar,  DBNull.Value,                   200,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intGroomUserNo",        DBType.adInteger,   DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_intBrideUserNo",        DBType.adInteger,   DBNull.Value,                   0,      ParameterDirection.Output);

            pl_objDas.AddParam("@po_intHallNo",             DBType.adInteger,   DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_intHallDtlNo",          DBType.adInteger,   DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_strHallName",           DBType.adVarWChar,  DBNull.Value,                   200,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_strHallAddress",        DBType.adVarWChar,  DBNull.Value,                   500,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_strHallPhoneNo",        DBType.adVarChar,   DBNull.Value,                   100,    ParameterDirection.Output);

            pl_objDas.AddParam("@po_strFamilyEventDate",    DBType.adVarChar,   DBNull.Value,                   19,     ParameterDirection.Output);
            pl_objDas.AddParam("@po_strStartDate",          DBType.adVarChar,   DBNull.Value,                   19,     ParameterDirection.Output);
            pl_objDas.AddParam("@po_strEndDate",            DBType.adVarChar,   DBNull.Value,                   19,     ParameterDirection.Output);
            pl_objDas.AddParam("@po_intMinAmount",          DBType.adInteger,   DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_intMaxFacilityTicket",  DBType.adInteger,   DBNull.Value,                   0,      ParameterDirection.Output);

            pl_objDas.AddParam("@po_intAdminNo",            DBType.adInteger,   DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_intStateCode",          DBType.adTinyInt,   DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_strRegDate",            DBType.adVarChar,   DBNull.Value,                   19,     ParameterDirection.Output);
            pl_objDas.AddParam("@po_strUpdDate",            DBType.adVarChar,   DBNull.Value,                   19,     ParameterDirection.Output);

            pl_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                   256,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                   4,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                   256,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                   4,      ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_FAMILY_EVENT_INFO_NT_GET");

            if (!pl_objDas.LastErrorCode.Equals(0))
            {
                pl_intRetVal = pl_objDas.LastErrorCode;
                strErrMsg    = pl_objDas.LastErrorMessage;
                return pl_intRetVal;
            }

            pl_intRetVal = Convert.ToInt32(pl_objDas.GetParam("@po_intRetVal"));
            if (!pl_intRetVal.Equals(0))
            {
                strErrMsg = pl_objDas.GetParam("@po_strErrMsg");
                return pl_intRetVal;
            }

            objResParam.intFamilyEventNo     = objReqParam.intFamilyEventNo;
            objResParam.intFamilyEventCode   = Convert.ToInt16(pl_objDas.GetParam("@po_intFamilyEventCode"));
            objResParam.strFamilyEventName   = pl_objDas.GetParam("@po_strFamilyEventName");
            objResParam.intGroomUserNo       = Convert.ToInt32(pl_objDas.GetParam("@po_intGroomUserNo"));
            objResParam.intBrideUserNo       = Convert.ToInt32(pl_objDas.GetParam("@po_intBrideUserNo"));
            objResParam.intHallNo            = Convert.ToInt32(pl_objDas.GetParam("@po_intHallNo"));
            objResParam.intHallDtlNo         = Convert.ToInt32(pl_objDas.GetParam("@po_intHallDtlNo"));
            objResParam.strHallName          = pl_objDas.GetParam("@po_strHallName");
            objResParam.strHallAddress       = pl_objDas.GetParam("@po_strHallAddress");
            objResParam.strHallPhoneNo       = pl_objDas.GetParam("@po_strHallPhoneNo");
            objResParam.strFamilyEventDate   = pl_objDas.GetParam("@po_strFamilyEventDate");
            objResParam.strStartDate         = pl_objDas.GetParam("@po_strStartDate");
            objResParam.strEndDate           = pl_objDas.GetParam("@po_strEndDate");
            objResParam.intMinAmount         = Convert.ToDouble(pl_objDas.GetParam("@po_intMinAmount"));
            objResParam.intMaxFacilityTicket = Convert.ToInt32(pl_objDas.GetParam("@po_intMaxFacilityTicket"));
            objResParam.intAdminNo           = Convert.ToInt32(pl_objDas.GetParam("@po_intAdminNo"));
            objResParam.intStateCode         = Convert.ToInt16(pl_objDas.GetParam("@po_intStateCode"));
            objResParam.strRegDate           = pl_objDas.GetParam("@po_strRegDate");
            objResParam.strUpdDate           = pl_objDas.GetParam("@po_strUpdDate");
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15214;
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
                UtilLog.WriteLog("GetFamilyEventInfo", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // 가족 이벤트 정보 조회 요청 클래스
    public class GetFamilyEventInfoReqParam : DefaultReqParam
    {
        public int   intFamilyEventNo     { get; set; }
    }

    // 가족 이벤트 정보 조회 응답 클래스
    public class GetFamilyEventInfoResParam : DefaultResParam
    {
        public int    intFamilyEventNo     { get; set; }
        public int    intFamilyEventCode   { get; set; }
        public string strFamilyEventName   { get; set; }
        public int    intGroomUserNo       { get; set; }
        public int    intBrideUserNo       { get; set; }
        public int    intHallNo            { get; set; }
        public int    intHallDtlNo         { get; set; }
        public string strHallName          { get; set; }
        public string strHallAddress       { get; set; }
        public string strHallPhoneNo       { get; set; }
        public string strFamilyEventDate   { get; set; }
        public string strStartDate         { get; set; }
        public string strEndDate           { get; set; }
        public double intMinAmount         { get; set; }
        public int    intMaxFacilityTicket { get; set; }
        public int    intAdminNo           { get; set; }
        public int    intStateCode         { get; set; }
        public string strRegDate           { get; set; }
        public string strUpdDate           { get; set; }
    }




    #endregion
}