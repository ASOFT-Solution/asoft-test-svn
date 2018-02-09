
var GridPOST2021 = null;
var VoucherNow = null;
var actionChoose = null;

$(document).ready(function () {
    GridPOST2021 = $("#GridEditPOST2021").data("kendoGrid");
    $("#GridEditPOST2021").attr("AddNewRowDisabled", "false");
    $(".MemberName .asf-td-caption").append('<span class="asf-label-required">*</span>');

    if ($("#isUpdate").val() == "False")
    {
        addButtonChooseKT();
        $("input[name='SuggestType'][value='0']").trigger("click");
        $("#IsConfirm").data("kendoComboBox").value(0);
        $(".IsConfirm").hide();
        GetvoucherNo();
        GetDataAddNew();
    }
    else {
        ASOFT.helper.postTypeJson("/POS/POSF2020/CheckConfirmUser", { APK : $("#APK").val() }, function (result) {
            if (result) {
                $(".IsConfirm").show();
            }
            else {
                $(".IsConfirm").hide();
            }
        });

        CheckConfirm();
    }
    $("input[name='SuggestType']").attr("onclick", "return false;");

    $("#btnMemberName").kendoButton({
        "click": getDialogMember
    });

    $("#btnConfirmUserName").kendoButton({
        "click": getDialogConfirmUserName
    });

    $("#btnDeleteConfirmUserName").kendoButton({
        "click": deleteConfirmUserName
    });

    $("#btnDeleteMemberName").kendoButton({
        "click": deleteMemberName
    });
})

function getReceipts() {
    actionChoose = 3;
    var UrlDialog = "/PopupSelectData/Index/POS/POSF2023?type=1";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(UrlDialog, {});
}

function getDialogMember() {
    actionChoose = 1;
    var UrlDialog = "/PopupSelectData/Index/POS/POSF00761?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(UrlDialog, {});
}

function getDialogConfirmUserName() {
    actionChoose = 2;
    var UrlDialog = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(UrlDialog, {});
}

function deleteConfirmUserName() {
    $("#ConfirmUserName").val('');
    $("#ConfirmUserID").val('');
}

function deleteMemberName() {
    $("#MemberName").val('');
    $("#MemberID").val('');
}

function receiveResult(result) {
    if (actionChoose == 1)
    {
        $("#MemberName").val(result.MemberName);
        $("#MemberID").val(result.MemberID);
    }
    if (actionChoose == 2) {
        $("#ConfirmUserName").val(result.EmployeeName);
        $("#ConfirmUserID").val(result.EmployeeID);
    }
    if (actionChoose == 3) {
        $("#MemberName").val(result[0].MemberName);
        $("#MemberID").val(result[0].MemberID);
        var dataPOST00801 = [];
        for (var k = 0; k < result.length; k++) {
            var itemKT = result[k];
            var itemDT = {};
            //itemDT.DivisionID = itemKT.DivisionID;
            itemDT.InVoucherTypeID = itemKT.VoucherTypeID;
            itemDT.InVoucherDate = itemKT.VoucherDate;
            itemDT.InVoucherNo = itemKT.VoucherNo;
            itemDT.InMemberName = itemKT.MemberName;
            itemDT.InMemberID = itemKT.MemberID;
            itemDT.Address = itemKT.Address;
            itemDT.Tel = itemKT.Tel;
            itemDT.Amount = itemKT.SumAmount;
            itemDT.ShopID = itemKT.ShopID;
            itemDT.APK = "";
            itemDT.APKMInherited = itemKT.APK;
            dataPOST00801.push(itemDT);
        }

        GridPOST2021.dataSource.data([]);
        GridPOST2021.dataSource.data(dataPOST00801);
    }
}

function CheckConfirm() {
    var data = {};
    data.APK = $("#APK").val();

    ASOFT.helper.postTypeJson("/POS/POSF2020/CheckConfirm", data, function (result) {
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
    var btnKT = '<a class="k-button-icontext asf-button k-button" id="btnKT" style="z-index:10001; position: absolute; right: 28px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0" onclick="getReceipts()"><span class="asf-button-text">...</span></a>';
    $("input[name='SuggestType'][value='0']").after(btnKT);
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

    $("#IsConfirm").data("kendoComboBox").enable(false);
    GridPOST2021.hideColumn("APK");
    $("#btnMemberName").data("kendoButton").enable(false);
    $("#btnDeleteMemberName").data("kendoButton").enable(false);
    $("#btnDeleteConfirmUserName").data("kendoButton").enable(false);
    $("#btnConfirmUserName").data("kendoButton").enable(false);

}


function GetvoucherNo(isUD) {
    var data = {};

    if (isUD)
    {
        data.VoucherNo = VoucherNow;
    }

    ASOFT.helper.postTypeJson("/POS/POSF2020/GetVoucherNo", data, function (result) {
        $("#VoucherNo").val(result.VoucherNo);
        VoucherNow = result.VoucherNo;
    });
}

function GetDataAddNew() {
    ASOFT.helper.postTypeJson("/POS/POSF2020/GetDataAddNew", {}, function (result) {
        $("#VoucherTypeID").val(result.VoucherTypeID);
        $("#ShopID").val(result.ShopID);
        $("#ObjectID").val(result.ShopID);
        $("#DivisionID").val($("#EnvironmentDivisionID").val());
        $("#RelatedToTypeID").val(49);
        $("#VoucherDate").data("kendoDatePicker").value(new Date);
    });
}

function onAfterInsertSuccess(result, action1) {
    if (result.Status == 0 && action1 == 1) {
        $("#MemberName").val('');
        $("#ConfirmUserName").val('');
        GetvoucherNo(true);
        GetDataAddNew();
    }

    if (result.Status == 0 && action1 == 2)
    {
        GetvoucherNo(true);
        GetDataAddNew();
    }

    if (result.Message == "00ML000053") {
        GetvoucherNo(true);
    }
}

function getMemberID() {
    return $("#MemberID").val();
}

function CustomerCheck() {
    var lData = GridPOST2021.dataSource.data();
    var lError = [];
    for (var i = 0; i < lData.length; i++)
    {
        if (lData[i].InMemberID != $("#MemberID").val())
        {
            lError.push(i);
        }
    }

    if (lError.length > 0)
    {
        var msg = ASOFT.helper.getMessage("POSFML000105");
        ASOFT.form.displayError("#POSF2021", msg);

        var lTh = GridPOST2021.tbody.find("tr");
        for (var i = 0; i < lTh.length; i++) {
            if (lError.indexOf(i) != -1)
            {
                $($(lTh[i]).find("td[columname='InMemberID']")).addClass('asf-focus-input-error');;
            }
        }
        return true;
    }

    return false;
}