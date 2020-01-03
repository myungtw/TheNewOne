using System;
using System.Data;
using System.IO;
using System.Reflection;
using System.Text;
using System.Web;

using Newtonsoft.Json;

using bill.payletter.com.CommonModule;
using bill.payletter.com.Session;

///================================================================
/// <summary>
/// FileName        : AshxBaseHandler.ashx
/// Description     : 핸들러 공통 이벤트 처리기
/// Copyright 2018 by PayLetter Inc. All rights reserved.
/// Author          : ysjee@payletter.com, 2019-08-20
/// Modify History  : just create.
/// </summary>
///================================================================
namespace bill.payletter.com.handler
{
    // DefaultReqParam, DefaultResParam 또는 상속받은 객체를 사용가능하다.
    public class AshxBaseHandler : IHttpHandler
    {
        protected string strPageMethodName    = string.Empty;
        protected string strRefererUrl        = string.Empty;
        protected const string strDefaultMsg  = "일시적인 오류입니다. 지속될 경우 관리자에게 문의하세요.";
        protected const string strReq         = "REQ";
        protected const string strRes         = "RES";
        protected UserSession objSes;

        //-------------------------------------------------------------
        /// <summary>
        /// 메인 프로세스
        /// </summary>
        //-------------------------------------------------------------
        public virtual void ProcessRequest (HttpContext objContext)
        {
            int    pl_intRetVal     = 0;
            string pl_strJsonResult = string.Empty;
            string pl_strReqParam   = string.Empty;
            string pl_strErrMsg     = string.Empty;

            HttpRequest     pl_objRequest  = null;
            HttpResponse    pl_objResponse = null;
            DefaultReqParam pl_objReqParam = new DefaultReqParam();
            DefaultResParam pl_objResParam = new DefaultResParam();
            MethodSet       objMethodAttr  = null;
            MethodInfo      objMethodInfo  = null;
            
            object[] parameters = null;     // 메소드의 in/out 파라미터

            try
            {
                strPageMethodName = MethodBase.GetCurrentMethod().Name;

                objContext.Response.ContentType     = "text/json";
                objContext.Response.ContentEncoding = Encoding.UTF8;
                pl_objRequest                       = objContext.Request;
                pl_objResponse                      = objContext.Response;
                pl_objResParam                      = new DefaultResParam();

                // 보안체크 1. UrlReferrer 확인
                if (!UserGlobal.GetUrlReferrer(pl_objRequest, out strRefererUrl))
                {
                    pl_intRetVal = 4001;
                    pl_strErrMsg = "Failed to GetUrlReferrer";
                    return;
                }

                // 보안체크 2. 전송 파라미터(json) 확인
                using (StreamReader objSR = new StreamReader(pl_objRequest.InputStream))
                {
                    pl_strReqParam = objSR.ReadToEnd();
                    JsonSerializerSettings set = new JsonSerializerSettings();
                    set.NullValueHandling      = NullValueHandling.Ignore;
                    pl_objReqParam = JsonConvert.DeserializeObject<DefaultReqParam>(pl_strReqParam, set);
                    
                    if (pl_objReqParam == null)
                    {
                        pl_intRetVal = 4002;
                        pl_strErrMsg = "RequestParam is Empty";
                        return;
                    }
                }

                // 보안체크 3.AjaxTicket 확인
                if (!UserGlobal.VerifyAjaxTicket(strRefererUrl, pl_objReqParam.strAjaxTicket))
                {
                    pl_intRetVal = 4003;
                    pl_strErrMsg = "Failed to VerifyAjaxTicket";
                    return;
                }

                // 보안체크 4. 메소드 이름 확인
                try
                {
                    // front 에서 호출한 메소드 이름이 같은 메소드가 있으면 할당
                    objMethodInfo = this.GetType().GetMethod(pl_objReqParam.strMethodName, BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.DeclaredOnly);
                    // 해당 메소드의 MethodSet 어노테이션 할당.
                    objMethodAttr = objMethodInfo.GetCustomAttribute(typeof(MethodSet)) as MethodSet;
                }
                catch {
                    pl_intRetVal = 4004;
                    pl_strErrMsg = "Invalid strMethodName";
                    return;
                }

                // 보안체크 5. 메소드 접근권한 체크.
                if (objMethodAttr.pageType.Equals(PageAccessType.Login)){
                    objSes = new UserSession();
                    if(!objSes.isLogin)
                    {
                        pl_intRetVal = 4005;
                        pl_strErrMsg = "do not have permission.";
                        return;
                    }
                }

                // 생성된 파라미터를 핸들러 메소드에 넣어준다.
                // PLNOTICE 요청, 응답, 메시지 꼭 이 순서로 함수를 구성하여야한다.
                parameters = new object[] { GetParamter(strReq, objMethodInfo, pl_strReqParam), GetParamter(strRes, objMethodInfo), null };

                // 핸들러 메소드 실행
                pl_intRetVal    = (int)objMethodInfo.Invoke(this , parameters);
                // 실행 후 반환 된 응답값을 pl_objResParam에 담아준다.
                pl_objResParam  = Convert.ChangeType(parameters[1], Type.GetType(objMethodInfo.GetParameters()[1].ParameterType.AssemblyQualifiedName)) as DefaultResParam;
                // 실행 후 반환 된 메시지값을 pl_strErrMsg에 담아준다.
                if (!pl_intRetVal.Equals(0))
                {
                    pl_strErrMsg = (string)parameters[2];
                    return;
                }
            }
            catch (Exception pl_objEx)
            {
                pl_intRetVal = -24001;
                UtilLog.WriteExceptionLog(pl_objEx.Message, pl_objEx.StackTrace);
            }
            finally
            {
                pl_objResParam.intRetVal = pl_intRetVal;

                if (!pl_intRetVal.Equals(0))
                {
                    UtilLog.WriteLog(strPageMethodName, pl_intRetVal, "ReqParameter : " + JsonConvert.SerializeObject(pl_objReqParam) + "ErrMsg : " + pl_strErrMsg);

                    // 4000번대 에러인 경우 대표메시지 설정.
                    if ((pl_intRetVal / 1000).Equals(4))
                    {
                        pl_objResParam.strErrMsg = "잘못된 접근입니다.";
                    }
                    // 대표메시지가 설정되어 있는 경우 대표메시지 출력
                    else if (objMethodAttr != null && !string.IsNullOrEmpty(objMethodAttr.strRepresentMsg))
                    {
                        pl_objResParam.strErrMsg = objMethodAttr.strRepresentMsg;
                    }
                    else
                    {
                        pl_objResParam.strErrMsg = pl_strErrMsg;
                    }
                }

                // JSON 결과 리턴
                pl_strJsonResult = JsonConvert.SerializeObject(pl_objResParam);
                pl_objResponse.Write(pl_strJsonResult);

                // 로깅이 필요한 메소드의 경우 인/아웃풋 로깅
                if (objMethodAttr != null && objMethodAttr.loggingFlag)
                {
                    UtilLog.WriteLog(strPageMethodName, pl_intRetVal, string.Format("ReqParam = {0}", pl_strReqParam));
                    UtilLog.WriteLog(strPageMethodName, pl_intRetVal, string.Format("Method : {0}, JsonData: {1}", pl_objReqParam.strMethodName, pl_strJsonResult));
                }

                pl_objReqParam = null;
                pl_objRequest  = null;
                pl_objResponse = null;
                pl_objResParam = null;
            }

            return;
        }

