<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="MyEventSample.aspx.cs" Inherits="Src_MyEventSample" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script src="/Lib/qrcode.min.js"></script>
<script>
    $(document).ready(function () {
        //QR코드 그리기
        var qrcode = new QRCode("qrcode", {
            text: "<%=strInvitationUrl%>",
            width: "250",
            height: "250",
            colorDark: "#000000",
            colorLight: "#ffffff",
            correctLevel: QRCode.CorrectLevel.L
        });
    });
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="welcome_area p_120">
        <div class="container">
        	<div class="row welcome_inner">
        		<div class="col-lg-6">
        			<div class="welcome_img">
        				<img class="img-fluid" src="/DesignTemplate/img/welcome-1.jpg" alt="">
        			</div>
        		</div>
        		<div class="col-lg-6">
        			<div class="welcome_text">
        				<h4>AA와 BB의 결혼식</h4>
        				<p>서울특별시 강남구 역삼동 513-12 3층 BC 홀</p>
        				<div class="row">
        					<div class="col-sm-4">
        						<div class="wel_item">
        							<i class="lnr lnr-database"></i>
        							<h4>30,000 원</h4>
        							<p>최소 결제 금액</p>
                                    <p><a class="genric-btn danger-border" href="#">수정</a></p>
        						</div>
        					</div>
        					<div class="col-sm-4">
        						<div class="wel_item">
        							<i class="lnr lnr-users"></i>
        							<h4>4장</h4>
        							<p>식권 지급수</p>
                                    <p><a class="genric-btn danger-border" href="#">수정</a></p>
        						</div>
        					</div>
        					<div class="col-sm-4">
        						<div class="wel_item">
        							<i class="lnr lnr-car"></i>
        							<h4>1장</h4>
        							<p>주차장 지급수</p>
                                    <p><a class="genric-btn danger-border" href="#">수정</a></p>
        						</div>
        					</div>
        				</div>
        			</div>
        		</div>        
                <div class="col-lg-6">
        			<div class="welcome_img">
                        <img src="/DesignTemplate/img/qrCode.png" alt=""/>
                        <div class="pop-dn" id="pop-dn1" style="position: absolute;">
                            <div id="qrcode" class="qr-code" style="position: relative; top: -325px; left: 75px;"></div>
                        </div>
        			</div>
        		</div>
        	</div>
        </div>
    </section>
    <section>
        <div class="container">
            <div class="main_title">
                <a href="#" class="genric-btn danger-border circle arrow">시설이용권 추가발급<span class="lnr lnr-arrow-right"></span></a>
                <a href="#" class="genric-btn danger-border circle arrow">내역 조회<span class="lnr lnr-arrow-right"></span></a>
            </div>
        </div>
    </section>
</asp:Content>

