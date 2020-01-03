<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/Master.master" AutoEventWireup="true" CodeFile="SaleItem.aspx.cs" Inherits="SaleItem" %>
<%@ Register TagPrefix="uc" TagName="UserControl" Src="~/Src/UC/UserControl.ascx"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script type="text/javascript" src="/Lib/Calendar.js?<%=DateTime.Now.ToString("yyyyMMdd") %>"></script>
<script type="text/javascript">
    var idx     = 0;
    var aItemID = "";
    $(document).ready( function() {
        // 이벤트 설정
        $("input[name='product']").on("click", fnGetProductList);
    });

    // 달력 보이기 이벤트
    function fnShowCalendar() {
        var calendarID = $(this).attr("id");

        $("#divCalendar").addClass("layer_on");
		$(".calendar").calendar("", calendarID, 1);
    }

    // 기간제 상품 종료일자 설정 이벤트
    function fnSetEndDate() {
        var $objStart = $(this);
        var $objEnd   = $objStart.next();
        var endDate   = getDate($objStart.data("date"), $(this).data("duration"));
        $objEnd.data("date", endDate);
        $objEnd.text(strToStr(endDate));
    }

    // 상품 모달 창 종료
    function fnCloseProductList() {
        $("#divProductList").removeClass("layer_on");
        $('input:radio').prop("checked", false);
    }

    // 장바구니 (상품상세) 삭제
    function fnDeleteShoppingCart() {
        $(".product"+$(this).closest("tr").data("idx")).remove();

        // 상품가 총액(Footer) 설정
        fnSetFooterPrice();
    }

    // 가격 정보 설정
    function fnSetDiscountAmt(discountPrice) {
        var $objThis    = $("#" + aItemID);
        var idx         = $objThis.data("idx");

        // 상품 할인금액 설정
        var productDiscountAmt = 0;
        $(".productDiscountAmt" + idx).each(function(){
            productDiscountAmt += Number($(this).text().replace(/,/gi, ""));
        });        
        $("#discountAmt" + idx).text(BOQ.Utils.fnAddComma(productDiscountAmt));

        // 상품 결제금액 설정        
        $("#purchasePrice" + idx).text(BOQ.Utils.fnAddComma(Number($("#originalPrice" + idx).data("originalprice")) - productDiscountAmt));
        
        // 물품 결제금액 설정        
        $objThis.closest("td").next().text(BOQ.Utils.fnAddComma(Number($objThis.closest("td").prev().data("originalprice")) - Number(discountPrice)));
        
        // 상품가 총액(Footer) 설정
        fnSetFooterPrice();
    }
    
    // 상품가 총액(Footer) 설정
    function fnSetFooterPrice() {
        // 상품가 총액 설정
        var originalPrice = 0;
        $(".originalPrice").each(function(){
            originalPrice += Number($(this).text().replace(/,/gi, ""));
        });        
        $("#totalOriginalPrice").text(BOQ.Utils.fnAddComma(originalPrice)+"원");
        
        // 할인 총액 설정
        var discountAmt = 0;
        $(".discountAmt").each(function(){
            discountAmt += Number($(this).text().replace(/,/gi, ""));
        });        
        $("#totalDiscountAmt").text(BOQ.Utils.fnAddComma(discountAmt)+"원");
        
        // 결제 금액 설정
        var totalPrice = Number(originalPrice) - Number(discountAmt);
        $("#totalPurchasePrice").text(BOQ.Utils.fnAddComma(totalPrice)+"원");

        if (totalPrice > 0)
            $("#btnNext").addClass("btn_navy").removeClass("btn_gray");
        else
            $("#btnNext").addClass("btn_gray").removeClass("btn_navy");
    }

    // 모달 버튼 클래스 설정
    function fnSetModalBtn() {
        if ($("#ulProductList").find("input:checkbox:checked").length > 0) {
            $(".btnShoppingCart").addClass("btn_navy2").removeClass("btn_gray2");
        }
        else {
            $(".btnShoppingCart").addClass("btn_gray2").removeClass("btn_navy2");
        }
    }

    // 상품 가격 할인 모달 창 설정
    function fnShowDiscountModal() {
        aItemID = $(this).attr("id");

        $("#divDiscountModal").addClass("layer_on");
        fnSetDiscountType(aItemID);
    }

    // 상품 할인 타입 설정
    function fnSetDiscountType(aItemID) {
        // 할인금액
        if($("#" + aItemID).data("storediscounttype") == 1) {
            $('input:radio[id="select_type02"]').prop("disabled", false).prop("checked", true);
            $('input:radio[id="select_type01"]').prop("disabled", true);
            $(".discountRateType").hide();
            $(".discountAmtType").show();
            $("#modalDiscountAmt").focus();
        }
        // 할인율
        else {
            $('input:radio[id="select_type01"]').prop("disabled", false).prop("checked", true);
            $('input:radio[id="select_type02"]').prop("disabled", true);
            $(".discountAmtType").hide();
            $(".discountRateType").show();
            $("#modalDiscountRate").focus();
        }
    }
    
    // 할인 금액 설정
    function fnSetProductDiscountAmt() {
        var $objThis = $("#" + aItemID);
        var discountPrice = 0;
        // 할인금액
        if($objThis.data("storediscounttype") == 1) {
            if($objThis.data("storediscountamt") < $("#modalDiscountAmt").val()) {
                alert("최대 할인 금액은 " + BOQ.Utils.fnAddComma($objThis.data("storediscountamt")) + "원 입니다.");
                $("#modalDiscountAmt").focus();
                return;
            }
            else if($("#modalDiscountAmt").val() < 0) {
                alert("0 이상의 금액을 입력해주세요.");
                $("#modalDiscountAmt").focus();
            }
            else {
                discountPrice = $("#modalDiscountAmt").val();
            }
        }
         // 할인율
        else {
            if($objThis.data("storediscountrate") < $("#modalDiscountRate").val()) {
                alert("최대 할인율은 " + $objThis.data("storediscountrate") + "% 입니다.");
                $("#modalDiscountRate").focus();
                return;
            }
            else if($("#modalDiscountRate").val() < 0) {
                alert("0 이상의 할인율을 입력해주세요.");
                $("#modalDiscountRate").focus();
            }
            else {
                var originalprice = $objThis.closest("tr").find(".tb_c04").data("originalprice");
                discountPrice = originalprice * $("#modalDiscountRate").val() / 100;
                $("#modalDiscountRateAmt").text(BOQ.Utils.fnAddComma(discountPrice) + "원");
            }
        }

        $objThis.text(BOQ.Utils.fnAddComma(discountPrice));
        fnSetDiscountAmt(discountPrice);

        $("#divDiscountModal").removeClass("layer_on");
    }
    
    // 할인 금액 설정
    function fnSetModalDiscountAmt() {
        var $objThis = $("#" + aItemID);
        var discountPrice = 0;

        if($objThis.data("storediscountrate") < $("#modalDiscountRate").val()) {
            alert("최대 할인율은 " + $objThis.data("storediscountrate") + "% 입니다.");
            $("#modalDiscountRate").focus();
            return;
        }

        var originalprice = $objThis.closest("tr").find(".tb_c04").data("originalprice");
        discountPrice = originalprice * $("#modalDiscountRate").val() / 100;
        $("#modalDiscountRateAmt").text(BOQ.Utils.fnAddComma(discountPrice) + "원");
    }

        
    //==========================================================================
    // AJAX 호출, Callback 함수 정의
    //==========================================================================
    // 상품 조회
    function fnGetProductList() {
        $("#productListTitle").text($(this).next().text() + " 상품 선택");

        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.SALEHANDLER%>";
        var callBack = "fnGetProductListCallBack";

        reqParam["strAjaxTicket"]       = '<%=AjaxTicket%>';
        reqParam["strMethodName"]       = 'GetProductList';
        reqParam["intProductTypeCode"]  = $('input:radio[name="product"]:checked').val();

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }
    // 상품 조회 Callback
    function fnGetProductListCallBack(result) {
        var target      = $("#ulProductList");
        var html        = "";

        if (result.intRetVal != 0) {
            alert("상품 조회에 실패하였습니다.");
            fnCloseProductList();
            return;
        }

        var objRet = result.objDT;
        if(objRet != null) {
            if (objRet.length > 0) {                    
                for (var i = 0 ; i < objRet.length; i++) {
                    html += "<li><span><input type='checkbox' name='product' id='layer_product" + i + "' data-productid='" + objRet[i].PRODUCTID + "'/><label for='layer_product" + i + "'>" + objRet[i].PRODUCTNAME + "</label></span><strong>" + BOQ.Utils.fnAddComma(objRet[i].PRICE) + "원</strong></li>"
                }
            }
            else {
                alert("상품이 없습니다.");
                fnCloseProductList();
                return;
            }

            target.html(html);
            fnSetModalBtn();
            $("input:checkbox").on("change", fnSetModalBtn);
            $("#divProductList").addClass("layer_on");
        }
    }
    
    // 상품 상세 조회(복수) - 장바구니 상품 추가
    function fnAddShoppingCart() {
        var strProductIDs   = "";
        $("#ulProductList").find("input:checkbox:checked").each(function () {
            strProductIDs += $(this).data("productid") + "^";
        });

        if (strProductIDs == "") {
            alert("선택된 상품이 없습니다.");
            return;
        }

        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.SALEHANDLER%>";
        var callBack = "fnAddShoppingCartCallBack";

        reqParam["strAjaxTicket"]   = '<%=AjaxTicket%>';
        reqParam["strMethodName"]   = 'GetProductDtl';
        reqParam["strProductIDs"]   = strProductIDs;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }
    // 상품 상세 조회(복수) Callback
    function fnAddShoppingCartCallBack(result) {
        var html        = "";
        var target      = $("#tShoppingCart");
        var productcnt  = 0;
        var objCExpMap  = new Map();

        if (result.intRetVal != 0) {
            alert(result.strErrMsg);
            fnCloseProductList();
            return;
        }

        var objRet = result.objDT;
        if(objRet != null) {
            if (objRet.length > 0) {                    
                for (var i = 0 ; i < objRet.length; i++) {
                    if(objRet[i].SORT == 1) {
                        productcnt++;
                        html += "<tr data-productid='" + objRet[i].PRODUCTID + "' data-itemid='" + objRet[i].ITEMID + "' data-itemtype='" + objRet[i].ITEMTYPE + "' data-idx='" + ++idx + "' class='product product" + idx + "'>";
                        // 이름
                        html += "   <td class='tb_c01'>" + objRet[i].PRODUCTNAME + "</td>";
                        // 기간설정
                        if(objRet[i].DURATIONTYPE == 1)
                            html += "   <td class='tb_c02'><a href='javascript:;' id='cal" + idx + "' class='start' data-duration='" + objRet[i].DURATION + "'>" + strToStr(getDate()) + "</a> ~ <span class='end'>" + strToStr(getDate('', objRet[i].DURATION)) + "</span></td>";
                        else if (objRet[i].DURATIONTYPE == 2)
                            html += "   <td class='tb_c02' data-symd='" + strToStr4(getDate()) + "' data-eymd='" + strToStr4(getDate('', objRet[i].EXPIREPERIOD)) + "'></td>";
                        else
                            html += "   <td class='tb_c02'></td>";
                        html += "   <td class='tb_c03'>1</td>";
                        // 원금액
                        html += "   <td class='tb_c04 originalPrice' id='originalPrice" + idx + "' data-originalprice='" + objRet[i].PRICE + "'>" + BOQ.Utils.fnAddComma(objRet[i].PRICE) + "</td>";
                        // 할인금액
                        html += "   <td class='tb_c05 discountAmt' id='discountAmt" + idx + "'>0</td>";
                        // 최종금액
                        html += "   <td class='tb_c06 purchasePrice' id='purchasePrice" + idx + "'>" + BOQ.Utils.fnAddComma(objRet[i].PRICE) + "</td>";
                        html += "   <td class='tb_c07'><button class='btn_del' type='button'>삭제</button></td>";
                        html += "</tr>";
                    }
                    else {
                        html += "<tr data-productid='" + objRet[i].PRODUCTID + "' data-itemid='" + objRet[i].ITEMID + "' data-idx='" + idx + "' class='bg item product" + idx + "'>";
                        // 이름
                        html += "   <td class='tb_c01'><div class='tit'>" + objRet[i].PRODUCTNAME + "</div></td>";
                        // 기간
                        html += "   <td class='tb_c02'></td>";
                        html += "   <td class='tb_c03'>1</td>";
                        // 원금액
                        html += "   <td class='tb_c04' data-originalprice='" + objRet[i].PRICE + "'>" + BOQ.Utils.fnAddComma(objRet[i].PRICE) + "</td>";
                        // 할인금액
                        html += "   <td class='tb_c05'>" + (objRet[i].STOREDISCOUNTFLAG == "Y" && objRet[i].MAXDISCOUNTAMT > 0 ? "<a id='item_" + idx + "_" + objRet[i].SEQNO + "' data-idx='" + idx + "' class='productDiscountAmt productDiscountAmt" + idx + "' data-maxdiscountamt='" + objRet[i].MAXDISCOUNTAMT + "' data-storediscounttype='" + objRet[i].STOREDISCOUNTTYPE + "' data-storediscountrate='" + objRet[i].STOREDISCOUNTRATE + "' data-storediscountamt='" + objRet[i].STOREDISCOUNTAMT + "'>0</a>" : "0") + "</td>";
                        // 최종금액
                        html += "   <td class='tb_c06'>" + BOQ.Utils.fnAddComma(objRet[i].PRICE) + "</td>";
                        html += "   <td class='tb_c07'></td>";
                        html += "</tr>";
                    }
                }

                // symd eymd itemtype 별 가장 마지막 날짜 기준으로 설정
                // 보유 상품 일자 체크
                if(result.strHoldCExpDates) {
                    var strCExpDates     = result.strHoldCExpDates;
                    var objCExpDateArray = strCExpDates.split('|');
                    
                    objCExpDateArray.forEach(function(item, index, array){
                        var tempArray = item.split('^');
                        objCExpMap.set(Number(tempArray[0]), tempArray[1]);
                    });
                }
            }
            else {
                alert("상품이 없습니다.");
                fnCloseProductList();
                return;
            }
        }
        target.append(html);

        // 장바구니 일자 체크
        target.find("tr.product").each(function(){
            var $objThis = $(this);
            if($objThis.data("idx") <= idx - productcnt) {
                var itemtype = $objThis.data("itemtype");
                if(itemtype != 0) {
                    var eymd = strToStr3($objThis.find(".tb_c02 span").text());
                    // 장바구니에 추가된 날짜가 더 이후면 값 업데이트
                    if(objCExpMap.has(itemtype) && eymd > objCExpMap.get(itemtype)) {
                        objCExpMap.delete(itemtype);
                    }
                    objCExpMap.set(itemtype, eymd);
                }
            }
        });

        // 새로 추가되는 상품에 기간제 상품이 있다면 최대 일자에 맞춰서 날짜 업데이트
        target.find("tr.product").each(function(){
            var $objThis = $(this);
            if($objThis.data("idx") > idx - productcnt) {
                var itemtype = $objThis.data("itemtype");
                if(itemtype != 0) {
                    if (objCExpMap.has(itemtype)) {
                        var eymd = objCExpMap.get(itemtype);
                        var startDate = getDate(strToDate(eymd), 2);
                        $objThis.find(".start").text(strToStr(startDate));
                        $objThis.find(".end").text(strToStr(getDate(startDate, $objThis.find(".start").data("duration"))));
                        objCExpMap.delete(itemtype);
                    }
                    objCExpMap.set(itemtype, strToStr3($objThis.find(".tb_c02 span").text()));
                }
            }
        });

        // 이벤트 설정
        $(".start").off().on("click", fnShowCalendar).on("DOMSubtreeModified", fnSetEndDate);
        $(".btn_del").off().on("click", fnDeleteShoppingCart);        
        $(".productDiscountAmt").off().on("click", fnShowDiscountModal);
        
        // 상품가 총액(Footer) 설정
        fnSetFooterPrice();

        // 상품 목록 닫기
        fnCloseProductList();
    }
       
    // 판매 정보 입력
    function fnInsPosLog() {
        var totalOriginalPrice = $("#totalOriginalPrice").text().replace(/,/gi, "").replace("원", "");
        var totalDiscountAmt   = $("#totalDiscountAmt").text().replace(/,/gi, "").replace("원", "");
        var totalPurchasePrice = $("#totalPurchasePrice").text().replace(/,/gi, "").replace("원", "");
        var posLogProductInfo  = "";
        $(".product").each(function(){
            var $objThis = $(this);
            // Index
            posLogProductInfo += $objThis.data("idx") + "^";
            // ProductID
            posLogProductInfo += $objThis.data("productid") + "^";
            // ProductCnt
            posLogProductInfo += $objThis.find(".tb_c03").text() + "^";
            // Product Consume Start Date
            posLogProductInfo += ($objThis.find(".tb_c02").find(".start").length ? strToStr3($objThis.find(".tb_c02").find(".start").text()) : ($objThis.find(".tb_c02").data("symd") ? $objThis.find(".tb_c02").data("symd") : "")) + "^";
            // Product Consume End Date
            posLogProductInfo += ($objThis.find(".tb_c02").find(".end").length ? strToStr3($objThis.find(".tb_c02").find(".end").text()) : ($objThis.find(".tb_c02").data("eymd") ? $objThis.find(".tb_c02").data("eymd") : "")) + "^";
            // PurchasePrice
            posLogProductInfo += $objThis.find(".purchasePrice").text().replace(/,/gi, "") + "|";
        });
        var posLogProductDtlInfo  = "";
        $(".bg").each(function(){
            var $objThis = $(this);
            // Index
            posLogProductDtlInfo += $objThis.data("idx") + "^";
            // ProductID
            posLogProductDtlInfo += $objThis.data("productid") + "^";
            // ItemID
            posLogProductDtlInfo += $objThis.data("itemid") + "^";
            // StoreDiscountAmt
            posLogProductDtlInfo += ($objThis.find("a").length ? $objThis.find("a").text().replace(/,/gi, "") : "0") + "|";
        });

        
        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL  = "<%=HandlerRefer.SALEHANDLER%>";
        var callBack = "fnInsPosLogCallBack";

        reqParam["strAjaxTicket"]           = '<%=AjaxTicket%>';
        reqParam["strMethodName"]           = 'InsPosLog';
        reqParam["intTotalOriginPrice"]     = totalOriginalPrice;
        reqParam["intTotalDiscountAmt"]     = totalDiscountAmt;
        reqParam["intTotalPurchasePrice"]   = totalPurchasePrice;
        
        reqParam["strProductInfos"]         = posLogProductInfo;
        reqParam["strProductDtlInfos"]      = posLogProductDtlInfo;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }
    // 판매 정보 입력 Callback
    function fnInsPosLogCallBack(result) {
        if (result.intRetVal != 0) {
            alert("판매 정보 저장에 실패하였습니다.\n" + result.strErrMsg);
            return;
        }

        location.href = "<%=strSalePaymentUrl %>" + result.intPosOrderNo;
    }
    

    // 날짜 YYYY-MM-DD
    function getDate(date, intAdd) {
        if (!date)
            date = Date.now();
        var dt = new Date(date);
        if(intAdd)
            dt.setDate(dt.getDate()+(intAdd-1));
 
        var todayYear  = dt.getFullYear();
        var todayMonth = dt.getMonth() + 1;
        var todayDay   = dt.getDate();
 
        if(todayMonth < 10) todayMonth = "0" + todayMonth;
        if(todayDay < 10)   todayDay = "0" + todayDay;
 
        return todayYear + "-" + todayMonth + "-" + todayDay;
    }

	// YYYY-MM-DD => "YY.MM.DD"
	function strToStr(d) {
        var arr     = d.split('-');
		var year    = arr[0].toString().substr(2,2);
		var month   = (arr[1].length == 1 ? "0" : "") + arr[1];
        var day     = (arr[2].length == 1 ? "0" : "") + arr[2];
		return year + "." + month + "." + day;
	};

	// YYYYMMDD => "YY.MM.DD"
	function strToStr2(d) {
		var year    = d.toString().substr(2,2);
		var month   = d.toString().substr(4,2);
        var day     = d.toString().substr(6,2);
		return year + "." + month + "." + day;
	};

	// YY.MM.DD => YYYYMMDD
	function strToStr3(d) {
		var year    = "20" + d.toString().substr(0,2);
		var month   = d.toString().substr(3,2);
        var day     = d.toString().substr(6,2);
		return year + month + day;
	};

	// YYYY-MM-DD => YYYYMMDD
	function strToStr4(d) {
		var year    = d.toString().substr(0,4);
		var month   = d.toString().substr(5,2);
        var day     = d.toString().substr(8,2);
		return year + month + day;
	};

	// YYYYMMDD => YYYY-MM-DD
	function strToDate(d) {
		var year    = d.toString().substr(0,4);
		var month   = d.toString().substr(4,2);
        var day     = d.toString().substr(6,2);
		return year + "-" + month + "-" + day;
	};
