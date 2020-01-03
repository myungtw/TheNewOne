<%@ WebHandler Language="C#" Class="UserHandler" %>

using System;
using System.Web;
using System.Collections.Generic;

using Newtonsoft.Json;

using bill.payletter.com.CommonModule;
using bill.payletter.com.handler;
using bill.payletter.com.Session;

///================================================================
/// <summary>
/// FileName        : UserHandler.ashx
/// Description     : 유저 이벤트 처리기
/// Copyright 2019 by PayLetter Inc. All rights reserved.
/// Author          : ejlee@payletter.com, 2019-09-06
/// Modify History  : just create.
/// </summary>
///================================================================
public class UserHandler : AshxBaseHandler
{
    #region 매니저 조회
    //-------------------------------------------------------------
    /// <summary>
    /// 매니저 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login)]
    private int GetManagerList(ManagerListReqParam objReqParam, ManagerListResParam objResParam, out string strErrMsg)
    {
        int     pl_intRetVal        = 0;
        string  pl_strReqAPIParam   = string.Empty;
        string  pl_strResParam      = string.Empty;

        strErrMsg = string.Empty;

        try
        {
            // 매니저 권한인 경우 API를 호출하지 않고 본인만 조회되도록 설정
            if(objSes.strUserID.Equals("AUTH02"))
            {
                objResParam.golfzonManagerList = new GolfzonManagerList {
                    code        = "1",
                    codeMessage = "",
                    rgnNo       = objReqParam.strStoreCode,
                    rgnNm       = ""
                };
                objResParam.golfzonManagerList.entitys.Add(new GolfzonManager {
                    userNo      = objSes.intUserNo,
                    userId      = objSes.strUserID,
                    userNm      = objSes.strUserName,
                    authType    = objSes.strUserID,
                    authNm      = objSes.strUserID
                });
            }
            else
            {
                pl_strReqAPIParam = "{\"rgnNo\":" + objReqParam.strStoreCode + "}";

                //pl_intRetVal = UserGlobal.CallWebRequest(pl_strReqAPIParam, Golfzon.GOLFZON_MANAGER_URL, "JSON", out pl_strResParam, out strErrMsg, "POST");

                objResParam.golfzonManagerList = JsonConvert.DeserializeObject<GolfzonManagerList>(pl_strResParam);
            }
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15111;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
        }

        return pl_intRetVal;
    }

    // 매니저 조회 요청 클래스
    public class ManagerListReqParam : DefaultReqParam
    {
        public string strStoreCode { get; set; }
    }

    // 매니저 조회 응답 클래스
    public class ManagerListResParam : DefaultResParam
    {
        public GolfzonManagerList golfzonManagerList;
    }

    // 골프존 매니저 조회 API 응답 클래스
    public class GolfzonManagerList
    {
        public string               code        { get; set; }
        public string               codeMessage { get; set; }
        public string               rgnNo       { get; set; }
        public string               rgnNm       { get; set; }
        public List<GolfzonManager> entitys;

        public GolfzonManagerList ()
        {
            code        = "";
            codeMessage = "";
            rgnNo       = "";
            rgnNm       = "";
            entitys     = new List<GolfzonManager>();
        }
    }

    // 골프존 매니저 클래스
    public class GolfzonManager
    {
        public int      userNo      { get; set; }
        public string   userId      { get; set; }
        public string   userNm      { get; set; }
        public string   authType    { get; set; }
        public string   authNm      { get; set; }

        public string   regDate     { get; set; }

        public GolfzonManager()
        {
            userNo      = 0;
            userId      = "";
            userNm      = "";
            authType    = "";
            authNm      = "";

            regDate     = "";
        }
    }
    #endregion


    #region 매장(권한) 조회
    //-------------------------------------------------------------
    /// <summary>
    /// 매장(권한) 조회
    /// </summary>
    //-------------------------------------------------------------
    [MethodSet(loggingFlag = true, pageType = PageAccessType.Login)]
    private int GetStoreList(DefaultReqParam objReqParam, StoreListResParam objResParam, out string strErrMsg)
    {
        int     pl_intRetVal        = 0;
        string  pl_strReqAPIParam   = string.Empty;
        string  pl_strResParam      = string.Empty;

        strErrMsg = string.Empty;

        try
        {
            pl_strReqAPIParam = "{\"userNo\":" + objSes.intUserNo + "}";

            //pl_intRetVal = UserGlobal.CallWebRequest(pl_strReqAPIParam, Golfzon.GOLFZON_AUTH_URL, "JSON", out pl_strResParam, out strErrMsg, "POST");

            objResParam.golfzonStoreList = JsonConvert.DeserializeObject<GolfzonStoreList>(pl_strResParam);
        }
        catch (Exception pl_objEx)
        {
            pl_intRetVal = -15112;
            strErrMsg    = pl_objEx.Message + pl_objEx.StackTrace;
            UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
        }
        finally
        {
        }

        return pl_intRetVal;
    }

    // 매장(권한) 조회 응답 클래스
    public class StoreListResParam : DefaultResParam
    {
        public GolfzonStoreList golfzonStoreList;
    }

    // 골프존 매장(권한) 조회 API 응답 클래스
    public class GolfzonStoreList
    {
        public string               code        { get; set; }
        public string               codeMessage { get; set; }
        public int                  userNo      { get; set; }
        public string               userNm      { get; set; }
        public string               authType    { get; set; }

        public string               authNm      { get; set; }
        public List<GolfzonStore>   entitys;

        public GolfzonStoreList ()
        {
            code        = "";
            codeMessage = "";
            userNo      = 0;
            userNm      = "";
            authType    = "";

            authNm      = "";
            entitys     = new List<GolfzonStore>();
        }
    }

    // 골프존 매장(권한) 클래스
    public class GolfzonStore
    {
        public string   rgnNo       { get; set; }
        public string   rgnNm       { get; set; }

        public GolfzonStore()
        {
            rgnNo   = "";
            rgnNm   = "";
        }
    }
    #endregion

}