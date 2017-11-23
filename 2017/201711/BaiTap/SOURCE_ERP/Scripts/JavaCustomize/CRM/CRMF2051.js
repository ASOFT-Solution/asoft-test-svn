var action = null;
var isAdd = false;

$(document).ready(function () {
    noClear = "OpportunityID";
    var urlPopup = window.location.href;
    var para = urlPopup.split('?')[1];

    if ($("#isUpdate").val() == "False" || $("#RelColumn").length > 0 || para == "isAdd=1") {
        refreshModel();
        $("#RelatedToTypeID").val(4);
        $("#Rate").val(0);
        $("#StageID").data("kendoComboBox").select(0);
        $("#StartDate").data("kendoDatePicker").value(new Date());
        $("#ExpectedCloseDate").data("kendoDatePicker").value(new Date());
        $("#NextActionDate").data("kendoDatePicker").value(new Date());
        if ($("#isUpdate").val() == "True")
        {
            $("#Save").unbind();
            $("#Save").kendoButton({
                "click": SaveCustom_Click,
            });
            $("#Close").unbind();
            $("#Close").kendoButton({
                "click": popupClose_Click,
            });
            $("#isUpdate").val("False")
            $("#OpportunityID").removeAttr('readonly');
            isAdd = true;
        }
        GetKeyAutomatic("CRMT20501", "OpportunityID");
    }
    var btnFromEmployee = '<a id="btSearchFromEmployee" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchEmployee_Click()">...</a>';

    var btnDelete = '<a id="btDeleteFrom" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFrom_Click(1)"></a>';

    var btnFromCampaign = '<a id="btSearchCampaign" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchCampaign_Click()">...</a>';

    var btnDeleteCampaign = '<a id="btDeleteFromCampaign" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteCampaign_Click(1)"></a>';

    var btnFromAccount = '<a id="btSearchAccount" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchAccount_Click()">...</a>';

    var btnDeleteAccount = '<a id="btDeleteFromAccount" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteAccount_Click(1)"></a>';


    $("#AssignedToUserName").after(btnFromEmployee);
    $("#AssignedToUserName").after(btnDelete);
    $("#AssignedToUserName").attr('disabled', 'disabled');

    $("#CampaignName").after(btnFromCampaign);
    $("#CampaignName").after(btnDeleteCampaign);
    $("#CampaignName").attr('disabled', 'disabled');

    $("#AccountName").after(btnFromAccount);
    $("#AccountName").after(btnDeleteAccount);
    $("#AccountName").attr('disabled', 'disabled');

    $($(".AssignedToUserName td")[0]).append('<span class="asf-label-required">*</span>')

    if ($("#ExpectAmount").val() != "") {
        $("#ExpectAmount").val(formatConvert(kendo.parseFloat($("#ExpectAmount").val())));
    }
    $("#Rate").val(formatDecimal(kendo.parseFloat($("#Rate").val())));

    $("#ExpectAmount").keydown(function (e) {
        if (e.keyCode < 48 || (e.keyCode > 57 && e.keyCode < 96) || e.keyCode > 105 && ((e.keyCode != 190 && e.keyCode != 110) || ($(this).val()).indexOf('.') != -1)) {
            if (e.keyCode != 13 && e.keyCode != 37 && e.keyCode != 39 && e.keyCode != 8)
                e.preventDefault()
        }
    });

    $("#Rate").keydown(function (e) {
        if (e.keyCode < 48 || (e.keyCode > 57 && e.keyCode < 96) || e.keyCode > 105) {
            if (e.keyCode != 13 && e.keyCode != 37 && e.keyCode != 39 && e.keyCode != 8 && ((e.keyCode != 190 && e.keyCode != 110) || ($(this).val()).indexOf('.') != -1)) {
                e.preventDefault()
            }
        }
        else {
            if (parseFloat($(this).val() + e.key) > 100) {
                e.preventDefault()
            }
        }
    });

    $("#ExpectAmount").focusout(function (e) {
        var value = $(this).val();
        value = formatConvert(kendo.parseFloat(value));
        $(this).val(value);
    });

    $("#Rate").focusout(function (e) {
        var value = $(this).val();
        value = formatDecimal(kendo.parseFloat(value));
        $(this).val(value);
    });

    $("#StageID").change(function (e) {
        var itemST = $("#StageID").data("kendoComboBox").dataItem($("#StageID").data("kendoComboBox").select());
        $("#Rate").val(formatDecimal(kendo.parseFloat(itemST.Rate)));
    })

    if ($("#IsAddCalendar").is(':checked')) {
        $("#EventSubject").attr("Disabled", false);
        $(".EventSubject").show();
    }
    else {
        $("#EventSubject").attr("Disabled", true);
        $(".EventSubject").hide();
    }

    $("#IsAddCalendar").click(function () {
        if ($(this).is(':checked')) {
            $("#EventSubject").attr("Disabled", false);
            $(".EventSubject").show();
        }
        else {
            $("#EventSubject").attr("Disabled", true);
            $(".EventSubject").hide();
        }
    })

    if ($("#NextActionDate").val() == "") {
        $("#IsAddCalendar").prop("checked", false);
        $("#IsAddCalendar").attr("Disabled", true);
    }

    $("#NextActionDate").focusout(function () {
        if ($(this).val() == "") {
            $("#IsAddCalendar").prop("checked", false);
            $("#IsAddCalendar").attr("Disabled", true);
            $("#EventSubject").attr("Disabled", true);
            $(".EventSubject").hide();
        }
        else {
            $("#IsAddCalendar").attr("Disabled", false);
        }
    })
});

