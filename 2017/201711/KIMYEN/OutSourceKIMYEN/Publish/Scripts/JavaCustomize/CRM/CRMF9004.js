var action = 1;
var divisionID = null;
var RelatedToID_OLD = null;
var RelatedToTypeID_REL_OLD = null;
var chooseDF = null;


$(document).ready(function () {
    divisionID = $("#DivisionID").val();
    var btnFrom = '<a id="btSearchFrom" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button {0} asf-button" role="button" aria-disabled="false" tabindex="0" {1}>...</a>';
    var btnFromEmployee = '<a id="btSearchFromEmployee" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchEmployee_Click()">...</a>';

    var btnDelete = '<a id="btDeleteFrom" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFrom_Click(1)"></a>';

    var btnDelete1 = '<a id="btDeleteFrom1" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button {0}  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" {1}></a>';

    var onclick = $("#RelatedToTypeID_REL").val() == "" ? "" : "onclick='btnSearchFrom_Click()'";
    var classE = $("#RelatedToTypeID_REL").val() == "" ? "k-state-disabled" : "k-button-icontext";
    var onclick1 = $("#RelatedToTypeID_REL").val() == "" ? "" : "onclick='btnDeleteFrom_Click()'";

    var btnFrom1 = kendo.format(btnFrom, classE, onclick);
    var btnDelete2 = kendo.format(btnDelete1, classE, onclick1);

    if ($("#isUpdate").val() == "True") {
        if ($("#RelatedToName").attr('type') == 'hidden') {
            $("#Save").data("kendoButton").enable(false);
            $("#Close").unbind();
            $("#Close").kendoButton({
                "click": CustomClose_Click,
            });
        }
    }

    if ($("#RelatedToName").attr('type') != 'hidden') {
        $("#RelatedToName").after(btnFrom1);
        $("#RelatedToName").after(btnDelete2);
        $(".RelatedToName .asf-td-caption").text($("#RelatedToTypeID_REL").data("kendoComboBox").text());
        var listDelete = [];
        for (var i = 0; i < $("#RelatedToTypeID_REL").data("kendoComboBox").dataSource.data().length; i++) {
            var itemToRemove = $("#RelatedToTypeID_REL").data("kendoComboBox").dataSource.at(i);
            if (itemToRemove.ID == "7") {
                listDelete.push(itemToRemove);
            }
        }

        for (var i = 0; i < listDelete.length; i++) {
            $("#RelatedToTypeID_REL").data("kendoComboBox").dataSource.remove(listDelete[i]);
        }
    }

    $("#AssignedToUserID").after(btnFromEmployee);
    $("#AssignedToUserID").after(btnDelete);
    $("#AssignedToUserID").attr('readonly', 'readonly');
    $("#RelatedToName").attr('disabled', 'disabled');
    //$("#RelatedToID").css("width", "95%");
    $(".line_left .asf-table-view tbody").prepend($(".StartDate"));

    $("#RelatedToTypeID_REL").change(function () {
        $("#btSearchFrom").remove();
        $("#btDeleteFrom1").remove();
        $(".RelatedToName .asf-td-caption").text($("#RelatedToTypeID_REL").data("kendoComboBox").text());
        onclick = $("#RelatedToTypeID_REL").val() == "" ? "" : "onclick='btnSearchFrom_Click()'";
        classE = $("#RelatedToTypeID_REL").val() == "" ? "k-state-disabled" : "k-button-icontext";
        onclick1 = $("#RelatedToTypeID_REL").val() == "" ? "" : "onclick='btnDeleteFrom_Click()'";
        btnFrom1 = kendo.format(btnFrom, classE, onclick);
        btnDelete2 = kendo.format(btnDelete1, classE, onclick1);
        $("#RelatedToName").after(btnFrom1);
        $("#RelatedToName").after(btnDelete2);

        $("#RelatedToName").val('');
        $("#RelatedToID").val('');
    });

    RelatedToID_OLD = $("#RelatedToID").val();
    RelatedToTypeID_REL_OLD = $("#RelatedToTypeID_REL").val();
    $("#RelatedToID_OLD").val($("#RelatedToID").val());
    $("#RelatedToTypeID_REL_OLD").val($("#RelatedToTypeID_REL").val());
})

function CustomClose_Click()
{
    parent.popupClose();
}

function btnSearchFrom_Click() {
    chooseDF = getScreenChoose($("#RelatedToTypeID_REL").val());
    var urlChoose = "/PopupSelectData/Index/" + chooseDF.Module + "/" + chooseDF.Screen + "?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    action = 1;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function btnSearchEmployee_Click() {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    action = 2;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function btnDeleteFrom_Click(ac) {
    if (ac == 1) {
        $("#AssignedToUserID").val('');
    }
    else {
        $("#RelatedToID").val('');
        $("#RelatedToName").val('');
    }
}

function receiveResult(result) {
    if (action == 1) {
        $("#RelatedToID").val(result["APK"]);
        $("#RelatedToName").val(result[chooseDF.Name]);
    }
    if (action == 2) {
        $("#AssignedToUserID").val(result["EmployeeID"]);
    }
}

function onAfterInsertSuccess(result, action1) {
    if (result.Status == 0 && action1 == 1) {
        $(".stPriorityID1").trigger('click');
        $("#DivisionID").val(divisionID);
        $("#RelatedToID").val(RelatedToID_OLD);
        $("#RelatedToTypeID_REL").val(RelatedToTypeID_REL_OLD);
        $("#AssignedToUserID").val('');
        $("#RelatedToName").val('');
        $("#StartDate").data("kendoDateTimePicker").value(new Date());
        $("#EndDate").data("kendoDateTimePicker").value(new Date());

        $("#RelatedToTypeID_REL").trigger("change");
    }
    if (typeof parent.readCalendar === "function") {
        parent.readCalendar();
    }
}

function getScreenChoose(Type) {
    var choose = {};
    choose.Module = 'CRM';
    switch(Type) {
        case "1":
            choose.Screen = 'CRMF9014';
            choose.Name = 'LeadName';
            break;
        case "2":
            choose.Screen = 'CRMF9002';
            choose.Name = 'ContactName';
            break;
        case "3":
            choose.Screen = 'CRMF9001';
            choose.Name = 'AccountName';
            break;
        case "4":
            choose.Screen = 'CRMF9013';
            choose.Name = 'OpportunityName';
            break;
        case "5":
            choose.Screen = 'SOF2024';
            choose.Name = 'QuotationNo';
            choose.Module = 'SO';
            break;
        case "6":
            choose.Screen = 'CRMF9008';
            choose.Name = 'CampaignName';
            break;
    }
    return choose;
}
