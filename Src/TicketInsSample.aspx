<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="TicketInsSample.aspx.cs" Inherits="Src_TicketInsSample" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="whole-wrap">
    <div class="container">
        <div class="section-top-border">
			<h3 class="mb-30 title_color">시설 이용권 추가 발급</h3>
				<div class="col-lg-12">
					<blockquote class="generic-blockquote">
                        <div class="input-group-icon mt-10">
                            <div class="icon"><i class="fa user fa-user" aria-hidden="true"></i></div>
		                    <input type="text" name="id" placeholder="ID" onfocus="this.placeholder = ''" onblur="this.placeholder = 'ID'" required="" class="single-input">
	                    </div>
                        <div class="input-group-icon mt-10">
		                    <div class="icon"><i class="fa fa-car" aria-hidden="true"></i></div>
		                    <input type="number" name="parkticket" min="0" placeholder="주차권" onfocus="this.placeholder = ''" onblur="this.placeholder = '주차권'" required="" class="single-input">
	                    </div>
                        <div class="input-group-icon mt-10">
		                    <div class="icon"><i class="fa fa-cutlery" aria-hidden="true"></i></div>
		                    <input type="number" name="foodticket" min="0" placeholder="식권" onfocus="this.placeholder = ''" onblur="this.placeholder = '식권'" required="" class="single-input">
	                    </div>
					</blockquote>
				</div>
			</div>

    </div>
    </div>
    <section>
        <div class="container">
            <div class="main_title">
                <a href="#" class="genric-btn danger-border circle arrow">발급<span class="lnr lnr-arrow-right"></span></a>
                <a href="#" class="genric-btn danger-border circle arrow">취소<span class="lnr lnr-arrow-right"></span></a>
            </div>
        </div>
    </section>
</asp:Content>

