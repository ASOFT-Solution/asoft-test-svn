
var currentChoose = null;
var isAdd = false;

$(document).ready(function () {
    noClear = "CampaignID";
    createGroup();
    LoadPartialView();
    showNameSaveID();
    if ($("#isUpdate").val() == "False")
    {
        $("#ExpectOpenDate").data("kendoDatePicker").value(new Date());
        $("#ExpectCloseDate").data("kendoDatePicker").value(new Date());
        GetKeyAutomatic("CRMT20401", "CampaignID");

        var ldata = { EmployeeID: ASOFTEnvironment.UserID, EmployeeName: ASOFTEnvironment.UserName };
        $("#AssignedToUserID").data('kendoMultiSelect').setDataSource([ldata]);
        $("#AssignedToUserID").data('kendoMultiSelect').value([ASOFTEnvironment.UserID]);
    }

    var urlPopup = window.location.href;
    var para = urlPopup.split('?')[1];
    if (para == "isAdd=1" && $("#isUpdate").val() == "True")
    {
        GetKeyAutomatic("CRMT20401", "CampaignID");
        $("#ExpectOpenDate").data("kendoDatePicker").value(new Date());
        $("#ExpectCloseDate").data("kendoDatePicker").value(new Date());
        $("#CampaignID").removeAttr("readonly");
        $("#Save").unbind();
        $("#Save").kendoButton({
            "click": SaveCustom_Click,
        });

        $("#Close").unbind();
        $("#Close").kendoButton({
            "click": popupClose_Click,
        });
        isAdd = true;
        var ldata = { EmployeeID: ASOFTEnvironment.UserID, EmployeeName: ASOFTEnvironment.UserName };
        $("#AssignedToUserID").data('kendoMultiSelect').setDataSource([ldata]);
        $("#AssignedToUserID").data('kendoMultiSelect').value([ASOFTEnvironment.UserID]);
    }
});

function SaveCustom_Click() {
    $("#isUpdate").val("False");
    var url = "/GridCommon/Insert/CRM/CRMF2041";
    action = 2;
    save(url);
}


function showNameSaveID() {
    //$("#AssignedToUserName").attr({"disabled":"disabled"}).addClass("disabled-cursor").on("focus", function () { $(this).blur() });
    $("#InventoryName").attr({ "disabled": "disabled" }).on("focus", function () { $(this).blur(); });
}
function createGroup() {
    $("#RelatedToTypeID").val(6);
    var form = $("#CRMF2041");
    var container_12 = form.find(".container_12");
    var html_container_12 = container_12[0].outerHTML;
    var html_group = ["<fieldset id='Group_InfoDetails'>", "<legend><label>" + $($(".ThongTinChiTiet td")[0]).text() + "</label></legend></fieldset>"].join("");
    var html_group2 = ["<fieldset id='Group_Number2'>", "<div class='container_12'><div class='asf-filter-main'><div class='grid_6'><table class='asf-table-view'><tbody></tbody></table></div><div class='grid_6 line_left'><table class='asf-table-view'><tbody></tbody></table></div></div></div>", "<legend><label>" + $($(".KyVongThucTe td")[0]).text() + "</label></legend></fieldset>"].join("");
    form.prepend(html_group+html_group2);
    var group_infodetails = $("#Group_InfoDetails");
    var group_number2 = $("#Group_Number2");
    container_12.prependTo(group_infodetails);

    moveElemnt(form, group_infodetails.find("tbody").eq(0), ["CampaignID", "CampaignName", "CampaignType", "AssignedToUserID", "Description", "IsCommon"]);
    moveElemnt(form, group_infodetails.find("tbody").eq(1), ["ExpectOpenDate", "ExpectCloseDate", "CampaignStatus", "InventoryName", "Sponsor", "Disabled"]);
    moveElemnt(form, group_number2.find("tbody").eq(0), ["BudgetCost", "ExpectedRevenue", "ExpectedSales", "ExpectedROI"]);
    moveElemnt(form, group_number2.find("tbody").eq(1), ["ActualCost", "ExpectedResponse", "ActualRevenue", "ActualSales", "ActualROI"]);

    $(".ThongTinChiTiet").remove();
    $(".KyVongThucTe").remove();
}

function moveElemnt(jqeryForm, jqueryElement, listElementClassName) {
    var i, l = listElementClassName.length;
    if (typeof jqueryElement !== "undefined" && l > 0 && jqeryForm !=="undefined") {
        for (i = 0; i < l; i++) {
            jqeryForm.find("." + listElementClassName[i]).appendTo(jqueryElement);
        }
    }
}


