using System;
using System.Data;

using BOQv7Das_Net;

//================================================================
// FileName        : CommonDB.cs
// Description     : 공통 DB 호출
// Copyright       : 2019 by PayLetter Inc. All rights reserved.
// Author          : tumyeong@payletter.com, 2019-08-26
// Modify History  : Just Created.
//================================================================
namespace bill.payletter.com.CommonModule
{
    public class CommonDB
    {
        public const int BOQ_DAS_STRING_MAX_SIZE = 8196;

        public CommonDB()
        {

        }

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// 상품 조회, 2019-09-19
        /// </summary>
        /// <param name="intSeqNo"></param>
        /// <param name="strModuleName"></param>
        /// <param name="pl_objDT"></param>
        /// <param name="pl_strErrMsg"></param>
        /// <returns></returns>
        ///----------------------------------------------------------------------------------
        public static int GetProductList(string strStoreCode, string strCashAttrCode, int intProductTypeCode, out DataTable objDT, out string strErrMsg)
        {
            int  pl_intRetVal = 0;
            IDas pl_objDas    = null;

            strErrMsg = "OK";
            objDT = null;

            try
            {
                pl_objDas             = new IDas();
                pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDas.CommandType = CommandType.StoredProcedure;
                pl_objDas.CodePage    = 0;
                
                pl_objDas.AddParam("@pi_strStoreCode",          DBType.adVarChar, strStoreCode,         50,  ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strCashAttrCode",       DBType.adVarChar, strCashAttrCode,      15,  ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intProductTypeCode",    DBType.adTinyInt, intProductTypeCode,   0,   ParameterDirection.Input);
                pl_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar, DBNull.Value,         256, ParameterDirection.Output);
                pl_objDas.AddParam("@po_intRetVal",             DBType.adInteger, DBNull.Value,         0,   ParameterDirection.Output);

                pl_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar, DBNull.Value,         256, ParameterDirection.Output);
                pl_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger, DBNull.Value,         0,   ParameterDirection.Output);

                pl_objDas.SetQuery("dbo.UP_POS_PRODUCT_UR_LST");
                
                if (!pl_objDas.LastErrorCode.Equals(0))
                {
                    pl_intRetVal = pl_objDas.LastErrorCode;
                    strErrMsg    = pl_objDas.LastErrorMessage;
                    return pl_intRetVal;
                }