function formatConvert(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString;
    return kendo.toString(value, format);
}

function formatDecimal(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
    return kendo.toString(value, format);
}


function SaveCustom_Click() {
    $("#isUpdate").val("False");
    var url = "/GridCommon/Insert/CRM/CRMF2051";
    action = 2;
    save(url);
}

function btnSearchEmployee_Click() {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    action = 1;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function btnSearchCampaign_Click() {
    var urlChoose = "/PopupSelectData/Index/CRM/CRMF9008?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    action = 2;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function btnSearchAccount_Click() {
    var urlChoose = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    action = 3;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function btnDeleteFrom_Click(ac) {
    $("#AssignedToUserID").val('');
    $("#AssignedToUserName").val('');
}

function btnDeleteCampaign_Click(ac) {
    $("#CampaignName").val('');
    $("#CampaignID").val('');
}

function btnDeleteAccount_Click(ac) {
    $("#AccountName").val('');
    $("#AccountID").val('');
}

function receiveResult(result) {
    if (action == 1) {
        $("#AssignedToUserID").val(result["EmployeeID"]);
        $("#AssignedToUserName").val(result["EmployeeName"]);
    }
    if (action == 2) {
        $("#CampaignName").val(result["CampaignName"]);
        $("#CampaignID").val(result["CampaignID"]);
    }
    if (action == 3) {
        $("#AccountName").val(result["AccountName"]);
        $("#AccountID").val(result["AccountID"]);
    }
}


function onAfterInsertSuccess(result, action) {
    if (action == 3 && result.Status == 0) {
        var url = parent.GetUrlContentMaster();
        var listSp = url.split('&');
        var division = listSp[listSp.length - 1];
        if ($("#IsCommon").is(':checked')) {
            url = url.replace(division, "DivisionID=" + "@@@");
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
        }
        window.parent.parent.location = url;
        parent.setReload();
    }
    if (action == 1 && result.Status == 0) {
        $(".stPriorityID1").trigger('click');
        $("#CampaignName").val('');
        $("#AssignedToUserName").val(ASOFTEnvironment.UserName);
        $("#AssignedToUserID").val(ASOFTEnvironment.UserID);
        $("#AccountName").val('');
        $("#StartDate").data("kendoDatePicker").value(new Date());
        $("#ExpectedCloseDate").data("kendoDatePicker").value(new Date());
        $("#NextActionDate").data("kendoDatePicker").value(new Date());
        $("#StageID").data("kendoComboBox").select(0);
        $("#Rate").val(0);
        $("#RelatedToTypeID").val(4);
        $("#SalesTagID").data('kendoMultiSelect').value([]);
        UpdateKeyAutomatic("CRMT20501", $("#OpportunityID").val());
        GetKeyAutomatic("CRMT20501", "OpportunityID");
    }
    if (result.Message == "00ML000053") {
        $("#RelatedToTypeID").val(4)
        UpdateKeyAutomatic("CRMT20501", $("#OpportunityID").val());
        GetKeyAutomatic("CRMT20501", "OpportunityID");
    }
    if (action == 2 && result.Status == 0) {
        UpdateKeyAutomatic("CRMT20501", $("#OpportunityID").val());
        if (isAdd) {
            if (typeof parent.QuickAddCommon === "function") {
                parent.QuickAddCommon($("#OpportunityID").val());
            }
            parent.popupClose();
        }
        GetKeyAutomatic("CRMT20501", "OpportunityID");
    }
}

