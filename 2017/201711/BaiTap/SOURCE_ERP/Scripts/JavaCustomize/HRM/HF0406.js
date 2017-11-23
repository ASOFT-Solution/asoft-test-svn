﻿
var url_loaddata_employee = "/HRM/HF0406/LoadDataEmployeeID";

$(document).ready(function () {
    var id = $("#sysScreenID").val();

    var OrtherInfo = "<fieldset id='HRM'><legend><label>" + $("#GroupTitle1").val() + "</label></legend></fieldset>";
    var tableOO = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO'> </table> </div> </div>";
    var tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    var filter = "<fieldset id='HRMfilter'><legend><label>" + $("#GroupTitle2").val() + "</label></legend></fieldset>";
    $("#FormReportFilter").prepend(filter);
    $("#FormReportFilter").prepend(OrtherInfo);
    $("#HRM").prepend(tableOO);
    $("#HRMfilter").append($("#FromToDate"));
    $("#HRMfilter").append(tableOO1);
    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));

    $("#TableOO1").append($(".Year"));
    $("#TableOO1").append($(".DepartmentID"));
    $("#TableOO1").append($(".TeamID"));
    $("#TableOO1").append($(".EmployeeID"));

    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");


    $("#Year").data("kendoComboBox").select(0);

    $("#popupInnerIframe").kendoWindow({
        activate: function () {
            var txtEmp_width = 250;
            var txtyear_width = $('#Year').width();
            var btnSearch_width = $('#btnOpenSearch_EmployeeID').width();
            if (txtyear_width && btnSearch_width) {
                txtEmp_width = txtyear_width - btnSearch_width;
            }

            /// Xử lý độ dài cho autocomplete EmployeeID
            $('#EmployeeID').parent().attr('style', ' width: ' + txtEmp_width + 'px !important; border-top: none; border-left: none; border-right: none; border-color: #AAA;');
            $('#EmployeeID').parent().hover(function () {
                $('#EmployeeID').parent().removeClass("k-state-hover");
            });
        }
    });
    

    //$("#DepartmentID").data("kendoDropDownList").select(0);
    //var cboDepartmentID = $("#DepartmentID").data("kendoComboBox");    
    //var cboTeamId = $("#teamid").data("kendocombobox");
    //var cboyear = $("#year").data("kendocombobox");

    //cboTeamID.sender = cboTeamID;
    //cboDepartmentID.sender = cboDepartmentID;
    //cboYear.sender = cboYear;

    //cboDepartmentID.select(0);
    //OpenComboDynamic(cboTeamID);
    //OpenComboDynamic(cboYear);
     

    //$('#btnPrint').css('display', 'none')
    $('#btnPrintBD').css('display', 'none')

    $('#btnOpenSearch_EmployeeID').unbind('click');
    $('#btnOpenSearch_EmployeeID').removeAttr('onclick');

    $('.btnOpenSearch').unbind('focusin');
    $("#btnOpenSearch_EmployeeID").attr("onclick", "CustomBtnSearch_Click();");
})

//setup before functions
var typingTimer;                //timer identifier
var doneTypingInterval = 750;  //time in ms, 0.75 second for example

$("#EmployeeID").keyup(function (e) {
    if (!KeyCode_IsValid(e))
        return;
    clearTimeout(typingTimer);
    typingTimer = setTimeout(doneTyping, doneTypingInterval);
});

$("#EmployeeID").keydown(function (e) {
    if (!KeyCode_IsValid(e))
        return;
    clearTimeout(typingTimer);
});

function KeyCode_IsValid(e) {
    var isValid = false;
    var keyCodeInput = e.keyCode;
    if (keyCodeInput >= 48 && keyCodeInput <= 90)
        isValid = true;
    if (!isValid && keyCodeInput >= 96 && keyCodeInput <= 105)
        isValid = true;
    if (!isValid && (keyCodeInput == 8 || keyCodeInput == 46)) // 8 backspcace, 46 delete
        isValid = true;
    return isValid;
}

//user is "finished typing," do something
function doneTyping() {
    //do something
    var autoComplete = $("#EmployeeID").data("kendoAutoComplete");
    var url = "/HRM/HF0406/LoadDataEmployeeID";
    var data = {
        year: $('#Year').val(),
        departmentID: $('#DepartmentID').val().split(',').join("','"),
        teamID: $('#TeamID').val().split(',').join("','"),
        employeeID: $('#EmployeeID').val(),
        month: $('#Month').val()
    };

    var dataIndex = 0;

    ASOFT.helper.postGetLargeJson(url_loaddata_employee, data, function (result) {
        if (result) {
            autoComplete.dataSource.data([]);
            ASOFT.asoftLoadingPanel.show();
            autoComplete.dataSource.data(result);

            ASOFT.asoftLoadingPanel.hide();
            autoComplete.search($("#EmployeeID").val());
        }
    });
}


function Auto_ChangeDynamic(item) {
    $('#EmployeeID').val(item.EmployeeID);
}

function CustomBtnSearch_Click() {

}