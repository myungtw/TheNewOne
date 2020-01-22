<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="FacilityTicketUse.aspx.cs" Inherits="FacilityTicketUse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script src="/Lib/qrcode.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            fnUseFacilityTicket() 
        });
        

        // 보유 시설이용권 사용
        function fnUseFacilityTicket() {
            // ========= 핸들러 호출 ===========================
            var reqParam = {};
            var callURL  = "<%=HandlerRefer.FACILITYTICKETHANDLER%>";
            var callBack = "fnUseFacilityTicketCallBack";

            reqParam["strAjaxTicket"]       = '<%=AjaxTicket %>';
            reqParam["strMethodName"]       = 'UseFacilityTicket';
            reqParam["intFacilityTicketNo"] = '<%=FacilityTicketNo%>';

            BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }

        // 보유 시설이용권 사용 CallBack
        function fnUseFacilityTicketCallBack(result) {
            if (result.intRetVal != 0) {
                $("#useResult").text("시설이용권 사용 실패");
                $("#useResultDtl").text(result.strErrMsg);
            }
            else
            {
                $("#useResult").text("시설이용권 사용 성공");
                $("#useResultDtl").text("시설이용권이 사용 되었습니다.");
            }
        }

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">    
	<section class="sample-text-area">
		<div class="container">
        	<div class="main_title">
        		<h2 id="useResult"></h2>
        		<p id="useResultDtl"></p>
        	</div>
		</div>
	</section>
</asp:Content>

