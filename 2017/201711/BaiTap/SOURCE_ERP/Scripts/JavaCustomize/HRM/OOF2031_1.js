//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     07/01/2015     Quang Chiến       Tạo mới
//####################################################################

var idFields = null;
var apk = null;
var urlParent = null;
var dataWorkFromDate = null;
var dataWorkToDate = null;
var tempCheckAllDataChange = [];
var isCheckAllDataChange = false;
var isStatus = null;

$(document).ready(function () {
    $('#GridEditOOT2030').data('kendoGrid').bind("dataBound", RowGrid_ChangeColor);
    urlParent = parent.GetUrlContentMaster() + "HRM/OOF2050";
    $('#ID').prop("readonly", true);
    idFields = $("#ID").val();

    if ($('#isUpdate').val() == "True") {
        isStatus = "Update";
    } else if ($('#isInherit').val() == "True") {
        isStatus = "Inherit";
    } else {
        isStatus ="AddNew";
    }
    
    if ($("#CheckDetail").val() == 1) {
        $("#DepartmentID").data("kendoComboBox").readonly();
        $("#SectionID").data("kendoComboBox").readonly();
        $("#SubsectionID").data("kendoComboBox").readonly();
        $("#ProcessID").data("kendoComboBox").readonly();
    } else {

        var cboDepartment = $("#DepartmentID").data("kendoComboBox");
        cboDepartment.bind("change", function (e) {
            $("#SubsectionID").data("kendoComboBox").text('');
            $("#ProcessID").data("kendoComboBox").text('');
            var grid = $('#GridEditOOT2030').data('kendoGrid');
            grid.dataSource.data([]);
            grid.addRow();

            cboDepartment.input.focus();
        });

        var cboSection = $("#SectionID").data("kendoComboBox");
        cboSection.bind("change", function (e) {
            $("#ProcessID").data("kendoComboBox").text('');
            var grid = $('#GridEditOOT2030').data('kendoGrid');
            grid.dataSource.data([]);
            grid.addRow();

            cboSection.input.focus();
        });

        var cboSubsection = $("#SubsectionID").data("kendoComboBox");
        cboSubsection.bind("change", function (e) {
            var grid = $('#GridEditOOT2030').data('kendoGrid');
            grid.dataSource.data([]);
            grid.addRow();

            cboSubsection.input.focus();
        });

        var cboProcess = $("#ProcessID").data("kendoComboBox");
        cboProcess.bind("change", function (e) {
            var grid = $('#GridEditOOT2030').data('kendoGrid');
            grid.dataSource.data([]);
            grid.addRow();

            cboProcess.input.focus();
        });
    }

    //Load nguoi duyet
    var level = $("#Level").val();
    for (var i = 1; i <= level; i++) {
        if (i < 10) {
            var ApprovePersonCombo = $("#ApprovePerson0" + i + "ID").data("kendoComboBox");
            if (ApprovePersonCombo) {
                ApprovePersonCombo.unbind("open");
                ApprovePersonCombo.bind("open", function (combo) {
                    OOF2031.OpenApprovePreson(combo,2);
                });
            }
        }
        else {
            var ApprovePersonCombo = $("#ApprovePerson" + i + "ID").data("kendoComboBox");
            if (ApprovePersonCombo) {
                ApprovePersonCombo.unbind("open");
                ApprovePersonCombo.bind("open", function () {
                    OOF2031.OpenApprovePreson(combo, 2);
                });
            }
        }

    }
    if ($('#isUpdate').val() == 'True') {
        for (var i = 1; i <= level; i++) {
            var ApprovePersonCombo = null;
            if (i < 10) {
                ApprovePersonCombo = $("#ApprovePerson0" + i + "ID").data("kendoComboBox");
            }
            else {
                ApprovePersonCombo = $("#ApprovePerson" + i + "ID").data("kendoComboBox");

            }
            if (ApprovePersonCombo) {
                OOF2031.OpenApprovePreson(ApprovePersonCombo, 1);
            }
        }
    }

    var grid = $('#GridEditOOT2030').data('kendoGrid');

    $(grid.tbody).on("change", "td", function (e) {

        var selectitem = grid.dataItem(grid.select());
        var column = e.target.id;

        if (column == 'cbbShiftID'){//'cbb4050') {
            var id = e.target.value;
            var value = $("#cbbShiftID").data("kendoComboBox").input.select().val();
            selectitem.ShiftID = id;
            selectitem.ShiftName = value;
        }

        if (column == 'WorkFromDate') {
            //truyền giá trị chọn vào model grid
            selectitem.WorkFromDate = e.target.value           
        }

        if (column == 'WorkToDate') {
            //truyền giá trị chọn vào model grid
            selectitem.WorkToDate = e.target.value
           
        }

        if (column == 'FromWorkingDate') {
            //truyền giá trị chọn vào model grid
            selectitem.FromWorkingDate = e.target.value
        }
        if (column == 'ToWorkingDate') {
            //truyền giá trị chọn vào model grid
            selectitem.ToWorkingDate = e.target.value
        }
    });

    $(grid.tbody).on("focusout", "td", function (e) {
        var selectitem = grid.dataItem(grid.select());
        var column = e.target.id;

        if (column == 'EmployeeID') {
            //truyền giá trị chọn vào model grid
            //selectitem.EmployeeID = e.target.value
            if (selectitem.WorkFromDate && e.target.value) {
                var url = "/HRM/OOF2030/LoadShift";
                var data = {
                    EmployeeID: e.target.value,
                    DateOT: changeDate(selectitem.WorkFromDate).split(" ")[0]
                }
                ASOFT.helper.post(url, data, function (data) {
                    selectitem.ShiftNow = data[0].ShiftID;
                    selectitem.set('ShiftNow', data[0].ShiftID);
                    grid.refresh();
                });
            }
        }

        //if (column == 'DateOT') {
        //    //truyền giá trị chọn vào model grid
        //    selectitem.DateOT = e.target.value
        //    if (selectitem.DateOT && selectitem.EmployeeID) {
        //        var url = "/HRM/OOF2030/LoadShift";
        //        var data = {
        //            EmployeeID: selectitem.EmployeeID,
        //            DateOT: changeDate(selectitem.DateOT)
        //        }
        //        ASOFT.helper.post(url, data, function (data) {
        //            selectitem.ShiftNow = data[0].ShiftID;
        //            selectitem.set('ShiftNow', data[0].ShiftID);
        //            grid.refresh();
        //        });
        //    }
        //}

        if (column == 'WorkFromDate') {
            //truyền giá trị chọn vào model grid
            selectitem.WorkFromDate = e.target.value
            //if (isStatus == "AddNew") {
                selectitem.FromWorkingDate = e.target.value.split(' ')[0]
            //}
            if (selectitem.WorkFromDate && selectitem.WorkToDate) {
                var diff = Date.parse(changeDate(selectitem.WorkToDate)) - Date.parse(changeDate(selectitem.WorkFromDate));
                //var diff = parseTime(selectitem.WorkToDate) - parseTime(selectitem.WorkFromDate);
                if (diff >= 0) {
                    //var hour = diff / 60;
                    var hour = diff / (1000 * 60 * 60);
                    selectitem.TotalOT = hour.toString();
                    selectitem.set('TotalOT', parseFloat(hour.toString()).toFixed(2));
                }
                else {
                    selectitem.TotalOT = '';
                    selectitem.set('TotalOT', null);
                }
            }

            if (selectitem.WorkFromDate && selectitem.EmployeeID) {
                var url = "/HRM/OOF2030/LoadShift";
                var data = {
                    EmployeeID: selectitem.EmployeeID,
                    DateOT: changeDate(selectitem.WorkFromDate).split(" ")[0]
                }
                ASOFT.helper.post(url, data, function (data) {
                    selectitem.ShiftNow = data[0].ShiftID;
                    selectitem.set('ShiftNow', data[0].ShiftID);
                    
                });
            }

            grid.refresh();
        }

        if (column == 'WorkToDate') {
            //truyền giá trị chọn vào model grid
            selectitem.WorkToDate = e.target.value
            //if (isStatus == "AddNew") {
                selectitem.ToWorkingDate = e.target.value.split(' ')[0]
            //}
            if (selectitem.WorkFromDate && selectitem.WorkToDate) {
                var diff = Date.parse(changeDate(selectitem.WorkToDate)) - Date.parse(changeDate(selectitem.WorkFromDate));
                //var diff = parseTime(selectitem.WorkToDate) - parseTime(selectitem.WorkFromDate);
                if (diff >= 0) {
                    //var hour = diff / 60;
                    var hour = diff / (1000 * 60 * 60);
                    selectitem.TotalOT = hour.toString();
                    selectitem.set('TotalOT', parseFloat(hour.toString()).toFixed(2));
                }
                else {
                    selectitem.TotalOT = '';
                    selectitem.set('TotalOT', null);
                }
            }
            grid.refresh();
        }

    });
    
    $(".WorkType").before($(".ProcessID"));

    if ($('#isInherit').val() == 'True') {
        $('#BtnSave').unbind();
        $("#BtnSave").kendoButton({
            "click": CustomBtnSave_Click,
        });

        grid.hideColumn(grid.columns.length - 1);

        grid.unbind("dataBound");
        var columns = grid.columns;
        var name = 'GridEditOOT2030';
        $(grid.tbody).off("keydown mouseleave", "td").on("keydown mouseleave", "td", function (e) {
            ASOFT.asoftGrid.currentRow = $(this).parent().index();
            ASOFT.asoftGrid.currentCell = $(this).index();

            var editor = columns[ASOFT.asoftGrid.currentCell].editor;
            var isDefaultLR = $(grid.element).attr('isDefaultLR');
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
    }

    GRID_AUTOCOMPLETE.config({
        gridName: 'GridEditOOT2030',
        inputID: 'autocomplete-box',
        autoSuggest: false,
        serverFilter: true,
        NameColumn: "EmployeeID",
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.container.parent().css('background', '')
            //if (dataItem.OvertTimeCompany >= 0 || dataItem.OvertTimeNN >= 0) {
            //    selectedRowItem.container.parent().css('background', 'red')
            //}

            var data1 = {
                OvertTime: dataItem.OvertTime
            }

            ASOFT.helper.postTypeJson("/HRM/OOF2030/CheckDataOvertime40", data1, function (result) {
                if (result.isCheck == 1) {
                    selectedRowItem.container.parent().css('background', 'yellow');
                }
                else if (result.isCheck == 2) {
                    selectedRowItem.container.parent().css('background', 'red');
                }
                else if (result.isCheck == 3) {
                    ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000036').f(dataSource[i].EmployeeID)], null);
                }
            });

            selectedRowItem.model.set("EmployeeID", dataItem.EmployeeID);
            selectedRowItem.model.set("EmployeeName", dataItem.EmployeeName);
            selectedRowItem.model.set("OvertTime", dataItem.OvertTime);
            selectedRowItem.model.set("OvertTimeNN", dataItem.OvertTimeNN);
            selectedRowItem.model.set("OvertTimeCompany", dataItem.OvertTimeCompany);
        }
    });
})

function parseTime(s) {
    var c = s.split(':');
    return parseInt(c[0]) * 60 + parseInt(c[1]);
}

function CustomerCheck() {
    ASOFT.form.clearMessageBox();

    var grid = $('#GridEditOOT2030').data('kendoGrid');

    var rowList = grid.tbody.children();
    $(rowList).removeAttr('style');

    var columns = grid.columns;
    var data = grid.dataSource.data();
    check = false;
    $(grid.tbody).find('td').removeClass('asf-focus-input-error');

    var indexDateOT = null;
    var indexWorkToDate = null;
    var indexWorkFromDate = null;
    var indexTotalOT = null;
    
    var array = [];

    $.each(columns, function (index, element) {
        if (element.field == "DateOT") {
            indexDateOT = index;
        }
        if (element.field == "WorkToDate") {
            indexWorkToDate = index;
        }
        if (element.field == "WorkFromDate") {
            indexWorkFromDate = index;
        }
        if (element.field == "TotalOT") {
            indexTotalOT = index;
        }
    });

    $(grid.tbody).find("td").each(function (index, element) {
        var grid1 = $('#GridEditOOT2030').data('kendoGrid');
        var data = grid1.dataSource.data();
        
        var rowIndex = $(element).parent().index();
        var cellIndex = $(element).index();
        if (cellIndex < data.length) {
            var totalOT = data[cellIndex].TotalOT;
            if (!totalOT || totalOT == 0) {
                $(element.children[indexWorkFromDate]).addClass('asf-focus-input-error');
                $(element.children[indexWorkToDate]).addClass('asf-focus-input-error');
                $(element.children[indexTotalOT]).addClass('asf-focus-input-error');
                ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000022')], null);
                check = true;
            }

        }
       

    });

    if (!check) {
        var grid1 = $('#GridEditOOT2030').data('kendoGrid');
        var rowList = grid.tbody.children();
        var dataSource = grid1.dataSource.data();
        for (var i = 0; i < dataSource.length; i++) {
            var data1 = {
                OvertTime: dataSource[i].OvertTime
            }

            ASOFT.helper.postTypeJson("/HRM/OOF2030/CheckDataOvertime40", data1, function (result) {
                if (result.isCheck == 1) {
                    var row = $(rowList[i]);
                    $(row).css('background', 'yellow');
                }
                else if (result.isCheck == 2) {
                    var row = $(rowList[i]);
                    $(row).css('background', 'red');
                }
                else if (result.isCheck == 3) {
                    array.push(dataSource[i].EmployeeID);
                }
            });
        }
        if (array.length > 0) {
            ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000036').f(array.join(','))], null);
            check = true;
        }        
    }

    if (!check) {
        //var tempEmp = [];
        //var tempKey = [];
        for (var i = 0; i < data.length; i++) {
            var empID = data[i].EmployeeID;
            for (var j = i + 1; j < data.length; j++) {
                if (empID == data[j].EmployeeID) {
                    var iWorkFromDate = Date.parse(changeDate(data[i].WorkFromDate));
                    var iWorkToDate = Date.parse(changeDate(data[i].WorkToDate));

                    var jWorkFromDate = Date.parse(changeDate(data[j].WorkFromDate));
                    var jWorkToDate = Date.parse(changeDate(data[j].WorkToDate));

                    var num = 0;
                    if (iWorkFromDate >= jWorkFromDate && iWorkFromDate <= jWorkToDate) {
                        $($($('#GridEditOOT2030 .k-grid-content tr')[i]).children()[indexWorkFromDate]).addClass('asf-focus-input-error')
                        $($($('#GridEditOOT2030 .k-grid-content tr')[i]).children()[indexWorkToDate]).addClass('asf-focus-input-error')
                        num = 1;
                    }

                    if (iWorkFromDate >= jWorkFromDate && iWorkFromDate <= jWorkToDate) {
                        $($($('#GridEditOOT2030 .k-grid-content tr')[j]).children()[indexWorkFromDate]).addClass('asf-focus-input-error')
                        $($($('#GridEditOOT2030 .k-grid-content tr')[j]).children()[indexWorkToDate]).addClass('asf-focus-input-error')
                        num = 2;
                    }

                    if (num > 0) {
                        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000021')], null);
                        check = true;
                    }
                }
            }
        }

        if (!check) {
            $.each(data, function (key, value) {
                //var index = $.inArray(value.EmployeeID, tempEmp);
                //if (index === -1) {
                //    tempEmp.push(value.EmployeeID);
                //    tempKey.push({
                //        WorkFromDate: value.WorkFromDate,
                //        WorkToDate: value.WorkToDate
                //    });
                //} else if (index != -1) {
                //    var tempWorkFromDate = Date.parse(changeDate(tempKey[index].WorkFromDate));
                //    var tempWorkToDate = Date.parse(changeDate(tempKey[index].WorkToDate));

                //    var vWorkFromDate = Date.parse(changeDate(value.WorkFromDate));
                //    var vWorkToDate = Date.parse(changeDate(value.WorkToDate));

                //        var num = 0;
                //        if (tempWorkFromDate <= vWorkFromDate && vWorkFromDate <= tempWorkToDate) {
                //            $($($('#GridEditOOT2030 .k-grid-content tr')[key]).children()[indexWorkFromDate]).addClass('asf-focus-input-error')
                //            num = 1;
                //        }

                //        if (tempWorkFromDate <= vWorkToDate && vWorkToDate <= tempWorkToDate) {
                //            $($($('#GridEditOOT2030 .k-grid-content tr')[key]).children()[indexWorkToDate]).addClass('asf-focus-input-error')
                //            num = 2;
                //        }

                //        if (num > 0) {
                //            ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000021')], null);
                //            check = true;
                //        }
                //        else {
                //            check = false;
                //        }
                //}

                tempCheckAllDataChange.push({
                    APK: value.APK,
                    APKMaster: $('#APK').val(),
                    EmployeeID: value.EmployeeID,
                    WorkFromDate: kendo.toString(kendo.parseDate(value.WorkFromDate, "dd/MM/yyyy HH:mm"), "s").split('T').join(' '),
                    WorkToDate: kendo.toString(kendo.parseDate(value.WorkToDate, "dd/MM/yyyy HH:mm"), "s").split('T').join(' ')
                });

            });
        }
        
    }

    if (!check) {
        var Url = "/HRM/OOF2030/CheckAllDataChange";
        var data = tempCheckAllDataChange;
        ASOFT.helper.postTypeJson(Url, data, CheckAllDataChangeSuccess);
        check = isCheckAllDataChange;
        isCheckAllDataChange = false;
        tempCheckAllDataChange = [];
    } else {
        tempCheckAllDataChange = [];
    }

    return check;
    
}


function CheckAllDataChangeSuccess(result) {
    isCheckAllDataChange = result.isChecked;
    //false là data  có giá trị, và ngược lại;
    var listCheck = result.list;
    var rowList = $('#GridEditOOT2030').data('kendoGrid').tbody.children();
    var columnIndexEmployeeID = $('#GridEditOOT2030').data('kendoGrid').wrapper.find(".k-grid-header [data-field=" + "EmployeeID" + "]").index();
    var columnIndexWorkFromDate = $('#GridEditOOT2030').data('kendoGrid').wrapper.find(".k-grid-header [data-field=" + "WorkFromDate" + "]").index();
    var columnIndexWorkToDate = $('#GridEditOOT2030').data('kendoGrid').wrapper.find(".k-grid-header [data-field=" + "WorkToDate" + "]").index();

    if (isCheckAllDataChange) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000019')], null);
        for (var i = 0; i < rowList.length; i++) {
            for (var j = 0; j < listCheck.length; j++) {
                var row = $(rowList[i]);
                if (row.children()[columnIndexEmployeeID].textContent.trim() == listCheck[j].EmployeeID &&
                    (row.children()[columnIndexWorkFromDate].textContent + ':00') == listCheck[j].WorkFromDate &&
                    (row.children()[columnIndexWorkToDate].textContent + ':00') == listCheck[j].WorkToDate) {

                    //row.children()[columnIndexEmployeeID].addClass('asf-focus-input-error');
                    //$(row.children()[columnIndexWorkFromDate]).addClass('asf-focus-input-error');
                    //$(row.children()[columnIndexWorkToDate]).addClass('asf-focus-input-error');
                    $(row).css('background', '#0ff');
                    break;
                }
            }
        }
    }
}


