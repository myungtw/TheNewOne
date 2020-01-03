<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LogInForm.aspx.cs" Inherits="LoginForm" MasterPageFile="~/MasterPage/BaseMasterPage.master" %>
<asp:Content ID="content1" ContentPlaceHolderID="head" runat="server">
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
</asp:Content>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<!--================Header Menu Area =================-->
        <header class="header_area">
            <div class="main_menu">
            	<nav class="navbar navbar-expand-lg navbar-light">
					<div class="container box_1620">
						<!-- Brand and toggle get grouped for better mobile display -->
						<a class="navbar-brand logo_h" href="index.html"><img src="img/logo.png" alt=""></a>
						<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</button>
						<!-- Collect the nav links, forms, and other content for toggling -->
						<div class="collapse navbar-collapse offset" id="navbarSupportedContent">
							<ul class="nav navbar-nav menu_nav ml-auto">
								<li class="nav-item active"><a class="nav-link" href="index.html">Home</a></li> 
								<li class="nav-item"><a class="nav-link" href="about-us.html">About</a></li>
								<li class="nav-item"><a class="nav-link" href="properties.html">Properties</a></li>
								<li class="nav-item"><a class="nav-link" href="agents.html">Team</a></li>
								<li class="nav-item submenu dropdown">
									<a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Pages</a>
									<ul class="dropdown-menu">
										<li class="nav-item"><a class="nav-link" href="elements.html">Elements</a></li>
									</ul>
								</li> 
								<li class="nav-item submenu dropdown">
									<a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Blog</a>
									<ul class="dropdown-menu">
										<li class="nav-item"><a class="nav-link" href="blog.html">Blog</a></li>
										<li class="nav-item"><a class="nav-link" href="single-blog.html">Blog Details</a></li>
									</ul>
								</li> 
								<li class="nav-item"><a class="nav-link" href="contact.html">Contact</a></li>
							</ul>
							<ul class="nav navbar-nav navbar-right">
								<li class="nav-item"><a href="#" class="search"><i class="lnr lnr-magnifier"></i></a></li>
							</ul>
						</div> 
					</div>
            	</nav>
            </div>
        </header>
        <section class="home_banner_area blog_banner">
            <div class="banner_inner d-flex align-items-center">
            	<div class="overlay bg-parallax" data-stellar-ratio="0.9" data-stellar-vertical-offset="0" data-background=""></div>
		        <div class="container">
                    <div class="element-wrap">
                    <div class="blog_b_text text-center">
                    <h1>User Login</h1>
                    <h2>User</h2>
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