        //-------------------------------------------------------------
        /// <summary>
        /// 파라미터를 동적으로 생성.
        /// </summary>
        //-------------------------------------------------------------
        private object GetParamter(string strType, MethodInfo objMethodInfo, string strSerial = null)
        {
            Type       getInstanceMethod;
            MethodInfo methodInfo;
            Type       paramType;
            Type[]     genericArguments;
            MethodInfo genericMethodInfo;
            
           
            getInstanceMethod = this.GetType().BaseType;
             // 현재 핸들러의 메소드중 GetReqInstance/GetResInstance의 정보를 가져온다.
             // 실행할 메소드의 파라미터의(요청 또는 응답) 클래스타입을 받아온다.
            if(strType.Equals(strReq))
            {
                methodInfo = getInstanceMethod.GetMethod("GetReqInstance", BindingFlags.Static | BindingFlags.Public);
                paramType  = Type.GetType(objMethodInfo.GetParameters()[0].ParameterType.AssemblyQualifiedName);
            }
            else
            {
                methodInfo = getInstanceMethod.GetMethod("GetResInstance", BindingFlags.Static | BindingFlags.Public);
                paramType  = Type.GetType(objMethodInfo.GetParameters()[1].ParameterType.AssemblyQualifiedName);
            }
            
            // 파라미터 타입을 세팅하고 GetReqInstance/GetResInstance 에 제네릭 값을 세팅한다.
            genericArguments = new Type[] { paramType };
            genericMethodInfo = methodInfo.MakeGenericMethod(genericArguments);  

