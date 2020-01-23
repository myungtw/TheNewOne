<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="ReceiveList.aspx.cs" Inherits="ReceiveList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script>
        $(document).ready(function () {
            // 무한 스크롤 이벤트 등록
            // 상품 페이지 번호 초기화
            fnRegistInfinityScrollEvent();
            fnReceiveList();
        });


        // 결제 수단 선택
        function fnReceiveList() {
            // ========= 핸들러 호출 ===========================
            var reqParam = {};
            var callURL  = "<%=HandlerRefer.PAYEVENTHANDLER%>";
            var callBack = "fnReceiveListCallBack";

            reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
            reqParam["strMethodName"] = 'GetReceiveList';
            reqParam["intPageSize"]   = BOQ.Utils.fnGetPageSizeForScroll();

            BOQ.Ajax.jQuery.fnScrollListRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }

        function fnReceiveListCallBack(result) {
            var target = $("#ReceiveList");
            if (result.intRetVal != 0) {
                alert(result.strErrMsg);
                return;
            }
            var objDT = result.objDT;
            var html = "";
            if (objDT != null) {

                for (var i = 0; i < objDT.length; i++) {
                    html += ""
                       + "     <tr>"
                       + "         <td>" + objDT[i].FAMILYEVENTNAME + "</td>"
                       + "         <td>" + objDT[i].JOINSUBCATEGORYNAME + "</td>"
                       + "         <td>" + objDT[i].SENDERUSERNAME + "(" + objDT[i].SENDERUSERID + ")</td>"
                       + "         <td>" + BOQ.Utils.fnAddComma(objDT[i].RECEIVEAMT) + "</td>"
                       + "         <td>" + objDT[i].PARKTICKETCNT + "</td>"
                       + "         <td>" + objDT[i].FOODTICKETCNT + "</td>"
                       + "         <td>" + objDT[i].REGDATE + "</td>"
                       +"     </tr>"
                }
                if (result.intRowCnt == 0) {
                    html = "<tr><td class='text-center' colspan='7'>조회된 건이 없습니다.</td></tr>"
                }
            }
            else if (result.intRowCnt == 0) {
                html = "<tr><td class='text-center' colspan='7'>조회된 건이 없습니다.</td></tr>"
            }


            target.html(html);
        }

        function fnRegistInfinityScrollEvent() {
            BOQ.Utils.fnResetPageNo();
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
                fnReceiveList();
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
                            <td>소속</td>
                            <td>보낸 분</td>
                            <td>보낸 금액</td>
                            <td>주차장 사용 수</td>
                            <td>식권 사용 수</td>
                            <td>날짜</td>
                        </tr>
                    </thead>
                    <tbody id="ReceiveList">
                    </tbody>
        		</table>
        	</div>
        </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="layer" Runat="Server">
</asp:Content>