OOF2031 = new function () {
    this.OpenApprovePreson = function (combo,num) {
        var Url = "/HRM/OOF9000/LoadDataComboApprovePerson";
        var ApprovePersonCombo = null;
        var array = [];

        var level = $("#Level").val();
        for (var i = 1; i <= level; i++) {
            if (i < 10) {
                ApprovePersonCombo = $("#ApprovePerson0" + i + "ID").val();
            }
            else {
                ApprovePersonCombo = $("#ApprovePerson" + i + "ID").val();
            }

            if (ApprovePersonCombo) {
                array.push(ApprovePersonCombo);
            }
        }
        var NameComboBox = null;
        if (num == 1) {
            NameComboBox = $(combo.element).attr('id');
        } else {
            NameComboBox = combo.sender.element.attr("Name");
        }
        var list = new Array();
        list.push(this.AddList("Name", NameComboBox));
        list.push(this.AddList("DepartmentID", $('#DepartmentID').val()));
        list.push(this.AddList("SectionID", $('#SectionID').val()));
        list.push(this.AddList("SubsectionID", $('#SubsectionID').val()));
        list.push(this.AddList("ProcessID", $('#ProcessID').val()));
        list.push(this.AddList("Num", num));
        list.push(this.AddList("Type", "DXLTG"));
        ASOFT.helper.postTypeJsonComboBox(Url, list, combo, this.onComboSuccess);
    }
    this.AddList = function (key, value) {
        var item = new Object();
        item.key = key;
        item.value = value;
        return item;
    };
    //Script combobox
    this.onComboSuccess = function (result, combo) {
        if (result[result.length - 1].Num == 1) {
            result.pop();
            combo.dataSource.data(result)
        } else {
            result.pop();
            combo.sender.element.data("kendoComboBox").dataSource.data(result);
        }
    };
}

