using bill.payletter.com.CommonModule;
using BOQv7Das_Net;
using System;
using System.Data;

public partial class PayResult : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public int InsPGPayLog(PGPayReqParam objPGPayReqParam, out string strErrMsg)
    {
        int    pl_intRetVal        = 0;
        string pl_strCashReceiptNo = string.Empty;
        IDas   pl_objDas           = null;

        strErrMsg = string.Empty;

        try
        {
            // 현금 영수증 정보 암호화
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
            pl_objDas.AddParam("@pi_strCashReceiptNo",      DBType.adVarChar,   pl_strCashReceiptNo,                100,    ParameterDirection.Input);
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
}