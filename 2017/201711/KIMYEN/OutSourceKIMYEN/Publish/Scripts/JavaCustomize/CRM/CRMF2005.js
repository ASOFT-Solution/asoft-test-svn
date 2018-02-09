//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     21/12/2015     Quang Hoàng       Tạo mới
//####################################################################


$(document).ready(function () {
    //$("#RouteID").attr("data-val-required", "The field is required.");
    //$("[for|='Address']").css("background", "#000000");
    //$("[for|='Address']").css("color", "#fff");
    //$("#IsCommon").attr("checked", "checked");
    var htmlIsInvoice = $(".IsInvoice").html();
    $(".IsInvoice").remove();

    $(".IsCommon").before(htmlIsInvoice);

    GetAccountID();
    //if (typeof parent.getdataScreenCall === "function") {
    //    var data = parent.getdataScreenCall();
    //    if (data.ContactNameSC !== undefined && data.ContactNameSC != "") {
    //        $("#IsOrganize").attr("checked", "checked");
    //    }
    //    $("#Tel").val(data.Tel);
    //}
    //var urlRouteID = "/Partial/RouteID/CRM/CRMF2005";
    //ASOFT.partialView.Load(urlRouteID, ".IsVATAccountID", 1);
    //if (typeof parent.IsTemp === "function") {
    //    if (parent.IsTemp() == "True") {
    //        var urlContactID = "/Partial/ContactID/CRM/CRMF2005";
    //        ASOFT.partialView.Load(urlContactID, ".IsOrganize", 0);
    //    }
    //    else {
    //        XuLyIsTempFalse();
    //    }
    //}
    //else {
    //    XuLyIsTempFalse();
    //}

    //var urlVATAccountID = "/Partial/VATAccountID/CRM/CRMF2005";

    //ASOFT.partialView.Load(urlVATAccountID, ".line_left .asf-table-view", 2);
    //$("#IsVATAccountID").click(function () {
    //    if ($(this).is(':checked')) {
    //        $("#VATAccountID").attr("Disabled", false);
    //        $("#btnChooseVATAccount").data("kendoButton").enable(true);
    //        $("#btnDeleteVATAccount").data("kendoButton").enable(true);
    //    }
    //    else {
    //        $("#VATAccountID").attr("Disabled", true);
    //        $("#btnChooseVATAccount").data("kendoButton").enable(false);
    //        $("#btnDeleteVATAccount").data("kendoButton").enable(false);
    //    }
    //})

    //$("#IsOrganize").click(function () {
    //    if ($(this).is(':checked')) {
    //        $("#ContactID").attr("Disabled", false);
    //        $("#btnAddContact").data("kendoButton").enable(true);
    //        $("#btnDeleteContact").data("kendoButton").enable(true);
    //        $("#btnChooseContact").data("kendoButton").enable(true);
    //        $("#ContactID").attr("data-val-required", "The field is required.");
    //    }
    //    else {
    //        $("#ContactID").attr("Disabled", true);
    //        $("#btnAddContact").data("kendoButton").enable(false);
    //        $("#btnDeleteContact").data("kendoButton").enable(false);
    //        $("#btnChooseContact").data("kendoButton").enable(false);
    //    }
    //})

    $("#Disabled").val("0");
    $("#IsUsing").val("0");
    $("#IsCustomer").val("1");

    $("#AccountName").attr("readonly", false)
    //$("#Address").attr("readonly", false)
    //$("#Tel").attr("readonly", false)
    //$("#Email").attr("readonly", false)

    $("#ReCreditLimit").keyup(function (e) {
        var value = $(this).val();
        value = formatDecimal(kendo.parseFloat(value));
        $(this).val(value);
    });


    $("#BottleLimit").keyup(function (e) {
        var value = $(this).val();
        value = formatDecimal(kendo.parseFloat(value));
        $(this).val(value);
    });
})

function formatDecimal(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
    return kendo.toString(value, format);
}

function XuLyIsTempFalse() {
    $("#SaveNew").addClass("control-hide");
    $("#SaveCopy").addClass("control-hide");
    ASOFT.partialView.Load("/CRM/CRMF2007/GetButtonSave?IsVATAccountID", "#SaveCopy", 1);
};

//function CRMFSave_Click() {
//    if (ASOFT.form.checkRequired(id)) {
//        return;
//    }
//    action = 5;
//    save1(url);
//};

