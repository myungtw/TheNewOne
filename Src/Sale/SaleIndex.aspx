<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/Master.master" AutoEventWireup="true" CodeFile="SaleIndex.aspx.cs" Inherits="SaleIndex" %>
<%@ Register TagPrefix="uc" TagName="UserControl" Src="~/Src/UC/UserControl.ascx"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">    
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="pos_content" Runat="Server">    
    <uc:UserControl ID="UserControl" runat="server" ReturnURL="/Src/Sale/SaleItem.aspx"/>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="pos_footer" Runat="Server">
</asp:Content>

