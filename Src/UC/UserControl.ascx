<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UserControl.ascx.cs" Inherits="UserControl" %>
    
<script type="text/javascript">
    $(document).ready(function () {
        $("#ulSelectType").html("<%=strSelectMemberTypeHtml%>");
        // ----- event 설정 -------------------------------------------------------
        // 회원 타입 이벤트 설정
        $("input[name='member']").change(function() { fnSelectMemberType(); });
        // 회원 검색 이벤트 설정
        $("#btSearch").on("click", fnSearchUser);

        // ----- 초기 설정 -------------------------------------------------------
        fnGetStoreList();
    });

    
    
    //==========================================================================
    // 이벤트 설정
    //==========================================================================
    // 회원 or 비회원 버튼 선택 시 이벤트 설정
    function fnSelectMemberType() {
        var checkedType = $("input[name='member']:checked").attr("id");

        // 비회원일때
        if(checkedType == "select_type01") {
            // 검색창 변경
            $("#divMember").hide();
            $("#divNonMember").show();

            // 다음 버튼 클래스 변경
            $("#aNext").removeClass("btn_gray").addClass("btn_navy");

            // 기존 검색 값 삭제
            $("#userName").val("");
            $("#cellphoneNumber").val("");
            $("#pNoResult").hide();
            $(".search_list").hide();
        }
        // 회원일때
        else if (checkedType == "select_type02") {
            // 검색창 변경
            $("#divNonMember").hide();
            $("#divMember").show();

            // 다음 버튼 클래스 변경
            $("#aNext").removeClass("btn_navy").addClass("btn_gray");
        }
    }
    
    function setSearchUI() {
        var selectedVal = $("#searchtype").val();
        var placeholder = "";

        // 이름
        if(selectedVal == "1") {
            placeholder = "홍길동";
            $("#liInfo").show();
        }
        else {
            $("#liInfo").hide();

            // 아이디
            if(selectedVal == "2") {
                placeholder = "아이디";
            }
            // 닉네임
            else if(selectedVal == "3") {
                placeholder = "닉네임";
            }
        }
        $("#searchval").val("").attr("placeholder", placeholder);
    }

    function setInfoUI() {
        var selectedVal = $("#infotype").val();
        var placeholder = "";

        // 휴대번호
        if (selectedVal == "1") {
            placeholder = "휴대번호 뒤 4자리";
        }
        else if (selectedVal == "2") {
            placeholder = "예)19820508";
        }
        $("#infoval").val("").attr("placeholder", placeholder);
    }



    //==========================================================================
    // AJAX 호출, Callback 함수 정의
    //==========================================================================
    // 매장 조회
    function fnGetStoreList() {
        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.USERHANDLER%>";
        var callBack = "fnGetStoreListCallBack";

        reqParam["strAjaxTicket"] = '<%=AjaxTicket%>';
        reqParam["strMethodName"] = 'GetStoreList';

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }
    // 매장 조회 Callback
    function fnGetStoreListCallBack(result) {
        var target      = $("#shop");
        var html        = "";

        if (result.intRetVal != 0) {
            alert("매장 조회에 실패하였습니다.");
            target.html(html);
            return;
        }

        var objRet = result.golfzonStoreList;
        if(objRet != null) {
            if (objRet.code == "1") {
                var storeCode = "";

                if (objRet.entitys.length > 0) {                    
                    for (var i = 0 ; i < objRet.entitys.length; i++) {
                        html += "<option value='" + objRet.entitys[i].rgnNo + "'>" + objRet.entitys[i].rgnNm + "</option>";
                    }
                    storeCode = objRet.entitys[0].rgnNo;
                }
                else {
                    target.html(html);
                    alert("매장 조회에 실패하였습니다.");
                    return;
                }

                target.html(html);

                // 매니저 조회
                fnGetManagerList(storeCode);

                // 프로 조회
                fnGetProList(storeCode);
            }
        }
    }
    
    // 매니저 조회
    function fnGetManagerList(storeCode) {
        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.USERHANDLER%>";
        var callBack = "fnGetManagerListCallBack";

        reqParam["strAjaxTicket"] = '<%=AjaxTicket%>';
        reqParam["strMethodName"] = 'GetManagerList';
        reqParam["strStoreCode"]  = storeCode;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }
    // 매니저 조회 Callback
    function fnGetManagerListCallBack(result) {
        var target      = $("#seller");
        var html        = "";

        if (result.intRetVal != 0) {
            target.html(html);
            alert("매니저 조회에 실패하였습니다.");
            return;
        }

        var objRet = result.golfzonManagerList;
        if(objRet != null) {
            if (objRet.code == "1") {
                if (objRet.entitys.length > 0) {                    
                    for (var i = 0 ; i < objRet.entitys.length; i++) {
                        html += "<option value='" + objRet.entitys[i].userNo + "' data-userid='" + objRet.entitys[i].userId + "'>" + objRet.entitys[i].userNm + "</option>";
                    }
                }
                else {
                    target.html(html);
                    alert("매니저 조회에 실패하였습니다.");
                    return;
                }

                target.html(html);
            }
        }
    }
    
    // 프로 조회
    function fnGetProList(storeCode) {
        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.USERHANDLER%>";
        var callBack = "fnGetProListCallBack";

        reqParam["strAjaxTicket"] = '<%=AjaxTicket%>';
        reqParam["strMethodName"] = 'GetProList';
        reqParam["strStoreCode"]  = storeCode;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }
    // 프로 조회 Callback
    function fnGetProListCallBack(result) {
        var target  = $("#name");
        var html    = "";

        if (result.intRetVal != 0) {
            target.html(html);
            alert("프로 조회에 실패하였습니다.");
            return;
        }

        var objRet = result.golfzonProList;
        if(objRet != null) {
            if (objRet.code == "1") {
                var strStoreCode = "";

                if (objRet.entitys.length > 0) {                    
                    for (var i = 0 ; i < objRet.entitys.length; i++) {
                        html += "<option value='" + objRet.entitys[i].userNo + "'>" + objRet.entitys[i].userNm + "</option>";
                    }
                }
                else {
                    target.html(html);
                    alert("프로 조회에 실패하였습니다.");
                    return;
                }

                target.html(html);
            }
        }
    }

    
    // 회원 조회
    function fnSearchUser() {
        // ========= 핸들러 호출 변수 ======================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.USERHANDLER%>";
        var callBack = "fnSearchUserCallBack";

        reqParam["strAjaxTicket"] = '<%=AjaxTicket%>';


        // ========= 유효성 체크 변수 ======================
        var searchtype  = $("#searchtype").val();
        var searchval   = $("#searchval").val();
        var infotype    = $("#infotype").val();
        var infoval     = $("#infoval").val();
        var errmsg      = "";
        
        // 이름
        if (searchtype == "1") {
            reqParam["strMethodName"]   = 'GetUserByAddInfo';
            reqParam["strUserName"]     = searchval;
            errmsg = "이름을 입력해주세요.";
        }
        // 아이디
        else if (searchtype == "2") {
            reqParam["strMethodName"]   = 'GetUserByUserID';
            reqParam["strUserID"]       = searchval;
            errmsg = "아이디를 입력해주세요.";
        }
        // 닉네임
        else if (searchtype == "3") {
            reqParam["strMethodName"]   = 'GetUserByNickName';
            reqParam["strNickName"]     = searchval;
            errmsg = "닉네임을 입력해주세요.";
        }
        else {
            alert("잘못된 검색 유형입니다.");
            $("#searchtype").focus();
            return;
        }
        if ( !searchval ) {
            alert(errmsg);
            $("#searchval").focus();
            return;
        }

        if (searchtype == "1") {
            var RegExp;
            var validchk = true;
            // 휴대번호
            if (infotype == "1") {
                errmsg = "휴대번호 뒤 네자리를 입력해주세요.";

                RegExp = /^[0-9]{4}$/;
                if (infoval && !RegExp.test(infoval)) {
                    errmsg      = "휴대번호 뒤 네자리를 숫자로 입력해주세요.\nex) 1234";
                    validchk    = false;
                }
                else {
                    reqParam["strUserCellphoneEnd"] = infoval;
                    reqParam["strUserBirthDay"]     = "";                    
                }
            }
            // 생년월일
            else if (infotype == "2") {
                errmsg = "생년월일을 입력해주세요.";

                RegExp = /^[0-9]{8}$/;
                if (infoval && !RegExp.test(infoval)) {
                    errmsg      = "생년월일 여덟자리를 숫자로 입력해주세요.\nex) 19820508";
                    validchk    = false;
                }
                else {
                    reqParam["strUserCellphoneEnd"] = "";
                    reqParam["strUserBirthDay"]     = infoval;                       
                }
            }
            else {
                alert("잘못된 검색 유형입니다.");
                $("#infotype").focus();
                return;
            }
            if ( !infoval || !validchk ) {
                alert(errmsg);
                $("#infoval").focus();
                return;
            }
        }

        // 호출
        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }
    // 회원 조회 Callback
    function fnSearchUserCallBack(result) {
        var target      = $(".search_list");
        var html        = "";

        if (result.intRetVal != 0) {
            alert("회원 조회에 실패하였습니다.");
            return;
        }

        $("#pNoResult").hide();

        var objRet = result.objGolfzonUserInfo;
        if(objRet != null) {
            if (objRet.code == "000") {
                // test 계정의 경우 실제 반영 시 삭제 필요
                if (objRet.entitys.length > 0 && ($("#userName").val() != "test")) {
                    $(".search_list").show();

                    for (var i = 0 ; i < objRet.entitys.length; i++) {
                        html += "<li><input type='radio' name='member_list' id='list" + i + "'" + (i==0 ? " checked='checked'" : "") + " value='" + objRet.entitys[i].usrNo + "'><label for='list" + i + "'><text>" + objRet.entitys[i].usrName + "</text>(<text>" + objRet.entitys[i].usrId + "</text>)" + "</label></li>"
                    }

                    $("#aNext").removeClass("btn_gray").addClass("btn_navy");
                }
                else {
                    $("#pNoResult").show();
                }
            }
            else               
                $("#pNoResult").show();
        }
        target.html(html);
    }


    // 판매 정보 쿠키 생성
    function fnSetSaleCookie() {
        // ========= 유효성 체크 ===========================
        var storeCode   = $("#shop").val();
        var managerNo   = $("#seller").val();
        var managerID   = $("#seller option:selected").data("userid");
        var managerName = $("#seller option:selected").text();
        var proNo       = $("#name").val();

        var siteCode    = "2";
        var userNo      = "0";
        var userID      = "";
        var userName    = "";

        // 매장 선택
        if (!storeCode) {
            alert("매장을 선택해주세요.");
            return;
        }

        // 판매자 선택
        if (!managerNo) {
            alert("판매자를 선택해주세요.");
            return;
        }
        
        // 프로 선택
        if (!proNo) {
            alert("담당 프로를 선택해주세요.");
            return;
        }

        // 회원 선택
        var checkedType = $("input[name='member']:checked").attr("id");

        // 회원 선택 타입
        var checkedType = $("input[name='member']:checked").attr("id");
        // 비회원일때
        if(checkedType == "select_type01") {
            userNo          = "0";
            userID          = "guest";
            userName        = "비회원";
            siteCode        = "99";
        }
        // 회원일때
        else if(checkedType == "select_type02") {
            // 회원일때만 체크
            if($("input[name='member_list']:checked").length != 1) {
                alert("회원을 선택해주세요.");
                return;
            }
            var $objUser    = $("input[name='member_list']:checked");
            userNo          = $objUser.val();
        }

        // ========= 핸들러 호출 ===========================
        var reqParam    = {};
        var callURL     = "<%=HandlerRefer.USERHANDLER%>";
        var callBack    = "fnSetSaleCookieCallBack";

        reqParam["strAjaxTicket"]       = '<%=AjaxTicket%>';
        reqParam["strMethodName"]       = 'SetSaleCookie';
        reqParam["strStoreCode"]        = storeCode;
        reqParam["intManagerNo"]        = managerNo;
        reqParam["strManagerID"]        = managerID;

        reqParam["strManagerName"]      = managerName;
        reqParam["intProNo"]            = proNo;
        reqParam["intSiteCode"]         = siteCode;
        reqParam["intUserNo"]           = userNo;
        reqParam["strUserID"]           = userID;

        reqParam["strUserName"]         = userName;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }
    // 판매 정보 쿠키 생성 Callback
    function fnSetSaleCookieCallBack(result) {
        if (result.intRetVal != 0) {
            alert(result.strErrMsg);
            return;
        }
        
        // 쿠키 생성에 이상이 없으면 페이지 이동
        location.href = "<%=strReturnURL%>";
    }

