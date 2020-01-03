<%@ WebHandler Language="C#" Class="SaleHandler" %>

using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

using BOQv7Das_Net;
using bill.payletter.com.CommonModule;
using bill.payletter.com.handler;

///================================================================
/// <summary>
/// FileName        : SaleHandler.ashx
/// Description     : 구매 이벤트 처리기
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author          : ejlee@payletter.com, 2019-08-28
/// Modify History  : just create.
/// </summary>
///================================================================
public class SaleHandler : AshxBaseHandler
{
    #region POS 결제/구매 로그 입력
    //-------------------------------------------------------------
    /// <summary>
    /// POS 결제/구매 로그 입력
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login)]
    private int InsPosLog(InsPosLogReqParam objReqParam, InsPosLogResParam objResParam, out string strErrMsg)
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

            pl_objDas.AddParam("@pi_intUserNo",             DBType.adInteger,   objSes.intUserNo,               0,                                  ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intStaffNo",            DBType.adInteger,   objSes.intUserNo,            0,                                  ParameterDirection.Input);
            pl_objDas.AddParam("@pi_strStaffID",            DBType.adVarChar,   objSes.strUserID,            50,                                 ParameterDirection.Input);

            pl_objDas.AddParam("@pi_strStaffName",          DBType.adVarWChar,  objSes.strUserName,          100,                                ParameterDirection.Input);
            //pl_objDas.AddParam("@pi_strBrandCode",          DBType.adVarChar,   UserGlobal.DEFAULT_BRANDCODE,       50,                                 ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intTotalOriginPrice",   DBType.adDouble,    objReqParam.intTotalOriginPrice,    0,                                  ParameterDirection.Input);

            pl_objDas.AddParam("@pi_intTotalDiscountAmt",   DBType.adDouble,    objReqParam.intTotalDiscountAmt,    0,                                  ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intTotalPurchasePrice", DBType.adDouble,    objReqParam.intTotalPurchasePrice,  0,                                  ParameterDirection.Input);
            pl_objDas.AddParam("@pi_strProductInfos",       DBType.adVarChar,   objReqParam.strProductInfos,        CommonDB.BOQ_DAS_STRING_MAX_SIZE,   ParameterDirection.Input);
            pl_objDas.AddParam("@pi_strProductDtlInfos",    DBType.adVarChar,   objReqParam.strProductDtlInfos,     CommonDB.BOQ_DAS_STRING_MAX_SIZE,   ParameterDirection.Input);
            pl_objDas.AddParam("@po_intPosOrderNo",         DBType.adBigInt,    DBNull.Value,                       0,                                  ParameterDirection.Output);

            pl_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                       256,                                ParameterDirection.Output);
            pl_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                       0,                                  ParameterDirection.Output);
            pl_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                       256,                                ParameterDirection.Output);
            pl_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                       0,                                  ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_POS_LOG_TX_INS");

            if (!pl_objDas.LastErrorCode.Equals(0))
            {
                pl_intRetVal = pl_objDas.LastErrorCode;
                strErrMsg    = pl_objDas.LastErrorMessage;
                return pl_intRetVal;
            }

            strErrMsg    = pl_objDas.GetParam("@po_strErrMsg");
            pl_intRetVal = Convert.ToInt32(pl_objDas.GetParam("@po_intRetVal"));
            if (!pl_intRetVal.Equals(0))
            {
                return pl_intRetVal;
            }

            objResParam.intPosOrderNo   = Convert.ToInt64(pl_objDas.GetParam("@po_intPosOrderNo"));
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
                UtilLog.WriteLog("InsPosLog", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // POS 결제/구매 로그 입력 요청 클래스
    public class InsPosLogReqParam : DefaultReqParam
    {
        public double   intTotalOriginPrice     { get; set; }
        public double   intTotalDiscountAmt     { get; set; }
        public double   intTotalPurchasePrice   { get; set; }
        public string   strProductInfos         { get; set; }
        public string   strProductDtlInfos      { get; set; }
    }

    // POS 결제/구매 로그 입력 응답 클래스
    public class InsPosLogResParam : DefaultResParam
    {
        public Int64    intPosOrderNo           { get; set; }
    }
    #endregion

    #region POS 결제/구매 로그 조회
    //-------------------------------------------------------------
    /// <summary>
    /// POS 주문 로그 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login)]
    private int GetPosLog(GetPosLogReqParam objReqParam, GetPosLogResParam objResParam, out string strErrMsg)
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

            pl_objDas.AddParam("@pi_intPosOrderNo",         DBType.adBigInt,    objReqParam.intPosOrderNo,          0,    ParameterDirection.Input);
            pl_objDas.AddParam("@pi_intUserNo",             DBType.adInteger,   objSes.intUserNo,               0,    ParameterDirection.Input);
            pl_objDas.AddParam("@po_intGChargeNo" ,         DBType.adBigInt,    DBNull.Value,                       0,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intSiteCode",           DBType.adTinyInt,   DBNull.Value,                       0,    ParameterDirection.Output);

            pl_objDas.AddParam("@po_intUserNo",             DBType.adInteger,   DBNull.Value,                       0,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_strUserID",             DBType.adVarChar,   DBNull.Value,                       50,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_intStaffNo",            DBType.adInteger,   DBNull.Value,                       0,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_strStaffID",            DBType.adVarChar,   DBNull.Value,                       50,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_intProNo",              DBType.adInteger,   DBNull.Value,                       0,    ParameterDirection.Output);

            pl_objDas.AddParam("@po_strBrandCode",          DBType.adVarChar,   DBNull.Value,                       50,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_strStoreCode",          DBType.adVarChar,   DBNull.Value,                       50,   ParameterDirection.Output);
            pl_objDas.AddParam("@po_strProductName",        DBType.adVarWChar,  DBNull.Value,                       100,  ParameterDirection.Output);
            pl_objDas.AddParam("@po_intTotalOriginPrice",   DBType.adDouble,    DBNull.Value,                       0,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intTotalDiscountAmt",   DBType.adDouble,    DBNull.Value,                       0,    ParameterDirection.Output);

            pl_objDas.AddParam("@po_intTotalPurchasePrice", DBType.adDouble,    DBNull.Value,                       0,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intPayProcessAmt",      DBType.adDouble,    DBNull.Value,                       0,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_intPayRemainAmt",       DBType.adDouble,    DBNull.Value,                       0,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_strPayYMD",             DBType.adChar,      DBNull.Value,                       8,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_strPosRsltCode",        DBType.adVarChar,   DBNull.Value,                       10,   ParameterDirection.Output);

            pl_objDas.AddParam("@po_strPosRsltMsg",         DBType.adVarWChar,  DBNull.Value,                       256,  ParameterDirection.Output);
            pl_objDas.AddParam("@po_intPosStateCode",       DBType.adTinyInt,   DBNull.Value,                       0,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                       256,  ParameterDirection.Output);
            pl_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                       0,    ParameterDirection.Output);
            pl_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                       256,  ParameterDirection.Output);

            pl_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                       0,    ParameterDirection.Output);

            pl_objDas.SetQuery("dbo.UP_POS_LOG_NT_GET");

            if (!pl_objDas.LastErrorCode.Equals(0))
            {
                pl_intRetVal = pl_objDas.LastErrorCode;
                strErrMsg    = pl_objDas.LastErrorMessage;
                return pl_intRetVal;
            }

            strErrMsg    = pl_objDas.GetParam("@po_strErrMsg");
            pl_intRetVal = Convert.ToInt32(pl_objDas.GetParam("@po_intRetVal"));
            if (!pl_intRetVal.Equals(0))
            {
                return pl_intRetVal;
            }

            objResParam.intGChargeNo            = Convert.ToInt64(pl_objDas.GetParam("@po_intGChargeNo"));
            objResParam.intSiteCode             = Convert.ToInt16(pl_objDas.GetParam("@po_intSiteCode"));
            objResParam.intUserNo               = Convert.ToInt32(pl_objDas.GetParam("@po_intUserNo"));
            objResParam.strUserID               = pl_objDas.GetParam("@po_strUserID");
            objResParam.intStaffNo              = Convert.ToInt32(pl_objDas.GetParam("@po_intStaffNo"));
            objResParam.strStaffID              = pl_objDas.GetParam("@po_strStaffID");
            objResParam.intProNo                = Convert.ToInt32(pl_objDas.GetParam("@po_intProNo"));
            objResParam.strBrandCode            = pl_objDas.GetParam("@po_strBrandCode");
            objResParam.strStoreCode            = pl_objDas.GetParam("@po_strStoreCode");
            objResParam.strProductName          = pl_objDas.GetParam("@po_strProductName");
            objResParam.intTotalOriginPrice     = Convert.ToDouble(pl_objDas.GetParam("@po_intTotalOriginPrice"));
            objResParam.intTotalDiscountAmt     = Convert.ToDouble(pl_objDas.GetParam("@po_intTotalDiscountAmt"));
            objResParam.intTotalPurchasePrice   = Convert.ToDouble(pl_objDas.GetParam("@po_intTotalPurchasePrice"));
            objResParam.intPayProcessAmt        = Convert.ToDouble(pl_objDas.GetParam("@po_intPayProcessAmt"));
            objResParam.intPayRemainAmt         = Convert.ToDouble(pl_objDas.GetParam("@po_intPayRemainAmt"));
            objResParam.strPayYMD               = pl_objDas.GetParam("@po_strPayYMD");
            objResParam.strPosRsltCode          = pl_objDas.GetParam("@po_strPosRsltCode");
            objResParam.strPosRsltMsg           = pl_objDas.GetParam("@po_strPosRsltMsg");
            objResParam.intPosStateCode         = Convert.ToInt16(pl_objDas.GetParam("@po_intPosStateCode"));

            //상품 내역
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
                UtilLog.WriteLog("GetPosLog", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // POS 주문 로그 입력 요청 클래스
    public class GetPosLogReqParam : DefaultReqParam
    {
        public Int64    intPosOrderNo           { get; set; }
    }

    // POS 주문 로그 입력 응답 클래스
    public class GetPosLogResParam : DefaultListResParam
    {
        public Int64    intGChargeNo            { get; set; }
        public Int16    intSiteCode             { get; set; }
        public int      intUserNo               { get; set; }
        public string   strUserID               { get; set; }
        public int      intStaffNo              { get; set; }
        public string   strStaffID              { get; set; }
        public int      intProNo                { get; set; }
        public string   strBrandCode            { get; set; }
        public string   strStoreCode            { get; set; }
        public string   strProductName          { get; set; }
        public double   intTotalOriginPrice     { get; set; }
        public double   intTotalDiscountAmt     { get; set; }
        public double   intTotalPurchasePrice   { get; set; }
        public double   intPayProcessAmt        { get; set; }
        public double   intPayRemainAmt         { get; set; }
        public string   strPayYMD               { get; set; }
        public string   strPosRsltCode          { get; set; }
        public string   strPosRsltMsg           { get; set; }
        public Int16    intPosStateCode         { get; set; }
    }

    //-------------------------------------------------------------
    /// <summary>
    /// POS PG 결제 완료 내역 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login)]
    private int GetPosPayCompleteList(PosPayCompleteListReqParam objReqParam, DefaultListResParam objResParam, out string strErrMsg)
    {
        int       pl_intRetVal = 0;
        DataTable pl_objDT     = null;

        strErrMsg = string.Empty;

        try
        {
            //POS PG 결제 완료 내역 조회
            pl_intRetVal = CommonDB.GetPayCompleteList(objReqParam.intPosOrderNo, out pl_objDT, out strErrMsg);

            objResParam.intRowCnt = pl_objDT.Rows.Count;
            objResParam.objDT = pl_objDT;
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15215;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
            if (!pl_intRetVal.Equals(0))
            {
                UtilLog.WriteLog("GetPosPayCompleteList", pl_intRetVal, strErrMsg);
            }
        }

        return pl_intRetVal;
    }

    // POS PG 결제 완료 내역 조회 요청 클래스
    public class PosPayCompleteListReqParam : DefaultReqParam
    {
        public Int64    intPosOrderNo           { get; set; }
    }
    #endregion

}