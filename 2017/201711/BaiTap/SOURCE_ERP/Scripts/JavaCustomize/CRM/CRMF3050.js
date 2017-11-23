
$(document).ready(function () {
    var buttonSearchObjec = '<span class="asf-button-special"><a id="btnSearchEmployeeID" class="btnOpenSearch k-button k-button-icontext asf-button asf-icon-24 asf-i-search-24" style="min-width: 28px; min-height: 28px" data-role="button" role="button" aria-disabled="false" onclick="btnChooseEmployee_Click()" tabindex="0">&nbsp;</a></span>';
    var buttonDeleteObjec = '<a id="btnDeleteEmployee" style="width : 26px; height: 26px; background-image: url(/Content/Images/icon-delete-24x24.png); background-repeat: no-repeat" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteEmployee_Click()"><span class="asf-button-text"></span></a>';

    $($(".EmployeeID").find('td')[1]).append(buttonSearchObjec);
    $($(".EmployeeID").find('td')[1]).append(buttonDeleteObjec);

    $(".EmployeeID").find('input').css("width", "84%");
    $("#EmployeeID").attr("readonly", "readonly");
    
    $("#CheckListPeriodControl").attr("data-val-required", "The field is required.");
    $("#FromDatePeriodControl").attr("data-val-required", "The field is required.");
    $("#ToDatePeriodControl").attr("data-val-required", "The field is required.");
    $("#EmployeeID_Type_Fields").val("4");
})

function CustomerCheck() {
    return ASOFT.form.checkRequired("FormReportFilter");
}

function btnChooseEmployee_Click() {
    var urlChooseEmployee = "/PopupSelectData/Index/00/CMNF9003?type=1&DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseEmployee, {});
}

function btnDeleteEmployee_Click() {
    $("#EmployeeID").val("");
}

function receiveResult(result) {
    var employ = "";
    for (var i = 0; i < result.length - 1; i++) {
        employ = employ + result[i]["EmployeeID"] + ",";
    }
    employ = employ + result[result.length - 1]["EmployeeID"]

    $("#EmployeeID").val(employ);
}