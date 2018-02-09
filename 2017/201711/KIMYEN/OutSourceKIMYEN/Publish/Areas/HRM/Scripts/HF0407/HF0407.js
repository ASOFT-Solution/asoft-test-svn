$(document).ready(function () {
    $("#popupInnerIframe").kendoWindow({
        activate: function () {
            HF0407.TeamIDopen();

            $('#EmployeeID').parent().attr('style', 'width: 92% !important; border-top: none; border-left: none; border-right: none; border-color: #AAA;');
            $('#EmployeeID').parent().hover(function () {
                $('#EmployeeID').parent().removeClass("k-state-hover");
            });
            $('#rdoFilterchkLabel[value="2"]').attr("style", "margin-left: 1px !important;");

            // bắt sự kiện thay đổi select trên radio button
            $('input[name="chkTitle"]:radio').change(function (e) {
                if (e.target.value == 2) {
                    $("#Period").data("kendoComboBox").enable(true);
                }
                else {
                    $("#Period").data("kendoComboBox").enable(false);
                }
            });
        }
    });
});

HF0407 = new function () {
    this.isSaved = false;

    this.getValuesFromDropdown = function () {
        // Document ready
        var idLst = [];
        $('#DepartmentID_listbox li').each(function () {

            var stsItem = $(this).attr('class');
            if (stsItem == 'k-item k-state-selected') {
                idLst.push($(this)[0].childNodes[0].defaultValue);
            }

        });
        console.log(idLst);
    };

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
        HF0407.closePopup();
    };

    // Hide Iframes
    this.closePopup = function () {
        ASOFT.asoftPopup.hideIframe(true);
    };

    this.btnSave_Click = function () {
        var url = $('#UrlUpdate').val();
        var data = {};
        data = ASOFT.helper.dataFormToJSON("HF0407");
        //data.lstEmp = data.EmployeeID.split(',');
        ASOFT.helper.postTypeJson(url, data, HF0407.saveSuccess); //post dữ liệu lên server
    }

    this.saveSuccess = function (result) {
        if (result.isChecked) {
            ASOFT.form.displayInfo('#HF0407', [ASOFT.helper.getMessage('OOFML000043')], null);
            window.parent.refreshGrid();
        }
        else {
            ASOFT.form.displayMessageBox('#HF0407', [ASOFT.helper.getMessage('OOFML000044')], null);
        }
    }

    this.comboDept_Changed = function (e) {
        $('#TeamID').data("kendoDropDownList").value(null);
        $('#TeamID').data("kendoDropDownList").text('');
        HF0407.TeamIDopen();
        $('#EmployeeID').val('');
    }

    this.comboTeamID_Changed = function (e) {
        $('#EmployeeID').val('');
    }

    this.comboDept_DataBound = function (e) {
        var item = e;
    }

    this.cboDepID_EventRequestEnd = function (e) {
        var cboToDepartmentID = $('#ToDepartmentID').data("kendoComboBox");
        cboToDepartmentID.setDataSource(e.response);
        cboToDepartmentID.select(e.response.length - 1);
    }

    this.cboTeamID_EventRequestEnd = function (e) {
        var cboToTeamID = $('#ToTeamID').data("kendoComboBox");
        cboToTeamID.setDataSource(e.response);
        cboToTeamID.select(e.response.length - 1);
    }

    this.cboEmpID_EventRequestEnd = function (e) {
        var cboEmployeeID = $('#EmployeeID').data("kendoComboBox");
        cboEmployeeID.setDataSource(e.response);
        cboEmployeeID.select(e.response.length - 1);
    }

    this.cboTeamID_EventPostData = function () {
        var data = {};
        data.fromDepartmentID = $('#FromDepartmentID').val();
        data.toDepartmentID = $('#ToDepartmentID').val();
        return data;
    }

    this.cboEmpID_EventPostData = function () {
        var data = {};
        data.fromDepartmentID = $('#FromDepartmentID').val();
        data.toDepartmentID = $('#ToDepartmentID').val();
        data.fromTeamID = $('#FromTeamID').val();
        data.toTeamID = $('#ToTeamID').val();
        return data;
    }

    this.TeamIDopen = function () {
        var data = {};
        data.departmentID = $('#DepartmentID').val().split(',').join("','");
        var url = $('#UrlLoadDataTeamID').val();
        ASOFT.helper.postTypeJson(url, data, function (result) {
            $('#TeamID').data("kendoDropDownList").dataSource.data(result);
        });
    }

    this.comboToTeamID_Opened = function () {
        var data = {};
        data.fromDepartmentID = $('#FromDepartmentID').val();
        data.toDepartmentID = $('#ToDepartmentID').val();
        var url = $('#UrlLoadDataTeamID').val();
        ASOFT.helper.postTypeJson(url, data, function (result) {
            var cboTeamID = $('#ToTeamID').data("kendoComboBox");
            if (cboTeamID) {
                cboTeamID.setDataSource(result);
                cboTeamID.select(result.length - 1);
            }
        });
    }

    this.comboEmpID_Opened = function () {
        var data = {};
        data.fromDepartmentID = $('#FromDepartmentID').val();
        data.toDepartmentID = $('#ToDepartmentID').val();
        data.fromTeamID = $('#FromTeamID').val();
        data.toTeamID = $('#ToTeamID').val();

        var url = $('#UrlLoadDataEmployeeID').val();
        ASOFT.helper.postTypeJson(url, data, function (result) {
            var cboEmployeeID = $('#EmployeeID').data("kendoComboBox");
            if (cboEmployeeID) {
                cboEmployeeID.setDataSource(result);
                cboEmployeeID.select(0);
            }
        });
    }

    this.btnChoose_Click = function () {
        var departmentID = $('#DepartmentID').val();
        var teamID = $('#TeamID').val();
        var chkTitle = null;
        if ($('#rdoFilterchkLabel[value=1]')[0].checked)
            chkTitle = 1;
        else
            chkTitle = 2;


        var period = $('#Period').val();
        var lasttranmonth = 0;
        var lasttranyear = 0;
        if (period) {
            lasttranmonth = period.split('/')[0];
            lasttranyear = period.split('/')[1];
        }
        var url1 = '/PopupSelectData/Index/HRM/OOF2004?DepartmentID=' + departmentID + '&TeamID=' + teamID + '&Mode=' + chkTitle + '&LastTranMonth=' + lasttranmonth + '&LastTranYear=' + lasttranyear + '&ScreenID=HF0407&type=2';
        ASOFT.asoftPopup.showIframe(url1, {});

    }

    this.Auto_Change = function () {
        //var autoComplete = $("#EmployeeID").data("kendoAutoComplete");
        //var url = $("#UrlLoadDataEmployeeID").val();

        //var period = $('#Period').val();
        //var lasttranmonth = 0;
        //var lasttranyear = 0;
        //if (period) {
        //    lasttranmonth = period.split('/')[0];
        //    lasttranyear = period.split('/')[1];
        //}

        //var data = {
        //    LstDepartmentID: $('#DepartmentID').val().split(',').join("','"),
        //    LstTeamID: $('#TeamID').val().split(',').join("','"),
        //    employeeID: $('#EmployeeID').val(),
        //    chkTitle: $('#rdoFilterchkLabel').val(),
        //    lastTranMonth: lasttranmonth,
        //    lastTranYear: lasttranyear
        //};
        //ASOFT.helper.postTypeJson(url, data, function (result) {
        //    autoComplete.dataSource.data(result);
        //    autoComplete.search($("#EmployeeID").val());
        //});
    }

    //setup before functions
    var typingTimer;                //timer identifier
    var doneTypingInterval = 750;  //time in ms, 0.75 second for example
    this.retyping = false;
    this.current_count_data = 0;

    $("#EmployeeID").keyup(function (e) {
        if (!KeyCode_IsValid(e))
            return;
        this.retyping = true;
        clearTimeout(typingTimer);
        typingTimer = setTimeout(doneTyping, doneTypingInterval);
    });

    $("#EmployeeID").keydown(function (e) {
        if (!KeyCode_IsValid(e))
            return;
        this.retyping = true;
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
        var autoComplete = $("#EmployeeID").data("kendoAutoComplete");
        var url = $("#UrlLoadDataEmployeeID").val();

        var period = $('#Period').val();
        var lasttranmonth = 0;
        var lasttranyear = 0;
        if (period) {
            lasttranmonth = period.split('/')[0];
            lasttranyear = period.split('/')[1];
        }

        var data = {
            LstDepartmentID: $('#DepartmentID').val().split(',').join("','"),
            LstTeamID: $('#TeamID').val().split(',').join("','"),
            employeeID: $('#EmployeeID').val(),
            chkTitle: $('#rdoFilterchkLabel').val(),
            lastTranMonth: lasttranmonth,
            lastTranYear: lasttranyear
        };

        //autoComplete.dataSource = [];
        var dataIndex = 0;

        ASOFT.asoftLoadingPanel.show();

        ASOFT.helper.postGetLargeJson(url, data, function (result) {
            if (result) {
                this.retyping = false;
                this.current_count_data = result.length;
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
}

var fill_data_counter = 0;
var fill_complete = false;
function addDataItem(autoComplete, result, dataIndex) {
    if (dataIndex < result.length && !HF0407.retyping) {
        if (!HF0407.retyping) {
            autoComplete.dataSource.add(result[dataIndex]);
            dataIndex++;
            fill_data_counter++;
            setTimeout(function () {
                addDataItem(autoComplete, result, dataIndex)
            }, 0);
        }
    }
    else {
        //HF0407.retyping = true;
        dataIndex = result.length;
        ASOFT.asoftLoadingPanel.hide();
        if (fill_data_counter >= HF0407.current_count_data - 1) {
            autoComplete.search($("#EmployeeID").val());
            HF0407.retyping = false;
        } else {
            autoComplete.dataSource.data([]);
            HF0407.retyping = true;
        }
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

