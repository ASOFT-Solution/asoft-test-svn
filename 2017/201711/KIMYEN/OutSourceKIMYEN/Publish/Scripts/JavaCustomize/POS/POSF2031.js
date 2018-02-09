
var GridPOST2031 = null;
var VoucherNow = null;
var actionChoose = null;

$(document).ready(function () {
    GridPOST2031 = $("#GridEditPOST2031").data("kendoGrid");
    $("#GridEditPOST2031").attr("AddNewRowDisabled", "false");
    $(".SuggestUserName .asf-td-caption").append('<span class="asf-label-required">*</span>');
    $("#VATObjectName").removeAttr("disabled");
    $("#VATObjectName").attr("readonly", "readonly");
    $("#BtnInheritDeposit").remove();
    $(".BtnInheritDeposit").hide();

    if ($("#isUpdate").val() == "False") {
        GetvoucherNo();
        GetDataAddNew();
    }
    else {
        $(".IsConfirm").show();
        CheckConfirm();
    }
    $("input[name='SuggestType']").attr("onclick", "return false;");

    $("#btnVATObjectName").kendoButton({
        "click": getDialogMember
    });

    $("#btnSuggestUserName").kendoButton({
        "click": getDialogSuggestUserName
    });

    $("#btnDeleteSuggestUserName").kendoButton({
        "click": deleteSuggestUserName
    });

    $("#btnDeleteVATObjectName").kendoButton({
        "click": deleteMemberName
    });

    var data = ASOFT.helper.dataFormToJSON(id);
    defaultValue = getDataInsert(data);
})

function getReceipts() {
    actionChoose = 3;
    var UrlDialog = "/PopupSelectData/Index/POS/POSF2033?type=1";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(UrlDialog, {});
}

function getDialogMember() {
    actionChoose = 1;
    var UrlDialog = "/PopupSelectData/Index/POS/POSF00761?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(UrlDialog, {});
}

function getDialogSuggestUserName() {
    actionChoose = 2;
    var UrlDialog = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(UrlDialog, {});
}

function deleteSuggestUserName() {
    $("#SuggestUserName").val('');
    $("#SuggestUserID").val('');
}

function deleteMemberName() {
    $("#VATObjectName").val('');
    $("#VATObjectID").val('');
    $("#VATObjectAddress").val('');
    $("#VATNo").val('');
    $("#btnKT").remove();
    $(".BtnInheritDeposit").hide();
}

function getVATObjectID () {
    return $("#VATObjectID").val();
}

function receiveResult(result, dataKT) {
    if (actionChoose == 1) {
        if (result.MemberID != $("#VATObjectID").val()) {
            GridPOST2031.dataSource.data([]);
            GridPOST2031.addRow();
        }
        addButtonChooseKT();
        $("#VATObjectName").val(result.MemberName);
        $("#VATObjectID").val(result.MemberID);
        $("#VATObjectAddress").val(result.Address);
        $("#VATNo").val(result.VATNo);
    }
    if (actionChoose == 2) {
        $("#SuggestUserName").val(result.EmployeeName);
        $("#SuggestUserID").val(result.EmployeeID);
    }
    if (actionChoose == 3) {
        var dataPOST00161 = [];
        for (var k = 0; k < dataKT.length; k++) {
            var itemKT = dataKT[k];
            var itemDT = {};
            //itemDT.DivisionID = itemKT.DivisionID;
            itemDT.InVoucherTypeID = itemKT.VoucherTypeID;
            itemDT.InVoucherDate = itemKT.VoucherDate;
            itemDT.InVoucherNo = itemKT.VoucherNo;
            itemDT.PackageID = itemKT.PackageID;
            itemDT.InventoryID = itemKT.InventoryID;
            itemDT.InventoryName = itemKT.InventoryName;
            itemDT.UnitID = itemKT.UnitID;
            itemDT.Quantity = itemKT.ActualQuantity;
            itemDT.UnitPrice = itemKT.UnitPrice;
            itemDT.OriginalAmount = itemKT.Amount;
            itemDT.ConvertedAmount = itemKT.Amount * itemKT.ExchangeRate;
            itemDT.CurrencyID = itemKT.CurrencyID;
            itemDT.DiscountRate = itemKT.DiscountRate;
            itemDT.ExchangeRate = itemKT.ExchangeRate;
            itemDT.DiscountAmount = itemKT.DiscountAmount;
            itemDT.VATGroupID = itemKT.VATGroupID;
            itemDT.VATPercent = itemKT.VATPercent;
            itemDT.TaxAmount = itemKT.TaxAmount;
            itemDT.SerialNo = itemKT.SerialNo;

            itemDT.APK = "";
            itemDT.APKMInherited = itemKT.APKMaster;
            itemDT.APKDInherited = itemKT.APK;
            dataPOST00161.push(itemDT);
        }

        GridPOST2031.dataSource.data([]);
        GridPOST2031.dataSource.data(dataPOST00161);
    }
}