function CustomRead() {
    var ct = [];
    ct.push($("#APK").val());
    ct.push($("#isInherit").val());
    ct.push($("#DepartmentID").val());
    ct.push($("#SectionID").val());
    ct.push($("#SubsectionID").val());
    ct.push($("#ProcessID").val());
    return ct;
}

function CustomBtnSave_Click() {
    var url = "/GridCommon/InsertPopupMasterDetail/" + module + "/" + id;
    //action = 1;
    saveInherit(url)
}

var id = $("#sysScreenID").val();
function saveSuccess(result) {
    if (result.Status == 0) {
        ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
        window.parent.IsCheckExecute = true;
        window.parent.BtnFilter_Click();
        //parent.popupClose();

    }
    else {
        if (result.Message != 'Validation') {
            var msg = ASOFT.helper.getMessage(result.Message);
            if (result.Data) {
                msg = kendo.format(msg, result.Data);
            }
            ASOFT.form.displayWarning('#' + id, msg);
        }
        else {
            var msgData = new Array();
            $.each(result.Data, function (index, value) {
                var child = value.split(',');
                var msg = ASOFT.helper.getMessage(child[0]);
                msg = kendo.format(msg, child[1], child[2], child[3], child[4]);
                msgData.push(msg);
            });
            ASOFT.form.displayMultiMessageBox(id, 1, msgData);
        }
    }
    if (typeof onAfterInsertSuccess !== 'undefined' && $.isFunction(onAfterInsertSuccess)) {
        onAfterInsertSuccess(result);
    }
}

