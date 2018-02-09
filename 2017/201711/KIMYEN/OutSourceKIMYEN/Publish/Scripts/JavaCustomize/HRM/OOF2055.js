﻿
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/01/2016     Quoc Tuan       Tạo mới
//####################################################################

var GridOOT2040 = null;

var urlParent = null;


$(document).ready(function () {
    urlParent = parent.GetUrlContentMaster() + "HRM/OOF2050";
    GridOOT2040 = $("#GridEditOOT2040").data("kendoGrid");
    GridOOT2040.hideColumn("APK");
    if ($("#IsLock").val() == "1") {
        $("#BtnSave").kendoButton({
            enable: false
        });
        $("#BtnSave").unbind();
        $("#Close").unbind();
        $("#Close").on("click", function () {
            parent.popupClose();
        })
    }
    $("#StatusOOT9001").on("change", StatusChange);
    if ($("#StatusOOT9001").val() != 1) {
        setTimeout(function () {
            var input = $("#GridEditOOT2040").find("input[type='checkbox']");
            $(input).each(function () {
                $(this).attr("onclick", "return false;");
            })
        }, 200)
    }
    GridOOT2040.unbind("dataBound");
    var columns = GridOOT2040.columns;
    var name = 'GridEditOOT2040';
    $(GridOOT2040.tbody).off("keydown mouseleave", "td").on("keydown mouseleave", "td", function (e) {
        ASOFT.asoftGrid.currentRow = $(this).parent().index();
        ASOFT.asoftGrid.currentCell = $(this).index();

        var editor = columns[ASOFT.asoftGrid.currentCell].editor;
        var isDefaultLR = $(GridOOT2040.element).attr('isDefaultLR');
        if (editor != undefined) {
            var elm = $(this);
            if (e.shiftKey) {
                switch (e.keyCode) {
                    case 13:
                        ASOFT.asoftGrid.previousCell(this, name, false);
                        e.preventDefault();
                        break;
                    case 9:
                        ASOFT.asoftGrid.previousCell(this, name, false);
                        e.preventDefault();
                        break;
                    default:
                        break;
                }
            } else {
                switch (e.keyCode) {
                    case 13:
                        ASOFT.asoftGrid.nextCell(this, name, false);
                        e.preventDefault();
                        break;
                    case 9:
                        ASOFT.asoftGrid.nextCell(this, name, false);
                        e.preventDefault();
                        break;
                    case 37: //left
                        if (!isDefaultLR) {
                            ASOFT.asoftGrid.leftCell(this, name);
                            e.preventDefault();
                        }
                        break;
                    case 39://right
                        if (!isDefaultLR) {
                            ASOFT.asoftGrid.rightCell(this, name);
                            e.preventDefault();
                        }
                        break;
                        //TODO : up & down
                        /*case 38:
                            ASOFT.asoftGrid.upCell(this, name);
                            e.preventDefault();
                        return false;
                        case 40:
                            ASOFT.asoftGrid.downCell(this, name);
                            e.preventDefault();
                        return false;*/
                    default:
                        break;
                }
            }
        }// end if

    });
})

function CustomRead() {
    var ct = [];
    ct.push($("#APK").val());
    ct.push($("#APKOOT9001").val());
    return ct;
}

function StatusChange() {
    GridOOT2040 = $('#GridEditOOT2040').data('kendoGrid');
    var data = GridOOT2040.dataSource.data();
    var totalNumber = data.length;
   
    if ($("#StatusOOT9001").val() == 1) {
        var input = $("#GridEditOOT2040").find("input#CbGridEdit_Status[type='checkbox']");
        $(input).each(function () {
            $(this).prop("checked", "checked");
        })

        for (var i = 0; i < data.length; i++) {
            data[i].Status = 1;
        }
    } else {
        var input = $("#GridEditOOT2040").find("input#CbGridEdit_Status[type='checkbox']");
        $(input).each(function () {
            $(this).prop('checked', '');
        })

        for (var i = 0; i < data.length; i++) {
            data[i].Status = 0;
        }
    }
}

