//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     18/12/2015     Quang Hoàng       Tạo mới
//####################################################################

$(document).ready(function () {
    $("[for|='Address']").css("background", "#000000");
    $("[for|='Address']").css("color", "#fff");
    $("#IsCommon").attr("checked", "checked");
    GetContactID();
    var url = "/Partial/AccountID/CRM/CRMF2007";
    if (typeof parent.IsTemp === "function") {
        if (parent.IsTemp() == "True") {
            ASOFT.partialView.Load(url, ".IsAccountID", 0);
        }
        else {
            XuLyIsTempFalse();
        }
    }
    else {
        XuLyIsTempFalse();
    }

    $("#ContactName").attr("data-val-required", "The field is required.");
    $(".ContactName .asf-td-caption").append("<span class='asf-label-required'>*</span>");


    $("#ContactName").attr("readonly", "");
    $("#AccountName").attr("Disabled", true);
    $("#IsAccountID").attr("checked", false);
    $("#AccountName").css("width", "200px");


    if (typeof parent.getdataScreenCall === "function") {
        var data = parent.getdataScreenCall();
        $("#ContactName").val(data.ContactNameSC);
        $("#Address").val(data.Address);
        $("#HomeMobile ").val(data.Tel);
        $("#HomeTel").val(data.Tel);
        $("#Description").val(data.Notes);
        if (data.AccountID !== undefined && data.AccountID != "") {
            $("#IsAccountID").attr("checked", "checked");
        }
    }


    $("#IsAccountID").click(function () {
        if ($(this).is(':checked')) {
            $("#AccountID").attr("Disabled", false);
            $("#btnAddAccount").data("kendoButton").enable(true);
            $("#btnDeleteAccount").data("kendoButton").enable(true);
            $("#btnChooseAccount").data("kendoButton").enable(true);
        }
        else {
            $("#AccountID").attr("Disabled", true);
            $("#btnAddAccount").data("kendoButton").enable(false);
            $("#btnDeleteAccount").data("kendoButton").enable(false);
            $("#btnChooseAccount").data("kendoButton").enable(false);
        }
    })
    var htmlDescription = $(".Description").html();
    $(".line_left").remove();
    $(".grid_6").addClass("form-content");
    $(".grid_6").removeClass();
    $("#popupInnerIframe").bind(".asf-td-caption").css("margin-left", "20px");
    $("#popupInnerIframe").bind(".asf-td-field").css("margin-right", "20px");
    
    //$(".asf-td-field").css("margin-left", "-23px");
    $(".Prefix .k-widget").css("top", "0px");
    $(".Prefix .k-widget").css("left", "0px");
    $(".ContactName").hide();
    $(".FirstName").hide();
    $("#ContactName").val(" ");
    $("#FirstName").val(" ");
    $(".Messenger").remove();
    $(".BusinessEmail").remove();
    $(".BusinessTel").remove();
    $(".BusinessFax").remove();
    $(".Title").remove();
    $(".DepartmentName").remove();
    $(".Description").remove()
    $(".HomeEmail").after(htmlDescription);
    //$("#ContactName").attr("readonly", false)
})
function XuLyIsTempFalse() {
    $("#SaveNew").addClass("control-hide");
    $("#SaveCopy").addClass("control-hide");
    ASOFT.partialView.Load("/CRM/CRMF2007/GetButtonSave?IsVATAccountID", "#SaveCopy", 1);
};

function CRMFSave_Click() {
    if (ASOFT.form.checkRequired(id)) {
        return;
    }
    action = 5;
    save1(url);
};

function btnAddAccount_Click() {
    action = 0;
    parent.UpdateIsTemp("False");
    urlojb = "/PopupLayout/Index/CRM/CRMF2005";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlojb, {});
}

function btnChooseAccount_Click() {
    urlChooseAccount = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseAccount, {});
}

function btnDeleteAccount_Click() {
    $("#AccountID").val("");
    $("#AccountName").val("");
}

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
};

function getdataScreenCall() {
    var data2 = parent.getdataScreenCall();
    return data2;
};

function receiveResult(result) {
    $("#AccountID").removeAttr("disabled");
    $("#AccountID").val(result["AccountID"]);
    $("#AccountName").val(result["AccountName"]);
}

function onAfterInsertSuccess(result, action1) {
    if (result.Status == 0 && action1 == 1) {
        $("#LastName").val(" ");
        $("#FirstName").val(" ");
        $("#AccountName").val("");
        $("#IsAccountID").attr("checked", false);
        $("#IsCommon").attr("checked", false);
        $("#AccountID").attr("Disabled", true);
        $("#btnAddAccount").data("kendoButton").enable(false);
        $("#btnDeleteAccount").data("kendoButton").enable(false);
        $("#btnChooseAccount").data("kendoButton").enable(false);
        GetContactID();
    }
    if (result.Status == 0 && action1 == 2) {
        GetContactID();
    }

    if (result.Message == "00ML000053") {
        GetContactID(true);
    }
    //Danh cho man hinh can receiveresult
    if (result.Status == 0 && action1 == 5)
    {
        if (typeof parent.receiveResult !== 'undefined' && $.isFunction(parent.receiveResult)) {
            var data = {
                ContactID: $("#ContactID").val(),
                ContactName: $("#ContactName").val(),
            }
            parent.receiveResult(data);
        }
        parent.popupClose();
    }
}

function GetContactID(t) {
    var url = '/CRM/CRMF1001/GetContactID';
    if (t) {
        url = '/CRM/CRMF1001/GetContactID?Update=' + $("#ContactID").val()
    }

    ASOFT.helper.postTypeJson(url, {}, function (result) {
        $("#ContactID").val(result.ContactID);
    });
}