function saveInherit(url) {
    var data = ASOFT.helper.dataFormToJSON(id);
    var Confirm;
    var Check;

    if (isInvalid(data)) {
        return false;
    }

    if (isInlistGrid(data)) {
        return false;
    }

    if (typeof CustomerCheck === "function") {
        Check = CustomerCheck();
        if (Check) {
            return false;
        }
    }

    if (typeof CustomerConfirm === "function") {
        Confirm = CustomerConfirm();
        if (Confirm.Status != 0) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage(Confirm.Message),
                function () {
                    saveExecute(url, data);
                },
                function () {
                    return false;
                });
        }
        else {
            saveExecute(url, data);
        }
    }
    else {
        saveExecute(url, data);
    }
}

function saveExecute(url, data) {
    var value1 = {};
    var datagrid = [];
    var master = [];
    var cb = $("input[type='checkbox']");
    $(cb).each(function () {
        var temp = $(this).attr("checked");
        var id = $(this).attr("id");
        if (temp == "checked") {
            data[id] = "1";
        }
        else {
            data[id] = "0";
        }
    })


    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox" && key != "Unique") {
            if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("tableNameEdit") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList") {
                if (value == "false")
                    value = "0";
                if (value == "true")
                    value = "1";
                value1[key] = data[key + "_Content_DataType"] + "," + value;
            }
        }
    })

    if (typeof CustomInsertPopupMaster === 'function') {
        datagrid = CustomInsertPopupMaster(datagrid);
    }
    else {
        master.push(value1)
        datagrid.push(master);
    }

    if (typeof CustomInsertPopupDetail === 'function') {
        datagrid = CustomInsertPopupDetail(datagrid);
    }
    else {
        $.each(tableName, function (key, value) {
            datagrid.push(getListDetail(value));
        })
    }

    if (checkunique == 1) {
        var un = 0;
        var unn = 0;
        $.each(unique, function (key, value) {
            if (unique[key] == data[key]) {
                unn++;
            }
            un++;
        })
        if (un == unn) {
            url = url + "?mode=1";
        }
        checkunique = 0;
    }

    ASOFT.helper.postTypeJson(url, datagrid, saveSuccess);
}

