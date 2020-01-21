<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="FamilyEventIndex.aspx.cs" Inherits="FamilyEventIndex" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    var userNo = <%=intUserNo %>;

    $(document).ready(function () {
        //내 이벤트 내역
        fnFamilyEventHoldList();
    });


    //이벤트 보유 내역 조회
    function fnFamilyEventHoldList() {
        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL = "<%=HandlerRefer.FAMILYEVENTHANDLER%>";
        var callBack = "fnFamilyEventHoldListCallBack";

        reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
        reqParam["strMethodName"] = 'GetFamilyEventHoldList';
        reqParam["intUserNo"]     = userNo;

        console.log(reqParam);

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    function fnFamilyEventHoldListCallBack(result) {
        console.log(result);
        if (result.intRetVal != 0) {
            alert("내역 조회에 실패하였습니다.");
            $("#divFamilyEventHoldList").html("");
            return;
        }

        var html = "";
        var objRet = result.objDT;
        if (objRet == null || objRet.length <= 0) {
            $("#divFamilyEventHoldList").html("");
            return;
        }

        for (i = 0; i < objRet.length; i++) {
            html += "<div class='col-lg-4'>";
            html += "   <a href='javascript:fnMyFamilyEvent(" + objRet[i].FAMILYEVENTNO + ");'>";
            html += "       <div class='pp_img'>";
            html += "           <img class='img-fluid' src='" + objRet[i].ROOMIMG + "' alt=''>";
            html += "       </div>";
            html += "   </a>";
            html += "   <div class='pp_content'>";
            html += "       <h4>" + objRet[i].FAMILYEVENTNAME + "</h4>";
            html += "   </div>";
            html += "   <div class='pp_footer'>";
            html += "       <h5>" + objRet[i].FAMILYEVENTYMD + " " + objRet[i].FAMILYEVENTWEEK + "</h5>";
            html += "       <h5>" + objRet[i].FAMILYEVENTTIME + "</h5>";
            html += "   </div>";
            html += "</div>";
        }

        $("#divFamilyEventHoldList").html(html);
    }

    //내 이벤트 정보
    function fnMyFamilyEvent(familyEventNo) {
        var url = '<%=strMyFamilyEventUrl %>' + "?familyeventno=" + familyEventNo;
        window.document.location = url;
    }

</script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<section class="properties_area pad_top">
    <div class="container">
        <div class="main_title">
            <h2>내 이벤트</h2>
            <p>현재 등록된 나의 이벤트를 확인하세요.</p>
        </div>
        <div id="divFamilyEventHoldList" class="row properties_inner">
        </div>
    </div>
</section>
<section class="feature_area p_120 pad_top">
    <div class="container">
        <div class="main_title">
            <h2>초대받은 이벤트</h2>
            <p>초대받은 이벤트를 확인하세요.</p>
        </div>
        <div class="row properties_inner">
            <div class="col-lg-4">
                <div class="properties_item">
                    <div class="pp_img">
                        <img class="img-fluid" src="/DesignTemplate/img/properties/pp-1.jpg" alt="">
                    </div>
                    <div class="pp_content">
                        <a href="#"><h4>AA와 BB의 결혼식</h4></a>
                        <div class="tags">
                            서울특별시 강남구 역삼동 513-12 3층 BC 홀
                        </div>
                        <div class="pp_footer">
                            <h5>2020년 1월 5일</h5>
                            <a class="main_btn" href="#">결제 하러가기</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="properties_item">
                    <div class="pp_img">
                        <img class="img-fluid" src="/DesignTemplate/img/properties/pp-2.jpg" alt="">
                    </div>
                    <div class="pp_content">
                        <a href="#"><h4>AA와 BB의 결혼식</h4></a>
                        <div class="tags">
                            서울특별시 강남구 역삼동 513-12 3층 BC 홀
                        </div>
                        <div class="pp_footer">
                            <h5>2020년 1월 5일</h5>
                            <a class="main_btn genric-btn info" href="#">시설이용권 사용</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="properties_item">
                    <div class="pp_img">
                        <img class="img-fluid" src="/DesignTemplate/img/properties/pp-3.jpg" alt="">
                    </div>
                    <div class="pp_content">
                        <a href="#"><h4>AA와 BB의 결혼식</h4></a>
                        <div class="tags">
                            서울특별시 강남구 역삼동 513-12 3층 BC 홀
                        </div>
                        <div class="pp_footer">
                            <h5>2020년 1월 5일</h5>
                            <a class="main_btn genric-btn info" href="#">시설이용권 사용</a>
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
            <a href="#" class="genric-btn danger-border circle arrow">내정보 보기<span class="lnr lnr-arrow-right"></span></a>
            <a href="#" class="genric-btn danger-border circle arrow">내역 조회<span class="lnr lnr-arrow-right"></span></a>
        </div>
    </div>
</section>
</asp:Content>

