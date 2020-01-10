<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/BaseMasterPage.master" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">


<script>



    function fnList() {
        // ========= 핸들러 호출 ===========================
        var reqParam = {};
        var callURL = "<%=HandlerRefer.FAMILYEVENTHANDLER%>";
        var callBack = "fnListCallBack";

        reqParam["strAjaxTicket"] = '<%=AjaxTicket %>';
        reqParam["strMethodName"] = 'GetFamilyEventHoldList';
        reqParam["intUserNo"] = 1;

        BOQ.Ajax.jQuery.fnRequest(REQUESTTYPE.JSON, reqParam, callURL, callBack, false);
    }

    function fnListCallBack(result) {
        console.log(result);
    }


</script>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <input type ="button" onclick="javascript: fnList();" value="aaaaaaaaa" />

</asp:Content>