</script>
 <div class="member_wrap">
    <h2>사원 정보</h2>
    <ul class="member_select">
        <li class="shop"><label for="shop">매장명</label><select id="shop" onchange="javascript:fnGetManagerList($(this).val()); fnGetProList($(this).val());"></select></li>
        <li class="seller"><label for="seller">판매자<br>(처리자)</label><select id="seller"></select></li>
        <li class="name"><label for="name">담당프로</label><select id="name"></select></li>
    </ul>
    <h2>회원 검색</h2>
    <div class="search_member">
        <ul class="select_type" id="ulSelectType"></ul>
        <div class="search_cont" id="divMember">
            <ul class="search_area">                
                <li><select onchange="javascript:setSearchUI();" id="searchtype"><option selected="selected" value="1">이름</option><option value="2">아이디</option><option value="3">닉네임</option></select><span><input type="text" id="searchval" placeholder="홍길동"></span></li>
                <li id="liInfo"><select id="infotype" onchange="javascript:setInfoUI()"><option value="1" selected="selected">휴대번호</option><option value="2">생년월일</option></select><span><input type="tel" id="infoval" placeholder="휴대번호 뒤 4자리"></span></li>
                <li><button type="button" id="btSearch" class="navy">검색</button></li>
            </ul>
            <ul class="search_list" style="display:none;"></ul>
            <p id="pNoResult" style="display:none;">검색된 회원이 없습니다.</p>
        </div>
        <div class="search_cont" id="divNonMember" style="display:none;">
            <p>비회원 판매는 1회성 상품만 판매해 주세요.</p>
        </div>
    </div>
</div>
<footer>
<a href="javascript:fnSetSaleCookie()" id="aNext" class="btn btn_gray" title="다음">다음</a>
</footer>