function CheckConfirm() {
    var data = {};
    data.APK = $("#APK").val();

    ASOFT.helper.postTypeJson("/POS/POSF2030/CheckConfirm", data, function (result) {
        if (result.Status != 0 && result.MessageID != null && result.MessageID != "") {
            var msg = ASOFT.helper.getMessage(result.MessageID);
            ASOFT.form.displayWarning('#' + id, kendo.format(msg, $("#VoucherNo").val()));
            EnableFields();
        }
        else {
            addButtonChooseKT();
        }
    });
}

function addButtonChooseKT() {
    if ($("#btnKT").length == 0) {
        var btnKT = '<a class="k-button-icontext asf-button k-button" id="btnKT" style="left: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0" onclick="getReceipts()"><span class="asf-button-text">...</span></a>';
        $(".BtnInheritDeposit .asf-td-field").append(btnKT);
    }
    $(".BtnInheritDeposit").show();
}

function EnableFields() {
    var data = ASOFT.helper.dataFormToJSON(id);

    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key != "Description") {
                if ($("#" + key).data("kendoComboBox") != null) {
                    $("#" + key).data("kendoComboBox").readonly(true);
                }
                if ($("#" + key).data("kendoDropDownList") != null) {
                    $("#" + key).data("kendoDropDownList").readonly(true);
                }
                if ($("#" + key).data("kendoDatePicker") != null) {
                    $("#" + key).data("kendoDatePicker").readonly(true);
                }
                if ($("#" + key).data("kendoTimePicker") != null) {
                    $("#" + key).data("kendoTimePicker").readonly(true);
                }
                if ($("#" + key).data("kendoDateTimePicker") != null) {
                    $("#" + key).data("kendoDateTimePicker").readonly(true);
                }
                $("#" + key).attr("readonly", "readonly");
            }
        }
    })

    GridPOST2031.hideColumn("APK");
    $("#btnVATObjectName").data("kendoButton").enable(false);
    $("#btnDeleteVATObjectName").data("kendoButton").enable(false);
    $("#btnDeleteSuggestUserName").data("kendoButton").enable(false);
    $("#btnSuggestUserName").data("kendoButton").enable(false);

}


function GetvoucherNo(isUD) {
    var data = {};

    if (isUD) {
        data.VoucherNo = VoucherNow;
    }

    ASOFT.helper.postTypeJson("/POS/POSF2030/GetVoucherNo", data, function (result) {
        $("#VoucherNo").val(result.VoucherNo);
        VoucherNow = result.VoucherNo;
    });
}

function GetDataAddNew() {
    ASOFT.helper.postTypeJson("/POS/POSF2030/GetDataAddNew", {}, function (result) {
        $("#VoucherTypeID").val(result.VoucherTypeID);
        $("#ShopID").val(result.ShopID);
        $("#ObjectID").val(result.ShopID);
        $("#ObjectName").val(result.ShopName);
        $("#DivisionID").val($("#EnvironmentDivisionID").val());
        $("#RelatedToTypeID").val(51);
        $("#VoucherDate").data("kendoDatePicker").value(new Date);
        $("#Status").val(0);
        $("#TableID").val("POST0016");
        $("#SuggestUserName").val(result.UserName);
        $("#SuggestUserID").val(result.UserID);
    });
}

function onAfterInsertSuccess(result, action1) {
    if (result.Status == 0 && action1 == 1) {
        $("#SuggestUserName").val('');
        $("#btnKT").remove();
        $(".BtnInheritDeposit").hide();
        GetvoucherNo(true);
        GetDataAddNew();
    }

    if (result.Status == 0 && action1 == 2) {
        GetvoucherNo(true);
        GetDataAddNew();
    }

    if (result.Message == "00ML000053") {
        GetvoucherNo(true);
    }
}
