<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="PayInfoInsSample.aspx.cs" Inherits="Src_PayInfoInsSample" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script>
        $(document).ready(function(){
            $("label").css("cursor", "pointer");
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="whole-wrap">
        <div class="container">
        	<div class="section-top-border">
				<h3 class="mb-30 title_color">메인 소속 선택</h3>
					<div class="col-lg-12">
						<blockquote class="generic-blockquote">
                         <div class="row">
							<div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="maleBtn">신랑</label></p>
									<div class="primary-radio">
										<input type="radio" id="maleBtn" name="main" checked="checked">
										<label for="maleBtn"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="femaleBtn">신부</label></p>
									<div class="primary-radio">
										<input type="radio" id="femaleBtn" name="main">
										<label for="femaleBtn"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
							</div>
                        </div>
						</blockquote>
					</div>
				</div>
			
            <div class="section-top-border">
				<h3 class="mb-30 title_color">세부 소속 선택</h3>
				<div class="row">
					<div class="col-lg-12">
						<blockquote class="generic-blockquote">
						    <div class="row">
							<div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="sub1">아버지 친인척</label></p>
									<div class="primary-radio">
										<input type="radio" id="sub1" name="sub" checked="checked">
										<label for="sub61"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="sub2">아버지 친구</label></p>
									<div class="primary-radio">
										<input type="radio" id="sub2" name="sub">
										<label for="sub2"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="sub3">어머니 친인척</label></p>
									<div class="primary-radio">
										<input type="radio" id="sub3" name="sub">
										<label for="sub3"></label>
									</div>
								</div>
							</div>
                        </div>
                        <div class="row">
							<div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="sub4">어머니 친구</label></p>
									<div class="primary-radio">
										<input type="radio" id="sub4" name="sub">
										<label for="sub4"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="sub5">친구</label></p>
									<div class="primary-radio">
										<input type="radio" id="sub5" name="sub">
										<label for="sub5"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="sub6">직장동료</label></p>
									<div class="primary-radio">
										<input type="radio" id="sub6" name="sub">
										<label for="sub6"></label>
									</div>
								</div>
							</div>
                        </div>
						</blockquote>
					</div>
				</div>
			</div>
            <div class="section-top-border">
				<h3 class="mb-30 title_color">결제수단 선택</h3>
				<div class="row">
					<div class="col-lg-12">
						<blockquote class="generic-blockquote">
							<div class="row">
							<div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="card">신용카드</label></p>
									<div class="primary-radio">
										<input type="radio" id="card" name="paytool" checked="checked">
										<label for="card"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="mobile">휴대폰</label></p>
									<div class="primary-radio">
										<input type="radio" id="mobile" name="paytool">
										<label for="mobile"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="mileage">마일리지</label></p>
									<div class="primary-radio">
										<input type="radio" id="mileage" name="paytool">
										<label for="mileage"></label>
									</div>
								</div>
							</div>
                        </div>
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
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="payamt1">30,000 원</label></p>
									<div class="primary-radio">
										<input type="radio" id="payamt1" name="payamt" checked="checked">
										<label for="payamt1"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="payamt2">50,000 원</label></p>
									<div class="primary-radio">
										<input type="radio" id="payamt2" name="payamt">
										<label for="payamt2"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="payamt3">100,000 원</label></p>
									<div class="primary-radio">
										<input type="radio" id="payamt3" name="payamt">
										<label for="payamt3"></label>
									</div>
								</div>
							</div>
                        </div>
                        <div class="row">
							<div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="payamt4">200,000 원</label></p>
									<div class="primary-radio">
										<input type="radio" id="payamt4" name="payamt">
										<label for="payamt4"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><label for="payamt5">300,000 원</label></p>
									<div class="primary-radio">
										<input type="radio" id="payamt5" name="payamt">
										<label for="payamt5"></label>
									</div>
								</div>
							</div>
                            <div class="col-md-4">
                                <div class="switch-wrap d-flex justify-content-between">
									<p><input type="number" placeholder="직접 입력" min="0" class="form-control" /></p>
									<div class="primary-radio">
										<input type="radio" id="payamt6" name="payamt">
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
                <a href="#" class="genric-btn danger-border circle arrow">결제하기<span class="lnr lnr-arrow-right"></span></a>
            </div>
        </div>
    </section>
</asp:Content>

