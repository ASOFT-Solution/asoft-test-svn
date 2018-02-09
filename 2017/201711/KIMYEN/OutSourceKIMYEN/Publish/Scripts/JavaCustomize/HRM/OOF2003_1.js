var department;
var sectionID;
var subsectionID;
var processID;
var isDataChangeProblem = false;
var isTimeStatusProblem = false;
$(document).ready(function () {
    department = $("#DepartmentID").val();
    sectionID = $("#SectionID").val();
    subsectionID = $("#SubsectionID").val();
    processID = $("#ProcessID").val();

    if ($('#isUpdate').val() == 'True') {
        if ($('#WorkDate').val()) {
            var num = $('#WorkDate').val().split('/')[0];
            $("tr[class^='D']").css('opacity', '0.5');
            cboDay_ReadOnly(num, true);
            cboDay_ReadOnly(num, false);
        }
    } else {
        var cboEmployeeID = $('#EmployeeID').data("kendoComboBox");
        if (cboEmployeeID) {
            cboEmployeeID.bind('change', cboEmployeeID_Change);
            $("tr[class^='D']").css('opacity', '0.5');
            cboDay_ReadOnly(32, true);
        }
    }
});

/**
 * Custom kiểm tra trước khi vào workflow
 * @returns {} 
 * @since [Văn Tài] Created [08/12/2017]
 */
function CustomerCheck() {
    ASOFT.form.clearMessageBox();
    var check = false;

    if (!check) {
        var tempCheckAllDataChange = CatchCheckChangeData();

        // Kiểm tra thời gian vào làm, nghỉ làm, thử việc của nhân viên
        var sendData = tempCheckAllDataChange;
        var Url = "/HRM/OOF2000/CheckDataChangedOOT2000";
        ASOFT.helper.postTypeJson(Url, sendData, CheckAllDataChangeSuccess);
        check = isDataChangeProblem;
    }

    if (!check) {
        var tempCheckStatus = CatchCheckStatus();
        var sendData = tempCheckStatus;
        var Url = "/HRM/OOF2000/CheckTimeStatus";
        ASOFT.helper.postTypeJson(Url, sendData, CheckTimeStatusSuccess);
        check = isTimeStatusProblem;
    }
    return check;
}

/**
 * Lấy dữ liệu để Kiểm tra trùng phân ca
 * @returns {} 
 * @since [Văn Tài] Created [08/12/2017]
 */
function CatchCheckChangeData() {
    var data = {};

    data.APKMaster = $('#APKMaster').val();
    data.EmployeeID = $('#EmployeeID').val();
    

    return data;
}

/**
 * Nhận dữ liệu Kiểm tra trùng phân ca từ server
 * @param {} result 
 * @returns {} 
 * @since [Văn Tài] Created [08/12/2017]
 */
function CheckAllDataChangeSuccess(result) {
    isDataChangeProblem = result.isChecked;

    if (result.isChecked == true) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage(result.checker.Message)], null);
    }
}

/**
 * Lấy dữ liệu để kiểm tra bảng phân ca
 * @returns {} 
 * @since [Văn Tài] Created [08/12/2017]
 */
function CatchCheckStatus() {
    var data = {};

    data.APKMaster = $('#APKMaster').val();
    data.EmployeeID = $('#EmployeeID').val();

    for (var i = 1; i <= 31; i++) {
        var key;
        if (i < 10)
            key = "D0{0}".format(i);
        else
            key = "D{0}".format(i);
        data[key] = $("#" + key).val();
    }
    return data;
}

/**
 * Nhận dữ liệu kiểm tra bảng phân ca từ server
 * @param {} result 
 * @returns {} 
 * @since [Văn Tài] Created [08/12/2017]
 */
function CheckTimeStatusSuccess(result) {
    isTimeStatusProblem = result.isChecked;
    var listCheck = result.list;
    if (isTimeStatusProblem) {
        var message_array = [];
        for (var index = 0; index < listCheck.length; index++) {
            var message = ASOFT.helper.getMessage(listCheck[index].MessageID);

            if (listCheck[index].Params.length == 1) message = message.format(listCheck[index].Params[0]);
            if (listCheck[index].Params.length == 2) message = message.format(listCheck[index].Params[0], listCheck[index].Params[1]);
            if (listCheck[index].Params.length == 3) message = message.format(listCheck[index].Params[0], listCheck[index].Params[1], listCheck[index].Params[2]);

            message_array.push(message);
        }
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), message_array, null);
    }
}


function onAfterInsertSuccess(result, action) {
    if (result.Status == 0) {
        if (action == 2) {
            clearfields();
        }
        $('#APKMaster').val($('#PKParent').val());

        $("#DepartmentID").val(department);
        $("#SectionID").val(sectionID);
        $("#SubsectionID").val(subsectionID);
        $("#ProcessID").val(processID);
        $("tr[class^='D']").css('opacity', '0.5');
        cboDay_ReadOnly(32, true);
    }
}

function cboEmployeeID_Change(e) {

    var workDate = e.sender.dataItem().WorkDate;

    if (!workDate) {
        cboDay_ReadOnly(1, false);
    } else {
        var number = workDate.split("/")[0];
        $("tr[class^='D']").css('opacity', '0.5');
        cboDay_ReadOnly(number, true);
        cboDay_ReadOnly(number, false);
    }
}


function cboDay_ReadOnly(num, isReadOnly) {
    if (isReadOnly) {
        for (var i = 1; i < num; i++) {
            var cboDay = $('#D' + (i < 10 ? "0" + i.toString() : i.toString())).data("kendoComboBox");
            cboDay.readonly(isReadOnly);
        }
    } else {
        for (var i = 31; i >= num; i--) {
            $("tr.D" + (i < 10 ? "0" + i.toString() : i.toString())).css('opacity', '1');
            var cboDay = $('#D' + (i < 10 ? "0" + i.toString() : i.toString())).data("kendoComboBox");
            cboDay.readonly(isReadOnly);
        }
    }
}