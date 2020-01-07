<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="MyEventPayListSample.aspx.cs" Inherits="Src_MyEventPayListSample" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <section class="welcome_area p_120">
        	<div class="container">
        		<table class="table">
                    <thead>
                        <tr>
                            <td>이름</td>
                            <td>구분</td>
                            <td>결제수단</td>
                            <td>금액</td>
                            <td>시설이용권(식권) 사용</td>
                            <td>시설이용권(주차권) 사용</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>지용선</td>
                            <td>구분</td>
                            <td>휴대폰</td>
                            <td>50,000원</td>
                            <td>3</td>
                            <td>1</td>
                        </tr>
                        <tr>
                            <td>지용선2</td>
                            <td>구분</td>
                            <td>휴대폰</td>
                            <td>50,000원</td>
                            <td>3</td>
                            <td>1</td>
                        </tr>
                    </tbody>
        		</table>
        	</div>
        </section>
        <section>
            <div class="container">
                <div class="main_title">
                    <a href="#" class="genric-btn danger-border circle arrow">뒤로가기<span class="lnr lnr-arrow-right"></span></a>
                </div>
            </div>
        </section>
</asp:Content>

