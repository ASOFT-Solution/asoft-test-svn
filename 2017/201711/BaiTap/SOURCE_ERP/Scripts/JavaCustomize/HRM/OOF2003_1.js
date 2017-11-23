var department;
var sectionID;
var subsectionID;
var processID;
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