function ChooseEmployeeID_Click() {
    var departmentID = $('#DepartmentID').val();
    var sectionID = $('#SectionID').val();
    var subsectionID = $('#SubsectionID').val();
    var processID = $('#ProcessID').val();
    var grid = $('#GridEditOOT2030').data('kendoGrid');
    var item = grid._data;

    var employee = '';
    var i = 0;
    while (i < item.length - 1) {
        if (i != 0) {
            employee += ',';
        }
        if (item[i].EmployeeID) {
            employee += item[i].EmployeeID;
        }
        i++;
    }

    url = '/PopupSelectData/Index/HRM/OOF2004?DepartmentID=' + departmentID + '&SectionID=' + sectionID + '&SubsectionID=' + subsectionID + '&ProcessID=' + processID + '&EmployeeID=' + employee + '&Type=DXLTG';
    ASOFT.asoftPopup.showIframe(url, {});
}

function receiveResult(result) {
    ASOFT.form.clearMessageBox();
    var grid = $('#GridEditOOT2030').data('kendoGrid');
    $(grid.select()).css('background', '');
    //if (result["OvertTimeCompany"] >= 0 || result["OvertTimeNN"] >= 0) {
    //    $(grid.select()).css('background', 'red');
    //}
    //var item= grid.select();
    var selectedItem = grid.dataItem(grid.select());
    selectedItem.set('EmployeeID', result["EmployeeID"]);
    selectedItem.set('EmployeeName', result["EmployeeName"]);
    var data1 = {
        OvertTime: result["OvertTime"]
    }

    ASOFT.helper.postTypeJson("/HRM/OOF2030/CheckDataOvertime40", data1, function (result) {
        if (result.isCheck == 1) {
            $(grid.select()).css('background', 'yellow');
        }
        else if (result.isCheck == 2) {
            $(grid.select()).css('background', 'red');
        }
        else if (result.isCheck == 3) {
            ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000036').f(dataSource[i].EmployeeID)], null);
        }
    });

    selectedItem.set('OvertTime', result["OvertTime"]);
    selectedItem.set('OvertTimeNN', result["OvertTimeNN"]);
    selectedItem.set('OvertTimeCompany', result["OvertTimeCompany"]);
   
    
    //grid.refresh();
}

