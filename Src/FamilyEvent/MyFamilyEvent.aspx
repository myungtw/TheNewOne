<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="MyFamilyEvent.aspx.cs" Inherits="MyFamilyEvent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    var familyEventNo = <%=intFamilyEventNo %>;

    $(document).ready(function () {
        if (familyEventNo == 0 ) {
            alert("유효하지 않은 이벤트 번호 입니다.");
            window.location.href = "<%=strFamilyEventIndexUrl %>";
            return;
        }

        //이벤트 정보 조회
        fnFamilyEventInfo();

    });

    //내 이벤트 정보 조회
    function fnFamilyEventInfo() {
        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL = "<%=HandlerRefer.FAMILYEVENTHANDLER%>";
        var callBack = "fnFamilyEventInfoCallBack";

        reqParam["strAjaxTicket"]    = '<%=AjaxTicket %>';
        reqParam["strMethodName"]    = 'GetFamilyEventInfo';
        reqParam["intFamilyEventNo"] = familyEventNo;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    function fnFamilyEventInfoCallBack(result) {
        console.log(result);
        if (result.intRetVal != 0) {
            alert("내역 조회에 실패하였습니다.");
            $("#divInfo").html("");
            return;
        }


        $("#familyEventName").html(result.strFamilyEventName);
        $("#familyEventDate").html(result.strFamilyEventDate);

        $("#hallName").html(result.strHallName);
        $("#hallAddress").html(result.strHallAddress);
        $("#hallPhoneNo").html(result.strHallPhoneNo);

        $("#minAmount").html(result.intMinAmount);
        $("#maxFacilityTicket_Food").html(result.intMaxFacilityTicket);
        $("#maxFacilityTicket_Packing").html(result.intMaxFacilityTicket);

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
                                <h4 id="minAmount"></h4>
                                <p>최소 결제 금액</p>
                                <p><a class="genric-btn danger-border" href="#">수정</a></p>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="wel_item">
                                <i class="lnr lnr-users"></i>
                                <h4 id="maxFacilityTicket_Food"></h4>
                                <p>식권 지급수</p>
                                <p><a class="genric-btn danger-border" href="#">수정</a></p>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="wel_item">
                                <i class="lnr lnr-car"></i>
                                <h4 id="maxFacilityTicket_Packing"></h4>
                                <p>주차장 지급수</p>
                                <p><a class="genric-btn danger-border" href="#">수정</a></p>
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
            <a href="#" class="genric-btn danger-border circle arrow">시설이용권 추가발급<span class="lnr lnr-arrow-right"></span></a>
            <a href="#" class="genric-btn danger-border circle arrow">내역 조회<span class="lnr lnr-arrow-right"></span></a>
        </div>
    </div>
</section>
</asp:Content>




