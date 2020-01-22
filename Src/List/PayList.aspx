<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="PayList.aspx.cs" Inherits="PayList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <script>
        $(document).ready(function () {
            // 무한 스크롤 이벤트 등록
            fnPayList();
            fnRegistInfinityScrollEvent();
        });


        // 결제 수단 선택
        function fnPayList() {
            // ========= 핸들러 호출 ===========================
            var reqParam = {};
            var callURL  = "<%=HandlerRefer.PAYEVENTHANDLER%>";
            var callBack = "fnPayListCallBack";

            reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
            reqParam["strMethodName"] = 'GetUserPayList';
            reqParam["intPageSize"]   = BOQ.Utils.fnGetPageSizeForScroll();

            BOQ.Ajax.jQuery.fnScrollListRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }

        function fnPayListCallBack(result) {
            var target = $("#payList");
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
                    html += ""
                       + "     <tr>"
                       + "         <td>" + objDT[i].FAMILYEVENTNAME + "</td>"
                       + "         <td>" + objDT[i].RECEIVEUSERNAME + "</td>"
                       + "         <td>" + objDT[i].PAYTOOLNAME + "</td>"
                       + "         <td>" + BOQ.Utils.fnAddComma(objDT[i].PAYAMT) + "</td>"
                       + "         <td>" + objDT[i].REGDATE + "</td>"
                       +"     </tr>"
                }
            }


            target.html(html);
        }

        function fnRegistInfinityScrollEvent() {
            $(window).on("scroll", fnInfinityScroll);
        }


        //------------------------------------------------------------  
        // 일반 함수정의
        //------------------------------------------------------------
        function fnInfinityScroll() {
            var scrollHeight = $(document).height();
            var scrollPosition = $(window).height() + $(window).scrollTop();

            // 스크롤이 100보다 조금 남고, 현재 PageNo가 Max PageNo 가 아닐때
            if (scrollPosition > scrollHeight - 100 && !BOQ.Utils.fnIsMaxPageNo()) {
                // 상품정보 호출
                fnPayList();
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
                            <td>결혼식 명</td>
                            <td>받는 분</td>
                            <td>결제수단</td>
                            <td>금액</td>
                            <td>날짜</td>
                        </tr>
                    </thead>
                    <tbody id="payList">
                    </tbody>
        		</table>
        	</div>
        </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="layer" Runat="Server">
</asp:Content>

