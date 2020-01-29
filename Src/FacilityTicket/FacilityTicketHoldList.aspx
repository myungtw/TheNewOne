<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="FacilityTicketHoldList.aspx.cs" Inherits="FacilityTicketHoldList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script src="/Lib/qrcode.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            fnGetFacilityTicketList();
            $("#facilityBtn").on("click", function(){
                location.href="/Src/FacilityTicket/FacilityTicketEventDtl.aspx?familyeventno="+<%=FamilyEventNo%>;
            });
        });
        

        // 보유 시설이용권 조회
        function fnGetFacilityTicketList() {
            // ========= 핸들러 호출 ===========================
            var reqParam = {};
            var callURL  = "<%=HandlerRefer.FACILITYTICKETHANDLER%>";
            var callBack = "fnGetFacilityTicketListCallBack";

            reqParam["strAjaxTicket"]       = '<%=AjaxTicket %>';
            reqParam["strMethodName"]       = 'GetFacilityTicketList';
            reqParam["intFamilyEventNo"]    = <%=FamilyEventNo%>;

            BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }

        // 보유 시설이용권 조회 CallBack
        function fnGetFacilityTicketListCallBack(result) {   
            var target      = $("#divFacilityTicketHoldList");
            var html        = "";

            if (result.intRetVal != 0) {
                alert("보유 시설이용권 조회에 실패하였습니다.");
                history.back();
                return;
            }

            var objRet = result.objDT;
            if(objRet != null) {
                if (objRet.length > 0) {
                    $("#familyEventName").text(objRet[0].FAMILYEVENTNAME);

                    for (var i = 0 ; i < objRet.length; i++) {
                        html += "<div class='col-lg-3 col-sm-6'>"
                        html += "	<div class='team_item wel_item'>"
                        html += "       <div id='qrcode" + objRet[i].FACILITYTICKETNO + "' data-ticketno='" + objRet[i].FACILITYTICKETNO + "' class='team_img' style='padding:10px;'></div>"
                        html += "		<div class='team_name'>"
                        html += "			<h4></h4>"
                        html += "			<p>" + objRet[i].FACILITYTICKETTYPEM + " (" + objRet[i].STATECODEM + " 완료)</p>"
                        html += "		</div>"
                        html += "	</div>"
                        html += "</div>"                
                    }
                }
                else {
                    alert("보유 시설이용권이 없습니다.");
                    history.back();
                    return;
                }

                target.html(html);
                //QR코드 그리기
                
                $(".team_img").each(function() {
                    var div = $(this).attr("id");
                    var qrcode = new QRCode(div, {
                        text: "<%=FacilityTicketUseUrl%>?facilityticketno=" + $(this).data("ticketno"),
                        width: "190",
                        height: "190",
                        colorDark: "#000000",
                        colorLight: "#ffffff",
                        correctLevel: QRCode.CorrectLevel.L
                    });
                }).find("img").addClass("img-fluid");
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <!--================Team Area =================-->
    <section class="team_area p_120">
        <div class="main_title">
        	<h2 id="familyEventName"></h2>
        </div>
        <div class="container">
        	<div class="row team_inner" id="divFacilityTicketHoldList"></div>
        </div>
    </section>
    <!--================End Team Area =================-->
        
    <section>
        <div class="container">
            <div class="main_title">
                <%--<a href="#" class="genric-btn danger-border circle arrow">뒤로가기<span class="lnr lnr-arrow-right"></span></a>--%>
                <a href="#" class="genric-btn danger-border circle arrow" id="facilityBtn">시설이용권 관리<span class="lnr lnr-arrow-right"></span></a>
            </div>
        </div>
    </section>
    
        
</asp:Content>

