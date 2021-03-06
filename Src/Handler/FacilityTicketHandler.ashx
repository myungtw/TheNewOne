﻿<%@ WebHandler Language="C#" Class="FacilityTicketHandler" %>

using System;
using System.Data;

using bill.payletter.com.CommonModule;
using bill.payletter.com.handler;
using BOQv7Das_Net;

///================================================================
/// <summary>
/// FileName        : FacilityTicketHandler.ashx
/// Description     : 시설이용권 이벤트 처리기
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author          : tumyeong@payletter.com, 2020-01-15
/// Modify History  : just create.
/// </summary>
///================================================================
public class FacilityTicketHandler : AshxBaseHandler
{
    #region 시설이용권 보유 내역 조회
    //-------------------------------------------------------------
    /// <summary>
    /// 시설이용권 보유 내역 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login, strRepresentMsg = strDefaultMsg)]
    private int GetFacilityTicketList(ReqFacilityTicketListParam objReq, DefaultListResParam objRes, out string strErrMsg)
    {
        int  pl_intRetVal = 0;
        IDas pl_objDas    = null;
        strErrMsg         = string.Empty;

        try
        {
            //시설이용권 보유 내역 조회
            pl_objDas = new IDas();
            pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage = 0;

            pl_objDas.AddParam("@pi_intUserNo",         DBType.adInteger,   objSes.intUserNo,        0, ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intFamilyEventNo",  DBType.adBigInt,    objReq.intFamilyEventNo, 0, ParameterDirection.Input);
            pl_objDas.AddParam("@po_intRecordCnt",      DBType.adInteger,   DBNull.Value,            0, ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_FACILITY_TICKET_HOLD_UR_LST");

            if (!pl_objDas.LastErrorCode.Equals(0))
            {
                pl_intRetVal = pl_objDas.LastErrorCode;
                strErrMsg    = pl_objDas.LastErrorMessage;
                return pl_intRetVal;
            }
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
                UtilLog.WriteLog("GetFacilityTicketList", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // 시설이용권 보유 내역 조회 요청 클래스
    public class ReqFacilityTicketListParam : DefaultReqParam
    {
        public int      intFamilyEventNo { get; set; }
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

            pl_objDas.AddParam("@pi_intUserNo",                DBType.adInteger, objSes.intUserNo,                  0,   ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intUserID",                DBType.adVarChar, DBNull.Value,                      0,   ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intFacilityTicketType",    DBType.adTinyInt, objReq.intFacilityTicketType,      0,   ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intFacilityTicketAmount",  DBType.adInteger, objReq.intFacilityTicketAmount,    0,   ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intFacilityTicketRegType", DBType.adTinyInt, objReq.intFacilityTicketRegType,   0,   ParameterDirection.Input);

            pl_objDas.AddParam("@pi_intFamilyEventNo",         DBType.adBigInt,  objReq.intFamilyEventNo,           0,   ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intJoinMstCategory",       DBType.adInteger, objReq.intJoinMstCategory,         0,   ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intAdminNo",               DBType.adInteger, objSes.intUserNo,                  0,   ParameterDirection.Input);
            pl_objDas.AddParam("@po_strErrMsg",                DBType.adVarChar, DBNull.Value,                      256, ParameterDirection.Output);
            pl_objDas.AddParam("@po_intRetVal",                DBType.adInteger, DBNull.Value,                      0,   ParameterDirection.Output);

            pl_objDas.AddParam("@po_strDBErrMsg",              DBType.adVarChar, DBNull.Value,                      256, ParameterDirection.Output);
            pl_objDas.AddParam("@po_intDBRetVal",              DBType.adInteger, DBNull.Value,                      0,   ParameterDirection.Output);

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
                UtilLog.WriteLog("InsFacilityTicket", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // 시설이용권 발급 요청 클래스
    public class ReqInsFacilityTicketParam : DefaultReqParam
    {
        public Int16 intFacilityTicketType      { get; set; }
        public int   intFacilityTicketAmount    { get; set; }
        public Int16 intFacilityTicketRegType   { get; set; }
        public Int64 intFamilyEventNo           { get; set; }
        public int   intJoinMstCategory         { get; set; }
    }
    #endregion


    #region 시설이용권 사용 처리
    //-------------------------------------------------------------
    /// <summary>
    /// 시설이용권 사용
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login)]
    private int UseFacilityTicket(ReqUseFacilityTicketParam objReq, DefaultResParam objRes, out string strErrMsg)
    {
        int  pl_intRetVal = 0;
        IDas pl_objDas = null;
        strErrMsg         = string.Empty;
        try
        {
            //시설이용권 사용
            pl_objDas = new IDas();
            pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage = 0;

            pl_objDas.AddParam("@pi_intUserNo",            DBType.adInteger, objSes.intUserNo,              0,   ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intFacilityTicketNo",  DBType.adBigInt,  objReq.intFacilityTicketNo,    0,   ParameterDirection.Input);
            pl_objDas.AddParam("@po_strErrMsg",            DBType.adVarChar, DBNull.Value,                  256, ParameterDirection.Output);
            pl_objDas.AddParam("@po_intRetVal",            DBType.adInteger, DBNull.Value,                  0,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_strDBErrMsg",          DBType.adVarChar, DBNull.Value,                  256, ParameterDirection.Output);

            pl_objDas.AddParam("@po_intDBRetVal",          DBType.adInteger, DBNull.Value,                  0,   ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_FACILITY_TICKET_TX_USE");
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
                UtilLog.WriteLog("UseFacilityTicket", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // 시설이용권 사용 요청 클래스
    public class ReqUseFacilityTicketParam : DefaultReqParam
    {
        public Int64 intFacilityTicketNo { get; set; }
    }
    #endregion


    #region 시설이용권 갯수 조회
    //-------------------------------------------------------------
    /// <summary>
    /// 시설이용권 사용
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login, strRepresentMsg = strDefaultMsg)]
    private int GetFacilityCnt(ReqGetFacilityCntParam objReq, ResGetFacilityCntParam objRes, out string strErrMsg)
    {
        int  pl_intRetVal = 0;
        IDas pl_objDas = null;
        strErrMsg         = string.Empty;
        try
        {
            //시설이용권 사용
            pl_objDas = new IDas();
            pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
            pl_objDas.CommandType = CommandType.StoredProcedure;
            pl_objDas.CodePage = 0;

            pl_objDas.AddParam("@pi_intUserNo",        DBType.adInteger,  objSes.intUserNo,        0,   ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intFamilyEventNo", DBType.adBigInt,   objReq.intFamilyEventNo, 0,   ParameterDirection.Input);
            pl_objDas.AddParam("@po_intParkCurrCnt",   DBType.adInteger,  DBNull.Value,            0,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_intParkMaxCnt",    DBType.adInteger,  DBNull.Value,            0,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_intFoodCurrCnt",   DBType.adInteger,  DBNull.Value,            0,   ParameterDirection.Output);

            pl_objDas.AddParam("@po_intFoodMaxCnt",    DBType.adInteger,  DBNull.Value,            0,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_strRoomImgUrl",    DBType.adVarChar,  DBNull.Value,            200, ParameterDirection.Output);
            pl_objDas.AddParam("@po_strEventName",     DBType.adVarWChar, DBNull.Value,            200, ParameterDirection.Output);
            pl_objDas.SetQuery("dbo.UP_FACILITY_TICKET_HOLDCNT_GET");
            if (!pl_objDas.LastErrorCode.Equals(0))
            {
                pl_intRetVal = pl_objDas.LastErrorCode;
                strErrMsg    = pl_objDas.LastErrorMessage;
                return pl_intRetVal;
            }

            objRes.intRowCnt = pl_objDas.RecordCount;
            objRes.objDT     = pl_objDas.objDT;

            objRes.intParkCurrCnt = Convert.ToInt32(pl_objDas.GetParam("@po_intParkCurrCnt"));
            objRes.intParkMaxCnt  = Convert.ToInt32(pl_objDas.GetParam("@po_intParkMaxCnt"));
            objRes.intFoodCurrCnt = Convert.ToInt32(pl_objDas.GetParam("@po_intFoodCurrCnt"));
            objRes.intFoodMaxCnt  = Convert.ToInt32(pl_objDas.GetParam("@po_intFoodMaxCnt"));
            objRes.strRoomImgUrl  = pl_objDas.GetParam("@po_strRoomImgUrl");
            objRes.strEventName   = pl_objDas.GetParam("@po_strEventName");
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
                UtilLog.WriteLog("UseFacilityTicket", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // 시설이용권 갯수 요청 클래스
    public class ReqGetFacilityCntParam : DefaultReqParam
    {
        public Int64 intFamilyEventNo { get; set; }
    }
    // 시설이용권 갯수 응답 클래스
    public class ResGetFacilityCntParam : DefaultListResParam
    {
        public int    intParkCurrCnt { get; set; }
        public int    intParkMaxCnt  { get; set; }
        public int    intFoodCurrCnt { get; set; }
        public int    intFoodMaxCnt  { get; set; }
        public string strRoomImgUrl  { get; set; }
        public string strEventName   { get; set; }
    }
    #endregion
}