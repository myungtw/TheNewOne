<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="FacilityTicketHoldList.aspx.cs" Inherits="FacilityTicketHoldList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            fnGetFacilityTicketList() 
        });
        

        // 보유 시설이용권 조회
        function fnGetFacilityTicketList() {
            // ========= 핸들러 호출 ===========================
            var reqParam = {};
            var callURL  = "<%=HandlerRefer.FACILITYTICKETHANDLER%>";
            var callBack = "fnGetFacilityTicketListCallBack";

            reqParam["strAjaxTicket"]       = '<%=AjaxTicket %>';
            reqParam["strMethodName"]       = 'GetFacilityTicketList';
            reqParam["intFamilyEventNo"]    = 2;

            BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }

        // 보유 시설이용권 조회 CallBack
        function fnGetFacilityTicketListCallBack(result) {   
            var target      = $("#tFacilityTicketHoldList");
            var html        = "";

            if (result.intRetVal != 0) {
                alert("보유 시설이용권 조회에 실패하였습니다.");
                return;
            }

            var objRet = result.objDT;
            if(objRet != null) {
                if (objRet.length > 0) {                    
                    for (var i = 0 ; i < objRet.length; i++) {
                        html += "<tr>"
                        html += "<td>" + objRet[i].FAMILYEVENTNAME + "</td>"
                        html += "<td>" + objRet[i].FACILITYTICKETTYPEM + "</td>"
                        html += "<td>" + objRet[i].FACILITYTICKETNO + "</td>"
                        html += "<td>" + objRet[i].FACILITYTICKETTYPEM + "</td>"
                        html += "<td>" + objRet[i].STATECODEM + "</td>"
                        html += "<td>" + objRet[i].UPDDATE + "</td>"
                        html += "</tr>"
                    }
                }
                else {
                    alert("보유 시설이용권이 없습니다.");
                    return;
                }

                target.html(html);
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="welcome_area p_120">
        	<div class="container">
        		<table class="table">
                    <thead>
                        <tr>
                            <td>경조사명</td>
                            <td>시설이용권 구분</td>
                            <td>시설이용권 번호</td>
                            <td>발급 구분</td>
                            <td>사용 여부</td>
                            <td>사용 일자</td>
                        </tr>
                    </thead>
                    <tbody id="tFacilityTicketHoldList"></tbody>
        		</table>
        	</div>
        </section>
        <section>
            <div class="container">
                <div class="main_title">
                    <a href="#" class="genric-btn danger-border circle arrow">뒤로가기<span class="lnr lnr-arrow-right"></span></a>
                </div>
            </div>
        </section>
</asp:Content>

