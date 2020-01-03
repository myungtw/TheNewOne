<%@ Page Language="C#" MasterPageFile="~/MasterPage/Master.master" AutoEventWireup="true" CodeFile="Payment.aspx.cs" Inherits="Payment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript">
    $(document).ready(function () {
        if (<%=intPosOrderNo %> == 0 ) {
            alert("유효하지 않은 주문번호 입니다.");
            window.location.href = "<%=strPaymentResultUrl %>";
            return;
        }

        //Pos 주문정보 조회
        fnGetPosLog();

        //신용카드 추가 버튼
        $("#btnAddPayment").on("click", fnAddCardPayment);

        //현금영수증 - 용도에 선택 따른 식별번호 Option 설정
        $("input:radio[name='payment']").on("change", fnSetCashTRCode);

        //메시지 출력
        if ("<%=strResultMsg %>" != "") {
            alert("<%=strResultMsg %>".replace(/\|/gi, "\n"));
        }
    });

    //현금영수증 레이어
    function fnShowCashPaymentModal() {
        $(".layer_wrap").removeClass("layer_on");
        $("#divCashPayment").addClass("layer_on");

        $("#payCashAmt").val($("#cashAmt").data("payamt"));

        fnSetCashTRCode();
    }

    //현금영수증 - 용도에 따른 식별번호 Option 생성
    function fnSetCashTRCode() {
        $("#idInfo").val("");
        $("#selIdInfo option").remove();
        if ($("input:radio[name='payment']:checked").val() == 0) {
            $("#selIdInfo").append("<option value='mobileno'>휴대폰번호</option>");
            $("#selIdInfo").append("<option value='cardno'>소득공제카드</option>");
        }
        else {
            $("#selIdInfo").append("<option value='businessno'>사업자번호</option>");
        }
    }

    //신용카드 레이어
    function fnShowCardPaymentModal(idx) {
        $(".layer_wrap").removeClass("layer_on");
        $("#divCardPayment").addClass("layer_on");
        
        $("#payCardAmt").data("idx", idx);
        $("#payCardAmt").val($("#cardAmt" + idx).data("payamt"));
    }

    //신용카드 추가 버튼
    function fnAddCardPayment() {
        var payRemainAmt = $("#hidPayRemainAmt").val();
        var idx = $("#ulPaymentList").children().length - 1;

        $("#ulPaymentList").children().last().before("<li onclick='fnShowCardPaymentModal(" + idx + ");'><span>신용카드</span><p id='cardAmt" + idx + "' name='cardAmt'  data-idx='" + idx + "'  data-payamt='0'>0원</div></li>");

        //현금 결제 미완료 시 금액 초기화
        if ($("#hidCompletedCash").val() == "N") {
            $("#cashAmt").data("payamt", 0);
            $("#cashAmt").text("0원");
        }

        //최초 신용카드 추가 시 잔액 설정
        if ($("p[name='cardAmt']").length == 1) {
            $("p[name='cardAmt']").data("payamt", payRemainAmt);
            $("p[name='cardAmt']").text(BOQ.Utils.fnAddComma(payRemainAmt) + "원");
        }

        //결제수단 10개가 넘으면 신용카드 추가 버튼 none
        if ($("#ulPaymentList").children("li").length > 10) {
            $("#btnAddPayment").attr("style", "display : none");
        }
    }

    //이전 페이지 (상품 선택) 이동
    function fnSaleItem() {
        window.location.href = "/Src/Sale/SaleItem.aspx";
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
        reqParam["intPosOrderNo"] = <%=intPosOrderNo %>;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    //Pos 주문정보 조회 Callback
    function fnGetPosLogCallBack(result) {
        if (result.intRetVal != 0) {
            alert("주문 정보 조회에 실패하였습니다.");
            return;
        }

        //Pos 주문 상태, 총 결제 금액 및 잔여 금액
        var posStateCode      = result.intPosStateCode;
        var totalPurchasPrice = result.intTotalPurchasePrice;
        var payRemainAmt      = result.intPayRemainAmt;
        
        $("#hidPosStateCode").val(posStateCode);
        $("#hidTotalPurchasPrice").val(result.intTotalPurchasePrice);
        $("#hidPayRemainAmt").val(payRemainAmt);
        $("#totalPurchasePrice").text(BOQ.Utils.fnAddComma(totalPurchasPrice) + "원");
        $("#payRemainAmt").text(BOQ.Utils.fnAddComma(payRemainAmt) + "원");
        $("#hidProductName").val(result.strProductName);

        //결제 완료 내역 조회
        fnGetPosPayCompleteList();

        //구매 성공 시 신용카드 추가 히든
        if (posStateCode == 2) {
            $("#btnAddPayment").attr("style", "display : none");
        }
        //결제 완료 시 신용카드 추가 버튼 히든, 완료 버튼 활성화
        else if (payRemainAmt == 0) {
            $("#btnAddPayment").attr("style", "display : none");
            $("#btnPayComplete").removeClass("btn_gray").addClass("btn_navy");
        }
    }

    //Pos PG 결제 완료 내역 조회
    function fnGetPosPayCompleteList() {
        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.SALEHANDLER%>";
        var callBack = "fnGetPosPayCompleteListCallBack";

        reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
        reqParam["strMethodName"] = 'GetPosPayCompleteList';
        reqParam["intPosOrderNo"] = <%=intPosOrderNo %>;

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
                //현금 내역을 최상단에 노출
                if (objRet[i].PAYTOOLCODE == "<%=intCashPayTool %>") {
                    $("#ulPaymentList").children().first().remove();
                    $("#ulPaymentList").prepend("<li style='background-color:skyblue;'><span>현금</span><p data-payamt='" + objRet[i].PAYAMT + "'>" + BOQ.Utils.fnAddComma(objRet[i].PAYAMT) + "원</p></li>");
                    $("#hidCompletedCash").val("Y");
                }
                else if (objRet[i].PAYTOOLCODE == "<%=intCardPayTool %>") {
                    $("#ulPaymentList").children().last().before("<li style='background-color:skyblue;'><span>신용카드</span><p data-payamt='" + objRet[i].PAYAMT + "'>" + BOQ.Utils.fnAddComma(objRet[i].PAYAMT) + "원</p></li>");
                }
            }

            //잔여 금액 현금에 세팅
            if ($("#hidCompletedCash").val() == "N") {
                $("#cashAmt").data("payamt", Number($("#hidPayRemainAmt").val()));
                $("#cashAmt").text(BOQ.Utils.fnAddComma(Number($("#hidPayRemainAmt").val())) + "원");
            }
        }

        //잔여 금액이 남은 경우 신용카드 추가
        if ($("#hidPayRemainAmt").val() > 0) {
            fnAddCardPayment();
        }
    }

    //PG 결제 요청
    function fnPayRequest(type, paytool, pgcode) {
        var $objThis;

        if (type == "card") {
            $objThis    = $("#payCardAmt");
        }
        else {
            $objThis    = $("#payCashAmt");
        }

        //유효성 검사
        if (Number($objThis.val()) <= 0) {
            alert("금액을 입력하세요.");
            return;
        }
        else if (Number($objThis.val()) > Number($("#hidPayRemainAmt").val())) {
            alert("승인 금액이 잔여 금액보다 큽니다.");
            return;
        }
        if (paytool == '<%=intCashPayTool %>') {
            if ($("#idInfo").val() == '') {
                alert("정보를 입력하세요.");
                return;
            }

            //핸드폰 번호 : 10~11자리, 현금영수증카드번호 : 13~19자리, 사업자번호 10자리
            if (($("#selIdInfo").val() == 'mobileno' && ($("#idInfo").val().length < 10 || $("#idInfo").val().length > 11)) ||
                ($("#selIdInfo").val() == 'cardno'   && ($("#idInfo").val().length < 13 || $("#idInfo").val().length > 19))   ||
                ($("#selIdInfo").val() == 'businessno' && $("#idInfo").val().length != 10)) {
                alert("정보를 확인해주세요.");
                return;
            }
        }

        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.SALEHANDLER%>";
        var callBack = "fnPayRequestCallBack";

        reqParam["strAjaxTicket"]  = '<%=AjaxTicket %>';
        reqParam["strMethodName"]  = 'PayRequest';
        reqParam["intPosOrderNo"]  = <%=intPosOrderNo %>;
        reqParam["strProductName"] = $("#hidProductName").val();
        reqParam["intPayToolCode"] = paytool;
        reqParam["strPGCode"]      = pgcode;
        reqParam["intPayAmt"]      = $objThis.val();

        //신용카드인 경우
        if (paytool == '<%=intCardPayTool %>') {
            reqParam["intInsMon"] = $("#insmon").val();
        }
        //현금영수증인 경우
        else if (paytool == '<%=intCashPayTool %>') {
            reqParam["intTrCode"] = $("input[name='payment']:checked").val();
            reqParam["strIdInfo"] = $("#idInfo").val();
        }

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    //PG 결제 요청 CallBack
    function fnPayRequestCallBack(result) {
        if (result.intRetVal != 0) {
            alert("결제 요청에 실패하였습니다.\n다시 시도해 주세요.");
            return;
        }

        //RedirectUrl 결제 수단에 따라 다름
        //신용카드(CheckMobile) : PG 결제 요청 Url
        //현금영수증(KCP) : 빌링 결제 처리 Url (핸들러에서 결과까지 받음)
        if (result.strRedirectUrl != "") {
            window.location.href = result.strRedirectUrl;
        }
    }

    //결제 취소 요청
    function fnPayCancelRequest() {
        //구매 성공 시
        if ($("#hidPosStateCode").val() == 2) {
            alert("환불 메뉴를 이용해 주세요.");
            return;
        }

        //결제 완료 건이 없는 경우
        if ($("#hidTotalPurchasPrice").val() == $("#hidPayRemainAmt").val()) {
            return;
        }

        if (!confirm("해당 구매 건이 일괄 취소 됩니다.\n취소 하시겠습니까?")) {
            return;
        }

        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.SALEHANDLER%>";
        var callBack = "fnPayCancelRequestCallBack";

        reqParam["strAjaxTicket"]  = '<%=AjaxTicket %>';
        reqParam["strMethodName"]  = 'PayCancelRequest';
        reqParam["intPosOrderNo"]  = <%=intPosOrderNo %>;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }
    
    //결제 취소 요청 CallBack
    function fnPayCancelRequestCallBack(result) {
        if (result.intRetVal != 0) {
            alert("결제 취소 요청에 실패하였습니다.\n다시 시도해 주세요.");
            return;
        }

        //리로드
        location.href = "<%=strPaymentUrl %>" + result.strResultMsg;
    }

    //구매 요청
    function fnPurchaseRequest() {
        //결제 완료 여부 체크
        if ($("#hidPayRemainAmt").val() != 0) {
            alert("결제 잔여 금액이 있습니다.\n확인 바랍니다.");
            return;
        }
        else if (!confirm("판매 완료 페이지로 이동 합니다.")) {
            return;
        }
        
        //구매 완료(성공/실패) 시 결과 페이지 이동
        if ($("#hidPosStateCode").val() != 1) {
            window.location.href = "<%=strPaymentResultUrl %>";
            return;
        }

        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.SALEHANDLER%>";
        var callBack = "fnPurchaseRequestCallBack";

        reqParam["strAjaxTicket"]  = '<%=AjaxTicket %>';
        reqParam["strMethodName"]  = 'PurchaseRequest';
        reqParam["intPosOrderNo"]  = <%=intPosOrderNo %>;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    //결제 완료 버튼 (구매 요청) CallBack
    function fnPurchaseRequestCallBack(result) {
        if (result.intRetVal != 0) {
            alert("구매 요청에 실패하였습니다.\n다시 시도해 주세요.");
            return;
        }

        window.location.href = "<%=strPaymentResultUrl %>";
    }

</script>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="pos_content" Runat="Server">
    <input type="hidden" id="hidPosStateCode"      name="hidPosStateCode" />
    <input type="hidden" id="hidTotalPurchasPrice" name="hidTotalPurchasPrice" />
    <input type="hidden" id="hidPayRemainAmt"      name="hidPayRemainAmt" />
    <input type="hidden" id="hidProductName"       name="hidProductName" />
    <input type="hidden" id="hidCompletedCash"     name="hidCompletedCash" />

    <!-- 회원 정보 /-->
    <ul class="member_info">
        <li><span>회원명</span><strong></strong></li>
        <li><span>아이디</span><strong></strong></li>
        <li style="visibility: hidden;"><span>마일리지</span><strong></strong></li>
    </ul>

    <!-- 결제 /-->
    <div class="payment_wrap">
        <h2>결제</h2>
        <div class="payment_cont">
            <span>받을 금액</span><div id="totalPurchasePrice">0원</div>
        </div>
        <ul class="payment_list" id="ulPaymentList">
            <li onclick="fnShowCashPaymentModal();"><span>현금</span><p id="cashAmt" data-payamt="0">0원</p></li>
            <li><button type="button" id="btnAddPayment"><em>신용카드 추가하기</em></button></li>
        </ul>
        <div class="payment_cont">
            <span>결제 잔여 금액</span><strong id="payRemainAmt">0원</strong>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="pos_footer" Runat="Server">
    <a href="javascript:fnSaleItem();" class="btn btn_navy2" title="이전 페이지">이전 페이지</a>
    <a href="javascript:fnPayCancelRequest();" class="btn btn_navy3" id="btnPayCancel" title="구매 진행 취소">구매 진행 취소</a>
    <a href="javascript:fnPurchaseRequest();" class="btn btn_gray" id="btnPayComplete" title="결제 완료">결제 완료</a>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="pos_layer" Runat="Server">
    <div id="divCardPayment" class="layer_wrap">
        <div class="layer_bg" onclick="this.parentNode.className='layer_wrap';"></div>
        <div class="layer_cont layer_payment">
            <h3>신용카드 결제</h3>
            <table>
                <colgroup>
                    <col class="col01" />
                    <col class="col02" />
                </colgroup>
                <tbody>
                    <tr>
                        <th>승인금액</th>
                        <td><input type="number" id="payCardAmt" data-idx="0" onfocus="javacript:this.value='';" placeholder="금액을 입력하세요" /></td>
                    </tr>
                    <tr>
                      <th>할부선택</th>
                      <td>
                          <select id="insmon">
                              <option value="0" selected="selected">일시불</option>
                              <option value="2">2개월</option>
                              <option value="3">3개월</option>
                              <option value="4">4개월</option>
                              <option value="5">5개월</option>
                              <option value="6">6개월</option>
                          </select>
                      </td>
                    </tr>
                </tbody>
            </table>
            <ul class="layer_btn">
                <li><a href="javascript:;" title="취소" class="btn btn_navy3" onclick="this.parentNode.parentNode.parentNode.parentNode.className='layer_wrap';">취소</a></li>
                <li><a href="javascript:fnPayRequest('card', <%=intCardPayTool %>, '<%=strCardPGCode %>');" title="결제" class="btn btn_navy2">결제</a></li>
            </ul>
        </div>
    </div>
    <div id="divCashPayment" class="layer_wrap">
        <div class="layer_bg" onclick="this.parentNode.className='layer_wrap';"></div>
        <div class="layer_cont layer_payment">
            <h3>현금 결제</h3>
            <table>
                <colgroup>
                    <col class="col01" />
                    <col class="col02" />
                </colgroup>
                <tbody>
                    <tr>
                        <th>승인금액</th>
                        <td><input type="number" id="payCashAmt" data-idx="1" onfocus="javacript:this.value='';" placeholder="금액을 입력하세요" /></td>
                    </tr>
                    <tr>
                        <th>용도</th>
                        <td>
                            <ul class="select_type">
                                <li><input type="radio" name="payment" id="select_type01" value="0" checked="checked" /><label for="select_type01">소득공제용</label></li>
                                <li><input type="radio" name="payment" id="select_type02" value="1" /><label for="select_type02">지출증빙용</label></li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th>식별번호</th>
                        <td>
                            <select id="selIdInfo"></select>
                        </td>
                    </tr>
                    <tr>
                        <th>정보</th>
                        <td><input type="number" id="idInfo" placeholder="'-' 표시 없이 입력하세요." /></td>
                    </tr>
                </tbody>
            </table>
            <ul class="layer_btn">
                <li><a href="javascript:;" title="취소" class="btn btn_navy3" onclick="this.parentNode.parentNode.parentNode.parentNode.className='layer_wrap';">취소</a></li>
                <li><a href="javascript:fnPayRequest('cash', <%=intCashPayTool %>, '<%=strCashPGCode %>');" title="발행" class="btn btn_navy2">발행</a></li>
            </ul>
        </div>
    </div>
</asp:Content>