function LoadPartialView() {
    //Load Partial ChooseAssignedToUserID
    //ASOFT.partialView.Load("/CRM/CRMF2041/PartialChooseAssignedToUserID", "#AssignedToUserName", 0);
    //ASOFT.partialView.Load("/CRM/CRMF2041/PartialInventoryID", "#InventoryName", 0);
    var btnFromEmployee = '<a id="btSearchFromEmployee" style="bottom: 68px; z-index:100001; position: absolute; right: 25px; height: 27px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchEmployee_Click()">...</a>';

    var btnDelete = '<a id="btDeleteFrom" style="bottom: 68px; z-index:10001; position: absolute; right: 0px; height: 27px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFrom_Click()"></a>';

    var btnFromInventoryID = '<a id="btSearchFromInventoryID" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchInventoryID_Click()">...</a>';

    var btnDeleteInventoryID = '<a id="btnDeleteInventoryID" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFromInventoryID_Click()"></a>';

    $("#AssignedToUserID").parent().parent().after(btnFromEmployee);
    $("#AssignedToUserID").parent().parent().after(btnDelete);
    $(".k-multiselect").css("width", "84%");
    $("#InventoryName").after(btnFromInventoryID);
    $("#InventoryName").after(btnDeleteInventoryID);
}

function receiveResult(result) {
    if (currentChoose == 1) {
        var ldata = [];
        var sdate = [];
        for (var i = 0; i < result.length; i++)
        {
            var data = {};
            data.EmployeeID = result[i]["EmployeeID"];
            data.EmployeeName = result[i]["EmployeeName"];
            sdate.push(result[i]["EmployeeID"]);
            ldata.push(data);
        }
        $("#AssignedToUserID").data("kendoMultiSelect").setDataSource(ldata);
        $("#AssignedToUserID").data("kendoMultiSelect").value(sdate);
    }
    if (currentChoose == 2) {
        $("#InventoryID").val(result["InventoryID"]);
        $("#InventoryName").val(result["InventoryName"]);
    }
};

//Xử lý sự kiện cho các button

function btnSearchEmployee_Click() {
    var divisionID = $("#EnvironmentDivisionID").val();
    var urlpopup = ["/PopupSelectData/Index/00/CMNF9003", "?", "DivisionID=", divisionID, "&Type=1"].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = 1;
}

function btnDeleteFrom_Click() {
    $("#AssignedToUserID").data("kendoMultiSelect").setDataSource([]);
    $("#AssignedToUserID").data("kendoMultiSelect").value('');
}

function btnSearchInventoryID_Click() {
    var divisionID = $("#EnvironmentDivisionID").val();
    var urlpopup = ["/PopupSelectData/Index/00/CMNF9001", "?", "DivisionID=", divisionID].join("");
    ASOFT.asoftPopup.showIframe(urlpopup, {});
    currentChoose = 2;
}

function btnDeleteFromInventoryID_Click() {
    $("#InventoryID").val("");
    $("#InventoryName").val("");
}

function onAfterInsertSuccess(result, action) {
    $("#RelatedToTypeID").val(6);
    if (action == 1) {
        $("#AssignedToUserID").val("");
        $("#AssignedToUserName").val("");
        $("#InventoryID").val("");
        $("#InventoryName").val("");
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
        $("#RelatedToTypeID").val(6)
        $("#InventoryName").val('');

        var ldata = { EmployeeID: ASOFTEnvironment.UserID, EmployeeName: ASOFTEnvironment.UserName };
        $("#AssignedToUserID").data('kendoMultiSelect').setDataSource([ldata]);
        $("#AssignedToUserID").data('kendoMultiSelect').value([ASOFTEnvironment.UserID]);

        $("#ExpectOpenDate").data("kendoDatePicker").value(new Date());
        $("#ExpectCloseDate").data("kendoDatePicker").value(new Date());
        UpdateKeyAutomatic("CRMT20401", $("#CampaignID").val());
        GetKeyAutomatic("CRMT20401", "CampaignID");
    }
    if (result.Message == "00ML000053") {
        UpdateKeyAutomatic("CRMT20401", $("#CampaignID").val());
        GetKeyAutomatic("CRMT20401", "CampaignID");
    }
    if (action == 2 && result.Status == 0) {
         $("#RelatedToTypeID").val(6)
        UpdateKeyAutomatic("CRMT20401", $("#CampaignID").val());
        if (isAdd) {
            if (typeof parent.QuickAddCommon === "function") {
                parent.QuickAddCommon($("#CampaignID").val());
            }
            parent.popupClose();
        }
        GetKeyAutomatic("CRMT20401", "CampaignID");
    }
}

