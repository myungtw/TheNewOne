<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="FamilyEventIndex.aspx.cs" Inherits="FamilyEventIndex" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">

    $(document).ready(function () {
        //내 이벤트 내역
        fnMyFamilyEventHoldList();
        //초대받은 이벤트 내역
        fnInvitedFamilyEventHoldList();
    });


    //나의 이벤트 보유 내역 조회
    function fnMyFamilyEventHoldList() {
        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL = "<%=HandlerRefer.FAMILYEVENTHANDLER%>";
        var callBack = "fnMyFamilyEventHoldListCallBack";

        reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
        reqParam["strMethodName"] = 'GetMyFamilyEventHoldList';

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    function fnMyFamilyEventHoldListCallBack(result) {
        if (result.intRetVal != 0) {
            alert("내역 조회에 실패하였습니다.");
            $("#divMyEventHoldList").html("");
            return;
        }

        var html = "";
        var objRet = result.objDT;
        if (objRet == null || objRet.length <= 0) {
            $("#divMyEventHoldList").html("");
            $(".myevent").hide();
            return;
        }

        for (i = 0; i < objRet.length; i++) {
            html += "<div class='col-lg-4'>";
            html += "  <div class='properties_item'>";
                
            html += "   <a href='javascript:fnMyFamilyEvent(" + objRet[i].FAMILYEVENTNO + ");'>";
            html += "       <div class='pp_img'>";
            html += "           <img class='img-fluid' src='" + objRet[i].ROOMIMG + "' alt=''>";
            html += "       </div>";
            html += "   </a>";
            html += "   <div class='pp_content'>";
            html += "       <a href='javascript:fnMyFamilyEvent(" + objRet[i].FAMILYEVENTNO + ");'><h4>" + objRet[i].FAMILYEVENTNAME + "</h4></a>";
            html += "       <div class='tags'>";
            html += "           <h5>" + objRet[i].HALLADDRESS + "</h5>";
            html += "       </div>";
            html += "       <div class='pp_footer'>";                            
            html += "           <h5 style='height: 30px;'>" + objRet[i].FAMILYEVENTYMD + " " + objRet[i].FAMILYEVENTWEEK + " " + objRet[i].FAMILYEVENTTIME + "</h5>";                        
            html += "           <a class='main_btn' href='#'>경조사 관리</a>";  
            html += "           <a class='genric-btn info' href='#'>시설이용권 발급</a>";          
            html += "       </div>";
            html += "   </div>";
            html += "  </div>";
            html += "</div>";
        }

        $("#divMyEventHoldList").html(html);
    }

    //내 이벤트 정보
    function fnMyFamilyEvent(familyEventNo) {
        var url = '<%=strMyFamilyEventUrl %>' + "?familyeventno=" + familyEventNo;
        window.document.location = url;
    }


    //초대받은 이벤트 보유 내역 조회
    function fnInvitedFamilyEventHoldList() {
        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL = "<%=HandlerRefer.FAMILYEVENTHANDLER%>";
        var callBack = "fnInvitedFamilyEventHoldListCallBack";

        reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
        reqParam["strMethodName"] = 'GetInvitedFamilyEventHoldList';

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    function fnInvitedFamilyEventHoldListCallBack(result) {
        if (result.intRetVal != 0) {
            alert("내역 조회에 실패하였습니다.");
            $("#divInvitedEventHoldList").html("");
            return;
        }

        var html = "";
        var objRet = result.objDT;
        if (objRet == null || objRet.length <= 0) {
            $("#divInvitedEventHoldList").html("");
            return;
        }

        for (i = 0; i < objRet.length; i++) {
            html += "<div class='col-lg-4'>";
            html += "  <div class='properties_item'>";
                
            html += "   <a href='javascript:fnInvitedFamilyEvent(" + objRet[i].FAMILYEVENTNO + ");'>";
            html += "       <div class='pp_img'>";
            html += "           <img class='img-fluid' src='" + objRet[i].ROOMIMG + "' alt=''>";
            html += "       </div>";
            html += "   </a>";
            html += "   <div class='pp_content'>";
            html += "       <a href='javascript:fnInvitedFamilyEvent(" + objRet[i].FAMILYEVENTNO + ");'><h4>" + objRet[i].FAMILYEVENTNAME + "</h4></a>";
            html += "       <div class='tags'>";
            html += "           <h5>" + objRet[i].HALLADDRESS + "</h5>";
            html += "       </div>";
            html += "       <div class='pp_footer'>";                            
            html += "           <h5 style='height: 30px;'>" + objRet[i].FAMILYEVENTYMD + " " + objRet[i].FAMILYEVENTWEEK + " " + objRet[i].FAMILYEVENTTIME + "</h5>";
            html += "           <a class='main_btn' href='#'>결제 하러가기</a>";
            html += "           <a class='genric-btn info' href='javascript:fnFacilityTicketHoldList(" + objRet[i].FAMILYEVENTNO + ");'>시설이용권 사용</a>";
            html += "       </div>";
            html += "   </div>";
            html += "  </div>";
            html += "</div>";
        }

        $("#divInvitedEventHoldList").html(html);
    }

    //보유 시설이용권 정보
    function fnFacilityTicketHoldList(familyEventNo) {
        var url = '<%=strFacilityTicketHoldUrl %>' + "?familyeventno=" + familyEventNo;
        window.document.location = url;
    }

</script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="properties_area pad_top myevent">
    <div class="container">
        <div class="main_title">
            <h2>내 이벤트</h2>
            <p>현재 등록된 나의 이벤트를 확인하세요.</p>
        </div>
        <div id="divMyEventHoldList" class="row properties_inner"></div>
    </div>
</section>
<section class="feature_area p_120 pad_top">
    <div class="container">
        <div class="main_title">
            <h2>초대받은 이벤트</h2>
            <p>초대받은 이벤트를 확인하세요.</p>
        </div>        
        <div id="divInvitedEventHoldList" class="row properties_inner"></div>
    </div>

</section>
<section>
    <div class="container">
        <div class="main_title">
            <a href="#" class="genric-btn danger-border circle arrow">내정보 보기<span class="lnr lnr-arrow-right"></span></a>
            <a href="#" class="genric-btn danger-border circle arrow">내역 조회<span class="lnr lnr-arrow-right"></span></a>
        </div>
    </div>
</section>
</asp:Content>