            // GetReqInstance/GetResInstance 실행하여 인스턴스 생성.
            if(strType.Equals(strReq))
            {
                return genericMethodInfo.Invoke(null, new object[] { strSerial });
            }else
            {
                return genericMethodInfo.Invoke(null, new object[] { });
            }
        }

        //-------------------------------------------------------------
        /// <summary>
        /// 요청 파라미터 값 전달
        /// </summary>
        //-------------------------------------------------------------
        public static T GetReqInstance<T>(string pl_strReqParam)
        {
            return JsonConvert.DeserializeObject<T>(pl_strReqParam);
        }

        //-------------------------------------------------------------
        /// <summary>
        /// 응답 파라미터 값 전달
        /// </summary>
        //-------------------------------------------------------------
        public static T GetResInstance<T>() where T : new()
        {
            return new T();
        }
        
        //-------------------------------------------------------------
        /// <summary>
        /// IsReusable
        /// </summary>
        //-------------------------------------------------------------
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
    
    ///--------------------------------------------------------------------------------------------
    /// <summary>
    /// Function Name  : MethodSet
    /// Description    : 핸들러 메소드 정보
    /// Author         : ysjee@payletter.com, 2018-08-20
    /// Modify History : Just Created.
    /// <summary>
    ///--------------------------------------------------------------------------------------------
    [AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
    public class MethodSet : Attribute
    {
        /// <summary>
        /// 페이지 접근 권한
        /// </summary>
        public PageAccessType pageType        { get; set; }
        /// <summary>
        /// In/Output 로깅 여부
        /// </summary>
        public bool           loggingFlag     { get; set; }
        /// <summary>
        /// 대표 메시지, 설정 안할시 오류 그대로 출력.
        /// </summary>
        public string         strRepresentMsg { get; set; }
    }

    //-------------------------------------------------------------
    /// <summary>
    /// 요청 파라미터 데이터 클래스
    /// </summary>
    //-------------------------------------------------------------
    public class DefaultReqParam
    {
        public string strAjaxTicket  { get; set; }
        public string strMethodName  { get; set; }
        
        public DefaultReqParam()
        {

        }
    }

    //-------------------------------------------------------------
    /// <summary>
    /// 응답 파라미터 데이터 클래스
    /// </summary>
    //-------------------------------------------------------------
    public class DefaultResParam
    {
        public int    intRetVal { get; set; }
        public string strErrMsg { get; set; }

        public DefaultResParam()
        {

        }
    }

    //-------------------------------------------------------------
    /// <summary>
    /// 리스트 응답 파라미터 데이터 클래스
    /// </summary>
    //-------------------------------------------------------------
    public class DefaultListResParam : DefaultResParam
    {
        public DataTable objDT     { get; set; }
        public int       intRowCnt { get; set; }
    }
}