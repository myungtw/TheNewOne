<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

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
        //로그아웃
        $("#btnLogout").on("click", fnLoutout);
    });

    function fnLoutout() {
        window.location.href = "/Src/Login/Logout.aspx";
    }
</script>
</head>
<body>
    <form id="frmIndex" name="frmIndex" runat="server">
        <div class="wrap">
            <div class="login_wrap">
                <h1>User Index</h1>
                <h2>User</h2>
                <div>
                    <button type="button" id="btnLogout" name="btnLogout" class="navy">로그아웃</button>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
