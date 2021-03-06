﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="PayInfoIns.aspx.cs" Inherits="PayInfoIns" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script>
        $(document).ready(function(){
            $("label").css("cursor", "pointer");
            $("#payBtn").on("click", function () {
                if ($("input[name=payAmt]:checked").val() == "-1" && parseInt($("#payamtDirect").val()) <= 0) {
                    alert("금액을 확인해주세요");
                    return;
                }
                else if ($("input[name=payAmt]:checked").val() == "-1") {
                    $("#payamt6").val($("#payamtDirect").val());
                }
                $("input[name=pgCode]").val($("input[name=paytool]:checked").data("pgcode"));
                $("input[name=paytoolName]").val($("input[name=paytool]:checked").data("paytoolname"));
                $("#form1").attr("action", "/Src/Pay/POQ.aspx");
                $("#form1").submit();
            });
            fnSelectMstCategory();
            fnSelectPaytool();
        });

        //메인 소속 조회
        function fnSelectMstCategory() {
            // ========= 핸들러 호출 ===========================
            var reqParam = {};
            var callURL  = "<%=HandlerRefer.FAMILYEVENTHANDLER%>";
            var callBack = "fnSelectMstCategoryCallBack";

            reqParam["strAjaxTicket"]     = '<%=AjaxTicket %>';
            reqParam["strMethodName"]     = 'MstCategoryLst';
            reqParam["intEventNo"]        = '<%=FamilyEventNo%>';

            BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }
        
        //세부 소속 조회
        function fnSelectSubCategory() {
            // ========= 핸들러 호출 ===========================
            var reqParam = {};
            var callURL  = "<%=HandlerRefer.FAMILYEVENTHANDLER%>";
            var callBack = "fnSelectSubCategoryCallBack";

            reqParam["strAjaxTicket"]     = '<%=AjaxTicket %>';
            reqParam["strMethodName"]     = 'SubCategoryLst';
            reqParam["intEventNo"]        = '<%=FamilyEventNo%>';
            reqParam["intMasterCategory"] = $("input[name=joinMstCategory]:checked").val();

            BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }

        // 결제 수단 선택
        function fnSelectPaytool() {
            // ========= 핸들러 호출 ===========================
            var reqParam = {};
            var callURL  = "<%=HandlerRefer.PAYEVENTHANDLER%>";
            var callBack = "fnSelectPaytoolCallBack";

            reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
            reqParam["strMethodName"] = 'PaytoolLst';

            BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
        }
        function fnSelectMstCategoryCallBack(result) {
            var target = $("#mstCategoryBlock");
            if (result.intRetVal != 0) {
                alert(result.strErrMsg);
                return;
            }
            var objDT = result.objDT;
            var html = "";
            if (objDT != null) {
                for (var i = 0; i < objDT.length; i++) {
                    if (i % 3 == 0) {
                        html += "<div class='row'>";
                    }
                    html += "<div class='col-md-4'>"
                         + "    <div class='switch-wrap d-flex '>"
                         + "        <p><label for='mst" + i + "'>" + objDT[i].JOINMSTCATEGORYNAME + "</label></p>&nbsp&nbsp&nbsp"
                         + "        <div class='primary-radio'>"
                         + "            <input type='radio' id='mst" + i + "' name='joinMstCategory' value='" + objDT[i].JOINMSTCATEGORY + "' ";
                    if (i == 0) {
                        html += "checked='checked'>"
                    }
                    else {
                        html += ">"
                    }
                    html += "            <label for='mst" + i + "'></label>"
                         + "        </div>"
                         + "    </div>"
                         + "</div>";
                    if ((i != 0 && (i + 1) % 3 == 0) || i == objDT.length - 1) {
                        html += "</div>";
                    }
                }
            }

            target.html(html);
            fnSelectSubCategory();
            $("input[name=joinMstCategory]").on("change", fnSelectSubCategory);
        }

        function fnSelectSubCategoryCallBack(result){
            var target = $("#subCategoryBlock");
            if (result.intRetVal != 0) {
                alert(result.strErrMsg);
                return;
            }
            var objDT = result.objDT;
            var html  = "";
            if (objDT != null) {
                for (var i = 0; i < objDT.length; i++)
                {
                    if(i % 3 == 0){
                        html+="<div class='row'>";
                    }
                    html += "<div class='col-md-4'>"
                         + "    <div class='switch-wrap d-flex '>"
                         + "        <p><label for='sub" + i + "'>" + objDT[i].JOINSUBCATEGORYNAME + "</label></p>&nbsp&nbsp&nbsp"
                         + "        <div class='primary-radio'>"
                         + "            <input type='radio' id='sub" + i + "' name='joinSubCategory' value='" + objDT[i].JOINSUBCATEGORY + "' ";
                    if (i == 0) {
                        html += "checked='checked'>"
                    }
                    else {
                        html += ">"
                    }
                    html += "            <label for='sub" + i + "'></label>"
                         + "        </div>"
                         + "    </div>"
                         + "</div>";
                    if((i != 0 && (i + 1)% 3 == 0) || i == objDT.length -1){
                        html+="</div>";
                    }
                }
            }

            target.html(html);
        }

        function fnSelectPaytoolCallBack(result) {
            var target = $("#paytoolBlock");
            if (result.intRetVal != 0) {
                alert(result.strErrMsg);
                return;
            }
            var objDT = result.objDT;
            var html = "";
            if (objDT != null) {
                for (var i = 0; i < objDT.length; i++) {
                    if (i % 3 == 0) {
                        html += "<div class='row'>";
                    }
                    html += "<div class='col-md-4'>"
                         + "    <div class='switch-wrap d-flex '>"
                         + "        <p><label for='paytool" + i + "'>" + objDT[i].PAYTOOLNAME + "</label></p>&nbsp&nbsp&nbsp"
                         + "        <div class='primary-radio'>"
                         + "            <input type='radio' id='paytool" + i + "' name='paytool' data-paytoolname='" + objDT[i].PAYTOOLNAME + "' data-pgcode='" + objDT[i].PGCODE + "' value='" + objDT[i].PAYTOOL + "' ";
                    if (i == 0) {
                        html += "checked='checked'>"
                    }
                    else {
                        html += ">"
                    }
                    html += "            <label for='paytool" + i + "'></label>"
                         + "        </div>"
                         + "    </div>"
                         + "</div>";
                    if ((i != 0 && (i + 1) % 3 == 0) || i == objDT.length - 1) {
                        html += "</div>";
                    }
                }
            }


            target.html(html);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <input type="hidden" name="eventNo" value="<%=FamilyEventNo %>" />
    <input type="hidden" name="pgCode"  value="" />
    <input type="hidden" name="paytoolName"  value="" />
    <div class="whole-wrap">
        <div class="container">
        	<div class="section-top-border">
				<h3 class="mb-30 title_color">메인 소속 선택</h3>
					<div class="col-lg-12">
						<blockquote class="generic-blockquote" id="mstCategoryBlock">
						</blockquote>
					</div>
				</div>
			
            <div class="section-top-border">
				<h3 class="mb-30 title_color">세부 소속 선택</h3>
				<div class="row">
					<div class="col-lg-12">
						<blockquote class="generic-blockquote" id="subCategoryBlock">
						
						</blockquote>
					</div>
				</div>
			</div>
            <div class="section-top-border">
				<h3 class="mb-30 title_color">결제수단 선택</h3>
				<div class="row">
					<div class="col-lg-12">
						<blockquote class="generic-blockquote" id="paytoolBlock">
						</blockquote>
					</div>
				</div>
			</div>
            <div class="section-top-border">
				<h3 class="mb-30 title_color">금액 선택</h3>
				<div class="row">
					<div class="col-lg-12">
						<blockquote class="generic-blockquote">
						<div class="row">
							<div class="col-md-4">
                                <div class="switch-wrap d-flex">
									<p><label for="payamt1">30,000 원</label></p>&nbsp&nbsp&nbsp
									<div class="primary-radio">
										<input type="radio" id="payamt1" name="payAmt" checked="checked" value="30000">
										<label for="payamt1"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex">
									<p><label for="payamt2">50,000 원</label></p>&nbsp&nbsp&nbsp
									<div class="primary-radio">
										<input type="radio" id="payamt2" name="payAmt" value="50000">
										<label for="payamt2"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex ">
									<p><label for="payamt3">100,000 원</label></p>&nbsp&nbsp&nbsp
									<div class="primary-radio">
										<input type="radio" id="payamt3" name="payAmt" value="100000">
										<label for="payamt3"></label>
									</div>
								</div>
							</div>
                        </div>
                        <div class="row">
							<div class="col-md-4">
                                <div class="switch-wrap d-flex ">
									<p><label for="payamt4">200,000 원</label></p>&nbsp&nbsp&nbsp
									<div class="primary-radio">
										<input type="radio" id="payamt4" name="payAmt" value="200000">
										<label for="payamt4"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex ">
									<p><label for="payamt5">300,000 원</label></p>&nbsp&nbsp&nbsp
									<div class="primary-radio">
										<input type="radio" id="payamt5" name="payAmt" value="300000">
										<label for="payamt5"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex ">
									<p><label for="payamt6"><input type="number" placeholder="직접 입력" min="0" class="form-control" id="payamtDirect" /></label></p>&nbsp&nbsp&nbsp
									<div class="primary-radio">
										<input type="radio" id="payamt6" name="payAmt" value="-1">
										<label for="payamt6"></label>
									</div>
								</div>
							</div>
                        </div>
						</blockquote>
					</div>
				</div>
			</div>
        </div>
    </div>
    <section>
        <div class="container">
            <div class="main_title">
                <a href="javascript:;" id="payBtn" class="genric-btn danger-border circle arrow">결제하기<span class="lnr lnr-arrow-right"></span></a>
            </div>
        </div>
    </section>
</asp:Content>