</script>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="pos_content" Runat="Server">
    <input type="hidden" id="PosOrderNo" name="PosOrderNo"/>
    <ul class="member_info">
    <li><span>회원명</span><strong></strong></li>
    <li><span>아이디</span><strong></strong></li>
    <li style="visibility:hidden"><span>마일리지</span><strong>10,000</strong></li>
    </ul>
    <div class="sell_wrap">
    <h2>상품 선택</h2>
    <ul class="product_wrap"><%=strProductTypeOption%></ul>
    <h2>장바구니</h2>
    <div class="tb_cart">
        <table>
        <colgroup><col class="col01"/><col class="col02"/><col class="col03"/><col class="col04"/><col class="col05"/><col class="col06"/><col class="col07"/></colgroup>
        <thead>
            <tr><th>상품명</th><th>유효기간</th><th>수량</th><th>상품가</th><th>할인금액</th><th>결제금액</th><th></th></tr>
        </thead>
        <tbody id="tShoppingCart"></tbody>
        </table>
    </div>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="pos_footer" Runat="Server">
    <ul class="price_wrap">
        <li class="tot"><span>상품가 총액</span><strong id="totalOriginalPrice">0원</strong></li>
        <li class="discount"><span>할인 총액</span><strong id="totalDiscountAmt">0원</strong></li>
        <li class="payment"><span>결제 금액</span><strong id="totalPurchasePrice">0원</strong></li>
    </ul>
    <a href="javascript:fnInsPosLog();" class="btn btn_gray" data-auth="1" id="btnNext" title="다음">다음</a>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="pos_layer" Runat="Server">
  <div id="divCalendar" class="layer_wrap">
    <div class="layer_bg" onclick="this.parentNode.className='layer_wrap';"></div>
	<div class="calendar"></div>
  </div>

  <div id="divProductList" class="layer_wrap">
    <div class="layer_bg" onclick="this.parentNode.className='layer_wrap';"></div>
    <div class="layer_cont layer_product">
      <h3 id="productListTitle"></h3>
      <ul class="product_list" id="ulProductList"></ul>
      <ul class="layer_btn">
        <li><a href="javascript:fnCloseProductList();" title="취소" class="btn btn_navy3">취소</a></li>
        <li><a href="javascript:fnAddShoppingCart();" title="장바구니 담기" class="btn btn_gray2 btnShoppingCart">장바구니 담기</a></li>
      </ul>
    </div>
  </div>
        
  <div id="divDiscountModal" class="layer_wrap">
    <div class="layer_bg" onclick="this.parentNode.className='layer_wrap';"></div>
    <div class="layer_cont layer_payment">
      <h3>상품 할인</h3>
      <table>
        <colgroup>
          <col class="col01"/>
          <col class="col02"/>
        </colgroup>
        <tbody>
        <tr>
          <th>할인액 계산 방식</th>
          <td>
            <ul class="select_type">
              <li><input type="radio" name="discount" id="select_type01" onclick="javascript:;"/><label for="select_type01">할인율</label></li>
              <li><input type="radio" name="discount" id="select_type02" onclick="javascript:;"/><label for="select_type02">할인금액</label></li>
            </ul>
          </td>
        </tr>
        <tr class="discountRateType">
          <th>할인율(%)</th>
          <td><input type="number" value="" id="modalDiscountRate" onfocus="javacript:this.value='';$('#modalDiscountRateAmt').val('0원')" onblur="javascript:fnSetModalDiscountAmt();" placeholder="할인 %를 입력하세요"/></td>
        </tr>
        <tr class="discountRateType">
          <th>할인액</th>
          <td><strong id="modalDiscountRateAmt">0원</strong></td>
        </tr>
        <tr class="discountAmtType">
          <th>할인 금액</th>
          <td><input type="number" value="" id="modalDiscountAmt" onfocus="javacript:this.value='';" placeholder="할인 금액을 입력하세요"/></td>
        </tr>
        </tbody>
      </table>
      <ul class="layer_btn">
        <li><a href="javascript:;" title="취소" class="btn btn_navy3" onclick="this.parentNode.parentNode.parentNode.parentNode.className='layer_wrap';">취소</a></li>
        <li><a href="javascript:fnSetProductDiscountAmt();" title="할인 적용" class="btn btn_navy2">할인 적용</a></li>
      </ul>
    </div>
  </div>
</asp:Content>
