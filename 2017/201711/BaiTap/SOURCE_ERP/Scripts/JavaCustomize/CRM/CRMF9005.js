var action = 1;
var divisionID = null;
var RelatedToID_OLD = null;
var RelatedToTypeID_REL_OLD = null;
var chooseDF = null;
var isAdd = false;
var isType = false;

$(document).ready(function () {
    var urlPopup = window.location.href;
    var para = urlPopup.split('?')[1];
    isType = urlPopup.indexOf('Type=1') != -1;
    var noClear = "TypeID";
    

    $("#RelatedToTypeID_REL").val() == "" ? $(".RelatedToName").hide() : $(".RelatedToName").show();

    divisionID = $("#DivisionID").val();
    var btnFrom = '<a id="btSearchFrom" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button {0} asf-button" role="button" aria-disabled="false" tabindex="0" {1}>...</a>';
    var btnFromEmployee = '<a id="btSearchFromEmployee" style="z-index:10001; position: absolute; bottom: 7px; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchEmployee_Click()">...</a>';

    var btnDelete = '<a id="btDeleteFrom" style="z-index:10001; position: absolute; bottom: 7px; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFrom_Click(1)"></a>';

    var btnDelete1 = '<a id="btDeleteFrom1" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button {0}  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" {1}></a>';

    var onclick = $("#RelatedToTypeID_REL").val() == "" ? "" : "onclick='btnSearchFrom_Click()'";
    var classE = $("#RelatedToTypeID_REL").val() == "" ? "k-state-disabled" : "k-button-icontext";
    var onclick1 = $("#RelatedToTypeID_REL").val() == "" ? "" : "onclick='btnDeleteFrom_Click()'";

    var btnFrom1 = kendo.format(btnFrom, classE, onclick);
    var btnDelete2 = kendo.format(btnDelete1, classE, onclick1);
    getScreenChoose($("#RelatedToTypeID_REL").val());


    if ($("#isUpdate").val() == "True") {
        //if ($("#RelatedToName").attr('type') == 'hidden' && isType) {
        //    $("#Save").data("kendoButton").enable(false);
        //    $("#Close").unbind();
        //    $("#Close").kendoButton({
        //        "click": CustomClose_Click,
        //    });
        //}
        if (para == "isAdd=1" || (!isType && $("#RelatedToName").attr('type') == 'hidden'))
        {
            $("#Save").unbind();
            $("#Save").kendoButton({
                "click": SaveCustom_Click,
            });

            $("#Close").unbind();
            $("#Close").kendoButton({
                "click": popupClose_Click,
            });
            var ldata = { EmployeeID: ASOFTEnvironment.UserID, EmployeeName: ASOFTEnvironment.UserName };
            $("#AssignedListUserID").data('kendoMultiSelect').setDataSource([ldata]);
            $("#AssignedListUserID").data('kendoMultiSelect').value([ASOFTEnvironment.UserID]);
            $("#EventStatus").data('kendoComboBox').select(0);
            isAdd = true;
        }
        $("#EventSubject").removeAttr("readonly");
    }
    else {
        var ldata = { EmployeeID: ASOFTEnvironment.UserID, EmployeeName: ASOFTEnvironment.UserName };
        $("#AssignedListUserID").data('kendoMultiSelect').setDataSource([ldata]);
        $("#AssignedListUserID").data('kendoMultiSelect').value([ASOFTEnvironment.UserID]);
        $("#EventStatus").data('kendoComboBox').select(0);
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

    $("#AssignedListUserID").parent().parent().after(btnFromEmployee);
    $("#AssignedListUserID").parent().parent().after(btnDelete);
    $(".k-multiselect").css("width", "85%");
    $("#RelatedToName").attr('disabled', 'disabled');

    $(".line_left .asf-table-view tbody").prepend($(".EventStartDate"));
    //$("#RelatedToID").css("width", "95%");
    //$(".line_left .asf-table-view tbody").prepend($(".AssignedListUserID"));

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

        $("#RelatedToID").val('');
        $("#RelatedToName").val('');
        $("#RelatedToTypeID_REL").val() == "" ? $(".RelatedToName").hide() : $(".RelatedToName").show();
    });

    RelatedToID_OLD = $("#RelatedToID").val();
    RelatedToTypeID_REL_OLD = $("#RelatedToTypeID_REL").val();
    $("#RelatedToID_OLD").val($("#RelatedToID").val());
    $("#RelatedToTypeID_REL_OLD").val($("#RelatedToTypeID_REL").val());

    if (typeof parent.returnDateTimeAdd === "function")
    {
        var dateTime = parent.returnDateTimeAdd();
        if (dateTime != null)
        {
            $("#EventStartDate").data("kendoDateTimePicker").value(dateTime.start);
            $("#EventEndDate").data("kendoDateTimePicker").value(dateTime.end);
            parent.setDateTimeAdd();
        }
    }

    $("input[type='radio']").change(function () {
        var data = { TypeID : $(this).val()}
        ASOFT.helper.postTypeJson("/CRM/CRMF9005/TypeEvent", data, function () {
            OpenComboDynamic($("#EventStatus").data("kendoComboBox"));
            $("#EventStatus").data("kendoComboBox").value('');
        });
    })
})

