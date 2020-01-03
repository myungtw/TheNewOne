<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/Master.master" AutoEventWireup="true" CodeFile="PaymentResult.aspx.cs" Inherits="PaymentResult" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    var posOrderNo        = <%=intPosOrderNo %>;        //Pos 주문번호
    var posStateCode      = 0;

    $(document).ready(function () {
        if (posOrderNo == 0 ) {
            alert("유효하지 않은 주문번호 입니다.");
            window.location.href = "<%=strSaleIndexUrl %>";
            return;
        }
        //Pos 주문정보 조회
        fnGetPosLog();
        
        //메시지 출력
        if ("<%=strResultMsg %>" != "") {
            alert("<%=strResultMsg %>".replace(/\|/gi, "\n"));
        }
    });
    
    //관리자 지급 페이지 이동
    function fnFreeItem() {
        if (posStateCode == 1) {
            return;
        }

        window.location.href = "<%=strFreeItemIndexUrl %>";
    }
    
    //메인 페이지 이동
    function fnGoMain() {
        if (posStateCode == 1) {
            return;
        }

        window.location.href = "<%=strSaleIndexUrl %>";
    }

    //결과 메시지 레이어
    function fnShowResultMsgMadal(msg) {
        $("#resultMsg").text(msg);

        $(".layer_wrap").removeClass("layer_on");
        $("#divResultMsg").addClass("layer_on");
    }
    
    //==========================================================================
    // AJAX 호출, Callback 함수 정의
    //==========================================================================
    //Pos 주문정보 조회
    function fnGetPosLog() {
        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.SALEHANDLER%>";
        var callBack = "fnGetPosLogCallBack";

        reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
        reqParam["strMethodName"] = 'GetPosLog';
        reqParam["intPosOrderNo"] = posOrderNo;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    //Pos 주문정보 조회 Callback
    function fnGetPosLogCallBack(result) {
        if (result.intRetVal != 0) {
            alert("주문 정보 조회에 실패하였습니다.");
            return;
        }

        //Pos 주문 상태
        posStateCode = result.intPosStateCode;

        //구매 요청 중인 경우 결제 페이지로 이동
        if (posStateCode == 1) {
            alert("구매가 완료되지 않았습니다.");
            window.location.href = "<%=strPaymentUrl %>";
            return;
        }
        //구매 결과 메시지 설정
        else if (posStateCode == 2) {
            fnShowResultMsgMadal("판매가 완료되었습니다!");
        }
        else {
            fnShowResultMsgMadal("판매가 실패되었습니다!");
        }

        var html = "";
        var objRet = result.objDT;
        if(objRet != null && objRet.length > 0) {
            for (var i = 0 ; i < objRet.length; i++) {
                html += "<tr>"
                     +  "    <td>" + objRet[i].PRODUCTNAME + "</th>"
                     +  "    <td>" + objRet[i].SYMD + " ~ " + objRet[i].EYMD + "</td>"
                     +  "    <td>" + objRet[i].PRODUCTCNT + "</th>"
                     +  "    <td>" + BOQ.Utils.fnAddComma(objRet[i].PURCHASEPRICE) + "원</td>"
                     +  "</tr>";
            }
        }
        $("#tbodyProductList").html(html);

        //결제 완료 내역 조회
        fnGetPosPayCompleteList();

        //결제 완료 금액 설정
        $("#totalPayAmt").text(BOQ.Utils.fnAddComma(result.intPayProcessAmt) + "원");

        //관리자 지급 버튼 활성화
        $("#btnFreeItem").removeClass("btn_gray").addClass("btn_navy");
        $("#btnMain").removeClass("btn_gray").addClass("btn_navy3");
    }
    
    //Pos PG 결제 완료 내역 조회
    function fnGetPosPayCompleteList() {
        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.SALEHANDLER%>";
        var callBack = "fnGetPosPayCompleteListCallBack";

        reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
        reqParam["strMethodName"] = 'GetPosPayCompleteList';
        reqParam["intPosOrderNo"] = posOrderNo;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    //Pos PG 결제 완료 내역 조회 Callback
    function fnGetPosPayCompleteListCallBack(result) {
        if (result.intRetVal != 0) {
            alert("PG 결제 완료 내역 조회에 실패하였습니다.");
            return;
        }

        var html = "";
        var objRet = result.objDT;
        if(objRet != null && objRet.length > 0) {
            for (var i = 0 ; i < objRet.length; i++) {
                html += "<tr>"
                     +  "    <th colspan='2'>" + objRet[i].PAYTOOLDESC + "</th>"
                     +  "    <td>" + objRet[i].ETCDATA + "</td>"
                     +  "    <td>" + BOQ.Utils.fnAddComma(objRet[i].PAYAMT) + "원</td>"
                     +  "</tr>";
            }
            $("#tbodyPayList").html(html);
        }
    }

</script>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="pos_content" Runat="Server">
    <!-- 회원 정보 /-->
    <ul class="member_info">
        <li><span>회원명</span><strong></strong></li>
        <li><span>아이디</span><strong></strong></li>
        <li style="visibility: hidden;"><span>마일리지</span><strong></strong></li>
    </ul>
    
    <!-- 결제 결과 /-->
    <div class="sell_wrap">
        <h2>판매 내역</h2>
        <div class="sell_list">
            <table class="tb_payment">
                <colgroup>
                    <col class="col01" />
                    <col class="col02" />
                    <col class="col03" />
                    <col class="col04" />
                </colgroup>
                <thead>
                    <tr>
                        <th>상품명</th>
                        <th>유효기간</th>
                        <th>수량</th>
                        <th>구매가</th>
                    </tr>
                </thead>
                <tbody id="tbodyProductList">
                </tbody>
            </table>
        </div>
        <h2>결제 내역</h2>
        <div class="pay_list">
            <table class="tb_payment">
                <colgroup>
                    <col class="col01" />
                    <col class="col02" />
                    <col class="col03" />
                    <col class="col04" />
                </colgroup>
                <thead>
                    <tr>
                        <th colspan="2">결제수단</th>
                        <th>비고</th>
                        <th>결제금액</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th colspan="3">총 결제금액</th>
                        <td id="totalPayAmt"></td>
                    </tr>
                </tfoot>
                <tbody id="tbodyPayList">
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="pos_footer" Runat="Server">
    <a href="javascript:fnFreeItem();" class="btn btn_gray" id="btnFreeItem" title="관리자 지급">관리자 지급</a>
    <a href="javascript:fnGoMain();" class="btn btn_gray" id="btnMain" title="메인으로 가기">메인으로 가기</a>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="pos_layer" Runat="Server">
    <div id="divResultMsg" class="layer_wrap">
        <div class="layer_bg" onclick="this.parentNode.className='layer_wrap';"></div>
        <div class="layer_cont layer_complete">
            <strong id="resultMsg"></strong>
        </div>
    </div>
</asp:Content>
