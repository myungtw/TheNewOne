<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="FacilityTicketEventDtl.aspx.cs" Inherits="FacilityTicketEventDtl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            fnGetFacilityTicketCnt();
            $("#useBtn").on("click", function(){
                location.href="/Src/FacilityTicket/FacilityTicketHoldList.aspx?familyeventno="+<%=FamilyEventNo%>;
            })
        });
        function fnFacilityTicketIns() {
            // ========= 핸들러 호출 ===========================
            var reqParam = {};
            var callURL  = "<%=HandlerRefer.FACILITYTICKETHANDLER%>";
            var callBack = "fnFacilityTicketInsCallBack";

            reqParam["strAjaxTicket"]            = '<%=AjaxTicket %>';
            reqParam["strMethodName"]            = 'InsFacilityTicket';
            reqParam["intFamilyEventNo"]         = <%=FamilyEventNo%>;
            reqParam["intFacilityTicketType"]    = $(this).data("type");
            reqParam["intFacilityTicketAmount"]  = 1;

            reqParam["intFacilityTicketRegType"] = 1;
            reqParam["intJoinMstCategory"]       = $(this).data("category");
            BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }

        // 보유 시설이용권 조회
        function fnGetFacilityTicketCnt() {
            // ========= 핸들러 호출 ===========================
            var reqParam = {};
            var callURL  = "<%=HandlerRefer.FACILITYTICKETHANDLER%>";
            var callBack = "fnGetFacilityTicketCntCallBack";

            reqParam["strAjaxTicket"]       = '<%=AjaxTicket %>';
            reqParam["strMethodName"]       = 'GetFacilityCnt';
            reqParam["intFamilyEventNo"]    = <%=FamilyEventNo%>;

            BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }

        // 보유 시설이용권 조회 CallBack
        function fnFacilityTicketInsCallBack(result) {   
            var target      = $("#tFacilityTicketHoldList");
            var html        = "";

            if(result.intRetVal == 0) {
                alert("티켓 발급성공");
                fnGetFacilityTicketCnt();
            }
            else{
                alert("티켓 발급 실패 [" + result.strErrMsg+"]");
            }
        }

        // 보유 시설이용권 조회 CallBack
        function fnGetFacilityTicketCntCallBack(result) {   
            var foodtarget  = $("#foodLink");
            var parktarget  = $("#parkLink");
            var foodhtml    = "";
            var parkhtml    = "";

            if(result != null && result.intRowCnt > 0) {
               
                $("#hallImg").attr("src", result.strRoomImgUrl);
                $("#familyEventName").html(result.strEventName);
                $("#maxFacilityTicket_Food").html(result.intFoodCurrCnt +"/"+ result.intFoodMaxCnt);
                $("#maxFacilityTicket_Packing").html(result.intParkCurrCnt +"/"+ result.intParkMaxCnt);

                for (var i = 0; i < result.objDT.length; i++) {
                    foodhtml += "<a class='genric-btn danger-border insBtn' href='#' style='padding-left:10px;padding-right:10px;' data-category='"+result.objDT[i].JOINMSTCATEGORY+"' data-type='1'>"+result.objDT[i].JOINMSTCATEGORYNAME+" 측 발급</a> ";
                    parkhtml += "<a class='genric-btn danger-border insBtn' href='#' style='padding-left:10px;padding-right:10px;' data-category='"+result.objDT[i].JOINMSTCATEGORY+"' data-type='2'>"+result.objDT[i].JOINMSTCATEGORYNAME+" 측 발급</a> ";
                }
                foodtarget.html(foodhtml);
                parktarget.html(parkhtml);
            }
            $(".insBtn").on("click", fnFacilityTicketIns);
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
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="wel_item">
                                <i class="lnr lnr-users"></i>
                                <h4 id="maxFacilityTicket_Food"></h4>
                                <p>식권 지급수</p>
                                <p id="foodLink"></p>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="wel_item">
                                <i class="lnr lnr-car"></i>
                                <h4 id="maxFacilityTicket_Packing"></h4>
                                <p>주차장 지급수</p>
                                <p id="parkLink">
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
            <a class="genric-btn danger-border circle arrow" href="javascript:;" id="useBtn">이용권 조회 및 사용<span class="lnr lnr-arrow-right"></span></a>
        </div>
    </div>
</section>
</asp:Content>