function SaveCustom_Click() {
    $("#isUpdate").val("False");
    var url = "/GridCommon/Insert/CRM/CRMF9005";
    action = 2;
    save(url);
}

function CustomClose_Click() {
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
    var urlChoose = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val() + "&type=1";
    ASOFT.form.clearMessageBox();
    action = 2;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function btnDeleteFrom_Click(ac) {
    if (ac == 1) {
        $("#AssignedListUserID").data("kendoMultiSelect").setDataSource([]);
        $("#AssignedListUserID").data("kendoMultiSelect").value('');
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
        var ldata = [];
        var sdate = [];
        for (var i = 0; i < result.length; i++) {
            var data = {};
            data.EmployeeID = result[i]["EmployeeID"];
            data.EmployeeName = result[i]["EmployeeName"];
            sdate.push(result[i]["EmployeeID"]);
            ldata.push(data);
        }
        $("#AssignedListUserID").data("kendoMultiSelect").setDataSource(ldata);
        $("#AssignedListUserID").data("kendoMultiSelect").value(sdate);
    }
}

function onAfterInsertSuccess(result, action1) {
    if (typeof parent.readCalendar === "function") {
        parent.readCalendar();
    }

    if (result.Status == 0 && action1 == 1) {
        $(".stPriorityID1").trigger('click');
        $("#TypeID").val(1);
        $("#DivisionID").val(divisionID);
        $("#RelatedToID").val(RelatedToID_OLD);
        $("#RelatedToTypeID_REL").data('kendoComboBox').value(RelatedToTypeID_REL_OLD);
        $("#AssignedToUserID").val('');
        $("#RelatedToName").val('');
        $("#AssignedListUserID").data("kendoMultiSelect").setDataSource([]);
        $("#AssignedListUserID").data("kendoMultiSelect").value('');
        $("#EventStartDate").data("kendoDateTimePicker").value(new Date());
        $("#EventEndDate").data("kendoDateTimePicker").value(new Date());
        var ldata = { EmployeeID: ASOFTEnvironment.UserID, EmployeeName: ASOFTEnvironment.UserName };
        $("#AssignedListUserID").data('kendoMultiSelect').setDataSource([ldata]);
        $("#AssignedListUserID").data('kendoMultiSelect').value([ASOFTEnvironment.UserID]);
        $("#EventStatus").data('kendoComboBox').select(0);

        $("#RelatedToTypeID_REL").trigger("change");
    }

    if (result.Status == 0 && action1 == 2)
    {
        if (isAdd) {
            if (typeof parent.QuickAddCommon === "function") {
                parent.QuickAddCommon($("#EventSubject").val());
            }
            parent.popupClose();
        }
    }

    if (action == 3 && result.Status == 0) {
        if (!isType) { //Chỉ không reload khi câp nhật ở màn hình calendar
            setReload();
            parent.popupClose();
        }
    }
}

function getScreenChoose(Type) {
    var choose = {};
    choose.Module = 'CRM';
    switch (Type) {
        case "1":
            choose.Screen = 'CRMF9014';
            choose.Name = 'LeadName';
            $("#ObjectID").val("CRMT20301");
            $("#ObjectName").val("LeadName");
            break;
        case "2":
            choose.Screen = 'CRMF9002';
            choose.Name = 'ContactName';
            $("#ObjectID").val("CRMT10001");
            $("#ObjectName").val("ContactName");
            break;
        case "3":
            choose.Screen = 'CRMF9001';
            choose.Name = 'AccountName';
            $("#ObjectID").val("CRMT10101");
            $("#ObjectName").val("AccountName");
            break;
        case "4":
            choose.Screen = 'CRMF9013';
            choose.Name = 'OpportunityName';
            $("#ObjectID").val("CRMT20501");
            $("#ObjectName").val("OpportunityName");
            break;
        case "5":
            choose.Screen = 'SOF2024';
            choose.Name = 'QuotationNo';
            choose.Module = 'SO';
            $("#ObjectID").val("OT2101");
            $("#ObjectName").val("QuotationNo");
            break;
        case "6":
            choose.Screen = 'CRMF9008';
            choose.Name = 'CampaignName';
            $("#ObjectID").val("CRMT20401");
            $("#ObjectName").val("CampaignName");
            break;
    }
    return choose;
}

