var action = null;

$(document).ready(function () {
    var btnFromAccountID = '<a id="btnFromAccountID" style="z-index:10001; position: absolute; right: 47px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnFromAccountID_Click(1)">...</a>';

    var btnDeleteFromAccountID = '<a id="btnDeleteFromAccountID" style="z-index:10001; position: absolute; right: 19px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFromAccountID_Click(1)"></a>';

    var btnToAccountID = '<a id="btnToAccountID" style="z-index:10001; position: absolute; right: 47px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnFromAccountID_Click(2)">...</a>';

    var btnDeleteToAccountID = '<a id="btnDeleteToAccountID" style="z-index:10001; position: absolute; right: 19px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFromAccountID_Click(2)"></a>';


    var btnFromEployeeID = '<a id="btnFromEployeeID" style="z-index:10001; position: absolute; right: 47px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnFromEployeeID_Click(3)">...</a>';

    var btnDeleteFromEployeeID = '<a id="btnDeleteFromEployeeID" style="z-index:10001; position: absolute; right: 19px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFromEployeeID_Click(1)"></a>';

    var btnToEployeeID = '<a id="btnToEployeeID" style="z-index:10001; position: absolute; right: 47px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnFromEployeeID_Click(4)">...</a>';

    var btnDeleteToEployeeID = '<a id="btnDeleteToEployeeID" style="z-index:10001; position: absolute; right: 19px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFromEployeeID_Click(2)"></a>';

    var btnFromInventoryID = '<a id="btnFromInventoryID" style="z-index:10001; position: absolute; right: 47px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnFromInventoryID_Click(5)">...</a>';

    var btnDeleteFromInventoryID = '<a id="btnDeleteFromInventoryID" style="z-index:10001; position: absolute; right: 19px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFromInventoryID_Click(1)"></a>';

    $("#FromAccountName").attr('disabled', 'disabled');
    $("#ToAccountName").attr('disabled', 'disabled');
    $("#FromAccountName").after(btnFromAccountID);
    $("#FromAccountName").after(btnDeleteFromAccountID);
    $("#ToAccountName").after(btnToAccountID);
    $("#ToAccountName").after(btnDeleteToAccountID);

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

function btnFromAccountID_Click(type) {
    var urlChoose = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    action = type;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function btnFromEployeeID_Click(type) {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    action = type;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}



function btnDeleteFromAccountID_Click(type) {
    if (type == 1) {
        $("#FromAccountName").val('');
        $("#FromAccountID").val('');
    }

    if (type == 2) {
        $("#ToAccountName").val('');
        $("#ToAccountID").val('');
    }
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
    if (action == 1) {
        $("#FromAccountName").val(result["AccountName"]);
        $("#FromAccountID").val(result["AccountID"]);
    }
    if (action == 2) {
        $("#ToAccountName").val(result["AccountName"]);
        $("#ToAccountID").val(result["AccountID"]);
    }
    if (action == 3) {
        $("#FromSalesManName").val(result["EmployeeName"]);
        $("#FromSalesManID").val(result["EmployeeID"]);
    }
    if (action == 4) {
        $("#ToSalesManName").val(result["EmployeeName"]);
        $("#ToSalesManID").val(result["EmployeeID"]);
    }
}



