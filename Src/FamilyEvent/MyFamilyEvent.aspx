<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="MyFamilyEvent.aspx.cs" Inherits="MyFamilyEvent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script src="/Lib/qrcode.min.js"></script>

<script type="text/javascript">
    var familyEventNo    = <%=intFamilyEventNo %>;
    var loginUserNo      = <%=intUserNo %>;
    var myFamilyEventUrl = "<%=string.Format("{0}?encfamilyeventno={1}", strLoginUrl, strEncFamilyEventNo) %>";
    var qrcode;
    var qrcodeTitle;
    var loginUserJoinMstCategory;
    var facilityticketcode = "food";

    $(document).ready(function () {
        if (familyEventNo == 0 ) {
            alert("유효하지 않은 이벤트 번호 입니다.");
            window.location.href = "<%=strFamilyEventIndexUrl %>";
            return;
        }

        //내 이벤트 정보 조회 호출
        fnFamilyEventInfo();
    });

    //내 이벤트 정보 조회 핸들러 호출
    function fnFamilyEventInfo() {
        var reqParam = {};
        var callURL = "<%=HandlerRefer.FAMILYEVENTHANDLER%>";
        var callBack = "fnFamilyEventInfoCallBack";

        reqParam["strAjaxTicket"]    = '<%=AjaxTicket %>';
        reqParam["strMethodName"]    = 'GetFamilyEventInfo';
        reqParam["intFamilyEventNo"] = familyEventNo;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    //내 이벤트 정보 수정 핸들러 호출
    function fnUpdFamilyEventInfo(limitpolicytype, limitpolicyval, facilitytickettype, limitpolicyname) {
        var reqParam = {};
        var callURL = "<%=HandlerRefer.FAMILYEVENTHANDLER%>";
        var callBack = "fnUpdFamilyEventInfoCallBack";

        reqParam["strAjaxTicket"]         = '<%=AjaxTicket %>';
        reqParam["strMethodName"]         = 'UpdFamilyEventInfo';
        reqParam["intFamilyEventNo"]      = familyEventNo;
        reqParam["intLimitPolicyType"]    = limitpolicytype;
        reqParam["strLimitPolicyVal"]     = limitpolicyval;
        reqParam["intFacilityTicketType"] = facilitytickettype;
        reqParam["strLimitPolicyName"]    = limitpolicyname;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    //시설이용권 추가발급 핸들러 호출
    function fnFacilityTicket(targetuserid, facilitytickettype, facilityticketamount) {
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.FAMILYEVENTHANDLER%>";
        var callBack = "fnFacilityTicketInsCallBack";

        reqParam["strAjaxTicket"]            = '<%=AjaxTicket %>';
        reqParam["strMethodName"]            = 'InsFacilityTicket';
        reqParam["strUserID"]                = targetuserid;
        reqParam["intFamilyEventNo"]         = familyEventNo;
        reqParam["intFacilityTicketType"]    = facilitytickettype;
        reqParam["intFacilityTicketAmount"]  = facilityticketamount;

        reqParam["intFacilityTicketRegType"] = 2;
        reqParam["intJoinMstCategory"]       = loginUserJoinMstCategory;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    //내 이벤트 정보 조회 결과
    function fnFamilyEventInfoCallBack(result) {
        if (result.intRetVal != 0) {
            alert("내역 조회에 실패하였습니다.");

            return;
        }

        //QR코드 발급 제목 지정
        qrcodeTitle = result.strFamilyEventName;

        //대분류 값 지정
        loginUserJoinMstCategory = result.intJoinMstCategory;
        
        $("#familyEventName").html(result.strFamilyEventName);
        $("#familyEventDate").html(result.strFamilyEventDate);
        $("#hallName").html(result.strHallName);
        $("#hallAddress").html(result.strHallAddress);
        $("#hallPhoneNo").html(result.strHallPhoneNo);

        $("#minPayAmount").html(result.mnyMinPayAmt);
        $("#maxFoodTicket").html(result.intMaxFoodTicket);
        $("#maxParkingTicket").html(result.intMaxParkingTicket);

        //혼주(상주)인 경우 수정 버튼 노출 활성화
        if(loginUserNo == result.intHostUserNo){
            $(".ishostuser").show();
        }
    }

    //내 이벤트 정보 수정 결과
    function fnUpdFamilyEventInfoCallBack(result) {
        if (result.intRetVal != 0) {
            alert("수정에 실패하였습니다. 관리자에게 문의 해주세요.");

            return;
        }
        else{
            alert("수정이 완료되었습니다.");

            location.reload();
        }
    }

    // 보유 시설이용권 조회 CallBack
    function fnFacilityTicketInsCallBack(result) {
        if(result.intRetVal == 0) {
            alert("티켓 발급성공");

            location.reload();
        }
        else{
            alert("티켓 발급 실패 [" + result.strErrMsg+"]");
        }
    }

    //QR코드 발급 열기
    function fnOpenQRCode(){
        //QRCode 제목 지정
        $("#spQRCodeTitle").html("QR 코드 발급<br/>(" + qrcodeTitle + ")");

        //QRCode 그리기
        if(qrcode == null){
            qrcode = new QRCode("divQRCode", {
                text: myFamilyEventUrl,
                width: "190",
                height: "190",
                colorDark: "#000000",
                colorLight: "#ffffff",
                correctLevel: QRCode.CorrectLevel.L
            });
            
            $("#divQRCode").find("img").attr("style", "text-align:center");
        }

        $("#qrcode-modal").modal('show');
    }

    //QR코드 발급 닫기
    function fnCloseQRCode(){
        $("#qrcode-modal").modal('hide');
    }

    //시설이용권 추가 발급 열기
    function fnOpenFacilityTicket(){
        fnClearFacilityTicketModal();

        $("#btnFacilityTicketFood").click();

        $("#spFacilityTicketTitle").html("시설이용권 추가발급<br/>(" + qrcodeTitle + ")");
        
        $("#facilityticket-modal").modal('show');
    }

    //시설이용권 추가 발급 닫기
    function fnCloseFacilityTicket(){
        $("#facilityticket-modal").modal('hide');
    }

    //수정 버튼 클릭
    function fnShowUpd(target){
        if(target == "minPayAmount"){
            $("#btnUpdMinPayAmount").hide();
            $(".updMinPayAmount").show();

            $("#txtMinPayAmount").val($("#minPayAmount").html().replace(/,/gi, ''));
            $("#minPayAmount").hide();
            $("#txtMinPayAmount").show();
        }
        else if(target=="maxFoodTicket"){
            $("#btnUpdMaxFoodTicket").hide();
            $(".updMaxFoodTicket").show();

            $("#txtMaxFoodTicket").val($("#maxFoodTicket").html().replace(/,/gi, ''));
            $("#maxFoodTicket").hide();
            $("#txtMaxFoodTicket").show();
        }
        else if(target=="maxParkingTicket"){
            $("#btnUpdMaxParkingTicket").hide();
            $(".updMaxParkingTicket").show();

            $("#txtMaxParkingTicket").val($("#maxParkingTicket").html().replace(/,/gi, ''));
            $("#maxParkingTicket").hide();
            $("#txtMaxParkingTicket").show();
        }
    }

    //수정-취소 버튼 클릭
    function fnHideUpd(target){
        if(target == "minPayAmount"){
            $("#btnUpdMinPayAmount").show();
            $(".updMinPayAmount").hide();

            $("#minPayAmount").show();
            $("#txtMinPayAmount").hide();
        }
        else if(target == "maxFoodTicket"){
            $("#btnUpdMaxFoodTicket").show();
            $(".updMaxFoodTicket").hide();

            $("#maxFoodTicket").show();
            $("#txtMaxFoodTicket").hide();
        }
        else if(target == "maxParkingTicket"){
            $("#btnUpdMaxParkingTicket").show();
            $(".updMaxParkingTicket").hide();

            $("#maxParkingTicket").show();
            $("#txtMaxParkingTicket").hide();
        }
    }

    //수정-완료 버튼 클릭 (이벤트 상세 수정)
    function fnClickUpdFamilyEventInfo(target){
        var confirmMsg;
        var limitpolicytype;
        var limitpolicyval;
        var facilitytickettype;
        var strlimitpolicyname;

        if(target == "minPayAmount"){       //최소 결제 금액 수정
            limitpolicytype    = 1;
            limitpolicyval     = $("#txtMinPayAmount").val();
            facilitytickettype = 0;
            strlimitpolicyname = "최소 결제 금액";

            confirmMsg = "최소 결제 금액:" + $("#txtMinPayAmount").val() + " 수정 하시겠습니까?";
        }
        else if(target == "maxFoodTicket"){  //식권 지급수 수정
            limitpolicytype    = 2;
            limitpolicyval     = $("#txtMaxFoodTicket").val();
            facilitytickettype = 1;
            strlimitpolicyname = "식권";

            confirmMsg = "식권 지급수:" + $("#txtMaxFoodTicket").val() + " 수정 하시겠습니까?";
        }
        else if(target == "maxParkingTicket"){  //주차장 지급수 수정
            limitpolicytype    = 2;
            limitpolicyval     = $("#txtMaxParkingTicket").val();
            facilitytickettype = 2;
            strlimitpolicyname = "주차권";

            confirmMsg = "주차권 지급수:" + $("#txtMaxParkingTicket").val() + " 수정 하시겠습니까?";
        }

        //핸들러 호출
        if(confirm(confirmMsg)){
            fnUpdFamilyEventInfo(limitpolicytype, limitpolicyval, facilitytickettype, strlimitpolicyname);
        }
    }

    //시설이용권 추가발급 전환
    function fnChgFacilityTicket(target){
        fnClearFacilityTicketModal();

        if(target == "parking"){
            facilityticketcode = "parking";

            $("#btnFacilityTicketFood").removeClass('background');
            $("#btnFacilityTicketParking").addClass('background');

            $("#divFacilityTicketFood").hide();
            $("#divFacilityTicketParking").show();
        }
        else{
            facilityticketcode = "food";

            $("#btnFacilityTicketFood").addClass('background');
            $("#btnFacilityTicketParking").removeClass('background');

            $("#divFacilityTicketFood").show();
            $("#divFacilityTicketParking").hide();
        }
    }

    //시설이용권 추가 발급
    function fnInsFacilityTicket(){
        var targetuserid;
        var facilitytickettype;
        var facilityticketamount;

        targetuserid = $("#FacilityTicketUserID").val();

        //식권 발급
        if(facilityticketcode == "food"){
            facilitytickettype   = 1;
            facilityticketamount = $("#FacilityTicketFood").val();
        }
        //주차권 발급
        else if(facilityticketcode == "parking"){
            facilitytickettype   = 2;
            facilityticketamount = $("#FacilityTicketParking").val();
        }

        fnFacilityTicket(targetuserid ,facilitytickettype, facilityticketamount);
    }

    //시설이용권 추가 발급 Modal 초기화
    function fnClearFacilityTicketModal(){
        $("#FacilityTicketUserID").val("");
        $("#FacilityTicketFood").val("");
        $("#FacilityTicketParking").val("");
    }

</script>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="welcome_area p_120">
    <div class="container">
        <div class="row welcome_inner">
            <div class="col-lg-6">
                <div class="welcome_img">
                    <img id="hallImg" class="img-fluid" src="/DesignTemplate/img/welcome-1.jpg" alt="">
                </div>
            </div>
            <div class="col-lg-6">
                <div class="welcome_text">
                    <h4 id="familyEventName"></h4>
                    <h5 id="hallName"></h5>
                    <h5 id="familyEventDate"></h5>
                    <p id="hallAddress"></p>
                    <div class="row">
                        <div class="col-sm-4">
                            <div class="wel_item">
                                <i class="lnr lnr-database"></i>
                                <p>최소 결제 금액</p>
                                <h4>
                                    <span id="minPayAmount"></span>
                                    <input id="txtMinPayAmount" type="text" style="width:100%; display:none;" autocomplete="off" />
                                </h4>
                                <p class="ishostuser" style="display:none">
                                    <a class="genric-btn danger-border" id="btnUpdMinPayAmount" href="#1" onclick="fnShowUpd('minPayAmount')">수정</a>
                                </p>
                                <p class="updMinPayAmount" style="display:none">
                                    <a class="genric-btn danger-border" href="#1" onclick="fnClickUpdFamilyEventInfo('minPayAmount')">완료</a>
                                    <a class="genric-btn danger-border" href="#1" onclick="fnHideUpd('minPayAmount')">취소</a>
                                </p>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="wel_item">
                                <i class="lnr lnr-users"></i>
                                <p>식권 지급수</p>
                                <h4>
                                    <span id="maxFoodTicket"></span>
                                    <input id="txtMaxFoodTicket" type="text" style="width:100%; display:none;" autocomplete="off" />
                                </h4>
                                <p class="ishostuser" style="display:none">
                                    <a class="genric-btn danger-border" id="btnUpdMaxFoodTicket" href="#2" onclick="fnShowUpd('maxFoodTicket')">수정</a>
                                </p>
                                <p class="updMaxFoodTicket" style="display:none">
                                    <a class="genric-btn danger-border" href="#2" onclick="fnClickUpdFamilyEventInfo('maxFoodTicket')">완료</a>
                                    <a class="genric-btn danger-border" href="#2" onclick="fnHideUpd('maxFoodTicket')">취소</a>
                                </p>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="wel_item">
                                <i class="lnr lnr-car"></i>
                                <p>주차권 지급수</p>
                                <h4>
                                    <span id="maxParkingTicket"></span>
                                    <input id="txtMaxParkingTicket" type="text" style="width:100%; display:none;" autocomplete="off" />
                                </h4>
                                <p class="ishostuser" style="display:none">
                                    <a class="genric-btn danger-border" id="btnUpdMaxParkingTicket" href="#3" onclick="fnShowUpd('maxParkingTicket')">수정</a>
                                </p>
                                <p class="updMaxParkingTicket" style="display:none">
                                    <a class="genric-btn danger-border" href="#3" onclick="fnClickUpdFamilyEventInfo('maxParkingTicket')">완료</a>
                                    <a class="genric-btn danger-border" href="#3" onclick="fnHideUpd('maxParkingTicket')">취소</a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<section>
    <div class="container">
        <div class="main_title">
            <a href="#0" onclick="fnOpenFacilityTicket()" class="genric-btn danger-border circle arrow">시설이용권 추가 발급<span class="lnr lnr-arrow-right"></span></a>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="#0" onclick="fnOpenQRCode()" class="genric-btn danger-border circle arrow">QR 코드 발급<span class="lnr lnr-arrow-right"></span></a>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="#0" class="genric-btn danger-border circle arrow">상세 내역 조회<span class="lnr lnr-arrow-right"></span></a>
        </div>
    </div>


    <%--QRCode 발급 Modal--%>
    <div id="qrcode-modal" class="modal qrcode-modal" style="height:60%; overflow:hidden">
        <div class="modal-wrapper">
            <div class="modal-container">
                <div class="modal-contents">
                    <div class="qrcode-modal__container">
                        <div class="qrcode-modal__contents">
                            <header class="qrcode-modal__header">
                                <span id="spQRCodeTitle"></span>
                            </header>
                            <div class="container">
                                <div class="welcome_img">
                                    <div id="divQRCode" class="qr-code"></div>
                                </div>
                            </div>
                            <a onclick="fnCloseQRCode()" class="qrcode-modal__close"><span class="qrcode-modal__close-text">close</span></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%--시설이용권 추가 발급 Modal--%>
    <div id="facilityticket-modal" class="modal qrcode-modal" style="width:100%; overflow:hidden;">
        <div class="modal-wrapper">
            <div class="modal-container">
                <div class="modal-contents">
                    <div class="facilityticket-modal__container">
                        <div class="qrcode-modal__contents">
                            <header class="qrcode-modal__header">
                                <span id="spFacilityTicketTitle">시설이용권 추가 발급</span>
                            </header>
                            <div class="container">
                            <a href="#0" id="btnFacilityTicketFood" class="genric-btn danger-border background" onclick="fnChgFacilityTicket('food')">식권</a>
                            <a href="#0" id="btnFacilityTicketParking" class="genric-btn danger-border" onclick="fnChgFacilityTicket('parking')" style="float:right">주차권</a>
                              <div class="login_cont">
					                <div class="input-group-icon mt-10">
                                        <div class="icon"><i class="fa fa-user" aria-hidden="true"></i></div>
						                <input type="text" id="FacilityTicketUserID" placeholder="회원 아이디" onfocus="this.placeholder = ''" onblur="this.placeholder = '회원 아이디'" class="single-input" autocomplete="off"/>
					                </div>
					                <div class="input-group-icon mt-10" id="divFacilityTicketFood">
                                        <div class="icon"><i class="fa fa-book" aria-hidden="true"></i></div>
						                <input type="text" id="FacilityTicketFood" placeholder="식권 지급수" onfocus="this.placeholder = ''" onblur="this.placeholder = '식권 지급수'" class="single-input" autocomplete="off"/>
					                </div>
					                <div class="input-group-icon mt-10" id="divFacilityTicketParking" style="display:none">
                                        <div class="icon"><i class="fa fa-mobile-phone" aria-hidden="true"></i></div>
						                <input type="text" id="FacilityTicketParking" placeholder="주차권 지급수" onfocus="this.placeholder = ''" onblur="this.placeholder = '주차권 지급수'" class="single-input" autocomplete="off"/>
					                </div>
                                    <br />
                                    <a href="#0" class="genric-btn danger-border circle arrow" style="float:right" onclick="fnInsFacilityTicket()">발급 <span class="lnr lnr-arrow-right"></span></a>
                                    <br />
                                </div>
                            </div>
                            <a onclick="fnCloseFacilityTicket()" class="qrcode-modal__close"><span class="qrcode-modal__close-text">close</span></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</section>
</asp:Content>