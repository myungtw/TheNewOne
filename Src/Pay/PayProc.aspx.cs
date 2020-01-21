using bill.payletter.com.CommonModule;
using BOQv7Das_Net;
using System;
using System.Data;

public partial class PayProc : PageBase
{
    private Int64  pb_intEventNo         { get { return Convert.ToInt64(Request.Form["eventNo"]); } }
    private Int64  pb_intPayAmt          { get { return Convert.ToInt32(Request.Form["payAmt"]); } }
    private Int16  pb_intJoinMstCategory { get { return Convert.ToInt16(Request.Form["joinMstCategory"]); } }
    private int    pb_intJoinSubCategory { get { return Convert.ToInt32(Request.Form["joinSubCategory"]); } }
    private int    pb_intPaytool         { get { return Convert.ToInt32(Request.Form["paytool"]); } }
    private string pb_strPGCode          { get { return Request.Form["pgCode"].ToString(); } }

    protected void Page_Load(object sender, EventArgs e)
    {
        string strErrMsg = string.Empty;

        if(!IsPostBack)
        {
            InsPGPayLog(out strErrMsg);
        }
        Response.Redirect("/Src/Pay/PayResult.aspx");
    }
    public int InsPGPayLog(out string strErrMsg)
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

	        pl_objDas.AddParam("@pi_intFamilyEventNo",   DBType.adBigInt,  pb_intEventNo,         0,   ParameterDirection.Input);
	        pl_objDas.AddParam("@pi_intJoinMstCategory", DBType.adTinyInt, pb_intJoinMstCategory, 0,   ParameterDirection.Input);
	        pl_objDas.AddParam("@pi_intJoinSubCategory", DBType.adTinyInt, pb_intJoinSubCategory, 0,   ParameterDirection.Input);
	        pl_objDas.AddParam("@pi_intUserNo",          DBType.adInteger, objSes.intUserNo,      0,   ParameterDirection.Input);
	        pl_objDas.AddParam("@pi_intPayAmt",          DBType.adDouble,  pb_intPayAmt,          0,   ParameterDirection.Input);

	        pl_objDas.AddParam("@pi_strPGCode",          DBType.adVarChar, pb_strPGCode,          50,  ParameterDirection.Input);
	        pl_objDas.AddParam("@pi_intPayTool",         DBType.adTinyInt, pb_intPaytool,         0,   ParameterDirection.Input);
	        pl_objDas.AddParam("@po_strErrMsg",          DBType.adVarChar, DBNull.Value,          256, ParameterDirection.Output);
	        pl_objDas.AddParam("@po_intRetVal",          DBType.adInteger, DBNull.Value,          0,   ParameterDirection.Output);
	        pl_objDas.AddParam("@po_strDBErrMsg",        DBType.adVarChar, DBNull.Value,          256, ParameterDirection.Output);

	        pl_objDas.AddParam("@po_intDBRetVal",        DBType.adInteger, DBNull.Value,          0,   ParameterDirection.Output);
	        pl_objDas.SetQuery("dbo.UP_PAYMENT_TX_INS");

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