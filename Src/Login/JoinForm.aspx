<%@ Page Language="C#" AutoEventWireup="true" CodeFile="JoinForm.aspx.cs" Inherits="JoinForm" MasterPageFile="~/MasterPage/BaseMasterPage.master" %>

<asp:Content ID="content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
    $(document).ready(function () {
        $(".banner_area").remove();

        //로그인 여부
        if ("<%=objSes.isLogin%>" == "True") {
            window.location.href = "<%=strIndexUrl %>";
        }

        //로그인
        $("#btnJoin").on("click", fnJoin);

        //Enter키 이벤트
        $("body").keydown(function (e) {
            if (e.keyCode == 13) {
                //로그인
                $("#btnJoin").click();
            }
        });
        
    });

    //회원 가입 요청
    function fnJoin() {
        var strUserId       = "";
        var strUserPwd      = "";
        var strUserName     = "";
        var strUserPhoneNo  = "";
        var regExp;

        strUserId       = $("#userid").val();
        strUserPwd      = $("#userpwd").val();
        strUserName     = $("#username").val();
        strUserPhoneNo  = $("#usertel").val();

        //유효성 검사
        if (strUserId == "") {
            $("#userid").focus();
            alert("아이디를 입력해주세요.");
            return false;
        }
        if (strUserPwd == "") {
            $("#userpwd").focus();
            alert("비밀번호를 입력해주세요.");
            return false;
        }
        if (strUserName == "") {
            $("#username").focus();
            alert("이름을 입력해주세요.");
            return false;
        }
        if (strUserPhoneNo == "") {
            $("#usertel").focus();
            alert("핸드폰번호를 입력해주세요.");
            return false;
        }
        regExp = /^\d{3}-\d{3,4}-\d{4}$/;
        if (!regExp.test(strUserPhoneNo)) {
            $("#usertel").focus();
            alert("올바른 핸드폰번호를 입력해주세요.\nex) 010-1234-1234");
            return false;
        }

        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.LOGINHANDLER%>";
        var callBack = "fnJoinCallBack";

        reqParam["strAjaxTicket"]       = '<%=AjaxTicket %>';
        reqParam["strMethodName"]       = 'Join';        
        reqParam["strUserId"]           = strUserId;
        reqParam["strUserPwd"]          = strUserPwd;
        reqParam["strUserName"]         = strUserName;
        reqParam["strUserPhoneNo"]      = strUserPhoneNo;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    //로그인 요청 CallBack
    function fnJoinCallBack(result) {
        if (result.intRetVal != 0) {
            alert("(" + result.intRetVal + ")" + result.strErrMsg);
        }
        else {
            alert("회원 가입에 성공하였습니다.");
            window.location.href = "<%=strLoginUrl%>";
        }
        return;
    }
    </script>
</asp:Content>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="home_banner_area blog_banner">
        <div class="banner_inner d-flex align-items-center">
            <div class="overlay bg-parallax" data-stellar-ratio="0.9" data-stellar-vertical-offset="0" data-background=""></div>
		    <div class="container">
                <div class="element-wrap">
                    <div class="blog_b_text text-center">
                    <h1></h1>
                    <h2>Join</h2>
                        <div class="login_cont">
					        <div class="input-group-icon mt-10">
                                <div class="icon"><i class="fa fa-book" aria-hidden="true"></i></div>
						        <input type="text" id="userid" placeholder="아이디" onfocus="this.placeholder = ''" onblur="this.placeholder = '아이디'" required class="single-input"/>
					        </div>
					        <div class="input-group-icon mt-10">
                                <div class="icon"><i class="fa fa-lock" aria-hidden="true"></i></div>
						        <input type="password" id="userpwd" placeholder="비밀번호" onfocus="this.placeholder = ''" onblur="this.placeholder = '비밀번호'" required class="single-input"/>
					        </div>
					        <div class="input-group-icon mt-10">
                                <div class="icon"><i class="fa fa-user" aria-hidden="true"></i></div>
						        <input type="text" id="username" placeholder="이름" onfocus="this.placeholder = ''" onblur="this.placeholder = '이름'" required class="single-input"/>
					        </div>
					        <div class="input-group-icon mt-10">
                                <div class="icon"><i class="fa fa-mobile-phone" aria-hidden="true"></i></div>
						        <input type="tel" id="usertel" placeholder="핸드폰번호" onfocus="this.placeholder = ''" onblur="this.placeholder = '핸드폰번호'" required class="single-input"/>
					        </div>
                            <br />
                            <button type="button" id="btnJoin" name="btnJoin" class="genric-btn default-border radius arrow">로그인<span class="lnr lnr-arrow-right"></span></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>

