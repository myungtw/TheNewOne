<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LogInForm.aspx.cs" Inherits="LoginForm" MasterPageFile="~/MasterPage/BaseMasterPage.master" %>
<asp:Content ID="content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
    $(document).ready(function () {
            $(".banner_area").remove();
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

        reqParam["strAjaxTicket"]       = '<%=AjaxTicket %>';
        reqParam["strMethodName"]       = 'VerifyLogin';
        reqParam["strI"]                = loginID;
        reqParam["strP"]                = loginPW;
        reqParam["blnSave"]             = isSave;
        reqParam["strEncFamilyEventNo"] = "<%=EncFamilyEventNo%>";

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
</asp:Content>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<!--================Header Menu Area =================-->
        
    <section class="home_banner_area blog_banner">
        <div class="banner_inner d-flex align-items-center">
            <div class="overlay bg-parallax" data-stellar-ratio="0.9" data-stellar-vertical-offset="0" data-background=""></div>
		    <div class="container">
                <div class="element-wrap">
                    <div class="blog_b_text text-center">
                    <h1></h1>
                    <h2>Login</h2>
                        <div class="login_cont">
                            <div class="mt-10">
					            <input type="text"     class="single-input"  id="txtID" name="txtID" placeholder="ID를 입력해주세요" />
				            </div>
                            <div class="mt-10">
					            <input type="password" class="single-input"  id="txtPW" name="txtPW" placeholder="패스워드를 입력해주세요" />
				            </div>
                            <div class="switch-wrap d-flex justify-content-between mt-10">
				                <label for="chkSavaID">아이디 저장</label>
				                <div class="primary-checkbox">
					                <input type="checkbox" id="chkSavaID" name="chkSavaID" />
					                <label for="chkSavaID"></label>
				                </div>
                            </div>
                            <button type="button" id="btnLogin" name="btnLogin" class="genric-btn default-border radius arrow">로그인<span class="lnr lnr-arrow-right"></span></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>

