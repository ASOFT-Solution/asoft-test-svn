var isAdd = false;

$(document).ready(function () {
    noClear = "LeadID";
    var urlPopup = window.location.href;
    var para = urlPopup.split('?')[1];

    if ($("#isUpdate").val() == "False" || $("#RelColumn").length > 0 || para == "isAdd=1") {
        $("#LeadStatusID").data("kendoComboBox").select(0);
        $("#RelatedToTypeID").val(1);
        if ($("#isUpdate").val() == "True") {
            $("#Save").unbind();
            $("#Save").kendoButton({
                "click": SaveCustom_Click,
            });
            $("#Close").unbind();
            $("#Close").kendoButton({
                "click": popupClose_Click,
            });
            $("#isUpdate").val("False")
            $("#LeadID").removeAttr('readonly');
            isAdd = true;
        }
        GetKeyAutomatic("CRMT20301", "LeadID");
    }

    var btnFromEmployee = '<a id="btSearchFromEmployee" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchEmployee_Click()">...</a>';

    var btnDelete = '<a id="btDeleteFrom" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFrom_Click(1)"></a>';

    $(".Hobbies").after($(".NotesPrivate"));


    $("#AssignedToUserName").after(btnFromEmployee);
    $("#AssignedToUserName").after(btnDelete);
    $("#AssignedToUserName").attr('disabled', 'disabled');

    $($(".AssignedToUserName td")[0]).append('<span class="asf-label-required">*</span>')
});

function SaveCustom_Click() {
    $("#isUpdate").val("False");
    var url = "/GridCommon/Insert/CRM/CRMF2031";
    action = 2;
    save(url);
}

function btnSearchEmployee_Click() {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function btnDeleteFrom_Click(ac) {
    $("#AssignedToUserID").val('');
    $("#AssignedToUserName").val('');
}

function receiveResult(result) {
    $("#AssignedToUserID").val(result["EmployeeID"]);
    $("#AssignedToUserName").val(result["EmployeeName"]);
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
        $("#LeadStatusID").data("kendoComboBox").select(0);
        $("#RelatedToTypeID").val(1)
        UpdateKeyAutomatic("CRMT20301", $("#LeadID").val());
        GetKeyAutomatic("CRMT20301", "LeadID");
        $("#AssignedToUserName").val(ASOFTEnvironment.UserName);
        $("#AssignedToUserID").val(ASOFTEnvironment.UserID);
    }

    if (action == 2 && result.Status == 0)
    {
        $("#RelatedToTypeID").val(1)
        UpdateKeyAutomatic("CRMT20301", $("#LeadID").val());
        if (isAdd) {
            if (typeof parent.QuickAddCommon === "function") {
                parent.QuickAddCommon($("#LeadID").val());
            }
            parent.popupClose();
        }
        GetKeyAutomatic("CRMT20301", "LeadID");
    }

    if (result.Message == "00ML000053") {
        UpdateKeyAutomatic("CRMT20301", $("#LeadID").val());
        GetKeyAutomatic("CRMT20301", "LeadID");
    }
}