function RowGrid_ChangeColor(e)
{
    var item = e.sender._data;
    //lấy tất cả các dòng grid
    var rows = $('div.k-grid-content table tr');

    for (var i = 0; i < item.length; i++) {
        var data1 = {
            OvertTime: item[i].OvertTime ? item[i].OvertTime : 0
        }
        ASOFT.helper.postTypeJson("/HRM/OOF2030/CheckDataOvertime40", data1, function (result) {
            if (result.isCheck == 1) {
                $(rows[i]).css('background', 'yellow');
            }
            else if (result.isCheck == 2) {
                $(rows[i]).css('background', 'red');
            }
            else if (result.isCheck == 3) {
                ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000036').f(dataSource[i].EmployeeID)], null);
            }
        });
        //if (item[i].OvertTimeCompany >= 0 || item[i].OvertTimeNN >= 0) {
        //    $(rows[i]).css('background', 'red');//Do'red''#b24040'
        //}
    }
}

function onAfterInsertSuccess(result,action) {
    if (result.Status == 0) {
        var url = "/HRM/OOF9000/LoadLastKey";
        var data = {
            table: 'OOT2030',
            type: 'DXLTG',
            id: idFields
        };
        ASOFT.helper.post(url, data, function (data) {
            $('#ID').val(data.ID);
            $('#LastKey').val(data.LastKey);
            $('#LastKeyAPK').val(data.LastKeyAPK);
            $('#FormStatus').val(isStatus);
            $('#TypeName').val("DXLTG");
            apk = data.apk;
            idFields = data.ID;
        });

        var grid = window.parent.$('#GridOOT9000').data('kendoGrid');
        if (grid) {
            grid.dataSource.read();
        }

        if (action == 1) {
            sendMail();
            var grid = $("#GridEditOOT2030").data("kendoGrid");
            grid.dataSource.data([]);
            grid.addRow();
        }
        if (action == 2) {
            sendMail();
        }
        if (($('#isInherit').val() == 'True') || action == 3) {
            sendMail();
            parent.popupClose();
        }
    } else {
        if (result.Message == "OOFML000015") {
            var url = "/HRM/OOF9000/LoadLastKey";
            var data = {
                table: 'OOT2030',
                type: 'DXLTG',
                id: idFields
            };

            ASOFT.helper.post(url, data, function (data) {
                $('#ID').val(data.ID);
                $('#LastKey').val(data.LastKey);
                $('#LastKeyAPK').val(data.LastKeyAPK);
                $('#FormStatus').val(isStatus);
                $('#TypeName').val("DXLTG");
                apk = data.apk;
                idFields = data.ID;
            });
        }
        if (result.Message == "OOFML000037") {
            $("#BtnSave").kendoButton({
                enable: false
            });
            window.parent.IsCheckExecute = true;
            parent.refreshGrid();
        }
    }
}

