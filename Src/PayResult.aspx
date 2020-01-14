<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="PayResult.aspx.cs" Inherits="PayResult" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="whole-wrap">
        <div class="container">
        	<div class="section-top-border">
			    <h3 class="mb-30 title_color">결제 결과</h3>
				<div class="col-lg-12">
					<blockquote class="generic-blockquote">
                        <table class="table">
                            <tr>
                                <td class="alert-danger text-center" style="width:30%;">결제결과</td>
                                <td class="text-right">성공</td>
                            </tr>
                            <tr>
                                <td class="alert-danger text-center">결제수단</td>
                                <td class="text-right">핸드폰</td>
                            </tr>
                            <tr>
                                <td class="alert-danger text-center">결제금액</td>
                                <td class="text-right">50,000</td>
                            </tr>
                            <tr>
                                <td class="alert-danger text-center">받는사람</td>
                                <td class="text-right">지용선</td>
                            </tr>
                            <tr>
                                <td class="alert-danger text-center">결제자</td>
                                <td class="text-right">지용선</td>
                            </tr>
                        </table>
					</blockquote>
				</div>
			</div>
        </div>
    </div>
</asp:Content>

