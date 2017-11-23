
$(document).ready(function () {
    var btnFromEmployee = '<a id="btSearchFromEmployee" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchEmployee_Click()">...</a>';

    var btnDelete = '<a id="btDeleteFrom" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFrom_Click(1)"></a>';

    $("#EmployeeName").after(btnFromEmployee);
    $("#EmployeeName").after(btnDelete);
    $("#EmployeeName").attr('disabled', 'disabled');
})


function btnSearchEmployee_Click() {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#EnvironmentDivisionID").val();
  
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}


function receiveResult(result) {
    $("#EmployeeID").val(result["EmployeeID"]);
    $("#EmployeeName").val(result["EmployeeName"]);
}