$(document).ready(function () {
    $("#popupInnerIframe").kendoWindow({
        activate: function () {
            HF0405.TeamIDopen();

            var txtEmp_width = 250;
            var txtDepartment_width = $('#DepartmentID').width();
            var btnSearch_width = $('#btnChoose').width();
            if (txtDepartment_width && btnSearch_width) {
                txtEmp_width = txtDepartment_width - btnSearch_width - 10;
            }

            /// Xử lý độ dài cho autocomplete EmployeeID
            $('#EmployeeID').parent().attr('style', ' width: ' + txtEmp_width + 'px !important; border-top: none; border-left: none; border-right: none; border-color: #AAA;');
            $('#EmployeeID').parent().hover(function () {
                $('#EmployeeID').parent().removeClass("k-state-hover");
            });
        }
    });
    
});
HF0405 = new function () {
    this.isSaved = false;
    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        HF0405.closePopup();
    };

    // Hide Iframes
    this.closePopup = function () {
        ASOFT.asoftPopup.hideIframe(true);
    };


    this.btnSave_Click = function () {

        if (ASOFT.form.checkDateInPeriod('HF0405', ASOFTEnvironment.BeginDate, ASOFTEnvironment.EndDate, ['VoucherDate'])) {
            return;
        }

        var url = $('#UrlUpdate').val();
        var data = {};
        data = ASOFT.helper.dataFormToJSON("HF0405");
       // data.lstEmp = data.EmployeeID.split(',');
        ASOFT.helper.postTypeJson(url, data, HF0405.saveSuccess); //post dữ liệu lên server
    }

    this.saveSuccess = function (result) {
        if (result.isChecked) {
            ASOFT.form.displayInfo('#HF0405', [ASOFT.helper.getMessage('OOFML000045')], null);
            window.parent.refreshGrid();
        }
        else {
            ASOFT.form.displayMessageBox('#HF0405', [ASOFT.helper.getMessage('OOFML000046')], null);
        }
    }


    this.comboDept_Changed = function (e) {
        $('#TeamID').data("kendoDropDownList").value(null);
        $('#TeamID').data("kendoDropDownList").text('');
        $('#EmployeeID').data("kendoDropDownList").value(null);
        $('#EmployeeID').data("kendoDropDownList").text('');
        HF0405.TeamIDopen();
        HF0405.EmployeeIDopen();
    }

    this.comboTeam_Changed = function (e) {
        $('#EmployeeID').data("kendoDropDownList").value(null);
        $('#EmployeeID').data("kendoDropDownList").text('');
        HF0405.EmployeeIDopen();

    }

    this.combo_Changed = function (e) {
    }

    this.TeamIDopen = function (e) {
        var url = $('#UrlLoadDataTeamID').val();
        var data = {};
        data.departmentID = $('#DepartmentID').val()//.split(',').join("','");
        ASOFT.helper.postTypeJson(url, data, function (result) {
            $('#TeamID').data("kendoDropDownList").dataSource.data(result);
        });
    }

    this.EmployeeIDopen = function (e) {
        var url = $('#UrlLoadDataEmployeeID').val();
        var data = {};
        data.departmentID = $('#DepartmentID').val();
        data.teamID = $('#TeamID').val();
        ASOFT.helper.postTypeJson(url, data, function (result) {
            $('#EmployeeID').data("kendoDropDownList").dataSource.data(result);
        });
    }

    this.btnChoose_Click = function () {
        var departmentID = $('#DepartmentID').val();
        var teamID = $('#TeamID').val();
        var chkTitle = $('#rdoFilterchkLabel').val();

        var url1 = '/PopupSelectData/Index/HRM/OOF2004?DepartmentID=' + departmentID + '&TeamID=' + teamID + '&Mode=' + chkTitle + '&ScreenID=HF0405&type=2';
        ASOFT.asoftPopup.showIframe(url1, {});

    }

    this.Auto_Change = function () {
        var autoComplete = $("#EmployeeID").data("kendoAutoComplete");
        var url = $("#UrlLoadDataEmployeeID").val();
        var data = {
            departmentID: $('#DepartmentID').val().split(',').join("','"),
            teamID: $('#TeamID').val().split(',').join("','"),
            employeeID: $('#EmployeeID').val()
        };
        ASOFT.helper.postTypeJson(url, data, function (result) {
            autoComplete.dataSource.data(result);
            autoComplete.search($("#EmployeeID").val());
        });
    }
}

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
    var url = $("#UrlLoadDataEmployeeID").val();
    var data = {
        departmentID: $('#DepartmentID').val().split(',').join("','"),
        teamID: $('#TeamID').val().split(',').join("','"),
        employeeID: $('#EmployeeID').val()
    };

    var dataIndex = 0;

    ASOFT.helper.postGetLargeJson(url, data, function (result) {
        if (result) {
            autoComplete.dataSource.data([]);
            ASOFT.asoftLoadingPanel.show();
            autoComplete.dataSource.data(result);

            //autoComplete.dataSource.bind(result);

            //setTimeout(function () {
            //    addDataItem(autoComplete, result, dataIndex)
            //}, 0);

            ASOFT.asoftLoadingPanel.hide();
            autoComplete.search($("#EmployeeID").val());
        }
    });
}

function addDataItem(autoComplete, result, dataIndex) {
    if (dataIndex < result.length) {
        autoComplete.dataSource.add(result[dataIndex]);
        dataIndex++;
        setTimeout(function () {
            addDataItem(autoComplete, result, dataIndex)
        }, 0);
    }
    else {
        ASOFT.asoftLoadingPanel.hide();
        autoComplete.search($("#EmployeeID").val());
    }
}


function receiveResult(result) {
    ASOFT.form.clearMessageBox();
    $('#EmployeeID').val(result["EmployeeID"].toString());
    //var arr = [];
    //$.each(result, function (index, value) {
    //    arr.push(value.EmployeeID);
    //});
    //$('#EmployeeID').val(arr.join(','));
}