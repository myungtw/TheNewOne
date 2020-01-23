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
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login)]
    private int GetMyFamilyEventHoldList(DefaultReqParam objReqParam, DefaultListResParam objResParam, out string strErrMsg)
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

            pl_objDas.AddParam("@pi_intUserNo",     DBType.adInteger,   objSes.intUserNo,  0,  ParameterDirection.Input);
            pl_objDas.AddParam("@po_intRecordCnt",  DBType.adInteger,   DBNull.Value,      0,  ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_MY_FAMILY_EVENT_HOLD_UR_LST");

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
                UtilLog.WriteLog("GetMyFamilyEventHoldList", pl_intRetVal, strErrMsg);
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
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login, strRepresentMsg = strDefaultMsg)]
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
            pl_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger, DBNull.Value,             0,      ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_FAMILY_EVENT_JOIN_SUBCATEGORY_UR_LST");

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

    //-------------------------------------------------------------
    /// <summary>
    /// 가족 이벤트 메인 소속 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login, strRepresentMsg = strDefaultMsg)]
    private int MstCategoryLst(ReqFamilyEventDtl objReq, DefaultListResParam objRes, out string strErrMsg)
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

            pl_objDas.AddParam("@pi_intEventNo",   DBType.adBigInt,  objReq.intEventNo, 0, ParameterDirection.Input);
            pl_objDas.AddParam("@po_intRecordCnt", DBType.adInteger, DBNull.Value,      0, ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_FAMILY_EVENT_JOIN_MSTCATEGORY_UR_LST");

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

    //-------------------------------------------------------------
    /// <summary>
    /// 가족 이벤트 정보 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login, strRepresentMsg = strDefaultMsg)]
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

            pl_objDas.AddParam("@pi_intFamilyEventNo",       DBType.adBigInt,      objReqParam.intFamilyEventNo,   0,      ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intUserNo",              DBType.adInteger,     objSes.intUserNo,               0,      ParameterDirection.Input);
            pl_objDas.AddParam("@po_intFamilyEventCode",     DBType.adTinyInt,     DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_strFamilyEventName",     DBType.adVarWChar,    DBNull.Value,                   200,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intHallNo",              DBType.adInteger,     DBNull.Value,                   0,      ParameterDirection.Output);

            pl_objDas.AddParam("@po_strHallName",            DBType.adVarWChar,    DBNull.Value,                   200,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_strHallAddress",         DBType.adVarWChar,    DBNull.Value,                   500,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_strHallPhoneNo",         DBType.adVarChar,     DBNull.Value,                   100,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intRoomNo",              DBType.adInteger,     DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_strRoomName",            DBType.adVarWChar,    DBNull.Value,                   200,    ParameterDirection.Output);

            pl_objDas.AddParam("@po_strRoomImgUrl",          DBType.adVarWChar,    DBNull.Value,                   200,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_strFamilyEventDate",     DBType.adVarWChar,    DBNull.Value,                   19,     ParameterDirection.Output);
            pl_objDas.AddParam("@po_strDisplayStartDate",    DBType.adVarWChar,    DBNull.Value,                   19,     ParameterDirection.Output);
            pl_objDas.AddParam("@po_strDisplayEndDate",      DBType.adVarWChar,    DBNull.Value,                   19,     ParameterDirection.Output);
            pl_objDas.AddParam("@po_intHostUserNo",          DBType.adInteger,     DBNull.Value,                   0,      ParameterDirection.Output);

            pl_objDas.AddParam("@po_intAdminNo",             DBType.adInteger,     DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_intStateCode",           DBType.adTinyInt,     DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_mnyMinPayAmt",           DBType.adVarWChar,    DBNull.Value,                   100,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intMaxFoodTicket",       DBType.adInteger,     DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_intMaxParkingTicket",    DBType.adInteger,     DBNull.Value,                   0,      ParameterDirection.Output);

            pl_objDas.AddParam("@po_intJoinMstCategory",     DBType.adTinyInt,     DBNull.Value,                   0,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_strRegDate",             DBType.adVarChar,     DBNull.Value,                   19,     ParameterDirection.Output);
            pl_objDas.AddParam("@po_strUpdDate",             DBType.adVarChar,     DBNull.Value,                   19,     ParameterDirection.Output);
            pl_objDas.AddParam("@po_strErrMsg",              DBType.adVarChar,     DBNull.Value,                   256,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intRetVal",              DBType.adInteger,     DBNull.Value,                   4,      ParameterDirection.Output);

            pl_objDas.AddParam("@po_strDBErrMsg",            DBType.adVarChar,     DBNull.Value,                   256,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intDBRetVal",            DBType.adInteger,     DBNull.Value,                   4,      ParameterDirection.Output);

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
            objResParam.intHallNo            = Convert.ToInt32(pl_objDas.GetParam("@po_intHallNo"));

            objResParam.strHallName          = pl_objDas.GetParam("@po_strHallName");
            objResParam.strHallAddress       = pl_objDas.GetParam("@po_strHallAddress");
            objResParam.strHallPhoneNo       = pl_objDas.GetParam("@po_strHallPhoneNo");
            objResParam.intRoomNo            = Convert.ToInt32(pl_objDas.GetParam("@po_intRoomNo"));
            objResParam.strRoomName          = pl_objDas.GetParam("@po_strRoomName");

            objResParam.strRoomImgUrl        = pl_objDas.GetParam("@po_strRoomImgUrl");
            objResParam.strFamilyEventDate   = pl_objDas.GetParam("@po_strFamilyEventDate");
            objResParam.strDisplayStartDate  = pl_objDas.GetParam("@po_strDisplayStartDate");
            objResParam.strDisplayEndDate    = pl_objDas.GetParam("@po_strDisplayEndDate");
            objResParam.intHostUserNo        = pl_objDas.GetParam("@po_intHostUserNo");

            objResParam.intAdminNo           = Convert.ToInt32(pl_objDas.GetParam("@po_intAdminNo"));
            objResParam.intStateCode         = Convert.ToInt16(pl_objDas.GetParam("@po_intStateCode"));
            objResParam.strRegDate           = pl_objDas.GetParam("@po_strRegDate");
            objResParam.strUpdDate           = pl_objDas.GetParam("@po_strUpdDate");
            objResParam.mnyMinPayAmt         = String.Format("{0:#,###}", Convert.ToDouble(pl_objDas.GetParam("@po_mnyMinPayAmt")));

            objResParam.intMaxFoodTicket     = Convert.ToInt32(pl_objDas.GetParam("@po_intMaxFoodTicket"));
            objResParam.intMaxParkingTicket  = Convert.ToInt32(pl_objDas.GetParam("@po_intMaxParkingTicket"));
            objResParam.intJoinMstCategory   = Convert.ToInt32(pl_objDas.GetParam("@po_intJoinMstCategory"));
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
        public int    intMaxFacilityTicket { get; set; }
        public int    intAdminNo           { get; set; }
        public int    intStateCode         { get; set; }
        public string strRegDate           { get; set; }
        public string strUpdDate           { get; set; }
        public int    intRoomNo            { get; set; }
        public string strRoomName          { get; set; }
        public string strRoomImgUrl        { get; set; }
        public string strDisplayStartDate  { get; set; }
        public string strDisplayEndDate    { get; set; }
        public string intHostUserNo        { get; set; }
        public string mnyMinPayAmt         { get; set; }
        public int    intMaxParkingTicket  { get; set; }
        public int    intMaxFoodTicket     { get; set; }
        public int    intJoinMstCategory   { get; set; }
    }

    // 가족 이벤트 보유 내역 조회 요청 클래스
    public class ReqFamilyEventDtl : DefaultReqParam
    {
        public Int64 intEventNo        { get; set; }
        public Int16 intMasterCategory { get; set; }
    }
    #endregion

    #region 이벤트 정보 수정
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login, strRepresentMsg = strDefaultMsg)]
    private int UpdFamilyEventInfo(UpdFamilyEventInfoReqParam objReqParam, DefaultResParam objResParam, out string strErrMsg)
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

            pl_objDas.AddParam("@pi_intFamilyEventNo",         DBType.adBigInt,      objReqParam.intFamilyEventNo,         0,      ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intUserNo",                DBType.adInteger,     objSes.intUserNo,                     0,      ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intLimitPolicyType",       DBType.adTinyInt,     objReqParam.intLimitPolicyType,       0,      ParameterDirection.Input);
            pl_objDas.AddParam("@pi_strLimitPolicyVal",        DBType.adVarWChar,    objReqParam.strLimitPolicyVal,        100,    ParameterDirection.Input);
            pl_objDas.AddParam("@pi_strLimitPolicyName",       DBType.adVarWChar,    objReqParam.strLimitPolicyName,       200,    ParameterDirection.Input);

            pl_objDas.AddParam("@pi_intFacilityTicketType",    DBType.adTinyInt,     objReqParam.intFacilityTicketType,    0,      ParameterDirection.Input);
            pl_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar,     DBNull.Value,                         256,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intRetVal",                DBType.adInteger,     DBNull.Value,                         4,      ParameterDirection.Output);
            pl_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar,     DBNull.Value,                         256,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger,     DBNull.Value,                         4,      ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_FAMILY_EVENT_LIMITPOLICY_TX_UPD");

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
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15220;
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
                UtilLog.WriteLog("UpdFamilyEventInfo", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // 가족 이벤트 정보 수정 요청 클래스
    public class UpdFamilyEventInfoReqParam : DefaultReqParam
    {
        public int    intFamilyEventNo      { get; set; }
        public Int16  intLimitPolicyType    { get; set; }
        public Int16  intFacilityTicketType { get; set; }
        public string strLimitPolicyVal     { get; set; }
        public string strLimitPolicyName    { get; set; }
    }

    #endregion

    #region 시설이용권 발급
    //-------------------------------------------------------------
    /// <summary>
    /// 시설이용권 발급
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login)]
    private int InsFacilityTicket(ReqInsFacilityTicketParam objReq, DefaultResParam objRes, out string strErrMsg)
    {
        int  pl_intRetVal   = 0;
        IDas pl_objDas      = null;
        strErrMsg           = string.Empty;

        try
        {
            //시설이용권 발급
            pl_objDas = new IDas();
            pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage = 0;

            pl_objDas.AddParam("@pi_intUserNo",                   DBType.adInteger,    DBNull.Value,                       0,     ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intUserID",                   DBType.adVarChar,    objReq.strUserID,                   50,    ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intFacilityTicketType",       DBType.adTinyInt,    objReq.intFacilityTicketType,       0,     ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intFacilityTicketAmount",     DBType.adInteger,    objReq.intFacilityTicketAmount,     0,     ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intFacilityTicketRegType",    DBType.adTinyInt,    objReq.intFacilityTicketRegType,    0,     ParameterDirection.Input);
                                                                                                                                  
            pl_objDas.AddParam("@pi_intFamilyEventNo",            DBType.adBigInt,     objReq.intFamilyEventNo,            0,     ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intJoinMstCategory",          DBType.adInteger,    objReq.intJoinMstCategory,          0,     ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intAdminNo",                  DBType.adInteger,    objSes.intUserNo,                   0,     ParameterDirection.Input);
            pl_objDas.AddParam("@po_strErrMsg",                   DBType.adVarChar,    DBNull.Value,                       256,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_intRetVal",                   DBType.adInteger,    DBNull.Value,                       0,     ParameterDirection.Output);

            pl_objDas.AddParam("@po_strDBErrMsg",                 DBType.adVarChar,    DBNull.Value,                       256,   ParameterDirection.Output);                                                                                                                                  
            pl_objDas.AddParam("@po_intDBRetVal",                 DBType.adInteger,    DBNull.Value,                       0,     ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_FACILITY_TICKET_TX_INS");
            if (!pl_objDas.LastErrorCode.Equals(0))
            {
                pl_intRetVal = pl_objDas.LastErrorCode;
                strErrMsg    = pl_objDas.LastErrorMessage;
                return pl_intRetVal;
            }

            strErrMsg    = pl_objDas.GetParam("@po_strErrMsg");
            pl_intRetVal = Convert.ToInt32(pl_objDas.GetParam("@po_intRetVal"));
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15230;
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
                UtilLog.WriteLog("InsFacilityTicket", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // 시설이용권 발급 요청 클래스
    public class ReqInsFacilityTicketParam : DefaultReqParam
    {
        public string strUserID                 { get; set; }
        public Int16 intFacilityTicketType      { get; set; }
        public int   intFacilityTicketAmount    { get; set; }
        public Int16 intFacilityTicketRegType   { get; set; }
        public Int64 intFamilyEventNo           { get; set; }
        public int   intJoinMstCategory         { get; set; }
    }
    #endregion
    
    #region 초대받은 이벤트 조회
    //-------------------------------------------------------------
    /// <summary>
    /// 초대받은 이벤트 보유 내역 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login)]
    private int GetInvitedFamilyEventHoldList(DefaultReqParam objReqParam, DefaultListResParam objResParam, out string strErrMsg)
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

            pl_objDas.AddParam("@pi_intUserNo",     DBType.adInteger,   objSes.intUserNo,  0,  ParameterDirection.Input);
            pl_objDas.AddParam("@po_intRecordCnt",  DBType.adInteger,   DBNull.Value,      0,  ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_INVITED_FAMILY_EVENT_HOLD_UR_LST");

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
                UtilLog.WriteLog("GetInvitedFamilyEventHoldList", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }
    #endregion
}