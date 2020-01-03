using System;
using System.Data;
using System.Text;

using BOQv7Das_Net;

///////////////////////////////////////////////////////////////////////////////
/// FileName        : CommonDDLB.cs
/// Description     : 공용으로 사용되는 리스트 박스
/// Copyright ⓒ 2007 by PayLetter Inc. All rights reserved.
/// Author          : moondae@payletter.com, 2007-07-03
/// Modify History  : Just Created.
///////////////////////////////////////////////////////////////////////////////
namespace bill.payletter.com.CommonModule
{
    ///================================================================================
    /// Name           : CommonDDLB
    /// Description    : <summary>공용으로 사용되는 리스트 박스를 정의한다.</summary>
    /// Author         : moondae@payletter.com, 2007-07-03
    /// Modify History : Just Created.
    ///================================================================================
    public static class DDLB
    {
        // Html 타입 정의
        public enum HtmlType
        {
            freeItemProductType = 1, saleProductType = 2
        };

        ///----------------------------------------------------------------------
        /// <summary>
        /// option 생성.(value, text 만 입력)
        /// </summary>
        ///----------------------------------------------------------------------
        private static string MakeOption(string strOptionValue, string strOptionHtml, HtmlType objHtmlType)
        {
            string strHTML = string.Empty;

            switch(objHtmlType)
            {
                case HtmlType.freeItemProductType:
                    strHTML = String.Format("<option value='{0}'>{1}</option>", strOptionValue, strOptionHtml);
                    break;
                case HtmlType.saleProductType:
                    strHTML = String.Format("<li><input type='radio' name='product' id='product{0}' value='{0}'><label for='product{0}'>{1}</label></li>", strOptionValue, strOptionHtml);
                    break;
                default:
                    break;
            }

            return strHTML;
        }

        ///================================================================================
        /// Name           : PrintProductTypeDDLB
        /// Description    : <summary>일반 구매 시 사용되는 상품 타입 리스트 박스를 정의한다.</summary>
        /// Author         : ejlee@payletter.com, 2019-11-21
        /// Modify History : Just Created.
        ///================================================================================
        public static string PrintProductTypeDDLB(bool boolDefault, HtmlType objHtmlType = HtmlType.freeItemProductType)
        {
            IDas          pl_objDAS = null;
            StringBuilder pl_objSb  = null;
            
            try
            {
                pl_objSb = new StringBuilder();

                pl_objDAS = new IDas();
                pl_objDAS.Open(UserGlobal.BOQ_HOST_DAS);
                pl_objDAS.CommandType = CommandType.StoredProcedure;
                pl_objDAS.CodePage = 0;

                pl_objDAS.AddParam("@pi_strDisplayFlag", DBType.adChar, 'Y', 1, ParameterDirection.Input);
                pl_objDAS.SetQuery("dbo.UP_PRODUCT_TYPE_UR_LST");

                if (boolDefault)
                {
                    pl_objSb.Append(MakeOption("0", "전체", objHtmlType));
                }

                while (pl_objDAS.Read())
                {
                    pl_objSb.Append(MakeOption(pl_objDAS.GetString("PRODUCTTYPECODE"), pl_objDAS.GetString("PRODUCTTYPEDESC"), objHtmlType));
                }
                pl_objDAS.CloseTable();
            }
            finally
            {
                if (pl_objDAS != null)
                {
                    pl_objDAS.Close();
                }
                pl_objDAS = null;

            }
            return pl_objSb.ToString();
        }

        ///================================================================================
        /// Name           : PrintAdminProductTypeDDLB
        /// Description    : <summary>관리자 지급 시 사용되는 상품 타입 리스트 박스를 정의한다.</summary>
        /// Author         : ejlee@payletter.com, 2019-11-21
        /// Modify History : Just Created.
        ///================================================================================
        public static string PrintAdminProductTypeDDLB(bool boolDefault, HtmlType objHtmlType = HtmlType.freeItemProductType)
        {
            StringBuilder pl_objSb  = null;            
            try
            {
                pl_objSb = new StringBuilder();
                if (boolDefault)
                {
                    pl_objSb.Append(MakeOption("0", "전체", objHtmlType));
                }

                pl_objSb.Append(MakeOption("1", "이용료", objHtmlType));
                pl_objSb.Append(MakeOption("2", "레슨",   objHtmlType));
            }
            finally
            {
            }
            return pl_objSb.ToString();
        }

    }
}