function sendMail() {
    var dataSendMail = [];
    dataSendMail.push(apk);
    dataSendMail.push(null);
    dataSendMail.push(urlParent);
    ASOFT.helper.postTypeJson("/HRM/OOF2050/SendMail", dataSendMail, sendMailSuccess);
}

function sendMailSuccess(result) {
    if (result.isCheck) {
        if (result.isSendMail) {
            if (result.empName) {
                if ($('#isInherit').val() == 'True') {
                    var content = ASOFT.form.createMessageBox([ASOFT.helper.getMessage('OOFML000034').f(result.empName)]);
                    $(window.parent.FormFilter).prepend(content);
                } else {
                    ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000034').f(result.empName)], null);
                }
            }
        }
        else {
            if ($('#isInherit').val() == 'True') {
                var content = ASOFT.form.createMessageBox([ASOFT.helper.getMessage('00ML000097')]);
                $(window.parent.FormFilter).prepend(content);
            } else {
                ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('00ML000097')], null);
            }
        }
    }
}

function Openview() {
    $('#WorkFromDate_timeview').css({ "overflow": "scroll", "height": "150px" })
    $('#WorkToDate_timeview').css({ "overflow": "scroll", "height": "150px" })
}

//function changeDate(data) {
//    var dateformat = data.split("/");
//    var dateformat = dateformat[2] + "/" + dateformat[1] + "/" + dateformat[0];
//    return dateformat;
//}

function changeDate(data) {
    var date = data.split(" ");
    var dateformat = date[0].split("/");
    var dateformat = dateformat[2] + "/" + dateformat[1] + "/" + dateformat[0] + " " + date[1];
    return dateformat;
}