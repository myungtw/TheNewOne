<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LogInForm.aspx.cs" Inherits="LoginForm" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head lang="ko" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Front :: 로그인</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, target-densitydpi=medium-dpi, user-scalable=no, minimal-ui" />
<script type="text/javascript" src="/Lib/jQuery/jquery-1.12.4.js"></script>
<script type="text/javascript" src="/Lib/jQuery/jquery.ajax-retry.min.js"></script>
<script type="text/javascript" src="/Lib/BOQ.js?<%=DateTime.Now.ToString("yyyyMMdd") %>"></script>
<script type="text/javascript">
    $(document).ready(function () {
        //로그인 여부
        if ("<%=objSes.isLogin%>" == "True") {
            window.location.href = "<%=strIndexUrl %>";
        }

        //저장된 아이디 여부
        fnSavedIDCheck();

        //로그인
        $("#btnLogin").on("click", fnVerifyLogin);

        //Enter키 이벤트
        $("body").keydown(function (e) {
            if (e.keyCode == 13) {
                //로그인
                $("#btnLogin").click();
            }
        });
    });

    //저장된 아이디 여부
    function fnSavedIDCheck() {
        var savedID = BOQ.Cookie.fnGetCookie("<%=strSaveIDCookie %>");      //아이디 저장 쿠키
        if (savedID != "") {
            $("#txtID").val(savedID);
            $("#chkSavaID").prop("checked", true);
        }
    }

    //로그인 요청
    function fnVerifyLogin() {
        //아이디 앞뒤 공백 제거
        $("#txtID").val($.trim($("#txtID").val()));

        var loginID = $("#txtID").val();
        var loginPW = $("#txtPW").val();
        var isSave  = $("#chkSavaID").is(":checked");

        //유효성 검사
        if (loginID == "") {
            loginID.focus();
            alert("ID를 입력해주세요.");
            return false;
        }
        if (loginPW == "") {
            loginPW.focus();
            alert("패스워드를 입력해주세요");
            return false;
        }

        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.LOGINHANDLER%>";
        var callBack = "fnVerifyLoginCallBack";

        reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
        reqParam["strMethodName"] = 'VerifyLogin';
        reqParam["strI"]          = loginID;
        reqParam["strP"]          = loginPW;
        reqParam["blnSave"]       = isSave;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    //로그인 요청 CallBack
    function fnVerifyLoginCallBack(result) {
        if (result.intRetVal != 0) {
            alert("(" + result.intRetVal + ")" + result.strErrMsg);
            return;
        }

        window.location.href = "<%=strIndexUrl %>";
    }
</script>
</head>
<body>
    <form id="frmLogin" name="frmLogin" runat="server">
        <div class="wrap">
            <div class="login_wrap">
                <h1>User Login</h1>
                <h2>User</h2>
                <div class="login_cont">
                    <ul>
                        <li><span class="id"><input type="text"     id="txtID" name="txtID" placeholder="ID를 입력해주세요" /></span></li>
                        <li><span class="pw"><input type="password" id="txtPW" name="txtPW" placeholder="패스워드를 입력해주세요" /></span></li>
                    </ul>
                    <div class="privacy">
                        <input type="checkbox" id="chkSavaID" name="chkSavaID" /><label for="chkSavaID">아이디 저장</label>
                    </div>
                    <button type="button" id="btnLogin" name="btnLogin" class="navy">로그인</button>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