function btnAddContact_Click() {
    action = 0;
    parent.UpdateIsTemp("False");
    urlojb = "/PopupLayout/Index/CRM/CRMF2007";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlojb, {});
}

function btnChooseContact_Click() {
    urlChooseAccount = "/PopupSelectData/Index/CRM/CRMF9002?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseAccount, {});
    action = 1;
}

function btnDeleteContact_Click() {
    $("#ContactID").val("");
    $("#ContactName").val("");
}

function btnChooseRoute_Click() {
    urlChooseRoute = "/PopupSelectData/Index/CRM/CMNF9002?DivisionID=" + $("#DivisionID").val()
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseRoute, {});
    action = 2;
}

function btnDeleteRoute_Click() {
    $("#RouteID").val("");
    $("#RouteName").val("");
}

function btnChooseVATAccount_Click() {
    urlChooseVATAccount = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val()
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseVATAccount, {});
    action = 3;
}

function btnDeleteVATAccount_Click() {
    $("#VATAccounID").val("");
    $("#VATAccountName").val("");
}

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
};


function getdataScreenCall() {
    if (typeof parent.getdataScreenCall === "function") {
        var data2 = parent.getdataScreenCall();
        return data2;
    }
};


function receiveResult(result) {
    if (action == 1 || action == 0) {
        $("#ContactID").val(result["ContactID"]);
        $("#ContactName").val(result["ContactName"]);
    }
    if (action == 2) {
        $("#RouteID").removeAttr("disabled");
        $("#RouteID").val(result["RouteID"]);
        $("#RouteName").val(result["RouteName"]);
    }
    if (action == 3) {
        $("#VATAccountID").removeAttr("disabled");
        $("#VATAccountID").val(result["AccountID"]);
        $("#VATAccountName").val(result["AccountID"]);
    }
}

function onAfterInsertSuccess(result, action1) {
    if (result.Status == 0 && action1 == 1) {
        GetAccountID();
        $("#Disabled").val("0");
        $("#IsUsing").val("0");
        $("#IsCustomer").val("1");
        $("#IsCommon").attr("checked", false);
        $("#ContactName").val("");
        $("#IsOrganize").attr("checked", false);
        $("#ContactID").attr("Disabled", true);
        $("#RouteID").attr("Disabled", true);
        $("#IsVATAccountID").attr("checked", false);
        $("#IsInvoice").attr("checked", false);
        $("#RouteName").val("");
        $("#VATAccountName").val("");
        $("#VATAccountID").attr("Disabled", true);
        $("#btnAddContact").data("kendoButton").enable(false);
        $("#btnDeleteContact").data("kendoButton").enable(false);
        $("#btnChooseContact").data("kendoButton").enable(false);
        $("#O01ID").data("kendoComboBox").value('');
    }

    if (result.Status == 0 && action1 == 2) {
        GetAccountID();
    }

    if (result.Message == "00ML000053") {
        GetAccountID();
    }

    if (result.Status == 0 && action1 == 5) {
        if (typeof parent.receiveResult !== 'undefined' && $.isFunction(parent.receiveResult)) {
            var data = {
                AccountID: $("#AccountID").val(),
                AccountName: $("#AccountName").val(),
            }
            parent.receiveResult(data);
        }
        parent.popupClose();
    }
}

function clearfieldsCustomer() {
    var data = ASOFT.helper.dataFormToJSON(id);
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key.indexOf(noClear) == -1 && key != "AccountID" && key != "S1" && key != "S2" && key != "S3") {
                if ($("#" + key).data("kendoComboBox") != null) {
                    $("#" + key).data("kendoComboBox").value("");
                }
                if ($("#" + key).data("kendoDropDownList") != null) {
                    $("#" + key).data("kendoDropDownList").value("");
                    $("#" + key).data("kendoDropDownList").text("");
                }
                if ($("#" + key).data('kendoNumericTextBox') != null) {
                    $("#" + key).data('kendoNumericTextBox').value('');
                }
                $("#" + key).val('');
            }
        }
    })
}


function GetAccountID() {
    var S = [];
    S.push($("#S1").val());
    S.push($("#S2").val());
    S.push($("#S3").val());
    ASOFT.helper.postTypeJson('/CRM/CRMF1011/GetAccountID', S, function (result) {
        $("#AccountID").val(result.AccountID);
    });
}

