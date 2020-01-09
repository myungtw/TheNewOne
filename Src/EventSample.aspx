<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="EventSample.aspx.cs" Inherits="Src_EventSample" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="properties_area pad_top">
        	<div class="container">
        		<div class="main_title">
        			<h2>내 이벤트</h2>
        			<p>현재 등록된 나의 이벤트를 확인하세요.</p>
        		</div>
        		<div class="row properties_inner">
        			<div class="col-lg-4">
        				<div class="properties_item">
        					<div class="pp_img">
        						<img class="img-fluid" src="/DesignTemplate/img/properties/pp-1.jpg" alt="">
        					</div>
        					<div class="pp_content">
        						<a href="#"><h4>AA와 BB의 결혼식</h4></a>
        						<div class="tags">
        							서울특별시 강남구 역삼동 513-12 3층 BC 홀
        						</div>
        						<div class="pp_footer">
        							<h5>2020년 1월 5일</h5>
        							<a class="main_btn" href="#">자세히 보기</a>
        						</div>
        					</div>
        				</div>
        			</div>
        			<div class="col-lg-4">
        				<div class="properties_item">
        					<div class="pp_img">
        						<img class="img-fluid" src="/DesignTemplate/img/properties/pp-2.jpg" alt="">
        					</div>
        					<div class="pp_content">
        						<a href="#"><h4>AA와 BB의 결혼식</h4></a>
        						<div class="tags">
        							서울특별시 강남구 역삼동 513-12 3층 BC 홀
        						</div>
        						<div class="pp_footer">
        							<h5>2020년 1월 5일</h5>
        							<a class="main_btn" href="#">자세히 보기</a>
        						</div>
        					</div>
        				</div>
        			</div>
        			<div class="col-lg-4">
        				<div class="properties_item">
        					<div class="pp_img">
        						<img class="img-fluid" src="/DesignTemplate/img/properties/pp-3.jpg" alt="">
        					</div>
        					<div class="pp_content">
        						<a href="#"><h4>AA와 BB의 결혼식</h4></a>
        						<div class="tags">
        							서울특별시 강남구 역삼동 513-12 3층 BC 홀
        						</div>
        						<div class="pp_footer">
        							<h5>2020년 1월 5일</h5>
        							<a class="main_btn" href="#">자세히 보기</a>
        						</div>
        					</div>
        				</div>
        			</div>
        		</div>
        	</div>
        </section>
        <section class="feature_area p_120 pad_top">
        	<div class="container">
        		<div class="main_title">
        			<h2>초대받은 이벤트</h2>
        			<p>초대받은 이벤트를 확인하세요.</p>
        		</div>
        		<div class="row properties_inner">
        			<div class="col-lg-4">
        				<div class="properties_item">
        					<div class="pp_img">
        						<img class="img-fluid" src="/DesignTemplate/img/properties/pp-1.jpg" alt="">
        					</div>
        					<div class="pp_content">
        						<a href="#"><h4>AA와 BB의 결혼식</h4></a>
        						<div class="tags">
        							서울특별시 강남구 역삼동 513-12 3층 BC 홀
        						</div>
        						<div class="pp_footer">
        							<h5>2020년 1월 5일</h5>
        							<a class="main_btn" href="#">결제 하러가기</a>
        						</div>
        					</div>
        				</div>
        			</div>
        			<div class="col-lg-4">
        				<div class="properties_item">
        					<div class="pp_img">
        						<img class="img-fluid" src="/DesignTemplate/img/properties/pp-2.jpg" alt="">
        					</div>
        					<div class="pp_content">
        						<a href="#"><h4>AA와 BB의 결혼식</h4></a>
        						<div class="tags">
        							서울특별시 강남구 역삼동 513-12 3층 BC 홀
        						</div>
        						<div class="pp_footer">
        							<h5>2020년 1월 5일</h5>
        							<a class="main_btn genric-btn info" href="#">시설이용권 사용</a>
        						</div>
        					</div>
        				</div>
        			</div>
        			<div class="col-lg-4">
        				<div class="properties_item">
        					<div class="pp_img">
        						<img class="img-fluid" src="/DesignTemplate/img/properties/pp-3.jpg" alt="">
        					</div>
        					<div class="pp_content">
        						<a href="#"><h4>AA와 BB의 결혼식</h4></a>
        						<div class="tags">
        							서울특별시 강남구 역삼동 513-12 3층 BC 홀
        						</div>
        						<div class="pp_footer">
        							<h5>2020년 1월 5일</h5>
        							<a class="main_btn genric-btn info" href="#">시설이용권 사용</a>
        						</div>
        					</div>
        				</div>
        			</div>
        		</div>

        	</div>

        </section>
        <section>
            <div class="container">
                <div class="main_title">
                    <a href="#" class="genric-btn danger-border circle arrow">내정보 보기<span class="lnr lnr-arrow-right"></span></a>
                    <a href="#" class="genric-btn danger-border circle arrow">내역 조회<span class="lnr lnr-arrow-right"></span></a>
                </div>
            </div>
        </section>
</asp:Content>