function onCheckGridEdit(grid, key) {
    var chkbox = $(grid.select()).find("input#CbGridEdit_" + key + "[type='checkbox']");
    var data = grid.dataItem(grid.select());
    if ($("#StatusOOT9001").val() != 1) {
        if (chkbox.is(':checked')) {
            chkbox.prop("checked", "");
            data.Status = 0;
        }
        else {
            chkbox.prop('checked', 'checked');
            data.Status = 1;
        }

    }
    else {
        if (chkbox.is(':checked')) {
            chkbox.prop("checked", "checked");
            data.Status = 1;
        }
        else {
            chkbox.prop('checked', '');
            data.Status = 0;
        }
    }


}

function CustomInsertPopupMaster(data) {
    var datagrid = [];
    var value1 = {};
    var master = [];
    var cb = $("input[type='checkbox']");
    $(cb).each(function () {
        var temp = $(this).is(':checked');
        var id = $(this).attr("id");
        if (temp) {
            data[id] = "1";
        }
        else {
            data[id] = "0";
        }
    })


    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox" && key != "Unique") {
            if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("tableNameEdit") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "StatusDetail" && key.indexOf("CbGridEdit_") == -1) {
                if (value == "false")
                    value = "0";
                if (value == "true")
                    value = "1";
                value1[key] = data[key + "_Content_DataType"] + "," + value;
            }
        }
    })

    master.push(value1)
    datagrid.push(master);
    return datagrid;

}

function genStatus(data) {
    if (data && data.Status != null) {
        return data.Status;
    }
    return 0;
}


function onAfterInsertSuccess(result, action) {
    if (result.Status == 0) {
        var data = [];
        data.push($("#APK").val());
        data.push($("#APKOOT9001").val());
        data.push(urlParent);
        ASOFT.helper.postTypeJson("/HRM/OOF2050/SendMail", data, sendMailSuccess);
        IsCheckExecute = true;
        parent.BtnFilter_Click();
        parent.popupClose();
    }
}

function sendMailSuccess(result) {
    var content = null;
    if (result.isCheck) {
        if (result.isSendMail) {
            if (result.empName) {
                content = ASOFT.form.createMessageBox([ASOFT.helper.getMessage('OOFML000034').f(result.empName)]);
            }
        } else {
            content = ASOFT.form.createMessageBox([ASOFT.helper.getMessage('00ML000097')]);
        }
        $(window.parent.FormFilter).prepend(content);
    }
}

function CustomerCheck() {
    var isChecked = false;
    if ($("#StatusOOT9001").val() == 0) {
        var msg = ASOFT.helper.getMessage("OOFML000024");
        ASOFT.form.displayError("#OOF2055", msg);
        isChecked = true;
    }
    if (!isChecked) {
        var cboStatusOOT9001 = $('#StatusOOT9001').data('kendoComboBox');
        var data1 = {
            DivisionID: $("#EnvironmentDivisionID").val(),
            APKOOT9001: $('#APKOOT9001').val(),
            Status: cboStatusOOT9001.value(),
        };
        ASOFT.helper.postTypeJson("/HRM/OOF2050/CheckApprovedOOT9001", data1, function (result) {
            isChecked = result;
            if (result) {
                var msg = ASOFT.helper.getMessage("OOFML000052").f(cboStatusOOT9001.text().toLowerCase());
                ASOFT.form.displayError("#OOF2055", msg);
                return isChecked;
            }
        });
    }
    return isChecked;
}

//Tạm thời thêm vào coi sửa lại
function Openview() {
    $('#LeaveFromDate_timeview').css({ "overflow": "scroll", "height": "150px" })
    $('#LeaveToDate_timeview').css({ "overflow": "scroll", "height": "150px" })
}