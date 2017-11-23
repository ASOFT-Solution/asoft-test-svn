var action = null;

$(document).ready(function () {
    var btnFromEployeeID = '<a id="btnFromEployeeID" style="z-index:10001; position: absolute; right: 47px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnFromEployeeID_Click(3)">...</a>';

    var btnDeleteFromEployeeID = '<a id="btnDeleteFromEployeeID" style="z-index:10001; position: absolute; right: 19px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFromEployeeID_Click(1)"></a>';

    var btnToEployeeID = '<a id="btnToEployeeID" style="z-index:10001; position: absolute; right: 47px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnFromEployeeID_Click(4)">...</a>';

    var btnDeleteToEployeeID = '<a id="btnDeleteToEployeeID" style="z-index:10001; position: absolute; right: 19px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFromEployeeID_Click(2)"></a>';


    $("#FromSalesManName").attr('disabled', 'disabled');
    $("#ToSalesManName").attr('disabled', 'disabled');
    $("#FromSalesManName").after(btnFromEployeeID);
    $("#FromSalesManName").after(btnDeleteFromEployeeID);
    $("#ToSalesManName").after(btnToEployeeID);
    $("#ToSalesManName").after(btnDeleteToEployeeID);

    $("#CheckListPeriodControl").attr("data-val-required", "The field is required.");
    $("#FromDatePeriodControl").attr("data-val-required", "The field is required.");
    $("#ToDatePeriodControl").attr("data-val-required", "The field is required.");

})

function CustomerCheck() {
    return ASOFT.form.checkRequired("FormReportFilter");
}


function btnFromEployeeID_Click(type) {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    action = type;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}



function btnDeleteFromEployeeID_Click(type) {
    if (type == 1) {
        $("#FromSalesManName").val('');
        $("#FromSalesManID").val('');
    }

    if (type == 2) {
        $("#ToSalesManName").val('');
        $("#ToSalesManID").val('');
    }
}

function receiveResult(result) {
    if (action == 3) {
        $("#FromSalesManName").val(result["EmployeeName"]);
        $("#FromSalesManID").val(result["EmployeeID"]);
    }
    if (action == 4) {
        $("#ToSalesManName").val(result["EmployeeName"]);
        $("#ToSalesManID").val(result["EmployeeID"]);
    }
}



