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
    }
}