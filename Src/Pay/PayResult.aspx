<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="PayResult.aspx.cs" Inherits="PayResult" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <script>
        $(document).ready(function(){
            fnEventPayList();
            $("#payBtn").on("click", function(){
                location.href="/Src/Pay/PayInfoIns.aspx?familyeventno="+<%=FamilyEventNo%>;
            });
            $("#facilityBtn").on("click", function(){
                location.href="/Src/FacilityTicket/FacilityTicketEventDtl.aspx?familyeventno="+<%=FamilyEventNo%>;
            });
        });


        // 결제 수단 선택
        function fnEventPayList() {
            // ========= 핸들러 호출 ===========================
            var reqParam = {};
            var callURL  = "<%=HandlerRefer.PAYEVENTHANDLER%>";
            var callBack = "fnEventPayListCallBack";

            reqParam["strAjaxTicket"]    = '<%=AjaxTicket %>';
            reqParam["strMethodName"]    = 'EventPayList';
            reqParam["intFamilyEventNo"] = <%=FamilyEventNo%>;

            BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }

        function fnEventPayListCallBack(result) {
            var target = $("#payDiv");
            if (result.intRetVal != 0) {
                alert(result.strErrMsg);
                return;
            }
            var objDT = result.objDT;
            var html = "";
            if (objDT != null) {
                for (var i = 0; i < objDT.length; i++) {
                    if(i==0){
                        $("#receiver").html(objDT[i].FAMILYEVENTNAME)
                    }
                    html += "<h3>"+(i+1)+" 회차 결제</h3>"
                       +" <table class='table'>"
                       +"     <tr>"
                       +"         <td class='alert-danger text-center' style='width:30%;'>받는사람</td>"
                       +"         <td class='text-right'>"+objDT[i].USERNAME+" ("+objDT[i].USERID+")"+"</td>"
                       +"     </tr>"
                       +"     <tr>"
                       +"         <td class='alert-danger text-center'>결제수단</td>"
                       +"         <td class='text-right'>"+objDT[i].PAYTOOLNAME+"</td>"
                       +"     </tr>"
                       +"     <tr>"
                       +"         <td class='alert-danger text-center'>결제금액</td>"
                       + "         <td class='text-right'>" + BOQ.Utils.fnAddComma(objDT[i].RECEIVEAMT) + "</td>"
                       +"     </tr>"
                       +"     <tr>"
                       +"         <td class='alert-danger text-center'>결제일시</td>"
                       + "         <td class='text-right'>" + objDT[i].REGDATE + "</td>"
                       +"     </tr>"
                       +" </table>"
                }
            }


            target.html(html);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="whole-wrap">
        <div class="container">
        	<div class="section-top-border">
			    <h3 class="mb-30 title_color">결제 결과</h3>
				<div class="col-lg-12">
					<blockquote class="generic-blockquote">
                        <h3 id="receiver"></h3>
                        <hr />
                        <div id="payDiv">

                        </div>
					</blockquote>

				</div>
			</div>
        </div>
    </div>
    <section>
        <div class="container">
            <div class="main_title">
                <a href="javascript:;" class="genric-btn danger-border circle arrow" id="payBtn">추가 결제하기<span class="lnr lnr-arrow-right"></span></a>
                <a href="javascript:;" class="genric-btn danger-border circle arrow" id="facilityBtn">시설이용권 관리<span class="lnr lnr-arrow-right"></span></a>
            </div>
        </div>
    </section>
</asp:Content>