                objDT = new DataTable();
                objDT = pl_objDas.objDT;
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15701;
                strErrMsg    = "상품 목록 조회 실패";
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                if(pl_objDas != null)
                {
                    pl_objDas.Close();
                    pl_objDas = null;
                }
            }

            return pl_intRetVal;
        }

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// 상품 조회, 2019-09-19
        /// </summary>
        /// <param name="intSeqNo"></param>
        /// <param name="strModuleName"></param>
        /// <param name="pl_objDT"></param>
        /// <param name="pl_strErrMsg"></param>
        /// <returns></returns>
        ///----------------------------------------------------------------------------------
        public static int GetGuestProductList(string strStoreCode, string strCashAttrCode, int intProductTypeCode, out DataTable objDT, out string strErrMsg)
        {
            int  pl_intRetVal = 0;
            IDas pl_objDas    = null;

            strErrMsg = "OK";
            objDT = null;

            try
            {
                pl_objDas             = new IDas();
                pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDas.CommandType = CommandType.StoredProcedure;
                pl_objDas.CodePage    = 0;
                
                pl_objDas.AddParam("@pi_strStoreCode",          DBType.adVarChar, strStoreCode,         50,  ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strCashAttrCode",       DBType.adVarChar, strCashAttrCode,      15,  ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intProductTypeCode",    DBType.adTinyInt, intProductTypeCode,   0,   ParameterDirection.Input);                                                                
                pl_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar, DBNull.Value,         256, ParameterDirection.Output);
                pl_objDas.AddParam("@po_intRetVal",             DBType.adInteger, DBNull.Value,         0,   ParameterDirection.Output);

                pl_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar, DBNull.Value,         256, ParameterDirection.Output);
                pl_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger, DBNull.Value,         0,   ParameterDirection.Output);

                pl_objDas.SetQuery("dbo.UP_POS_GUEST_PRODUCT_UR_LST");
                
                if (!pl_objDas.LastErrorCode.Equals(0))
                {
                    pl_intRetVal = pl_objDas.LastErrorCode;
                    strErrMsg    = pl_objDas.LastErrorMessage;
                    return pl_intRetVal;
                }

                objDT = new DataTable();
                objDT = pl_objDas.objDT;
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15702;
                strErrMsg    = "상품 목록 조회 실패";
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                if(pl_objDas != null)
                {
                    pl_objDas.Close();
                    pl_objDas = null;
                }
            }

            return pl_intRetVal;
        }

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// 단말기 조회, 2019-09-19
        /// </summary>
        /// <param name="strStoreCode"></param>
        /// <param name="strDeviceID"></param>
        /// <param name="strErrMsg"></param>
        /// <returns></returns>
        ///----------------------------------------------------------------------------------
        public static int GetDeviceID(string strStoreCode, out string strDeviceID, out string strKCPSiteCode, out string strKCPSiteKey, out string strErrMsg)
        {
            int  pl_intRetVal = 0;
            IDas pl_objDas    = null;

            strErrMsg      = "OK";
            strDeviceID    = "";
            strKCPSiteCode = "";
            strKCPSiteKey  = "";

            try
            {
                pl_objDas             = new IDas();
                pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDas.CommandType = CommandType.StoredProcedure;
                pl_objDas.CodePage    = 0;

                pl_objDas.AddParam("@pi_strStoreCode",      DBType.adVarChar, strStoreCode,     50,  ParameterDirection.Input);
                pl_objDas.AddParam("@po_strDeviceID",       DBType.adVarChar, DBNull.Value,     50,  ParameterDirection.Output);
                pl_objDas.AddParam("@po_strKCPSiteCode",    DBType.adVarChar, DBNull.Value,     50,  ParameterDirection.Output);
                pl_objDas.AddParam("@po_strKCPSiteKey",     DBType.adVarChar, DBNull.Value,     50,  ParameterDirection.Output);
                pl_objDas.AddParam("@po_strErrMsg",         DBType.adVarChar, DBNull.Value,     256, ParameterDirection.Output);

                pl_objDas.AddParam("@po_intRetVal",         DBType.adInteger, DBNull.Value,     0,   ParameterDirection.Output);
                pl_objDas.AddParam("@po_strDBErrMsg",       DBType.adVarChar, DBNull.Value,     256, ParameterDirection.Output);
                pl_objDas.AddParam("@po_intDBRetVal",       DBType.adInteger, DBNull.Value,     0,   ParameterDirection.Output);

                pl_objDas.SetQuery("dbo.UP_POS_DEVICE_NT_GET");
                
                if (!pl_objDas.LastErrorCode.Equals(0))
                {
                    pl_intRetVal = pl_objDas.LastErrorCode;
                    strErrMsg    = pl_objDas.LastErrorMessage;
                    return pl_intRetVal;
                }
                pl_intRetVal    = Convert.ToInt32(pl_objDas.GetParam("@po_intRetVal"));
                strErrMsg       = pl_objDas.GetParam("@po_strErrMsg").ToString();
                strDeviceID     = pl_objDas.GetParam("@po_strDeviceID").ToString();
                strKCPSiteCode  = pl_objDas.GetParam("@po_strKCPSiteCode").ToString();
                strKCPSiteKey   = pl_objDas.GetParam("@po_strKCPSiteKey").ToString();

                if (!UserGlobal.SERVER_TYPE.Equals("REAL"))
                {
                    strDeviceID     = "1003324515";
                    strKCPSiteCode  = "A8B9G";
                    strKCPSiteKey   = "2OCB7gw8X4aOvvZY6Ut0S41__";
                    pl_intRetVal    = 0;
                }
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15703;
                strErrMsg    = "단말기 번호 조회 실패";
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                if(pl_objDas != null)
                {
                    pl_objDas.Close();
                    pl_objDas = null;
                }
            }

            return pl_intRetVal;
        }

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// PG 결제 로그 조회
        /// </summary>
        ///----------------------------------------------------------------------------------
        public static int GetPGPayLog(Int64 intOrderNo, Int16 intSiteCode, int intUserNo, PGPayLogInfo objPGPayLogInfo, out string strErrMsg)
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

                pl_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,    intOrderNo,         0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intSiteCode",           DBType.adTinyInt,   intSiteCode,        0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intUserNo",             DBType.adInteger,   intUserNo,          0,      ParameterDirection.Input);
                pl_objDas.AddParam("@po_intPosOrderNo",         DBType.adBigInt,    DBNull.Value,       0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_intPaySeqNo",           DBType.adTinyInt,   DBNull.Value,       0,      ParameterDirection.Output);

                pl_objDas.AddParam("@po_intSiteCode",           DBType.adTinyInt,   DBNull.Value,       0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_intUserNo",             DBType.adInteger,   DBNull.Value,       0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strUserID",             DBType.adVarChar,   DBNull.Value,       50,     ParameterDirection.Output);
                pl_objDas.AddParam("@po_strBrandCode",          DBType.adVarChar,   DBNull.Value,       50,     ParameterDirection.Output);
                pl_objDas.AddParam("@po_strStoreCode",          DBType.adVarChar,   DBNull.Value,       50,     ParameterDirection.Output);

                pl_objDas.AddParam("@po_intPayToolCode",        DBType.adTinyInt,   DBNull.Value,       0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strPGCode",             DBType.adVarChar,   DBNull.Value,       20,     ParameterDirection.Output);
                pl_objDas.AddParam("@po_strMallID",             DBType.adVarChar,   DBNull.Value,       50,     ParameterDirection.Output);
                pl_objDas.AddParam("@po_intPayAmt",             DBType.adDouble,    DBNull.Value,       0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strPayToolName",        DBType.adVarWChar,  DBNull.Value,       256,    ParameterDirection.Output);

                pl_objDas.AddParam("@po_strTID",                DBType.adVarChar,   DBNull.Value,       50,     ParameterDirection.Output);
                pl_objDas.AddParam("@po_strCID",                DBType.adVarChar,   DBNull.Value,       50,     ParameterDirection.Output);
                pl_objDas.AddParam("@po_intInstallment",        DBType.adTinyInt,   DBNull.Value,       0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strCashReceiptNo",      DBType.adVarChar,   DBNull.Value,       100,    ParameterDirection.Output);
                pl_objDas.AddParam("@po_strCardNo",             DBType.adVarChar,   DBNull.Value,       20,     ParameterDirection.Output);

                pl_objDas.AddParam("@po_strEtcInfo",            DBType.adVarWChar,  DBNull.Value,       256,    ParameterDirection.Output);
                pl_objDas.AddParam("@po_strPayYMD",             DBType.adChar,      DBNull.Value,       8,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strPGPayDate",          DBType.adVarChar,   DBNull.Value,       19,     ParameterDirection.Output);
                pl_objDas.AddParam("@po_strPayRsltCode",        DBType.adVarChar,   DBNull.Value,       10,     ParameterDirection.Output);
                pl_objDas.AddParam("@po_strPayRsltMsg",         DBType.adVarWChar,  DBNull.Value,       256,    ParameterDirection.Output);

                pl_objDas.AddParam("@po_intPayStateCode",       DBType.adTinyInt,   DBNull.Value,       0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,       256,    ParameterDirection.Output);
                pl_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,       0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,       256,    ParameterDirection.Output);
                pl_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,       0,      ParameterDirection.Output);

                pl_objDas.SetQuery("dbo.UP_POS_PG_PAYLOG_NT_GET");

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
                
                objPGPayLogInfo.intOrderNo          = intOrderNo;
                objPGPayLogInfo.intPosOrderNo       = Convert.ToInt64(pl_objDas.GetParam("@po_intPosOrderNo"));
                objPGPayLogInfo.intPaySeqNo         = Convert.ToInt16(pl_objDas.GetParam("@po_intPaySeqNo"));
                objPGPayLogInfo.intSiteCode         = Convert.ToInt16(pl_objDas.GetParam("@po_intSiteCode"));
                objPGPayLogInfo.intUserNo           = Convert.ToInt32(pl_objDas.GetParam("@po_intUserNo"));
                objPGPayLogInfo.strUserID           = pl_objDas.GetParam("@po_strUserID");
                objPGPayLogInfo.strBrandCode        = pl_objDas.GetParam("@po_strBrandCode");
                objPGPayLogInfo.strStoreCode        = pl_objDas.GetParam("@po_strStoreCode");
                objPGPayLogInfo.intPayToolCode      = Convert.ToInt16(pl_objDas.GetParam("@po_intPayToolCode"));
                objPGPayLogInfo.strPGCode           = pl_objDas.GetParam("@po_strPGCode");
                objPGPayLogInfo.strMallID           = pl_objDas.GetParam("@po_strMallID");
                objPGPayLogInfo.intPayAmt           = Convert.ToDouble(pl_objDas.GetParam("@po_intPayAmt"));
                objPGPayLogInfo.strPayToolName      = pl_objDas.GetParam("@po_strPayToolName");
                objPGPayLogInfo.strTID              = pl_objDas.GetParam("@po_strTID");
                objPGPayLogInfo.strCID              = pl_objDas.GetParam("@po_strCID");
                objPGPayLogInfo.intInstallment      = Convert.ToInt16(pl_objDas.GetParam("@po_intInstallment"));
                objPGPayLogInfo.strCashReceiptNo    = UserGlobal.GetDecryptStr(pl_objDas.GetParam("@po_strCashReceiptNo"));
                objPGPayLogInfo.strCardNo           = pl_objDas.GetParam("@po_strCardNo");
                objPGPayLogInfo.strEtcInfo          = pl_objDas.GetParam("@po_strEtcInfo");
                objPGPayLogInfo.strPayYMD           = pl_objDas.GetParam("@po_strPayYMD");
                objPGPayLogInfo.strApprovalDate     = pl_objDas.GetParam("@po_strPGRegDate");
                objPGPayLogInfo.strPayRsltCode      = pl_objDas.GetParam("@po_strPayRsltCode");
                objPGPayLogInfo.strPayRsltMsg       = pl_objDas.GetParam("@po_strPayRsltMsg");
                objPGPayLogInfo.intPayStateCode     = Convert.ToInt16(pl_objDas.GetParam("@po_intPayStateCode"));
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15704;
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

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// PG 결제 로그 입력
        /// </summary>
        ///----------------------------------------------------------------------------------
        public static int InsPGPayLog(PGPayReqParam objPGPayReqParam, out string strErrMsg)
        {
            int  pl_intRetVal = 0;
            IDas pl_objDas    = null;

            strErrMsg = string.Empty;

            try
            {
                // 현금 영수증 정보 암호화
                string strCashReceiptNo = UserGlobal.GetEncryptStr(objPGPayReqParam.strIdInfo);

                pl_objDas = new IDas();
                pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDas.CommandType = CommandType.StoredProcedure;
                pl_objDas.CodePage = 0;

                pl_objDas.AddParam("@pi_intPosOrderNo",         DBType.adBigInt,    objPGPayReqParam.intPosOrderNo,     0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intSiteCode",           DBType.adTinyInt,   objPGPayReqParam.intSiteCode,       0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intUserNo",             DBType.adInteger,   objPGPayReqParam.intUserNo,         0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strUserID",             DBType.adVarChar,   objPGPayReqParam.strUserID,         50,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strBrandCode",          DBType.adVarChar,   objPGPayReqParam.strBrandCode,      50,     ParameterDirection.Input);

                pl_objDas.AddParam("@pi_strStoreCode",          DBType.adVarChar,   objPGPayReqParam.strStoreCode,      50,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intPayToolCode",        DBType.adTinyInt,   objPGPayReqParam.intPayToolCode,    0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strPGCode",             DBType.adVarChar,   objPGPayReqParam.strPGCode,         20,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strMallID",             DBType.adVarChar,   DBNull.Value,                       20,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intPayAmt",             DBType.adDouble,    objPGPayReqParam.intPayAmt,         0,      ParameterDirection.Input);

                pl_objDas.AddParam("@pi_strTayToolName",        DBType.adVarWChar,  objPGPayReqParam.strPayToolName,    256,    ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intInstallment",        DBType.adTinyInt,   objPGPayReqParam.intInstallment,    0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strCashReceiptNo",      DBType.adVarChar,   strCashReceiptNo,                   100,    ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strEtcInfo",            DBType.adVarWChar,  objPGPayReqParam.strEtcInfo,        256,    ParameterDirection.Input);
                pl_objDas.AddParam("@po_intOrderNo",            DBType.adBigInt,    DBNull.Value,                       0,      ParameterDirection.Output);

                pl_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                       256,    ParameterDirection.Output);
                pl_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                       0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                       256,    ParameterDirection.Output);
                pl_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                       0,      ParameterDirection.Output);

                pl_objDas.SetQuery("dbo.UP_POS_PG_PAYLOG_TX_INS");

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

                objPGPayReqParam.intOrderNo = Convert.ToInt64(pl_objDas.GetParam("@po_intOrderNo"));
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15705;
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

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// PG 결제 로그 입력
        /// </summary>
        ///----------------------------------------------------------------------------------
        public static int UpdPGPayLog(PGPayResParam objPGPayResParam, out string strPayCompleteFlag, out string strErrMsg)
        {
            int  pl_intRetVal = 0;
            IDas pl_objDas    = null;

            strErrMsg          = string.Empty;
            strPayCompleteFlag = "N";

            try
            {
                // 현금 영수증 정보 암호화
                string strCashReceiptNo = UserGlobal.GetEncryptStr(objPGPayResParam.strCashReceiptNo);

                pl_objDas = new IDas();
                pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDas.CommandType = CommandType.StoredProcedure;
                pl_objDas.CodePage = 0;

                pl_objDas.AddParam("@pi_intOrderNo",            DBType.adBigInt,    objPGPayResParam.intOrderNo,        0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intPayAmt",             DBType.adDouble,    objPGPayResParam.intPayAmt,         0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strTayToolName",        DBType.adVarWChar,  objPGPayResParam.strPayToolName,    256,    ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strTID",                DBType.adVarChar,   objPGPayResParam.strTID,            50,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strCID",                DBType.adVarChar,   objPGPayResParam.strCID,            50,     ParameterDirection.Input);

                pl_objDas.AddParam("@pi_intInstallment",        DBType.adTinyInt,   objPGPayResParam.intInstallment,    0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strCashReceiptNo",      DBType.adVarChar,   strCashReceiptNo,                   100,    ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strCardNo",             DBType.adVarChar,   objPGPayResParam.strCardNo,         20,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strEtcInfo",            DBType.adVarWChar,  objPGPayResParam.strEtcInfo,        256,    ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strPGRegDate",          DBType.adVarChar,   objPGPayResParam.strApprovalDate,   19,     ParameterDirection.Input);

                pl_objDas.AddParam("@pi_strPayRsltCode",        DBType.adVarChar,   objPGPayResParam.strPayRsltCode,    10,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strPayRsltMsg",         DBType.adVarWChar,  objPGPayResParam.strPayRsltMsg,     256,    ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intPayStateCode",       DBType.adTinyInt,   objPGPayResParam.intPayStateCode,   0,      ParameterDirection.Input);
                pl_objDas.AddParam("@po_strPayCompleteFlag",    DBType.adChar,      DBNull.Value,                       1,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar,   DBNull.Value,                       256,    ParameterDirection.Output);

                pl_objDas.AddParam("@po_intRetVal",             DBType.adInteger,   DBNull.Value,                       0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar,   DBNull.Value,                       256,    ParameterDirection.Output);
                pl_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger,   DBNull.Value,                       0,      ParameterDirection.Output);

                pl_objDas.SetQuery("dbo.UP_POS_PG_PAYLOG_TX_UPD");

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

                strPayCompleteFlag = pl_objDas.GetParam("@po_strPayCompleteFlag");
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15706;
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

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// POS 아이템 구매
        /// </summary>
        ///----------------------------------------------------------------------------------
        public static int PurchaseItem(PosLogInfo objPosLogInfo, out string strErrMsg)
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

                pl_objDas.AddParam("@pi_intSiteCode",               DBType.adTinyInt, objPosLogInfo.intSiteCode,        0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intUserNo",                 DBType.adInteger, objPosLogInfo.intUserNo,          0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strUserID",                 DBType.adVarChar, objPosLogInfo.strUserID,          200,    ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strGameCode",               DBType.adVarChar, UserGlobal.BOQ_GAMECODE_GA,       15,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intPosOrderNo",             DBType.adBigInt,  objPosLogInfo.intPosOrderNo,      0,      ParameterDirection.Input);

                pl_objDas.AddParam("@pi_intPurchaseLocationCode",   DBType.adTinyInt, 1,                                0,      ParameterDirection.Input);     //구매 위치 코드(1:웹,2:게임)
                pl_objDas.AddParam("@pi_intPurchaseTypeCode",       DBType.adTinyInt, 1,                                0,      ParameterDirection.Input);     //구매 유형 코드(1:사용자,2:관리자,3:이벤트,4쿠폰)
                pl_objDas.AddParam("@pi_strPurchaseTypeVal",        DBType.adVarChar, DBNull.Value,                     50,     ParameterDirection.Input);     //구매 유형 값(PurchseTypeCode=1:NULL,PurchseTypeCode=2:관리자 아이디,PurchseTypeCode=3:이벤트 아이디,PurchseTypeCode=4:쿠폰 아이디)
                pl_objDas.AddParam("@pi_strIPAddr",                 DBType.adVarChar, UserGlobal.GetClientIP(),         50,     ParameterDirection.Input);
                pl_objDas.AddParam("@po_intGChargeNo",              DBType.adBigInt,  DBNull.Value,                     0,      ParameterDirection.Output);

                pl_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar, DBNull.Value,                     256,    ParameterDirection.Output);
                pl_objDas.AddParam("@po_intRetVal",                 DBType.adInteger, DBNull.Value,                     0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar, DBNull.Value,                     256,    ParameterDirection.Output);
                pl_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger, DBNull.Value,                     0,      ParameterDirection.Output);

                pl_objDas.SetQuery("dbo.UP_POS_PURCHASE_TX_CHA");

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

                objPosLogInfo.intGChargeNo    = Convert.ToInt64(pl_objDas.GetParam("@po_intGChargeNo"));
                objPosLogInfo.intPosStateCode = 2;       //구매성공
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15707;
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

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// 불일치 입력 : 실행 결과 무시
        /// </summary>
        ///----------------------------------------------------------------------------------
        public static void InsPayIncomplete (PGPayLogInfo objPGPayLogInfo, Int16 intIncompleteTypeCode, out int intSeqNo)
        {
            int    pl_intRetVal = 0;
            string pl_strErrMsg = string.Empty;
            IDas   pl_objDas    = null;

            intSeqNo  = 0;

            try
            {
                // 현금 영수증 정보 암호화
                string strCashReceiptNo = UserGlobal.GetEncryptStr(objPGPayLogInfo.strCashReceiptNo);

                pl_objDas = new IDas();
                pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDas.CommandType = CommandType.StoredProcedure;
                pl_objDas.CodePage = 0;

                pl_objDas.AddParam("@pi_intSiteCode",               DBType.adTinyInt,   objPGPayLogInfo.intSiteCode,        0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intUserNo",                 DBType.adInteger,   objPGPayLogInfo.intUserNo,          0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strUserID",                 DBType.adVarChar,   objPGPayLogInfo.strUserID,          200,    ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strBrandCode",              DBType.adVarChar,   objPGPayLogInfo.strBrandCode,       50,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strStoreCode",              DBType.adVarChar,   objPGPayLogInfo.strStoreCode,       50,     ParameterDirection.Input);

                pl_objDas.AddParam("@pi_intPayToolCode",            DBType.adTinyInt,   objPGPayLogInfo.intPayToolCode,     0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strPGCode",                 DBType.adVarChar,   objPGPayLogInfo.strPGCode,          20,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strMallID",                 DBType.adVarChar,   objPGPayLogInfo.strMallID,          20,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strCurrencyCode",           DBType.adChar,      UserGlobal.BOQ_CURRENCYCODE_KRW,    3,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intPayAmt",                 DBType.adDouble,    objPGPayLogInfo.intPayAmt,          0,      ParameterDirection.Input);

                pl_objDas.AddParam("@pi_strPayToolName",            DBType.adVarWChar,  DBNull.Value,                       256,    ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intOrderNo",                DBType.adBigInt,    objPGPayLogInfo.intOrderNo,         0,      ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strTID",                    DBType.adVarChar,   objPGPayLogInfo.strTID,             50,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strCID",                    DBType.adVarChar,   objPGPayLogInfo.strCID,             50,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intInstallment",            DBType.adTinyInt,   objPGPayLogInfo.intInstallment,     0,      ParameterDirection.Input);

                pl_objDas.AddParam("@pi_strCashReceiptNo",          DBType.adVarChar,   strCashReceiptNo,                   100,    ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strCardNo",                 DBType.adVarChar,   objPGPayLogInfo.strCardNo,          20,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strEtcInfo",                DBType.adVarWChar,  objPGPayLogInfo.strEtcInfo,         256,    ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strPGPayDate",              DBType.adVarChar,   objPGPayLogInfo.strApprovalDate,    19,     ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intIncompleteTypeCode",     DBType.adTinyInt,   intIncompleteTypeCode,              0,      ParameterDirection.Input);

                pl_objDas.AddParam("@pi_strAdminID",                DBType.adVarChar,   DBNull.Value,                       50,     ParameterDirection.Input);
                pl_objDas.AddParam("@po_intSeqNo",                  DBType.adInteger,   DBNull.Value,                       0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strErrMsg",                 DBType.adVarChar,   DBNull.Value,                       256,    ParameterDirection.Output);
                pl_objDas.AddParam("@po_intRetVal",                 DBType.adInteger,   DBNull.Value,                       0,      ParameterDirection.Output);
                pl_objDas.AddParam("@po_strDBErrMsg",               DBType.adVarChar,   DBNull.Value,                       256,    ParameterDirection.Output);

                pl_objDas.AddParam("@po_intDBRetVal",               DBType.adInteger,   DBNull.Value,                       0,      ParameterDirection.Output);

                pl_objDas.SetQuery("dbo.UP_POS_PAY_INCOMPLETE_TX_INS");

                if (!pl_objDas.LastErrorCode.Equals(0))
                {
                    pl_intRetVal = pl_objDas.LastErrorCode;
                    pl_strErrMsg = pl_objDas.LastErrorMessage;
                    return;
                }

                pl_strErrMsg = pl_objDas.GetParam("@po_strErrMsg");
                pl_intRetVal = Convert.ToInt32(pl_objDas.GetParam("@po_intRetVal"));
                if (!pl_intRetVal.Equals(0))
                {
                    return;
                }

                intSeqNo = Convert.ToInt32(pl_objDas.GetParam("@po_intSeqNo"));
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15708;
                pl_strErrMsg = pl_objEx.Message + pl_objEx.StackTrace;
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
                    UtilLog.WriteLog("UP_POS_PAY_INCOMPLETE_TX_INS", pl_intRetVal, pl_strErrMsg);
                }
            }

            return;
        }

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// PG 결제 완료 내역 조회
        /// </summary>
        ///----------------------------------------------------------------------------------
        public static int GetPayCompleteList(Int64 intPosOrderNo, out DataTable objDT, out string strErrMsg)
        {
            int  pl_intRetVal = 0;
            IDas pl_objDas    = null;

            strErrMsg      = string.Empty;
            objDT          = null;

            try
            {
                pl_objDas             = new IDas();
                pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDas.CommandType = CommandType.StoredProcedure;
                pl_objDas.CodePage    = 0;
                
                pl_objDas.AddParam("@pi_intPosOrderNo",     DBType.adBigInt,    intPosOrderNo,      0,    ParameterDirection.Input);

                pl_objDas.SetQuery("dbo.UP_POS_PAY_COMPLETE_UR_LST");

                if (!pl_objDas.LastErrorCode.Equals(0))
                {
                    pl_intRetVal = pl_objDas.LastErrorCode;
                    strErrMsg    = pl_objDas.LastErrorMessage;
                    return pl_intRetVal;
                }
                
                objDT = new DataTable();
                objDT = pl_objDas.objDT;
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15709;
                strErrMsg    = "PG 결제 완료 내역 조회 실패";
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                if(pl_objDas != null)
                {
                    pl_objDas.Close();
                    pl_objDas = null;
                }
            }

            return pl_intRetVal;
        }

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// 환불 캐시 조회
        /// </summary>
        ///----------------------------------------------------------------------------------
        public static int GetRefundCashList(RefundInfo pl_objRefundInfo, out DataTable objDT, out string strErrMsg)
        {
            int  pl_intRetVal = 0;
            IDas pl_objDas    = null;

            objDT     = new DataTable();
            strErrMsg = string.Empty;

            try
            {
                pl_objDas = new IDas();
                pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDas.CommandType = CommandType.StoredProcedure;
                pl_objDas.CodePage = 0;
                
                pl_objDas.AddParam("@pi_intGChargeNo", DBType.adBigInt,  pl_objRefundInfo.intGChargeNo, 0, ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intSiteCode",  DBType.adInteger, pl_objRefundInfo.intSiteCode,  0, ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intUserNo",    DBType.adInteger, pl_objRefundInfo.intUserNo,    0, ParameterDirection.Input);
                pl_objDas.SetQuery("dbo.UP_POS_REFUND_CASH_UR_LST");

                if (!pl_objDas.LastErrorCode.Equals(0))
                {
                    pl_intRetVal = pl_objDas.LastErrorCode;
                    strErrMsg    = pl_objDas.LastErrorMessage;
                    return pl_intRetVal;
                }

                // 최소 한건이라도 조회되어야 한다.
                if(pl_objDas.RecordCount.Equals(0))
                {
                    pl_intRetVal = -1711;
                    strErrMsg    = "조회된 건이 없습니다.";
                    return pl_intRetVal;
                }

                objDT = pl_objDas.objDT;
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15710;
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

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// 환불 등록
        /// </summary>
        ///----------------------------------------------------------------------------------
        public static int InsRefund(RefundInfo pl_objRefundInfo, out string strErrMsg)
        {
            int  pl_intRetVal = 0;
            IDas pl_objDas    = null;
            
            strErrMsg   = string.Empty;

            try
            {
                pl_objDas = new IDas();
                pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDas.CommandType = CommandType.StoredProcedure;
                pl_objDas.CodePage = 0;

                pl_objDas.AddParam("@pi_intSiteCode",      DBType.adTinyInt,  pl_objRefundInfo.intSiteCode,         0,   ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intUserNo",        DBType.adInteger,  pl_objRefundInfo.intUserNo,           0,   ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intGChargeNo",     DBType.adBigInt,   pl_objRefundInfo.intGChargeNo,        0,   ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strAdminID",       DBType.adVarChar,  pl_objRefundInfo.strManagerID,        20,  ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strAdminName",     DBType.adVarWChar, pl_objRefundInfo.strManagerName,      20,  ParameterDirection.Input);

                pl_objDas.AddParam("@pi_strAdminNo",       DBType.adVarChar,  pl_objRefundInfo.intManagerNo,        20,  ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intRefundType",    DBType.adInteger,  1,                                    0,   ParameterDirection.Input);
                pl_objDas.AddParam("@pi_intRefundFeeRate", DBType.adInteger,  pl_objRefundInfo.intRefundFeeRate,    0,   ParameterDirection.Input);
                //pl_objDas.AddParam("@pi_strBrandCode",     DBType.adVarChar,  UserGlobal.DEFAULT_BRANDCODE,         15,  ParameterDirection.Input);
                pl_objDas.AddParam("@pi_strStoreCode",     DBType.adVarChar,  pl_objRefundInfo.strStoreCode,        15,  ParameterDirection.Input);

                pl_objDas.AddParam("@pi_strIPAddr",        DBType.adVarChar,  UserGlobal.GetClientIP(),             20,  ParameterDirection.Input);
                pl_objDas.AddParam("@po_strErrMsg",        DBType.adVarChar,  DBNull.Value,                         256, ParameterDirection.Output);
                pl_objDas.AddParam("@po_intRetVal",        DBType.adInteger,  DBNull.Value,                         0,   ParameterDirection.Output);
                pl_objDas.AddParam("@po_strDBErrMsg",      DBType.adVarChar,  DBNull.Value,                         256, ParameterDirection.Output);
                pl_objDas.AddParam("@po_intDBRetVal",      DBType.adInteger,  DBNull.Value,                         0,   ParameterDirection.Output);
                pl_objDas.SetQuery("dbo.UP_POS_REFUND_TX_INS");

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
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15711;
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

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// 주문번호 생성
        /// </summary>
        ///----------------------------------------------------------------------------------
        public static int GetOrderNo(out Int64 intOrderNo, out string strErrMsg)
        {
            int  pl_intRetVal = 0;
            IDas pl_objDas    = null;

            intOrderNo  = 0;
            strErrMsg   = string.Empty;

            try
            {
                pl_objDas = new IDas();
                pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDas.CommandType = CommandType.StoredProcedure;
                pl_objDas.CodePage = 0;

                pl_objDas.AddParam("@po_intLogID",              DBType.adBigInt,  DBNull.Value,     0,   ParameterDirection.Output);                
                pl_objDas.AddParam("@po_strErrMsg",             DBType.adVarChar, DBNull.Value,     256, ParameterDirection.Output);
                pl_objDas.AddParam("@po_intRetVal",             DBType.adInteger, DBNull.Value,     0,   ParameterDirection.Output);
                pl_objDas.AddParam("@po_strDBErrMsg",           DBType.adVarChar, DBNull.Value,     256, ParameterDirection.Output);
                pl_objDas.AddParam("@po_intDBRetVal",           DBType.adInteger, DBNull.Value,     0,   ParameterDirection.Output);

                pl_objDas.SetQuery("dbo.UP_ORDERNO_NT_GET");
                
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

                intOrderNo = Convert.ToInt64(pl_objDas.GetParam("@po_intLogID"));
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15712;
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

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// 레슨 조회, 2019-09-19
        /// </summary>
        /// <param name="intGChargeNo"></param>
        /// <param name="pl_objDT"></param>
        /// <param name="pl_strErrMsg"></param>
        /// <returns></returns>
        ///----------------------------------------------------------------------------------
        public static int GetLessonList(Int64 intGChargeNo, out int intRowCnt, out DataTable objDT, out string strErrMsg)
        {
            int  pl_intRetVal = 0;
            IDas pl_objDas    = null;
            
            strErrMsg   = "OK";
            objDT       = null;
            intRowCnt   = 0;

            try
            {
                pl_objDas             = new IDas();
                pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDas.CommandType = CommandType.StoredProcedure;
                pl_objDas.CodePage    = 0;

                pl_objDas.AddParam("@pi_intGChargeNo", DBType.adBigInt,  intGChargeNo, 0,   ParameterDirection.Input);
                pl_objDas.AddParam("@po_strBrandCode", DBType.adVarChar, DBNull.Value, 15,  ParameterDirection.Output);
                pl_objDas.AddParam("@po_strStoreCode", DBType.adVarChar, DBNull.Value, 15,  ParameterDirection.Output);
                pl_objDas.AddParam("@po_intUserNo",    DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);
                pl_objDas.AddParam("@po_intProNo",     DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);

                pl_objDas.AddParam("@po_intRowCnt",    DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);
                pl_objDas.AddParam("@po_strErrMsg",    DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                pl_objDas.AddParam("@po_intRetVal",    DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);
                pl_objDas.AddParam("@po_strDBErrMsg",  DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
                pl_objDas.AddParam("@po_intDBRetVal",  DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);

                pl_objDas.SetQuery("dbo.UP_LESSON_INFO_UR_LST");
                
                if (!pl_objDas.LastErrorCode.Equals(0))
                {
                    pl_intRetVal    = pl_objDas.LastErrorCode;
                    strErrMsg       = pl_objDas.LastErrorMessage;
                    return pl_intRetVal;
                }

                pl_intRetVal    = Convert.ToInt32(pl_objDas.GetParam("@po_intRetVal"));
                intRowCnt       = Convert.ToInt32(pl_objDas.GetParam("@po_intRowCnt"));                
                objDT           = new DataTable();
                objDT           = pl_objDas.objDT;
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15713;
                strErrMsg = "레슨 목록 조회 실패";
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                if(pl_objDas != null)
                {
                    pl_objDas.Close();
                    pl_objDas = null;
                }
            }

            return pl_intRetVal;
        }

        ///----------------------------------------------------------------------------------
        /// <summary>
        /// 페이지 권한 체크
        /// </summary>
        ///----------------------------------------------------------------------------------
        public static int ChkMenuAccess(string strAuthtype, string strMenuLink, out string strErrMsg, out int intAuthCode)
        {
            int  pl_intRetVal   = 0;
            int  pl_intAuthCode = 0;
            IDas pl_objDas      = null;

            strErrMsg   = "OK";
            intAuthCode = 0;
            try
            {
                pl_objDas             = new IDas();
                pl_objDas.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDas.CommandType = CommandType.StoredProcedure;
                pl_objDas.CodePage    = 0;

	            pl_objDas.AddParam("@pi_strAuthType", DBType.adVarChar, strAuthtype,  15,  ParameterDirection.Input);
	            pl_objDas.AddParam("@pi_strMenuLink", DBType.adVarChar, strMenuLink,  100, ParameterDirection.Input);
	            pl_objDas.AddParam("@po_intAuthCode", DBType.adTinyInt, DBNull.Value, 0,   ParameterDirection.Output);
	            pl_objDas.AddParam("@po_strErrMsg",   DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
	            pl_objDas.AddParam("@po_intRetVal",   DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);

	            pl_objDas.AddParam("@po_strDBErrMsg", DBType.adVarChar, DBNull.Value, 256, ParameterDirection.Output);
	            pl_objDas.AddParam("@po_intDBRetVal", DBType.adInteger, DBNull.Value, 0,   ParameterDirection.Output);
	            pl_objDas.SetQuery("dbo.UP_POS_MANAGER_ACCESS_MENU_NT_CHK");
                
                if (!pl_objDas.LastErrorCode.Equals(0))
                {
                    pl_intRetVal    = pl_objDas.LastErrorCode;
                    strErrMsg       = pl_objDas.LastErrorMessage;
                    return pl_intRetVal;
                }

                pl_intRetVal = Convert.ToInt32(pl_objDas.GetParam("@po_intRetVal"));
                if(!pl_intRetVal.Equals(0))
                {
                    strErrMsg = pl_objDas.GetParam("@po_strErrMsg");
                    return pl_intRetVal;
                }

                pl_intAuthCode = Convert.ToInt32(pl_objDas.GetParam("@po_intAuthCode"));

                if(pl_intAuthCode.Equals(3))
                {
                    pl_intRetVal = -1741;
                    strErrMsg    =  "페이지 권한 없음.";
                    return pl_intRetVal;
                }
                intAuthCode = pl_intAuthCode;
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -15714;
                strErrMsg = "페이지권한 조회 실패";
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                if(pl_objDas != null)
                {
                    pl_objDas.Close();
                    pl_objDas = null;
                }
            }

            return pl_intRetVal;
        }
    }
}