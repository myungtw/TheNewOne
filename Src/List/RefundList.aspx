<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="RefundList.aspx.cs" Inherits="RefundList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script>
        $(document).ready(function () {
            //fnRegistInfinityScrollEvent();
            fnRefundPrice();
            fnRefundList();
        });
        
        function fnTxExchange() {
            if (confirm("환전을 진행하시겠습니까?")) {
                var reqParam = {};
                var callURL = "<%=HandlerRefer.PAYEVENTHANDLER%>";
                var callBack = "fnTxExchangeCallBack";

                reqParam["strAjaxTicket"]  = '<%=AjaxTicket %>';
                reqParam["strMethodName"]  = 'TXExchange';
                reqParam["strUserID"]      = $("#btn_exchange").closest(".row").data("userid");
                reqParam["dblExchangeAmt"] = $("#btn_exchange").closest(".row").data("exchangeamt")

                BOQ.Ajax.jQuery.fnScrollListRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
            }
        }

        function fnTxExchangeCallBack(result) {
            if (result.intRetVal != 0) {
                alert(result.strErrMsg);
                return;
            }

            //갱신
            fnRefundPrice();
            fnRefundList();
        }

        function fnRefundPrice() {
            var reqParam = {};
            var callURL = "<%=HandlerRefer.PAYEVENTHANDLER%>";
            var callBack = "fnReceiveTotalPriceCallBack";

            reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
            reqParam["strMethodName"] = 'GetReceiveTotalPrice';

            BOQ.Ajax.jQuery.fnScrollListRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }

        function fnReceiveTotalPriceCallBack(result) {
            var target = $("#RefundPrice");
            if (result.intRetVal != 0) {
                alert(result.strErrMsg);
                return;
            }

            var objDT = result.objDT;
            var html = "";
            if (objDT != null) {
                for (var i = 0; i < objDT.length; i++) {
                    html += ""
                        + "<div class='row'>"
                        + "<div class='col-sm-4'><div class='wel_item'><i class='lnr lnr-user'></i><h4>" + objDT[i].USERNAME + "</h4><p>혼주</p></div></div>"
                        + "<div class='col-sm-4'><div class='wel_item'><i class='lnr lnr-database'></i><h4>" + BOQ.Utils.fnAddComma(objDT[i].TOTALAMT) + " 원</h4><p>총 환전 가능 금액</p></div></div>"
                        + "<div class='col-sm-4'><div class='wel_item'><i class='lnr lnr-users'></i><h4>" + BOQ.Utils.fnAddComma(objDT[i].TOTALUSERCNT) + " 명</h4><p>총 방문자 수</p></div></div>"
                        + "</div><br>"
                        + "<div class='row' data-userid=" + objDT[i].USERID + " data-exchangeamt=" + objDT[i].TOTALAMT + ">"
                        + "<div class='col-lg-12 text-center'><a href='javascript:fnTxExchange();' class='genric-btn danger-border circle arrow' id='btn_exchange'>환전하기<span class='lnr lnr-arrow-right'></span></a></div>"
                        + "</div>"
                }
            }
            else if (result.intRowCnt == 0) {
                html += ""
                        + "<div class='col-sm-4'><div class='wel_item'><i class='lnr lnr-user'></i><h4></h4><p>혼주</p></div></div>"
                        + "<div class='col-sm-4'><div class='wel_item'><i class='lnr lnr-database'></i><h4>0</h4><p>총 환전 가능 금액</p></div></div>"
                        + "<div class='col-sm-4'><div class='wel_item'><i class='lnr lnr-users'></i><h4>0</h4><p>총 방문자 수</p></div></div>"
            }

            target.html(html);
        }

        function fnRefundList() {
            // ========= 핸들러 호출 ===========================
            var reqParam = {};
            var callURL  = "<%=HandlerRefer.PAYEVENTHANDLER%>";
            var callBack = "fnRefundListCallBack";

            reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
            reqParam["strMethodName"] = 'GetRefundList';

            BOQ.Ajax.jQuery.fnScrollListRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }

        function fnRefundListCallBack(result) {
            var target = $("#RefundList");
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
                        + "         <td>" + objDT[i].EXCHANGENO + "</td>"
                        + "         <td>" + BOQ.Utils.fnAddComma(objDT[i].EXCHAGEAMT) + " 원</td>"
                        + "         <td>" + objDT[i].REGDATE + "</td>"
                        + "         <td>" + objDT[i].STATECODEM + "</td>"
                        +"     </tr>"
                }
                if (result.intRowCnt == 0) {
                    html = "<tr><td class='text-center' colspan='4'>조회된 건이 없습니다.</td></tr>"
                }
            }
            else if (result.intRowCnt == 0) {
                html = "<tr><td class='text-center' colspan='4'>조회된 건이 없습니다.</td></tr>"
            }

            target.html(html);
        }

        //function fnRegistInfinityScrollEvent() {
        //    BOQ.Utils.fnResetPageNo();
        //    $(window).on("scroll", fnInfinityScroll);
        //}

        //------------------------------------------------------------  
        // 일반 함수정의
        //------------------------------------------------------------
        //function fnInfinityScroll() {
        //    var scrollHeight = $(document).height();
        //    var scrollPosition = $(window).height() + $(window).scrollTop();
        //
        //    // 스크롤이 100보다 조금 남고, 현재 PageNo가 Max PageNo 가 아닐때
        //    if (scrollPosition > scrollHeight - 100 && !BOQ.Utils.fnIsMaxPageNo()) {
        //        fnRefundList();
        //    }
        //}
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <section class="welcome_area p_120">
            <div class="container">
                <div class="welcome_text" id="RefundPrice"></div>
            </div>
            <br />
        	<div class="container">
        		<table class="table">
                    <thead>
                        <tr>
                            <td>환전번호</td>
                            <td>환전신청금액</td>
                            <td>환전신청날짜</td>
                            <td>결과</td>
                        </tr>
                    </thead>
                    <tbody id="RefundList">
                    </tbody>
        		</table>
        	</div>
        </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="layer" Runat="Server">
</asp:Content>