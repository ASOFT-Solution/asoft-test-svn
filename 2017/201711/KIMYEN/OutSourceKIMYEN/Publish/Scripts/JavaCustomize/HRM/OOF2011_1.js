//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/01/2016     Quang Chiến       Tạo mới
//####################################################################

var idFields = null;
var apk = null;
var urlParent = null;
var dataLeaveFromDate = null;
var dataLeaveToDate = null;
var tempCheckAllDataChange = [];
var isCheckAllDataChange = false;
var isTimeStatusProblem = false;
var isStatus = null;

$(document).ready(function () {
    urlParent = parent.GetUrlContentMaster() + "HRM/OOF2050";
    $('#ID').prop("readonly", true);
    idFields = $("#ID").val();
    if ($('#isUpdate').val() == "True") {
        isStatus = "Update";
    } else if ($('#isInherit').val() == "True") {
        isStatus = "Inherit";
    } else {
        isStatus = "AddNew";
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
            var grid = $('#GridEditOOT2010').data('kendoGrid');
            grid.dataSource.data([]);
            grid.addRow();

            cboDepartment.input.focus();
        });

        var cboSection = $("#SectionID").data("kendoComboBox");
        cboSection.bind("change", function (e) {
            $("#ProcessID").data("kendoComboBox").text('');
            var grid = $('#GridEditOOT2010').data('kendoGrid');
            grid.dataSource.data([]);
            grid.addRow();

            cboSection.input.focus();
        });

        var cboSubsection = $("#SubsectionID").data("kendoComboBox");
        cboSubsection.bind("change", function (e) {
            var grid = $('#GridEditOOT2010').data('kendoGrid');
            grid.dataSource.data([]);
            grid.addRow();

            cboSubsection.input.focus();
        });

        var cboProcess = $("#ProcessID").data("kendoComboBox");
        cboProcess.bind("change", function (e) {
            var grid = $('#GridEditOOT2010').data('kendoGrid');
            grid.dataSource.data([]);
            grid.addRow();

            cboProcess.input.focus();
        });
    }


    var level = $("#Level").val();
    for (var i = 1; i <= level; i++) {
        if (i < 10) {
            var ApprovePersonCombo = $("#ApprovePerson0" + i + "ID").data("kendoComboBox");

            if (ApprovePersonCombo) {
                ApprovePersonCombo.unbind("open");
                ApprovePersonCombo.bind("open", function (combo) {
                    OOF2011.OpenApprovePreson(combo, 2);
                });

            }
        }
        else {
            var ApprovePersonCombo = $("#ApprovePerson" + i + "ID").data("kendoComboBox");

            if (ApprovePersonCombo) {
                ApprovePersonCombo.unbind("open");
                ApprovePersonCombo.bind("open", function () {
                    OOF2011.OpenApprovePreson(combo, 2);
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
                OOF2011.OpenApprovePreson(ApprovePersonCombo, 1);
            }
        }
    }
    var grid = $('#GridEditOOT2010').data('kendoGrid');

    $(grid.tbody).on("focusin", "td", function (e) {
        var data = e.target.value;
        var column = e.target.id;

        if (column == 'LeaveFromDate') {
            dataLeaveFromDate = data;
        }
        if (column == 'LeaveToDate') {
            dataLeaveToDate = data;
        }
    });

    $(grid.tbody).on("change", "td", function (e) {
        var selectitem = grid.dataItem(grid.select());

        var column = e.target.id;
        if (ASOFTEnvironment.CustomerIndex.MEIKO == "True") {
            if (column == 'cbbShiftID') {//'cbb4050') {
                var id = e.target.value;
                var value = $("#cbbShiftID").data("kendoComboBox").input.select().val();
                selectitem.ShiftID = id;
                selectitem.ShiftName = value;
            }
        }
        if (column == 'cbbAbsentTypeID') {//'cbb1020') {
            var id = e.target.value;
            var combobox = $("#cbbAbsentTypeID").data("kendoComboBox");
            $.each(combobox.options.dataSource, function (index, value) {
                if (id == value.AbsentTypeID) {
                    selectitem.AbsentTypeID = id;
                    selectitem.AbsentTypeName = value.Description;
                    return;
                }
            });
            grid.refresh();
        }
        if (column == 'LeaveFromDate') {
            //truyền giá trị chọn vào model grid
            selectitem.LeaveFromDate = e.target.value
        }
        if (column == 'LeaveToDate') {
            //truyền giá trị chọn vào model grid
            selectitem.LeaveToDate = e.target.value
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
        if (selectitem) {
            if (column == 'EmployeeID') {
                //selectitem.EmployeeID = e.target.value;
                if (selectitem.LeaveToDate && e.target.value) {
                    var url = "/HRM/OOF2010/LoadShift";
                    var data = {
                        EmployeeID: e.target.value,
                        DateOT: changeDate(selectitem.LeaveToDate),
                        Type: 'DXP'
                    }
                    ASOFT.helper.post(url, data, function (data) {
                        if (data.length > 0) {
                            selectitem.OldShiftID = data[0].ShiftID;
                            selectitem.set('OldShiftID', data[0].ShiftID);
                            selectitem.FromWorkingDate = kendo.format("{0}/{1}/{2}", FromWorkingDate[2], FromWorkingDate[1], FromWorkingDate[0]);
                            selectitem.ToWorkingDate = kendo.format("{0}/{1}/{2}", ToWorkingDate[2], ToWorkingDate[1], ToWorkingDate[0]);
                            selectitem.IsNextDay = data[0].IsNextDay;
                            if (selectitem.IsNextDay == 1) {
                                $(grid.select()).find("input#CbGridEdit_IsNextDay[type='checkbox']").prop("checked", "checked");
                            } else {
                                $(grid.select()).find("input#CbGridEdit_IsNextDay[type='checkbox']").prop("checked", "");
                            }
                        }
                        else {
                            selectitem.OldShiftID = '';
                            selectitem.set('OldShiftID', '');
                            selectitem.FromWorkingDate = '';
                            selectitem.ToWorkingDate = '';
                            selectitem.IsNextDay = 0;
                            $(grid.select()).find("input#CbGridEdit_IsNextDay[type='checkbox']").prop("checked", "");
                        }
                    });
                    grid.refresh();
                }

                if (selectitem.LeaveFromDate && selectitem.LeaveToDate && selectitem.AbsentTypeID && e.target.value) {
                    var data1 = {
                        EmployeeID: employeeID,
                        FromDate: changeDate(selectitem.LeaveFromDate),
                        ToDate: changeDate(selectitem.LeaveToDate),
                        absentTypeID: selectitem.AbsentTypeID
                    }

                    ASOFT.helper.postTypeJson("/HRM/OOF2010/GetTotalTime", data1, function (data1) {
                        var totaltime = formatDecimal(kendo.parseFloat(data1), 1);
                        selectitem.TotalTime = totaltime;
                        selectitem.set('TotalTime', totaltime);
                        grid.refresh();
                    });
                }
            }

            if (column == 'AbsentTypeID') {
                //truyền giá trị chọn vào model grid
                selectitem.AbsentTypeID = e.target.value;
            }

            if (column == 'LeaveFromDate') {
                //truyền giá trị chọn vào model grid
                selectitem.LeaveFromDate = e.target.value;
                //if (isStatus == "AddNew") {
                //selectitem.FromWorkingDate = e.target.value.split(' ')[0]
                //}
                if (selectitem.EmployeeID && selectitem.LeaveFromDate && selectitem.LeaveToDate && selectitem.AbsentTypeID) {
                    var diff = Date.parse(changeDate(selectitem.LeaveToDate)) - Date.parse(changeDate(selectitem.LeaveFromDate));
                    if (diff >= 0) {
                        var data1 = {
                            EmployeeID: selectitem.EmployeeID,
                            FromDate: changeDate(selectitem.LeaveFromDate),
                            ToDate: changeDate(selectitem.LeaveToDate),
                            absentTypeID: selectitem.AbsentTypeID
                        }

                        ASOFT.helper.postTypeJson("/HRM/OOF2010/GetTotalTime", data1, function (data1) {
                            var totaltime = formatDecimal(kendo.parseFloat(data1), 1);
                            selectitem.TotalTime = totaltime;
                            selectitem.set('TotalTime', totaltime);
                        });
                        //var hours = diff / (1000 * 60 * 60);
                        //var day = (hours / 24);
                        //day = day.toString().split('.')[0] * 8;
                        //var hour = ((hours % 24) + day);//(hours % 24) > 8 ? (8 + day) : ((hours % 24) + day);
                        //selectitem.TotalTime = hour.toString();
                        //selectitem.set('TotalTime', parseFloat(hour).toFixed(2));
                    }
                    else {
                        selectitem.TotalTime = '';
                        selectitem.set('TotalTime', null);
                    }
                }


                grid.refresh();
            }
            if (column == 'LeaveToDate') {
                //truyền giá trị chọn vào model grid
                selectitem.LeaveToDate = e.target.value;
                //if (isStatus == "AddNew") {
                //selectitem.ToWorkingDate = e.target.value.split(' ')[0]
                //}
                if (selectitem.EmployeeID && selectitem.LeaveFromDate && selectitem.LeaveToDate && selectitem.AbsentTypeID) {
                    var diff = Date.parse(changeDate(selectitem.LeaveToDate)) - Date.parse(changeDate(selectitem.LeaveFromDate));
                    if (diff >= 0) {
                        var data1 = {
                            EmployeeID: selectitem.EmployeeID,
                            FromDate: changeDate(selectitem.LeaveFromDate),
                            ToDate: changeDate(selectitem.LeaveToDate),
                            absentTypeID: selectitem.AbsentTypeID
                        }

                        ASOFT.helper.postTypeJson("/HRM/OOF2010/GetTotalTime", data1, function (data1) {
                            var totaltime = formatDecimal(kendo.parseFloat(data1), 1);
                            selectitem.TotalTime = totaltime;
                            selectitem.set('TotalTime', totaltime);
                        });
                        //var hours = diff / (1000 * 60 * 60);
                        //var day = (hours / 24);
                        //day = day.toString().split('.')[0] * 8;
                        //var hour = ((hours % 24) + day);//(hours % 24) > 8 ? (8 + day) : ((hours % 24) + day);
                        //selectitem.TotalTime = hour.toString();
                        //selectitem.set('TotalTime', parseFloat(hour).toFixed(2));
                    }
                    else {
                        selectitem.TotalTime = '';
                        selectitem.set('TotalTime', null);
                    }

                }

                if (selectitem.LeaveToDate && selectitem.EmployeeID) {
                    var url = "/HRM/OOF2010/LoadShift";
                    var data = {
                        EmployeeID: selectitem.EmployeeID,
                        DateOT: changeDate(selectitem.LeaveToDate),
                        Type: 'DXP'
                    }
                    ASOFT.helper.post(url, data, function (data) {
                        if (data.length > 0) {
                            var FromWorkingDate = data[0].FromWorkingDate.split('-');
                            var ToWorkingDate = data[0].ToWorkingDate.split('-');
                            selectitem.OldShiftID = data[0].ShiftID;
                            selectitem.set('OldShiftID', data[0].ShiftID);
                            selectitem.FromWorkingDate = kendo.format("{0}/{1}/{2}", FromWorkingDate[2], FromWorkingDate[1], FromWorkingDate[0]);
                            selectitem.ToWorkingDate = kendo.format("{0}/{1}/{2}", ToWorkingDate[2], ToWorkingDate[1], ToWorkingDate[0]);
                            selectitem.IsNextDay = data[0].IsNextDay;
                            if (selectitem.IsNextDay == 1) {
                                $(grid.select()).find("input#CbGridEdit_IsNextDay[type='checkbox']").prop("checked", "checked");
                            } else {
                                $(grid.select()).find("input#CbGridEdit_IsNextDay[type='checkbox']").prop("checked", "");
                            }
                        }
                        else {
                            selectitem.OldShiftID = '';
                            selectitem.set('OldShiftID', '');
                            selectitem.FromWorkingDate = '';
                            selectitem.ToWorkingDate = '';
                            selectitem.IsNextDay = 0;
                            $(grid.select()).find("input#CbGridEdit_IsNextDay[type='checkbox']").prop("checked", "");
                        }
                    });
                }
                grid.refresh();
            }
        }
    });

    if ($('#isInherit').val() == 'True') {
        $('#BtnSave').unbind();
        $("#BtnSave").kendoButton({
            "click": CustomBtnSave_Click,
        });

        grid.hideColumn(grid.columns.length - 1);
        grid.unbind("dataBound");
        grid.bind("dataBound", function (e) {
            var dataSource = this.dataSource._data;
            $(dataSource).each(function () {
                if (this.LeaveToDate && this.LeaveFromDate && this.EmployeeID && this.AbsentTypeID) {
                    var diff = Date.parse(changeDate(this.LeaveToDate)) - Date.parse(changeDate(this.LeaveFromDate));
                    if (diff >= 0) {
                        //var hours = diff / (1000 * 60 * 60);
                        //var day = (hours / 24);
                        //day = day.toString().split('.')[0] * 8;
                        //var hour = ((hours % 24) + day);//(hours % 24) > 8 ? (8 + day) : ((hours % 24) + day);
                        //this.TotalTime = parseFloat(hour).toFixed(2);
                        var data1 = {
                            EmployeeID: this.EmployeeID,
                            FromDate: changeDate(this.LeaveFromDate),
                            ToDate: changeDate(this.LeaveToDate),
                            absentTypeID: this.AbsentTypeID
                        }
                        var totaltime = 0;
                        ASOFT.helper.postTypeJson("/HRM/OOF2010/GetTotalTime", data1, function (data1) {
                            totaltime = kendo.parseFloat(data1);
                        });
                        this.TotalTime = formatDecimal(totaltime, 1);
                    }
                }
            });
            var columnIndex = this.wrapper.find(".k-grid-header [data-field=" + "TotalTime" + "]").index();
            var row = e.sender.tbody.children().children()[columnIndex];
            $(row).text(dataSource[0].TotalTime);
        });
        var columns = grid.columns;
        var name = 'GridEditOOT2010';
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
        gridName: 'GridEditOOT2010',
        inputID: 'autocomplete-box',
        autoSuggest: false,
        serverFilter: true,
        NameColumn: "EmployeeID",
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.container.parent().css('background', '')
            selectedRowItem.model.set("EmployeeID", dataItem.EmployeeID);
            selectedRowItem.model.set("EmployeeName", dataItem.EmployeeName);
            selectedRowItem.model.set("TimeAllowance", dataItem.TimeAllowance);
            selectedRowItem.model.set("OffsetTime", dataItem.OffsetTime);

            //if (selectedRowItem.model.EmployeeID && selectedRowItem.model.LeaveFromDate && selectedRowItem.model.LeaveToDate) {
            //    var url = "/HRM/OOF2010/LoadDataShift";
            //    var data = {
            //        EmployeeID: selectedRowItem.model.EmployeeID,
            //        fromDate: selectedRowItem.model.LeaveFromDate,
            //        toDate: selectedRowItem.model.LeaveToDate
            //    }
            //    ASOFT.helper.post(url, data, function (data) {
            //        if (data) {
            //            if (data.length > 1 || data[0].ShiftID == '') {
            //                ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000033')], null);
            //                selectedRowItem.model.set("ShiftID", null);
            //            } else {
            //                ASOFT.form.clearMessageBox($('#sysScreenID').val())
            //                selectedRowItem.model.set("ShiftID", data[0].ShiftID);
            //                //selectitem.ShiftID = data[0].ShiftID;                       
            //            }
            //        }
            //    });
            //}
        }
    });
})


function CustomerCheck() {
    ASOFT.form.clearMessageBox();
    var grid = $('#GridEditOOT2010').data('kendoGrid');

    var rowList = grid.tbody.children();
    $(rowList).removeAttr('style');

    var columns = grid.columns;
    var data = grid.dataSource.data();
    var check = false;


    $(grid.tbody).find('td').removeClass('asf-focus-input-error');

    var indexLeaveFromDate = null;
    var indexLeaveToDate = null;
    $.each(columns, function (index, element) {
        if (element.field == "LeaveFromDate") {
            indexLeaveFromDate = index;
        }
        if (element.field == "LeaveToDate") {
            indexLeaveToDate = index;
        }
    });

    var check1 = false;
    var check2 = false;
    $(grid.tbody).find("tr").each(function (index, element) {

        var rowIndex = $(element).parent().index();
        var cellIndex = $(element).index();

        var leaveFromDate = data[cellIndex].LeaveFromDate;
        var leaveToDate = data[cellIndex].LeaveToDate;


        var diff = Date.parse(changeDate(leaveToDate)) - Date.parse(changeDate(leaveFromDate));
        if (diff <= 0) {
            $(element.children[indexLeaveFromDate]).addClass('asf-focus-input-error');
            $(element.children[indexLeaveToDate]).addClass('asf-focus-input-error');
            check1 = true;
        }

        if ($('#Day').val()) {

            var dt = new Date();
            dt = new Date(dt.getFullYear(), dt.getMonth(), dt.getDate());
            var dt1 = new Date(Date.parse(changeDate1(leaveFromDate)));

            dt1 = new Date(dt1.setDate(dt1.getDate() + parseInt($('#Day').val())));

            if (dt > dt1) {
                $(element.children[indexLeaveFromDate]).addClass('asf-focus-input-error');
                check2 = true;
            }
        }
    });

    var array1 = [];
    if (check1) {
        array1.push(ASOFT.helper.getMessage('OOFML000022'));
        //ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000022')], null);
    }
    if (check2) {
        array1.push(ASOFT.helper.getMessage('OOFML000051').f($('#Day').val()));
        //ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000022')], null);
    }

    check = (check1 || check2);
    if (check) {
        ASOFT.form.displayMultiMessageBox(id, 1, array1);
        array1 = [];
    }
    else {
        //var tempEmp = [];
        //var tempKey = [];

        for (var i = 0; i < data.length; i++) {
            var empID = data[i].EmployeeID;
            for (var j = i + 1; j < data.length; j++) {
                if (empID == data[j].EmployeeID) {
                    var iLeaveFromDate = Date.parse(changeDate(data[i].LeaveFromDate));
                    var iLeaveToDate = Date.parse(changeDate(data[i].LeaveToDate));

                    var jLeaveFromDate = Date.parse(changeDate(data[j].LeaveFromDate));
                    var jLeaveToDate = Date.parse(changeDate(data[j].LeaveToDate));

                    var num = 0;
                    if (iLeaveFromDate >= jLeaveFromDate && iLeaveFromDate <= jLeaveToDate) {
                        $($($('#GridEditOOT2010 .k-grid-content tr')[i]).children()[indexLeaveFromDate]).addClass('asf-focus-input-error')
                        $($($('#GridEditOOT2010 .k-grid-content tr')[i]).children()[indexLeaveToDate]).addClass('asf-focus-input-error')
                        num = 1;
                    }

                    if (jLeaveFromDate >= iLeaveFromDate && jLeaveFromDate <= iLeaveToDate) {
                        $($($('#GridEditOOT2010 .k-grid-content tr')[j]).children()[indexLeaveFromDate]).addClass('asf-focus-input-error')
                        $($($('#GridEditOOT2010 .k-grid-content tr')[j]).children()[indexLeaveToDate]).addClass('asf-focus-input-error')
                        num = 2;
                    }

                    if (num > 0) {
                        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000021')], null);
                        check = true;
                    }
                }
            }
        }

        // Reset data
        tempCheckAllDataChange = [];
        if (!check) {
            $.each(data, function (key, value) {
                //var index = $.inArray(value.EmployeeID, tempEmp);
                //if (index === -1) {
                //    tempEmp.push(value.EmployeeID);
                //    tempKey.push({
                //        LeaveFromDate: value.LeaveFromDate,
                //        LeaveToDate: value.LeaveToDate
                //    });
                //} else if (index != -1) {
                //    var tempLeaveFromDate = Date.parse(changeDate(tempKey[index].LeaveFromDate));
                //    var tempLeaveToDate = Date.parse(changeDate(tempKey[index].LeaveToDate));

                //    var vLeaveFromDate = Date.parse(changeDate(value.LeaveFromDate));
                //    var vLeaveToDate = Date.parse(changeDate(value.LeaveToDate));

                //        var num = 0;
                //        if (tempLeaveFromDate <= vLeaveFromDate && vLeaveFromDate <= tempLeaveToDate) {
                //            $($($('#GridEditOOT2010 .k-grid-content tr')[key]).children()[indexLeaveFromDate]).addClass('asf-focus-input-error')
                //            num = 1;
                //        }

                //        if (tempLeaveFromDate <= vLeaveToDate && vLeaveToDate <= tempLeaveToDate) {
                //            $($($('#GridEditOOT2010 .k-grid-content tr')[key]).children()[indexLeaveToDate]).addClass('asf-focus-input-error')
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
                    EmployeeID: value.EmployeeID ? value.EmployeeID : "",
                    ShiftID: value.ShiftID ? value.ShiftID : "",
                    LeaveFromDate: kendo.toString(kendo.parseDate(value.LeaveFromDate, "dd/MM/yyyy HH:mm"), "s").split('T').join(' '),
                    LeaveToDate: kendo.toString(kendo.parseDate(value.LeaveToDate, "dd/MM/yyyy HH:mm"), "s").split('T').join(' ')
                });

            });
        }
        if (!check) {
            var Url = "/HRM/OOF2010/CheckAllDataChange";
            var data = tempCheckAllDataChange;
            ASOFT.helper.postTypeJson(Url, data, CheckAllDataChangeSuccess);
            check = isCheckAllDataChange;
            isCheckAllDataChange = false;
        }

        if (!check) {
            // Kiểm tra thời gian vào làm, nghỉ làm, thử việc của nhân viên
            var sendData = tempCheckAllDataChange;
            var Url = "/HRM/OOF2010/CheckTimeStatus";
            ASOFT.helper.postTypeJson(Url, sendData, CheckTimeStatusSuccess);
            check = isTimeStatusProblem;
            isTimeStatusProblem = false;
        }
    }
    return check;
}

function CheckAllDataChangeSuccess(result) {
    isCheckAllDataChange = result.isChecked;
    //false là data  có giá trị, và ngược lại;
    var listCheck = result.list;
    var rowList = $('#GridEditOOT2010').data('kendoGrid').tbody.children();
    var columnIndexEmployeeID = $('#GridEditOOT2010').data('kendoGrid').wrapper.find(".k-grid-header [data-field=" + "EmployeeID" + "]").index();
    var columnIndexLeaveFromDate = $('#GridEditOOT2010').data('kendoGrid').wrapper.find(".k-grid-header [data-field=" + "LeaveFromDate" + "]").index();
    var columnIndexLeaveToDate = $('#GridEditOOT2010').data('kendoGrid').wrapper.find(".k-grid-header [data-field=" + "LeaveToDate" + "]").index();

    if (isCheckAllDataChange) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage('OOFML000017')], null);
        for (var i = 0; i < rowList.length; i++) {
            for (var j = 0; j < listCheck.length; j++) {
                var row = $(rowList[i]);
                if (row.children()[columnIndexEmployeeID].textContent.trim() == listCheck[j].EmployeeID &&
                    (row.children()[columnIndexLeaveFromDate].textContent + ':00') == listCheck[j].LeaveFromDate &&
                    (row.children()[columnIndexLeaveToDate].textContent + ':00') == listCheck[j].LeaveToDate) {

                    //row.children()[columnIndexEmployeeID].addClass('asf-focus-input-error');
                    //$(row.children()[columnIndexLeaveFromDate]).addClass('asf-focus-input-error');
                    //$(row.children()[columnIndexLeaveToDate]).addClass('asf-focus-input-error');
                    $(row).css('background', 'yellow');
                    break;
                }
            }
        }
    }
}

/**
 * Kiểm tra trùng thời gian xin nghỉ phép
 * @param {} result 
 * @returns {} 
 * @since [Văn Tài] Created [07/12/2017]
 */
function CheckTimeStatusSuccess(result) {
    isTimeStatusProblem = result.isChecked;
    //    isTimeStatusProblem
    var rowList = $('#GridEditOOT2010').data('kendoGrid').tbody.children();
    var listCheck = result.list;
    var columnIndexEmployeeID = $('#GridEditOOT2010').data('kendoGrid').wrapper.find(".k-grid-header [data-field=" + "EmployeeID" + "]").index();
    var columnIndexLeaveFromDate = $('#GridEditOOT2010').data('kendoGrid').wrapper.find(".k-grid-header [data-field=" + "LeaveFromDate" + "]").index();
    var columnIndexLeaveToDate = $('#GridEditOOT2010').data('kendoGrid').wrapper.find(".k-grid-header [data-field=" + "LeaveToDate" + "]").index();

    if (isTimeStatusProblem) {

        var message_array = [];
        for (var index = 0; index < listCheck.length; index++) {
            var message = ASOFT.helper.getMessage(listCheck[index].MessageID);

            if (listCheck[index].Params.length == 1) message = message.format(listCheck[index].Params[0]);
            if (listCheck[index].Params.length == 2) message = message.format(listCheck[index].Params[0], listCheck[index].Params[1]);
            if (listCheck[index].Params.length == 3) message = message.format(listCheck[index].Params[0], listCheck[index].Params[1], listCheck[index].Params[2]);

            message_array.push(message);
        }

        for (var i = 0; i < rowList.length; i++) {
            for (var j = 0; j < listCheck.length; j++) {
                var row = $(rowList[i]);
                if (row.children()[columnIndexEmployeeID].textContent.trim() == listCheck[j].EmployeeID &&
                    (row.children()[columnIndexLeaveFromDate].textContent) == format_date(new Date(listCheck[j].LeaveFromDate)) &&
                    (row.children()[columnIndexLeaveToDate].textContent) == format_date(new Date(listCheck[j].LeaveToDate))) {
                    $(row).css('background', 'yellow');
                    break;
                }
            }
        }

        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), message_array, null);
    }
}


OOF2011 = new function () {

    this.OpenApprovePreson = function (combo, num) {
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
        list.push(this.AddList("Type", "DXP"));
        list.push(this.AddList("Num", num));
        list.push(this.AddList("ApprovePersonID", array));

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

function changeDate(data) {
    var date = data.split(" ");
    var dateformat = date[0].split("/");
    var dateformat = dateformat[2] + "/" + dateformat[1] + "/" + dateformat[0] + " " + date[1];
    return dateformat;
}

function changeDate1(data) {
    var date = data.split(" ");
    var dateformat = date[0].split("/");
    var dateformat = dateformat[2] + "/" + dateformat[1] + "/" + dateformat[0];
    return dateformat;
}
function CustomRead() {
    var ct = [];
    ct.push($("#APK").val());
    ct.push($("#isInherit").val());
    return ct;
}

function CustomBtnSave_Click() {
    var url = "/GridCommon/InsertPopupMasterDetail/" + module + "/" + id;
    //action = 3;
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
    var grid = $('#GridEditOOT2010').data('kendoGrid');
    var item = grid._data;

    var employee = '';
    //var i = 0; 
    //while (i < item.length-1) {
    //    if (i != 0) {
    //        employee += ',';
    //    }
    //    if (item[i].EmployeeID) {
    //        employee +=item[i].EmployeeID;
    //    }
    //    i++;
    //}


    url = '/PopupSelectData/Index/HRM/OOF2004?DepartmentID=' + departmentID + '&SectionID=' + sectionID + '&SubsectionID=' + subsectionID + '&ProcessID=' + processID + '&EmployeeID=' + employee + '&Type=DXP';
    ASOFT.asoftPopup.showIframe(url, {});
}

function receiveResult(result) {
    ASOFT.form.clearMessageBox();
    var grid = $('#GridEditOOT2010').data('kendoGrid');
    $(grid.select()).css('background', '');
    var selectedItem = grid.dataItem(grid.select());
    selectedItem.set('EmployeeID', result["EmployeeID"]);
    selectedItem.set('EmployeeName', result["EmployeeName"]);
    selectedItem.set('TimeAllowance', result["TimeAllowance"]);
    selectedItem.set('OffsetTime', result["OffsetTime"]);

    grid.refresh();
}

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0) {
        var url = "/HRM/OOF9000/LoadLastKey";
        var data = {
            table: 'OOT2010',
            type: 'DXP',
            id: idFields
        };

        ASOFT.helper.post(url, data, function (data) {
            $('#ID').val(data.ID);
            $('#LastKey').val(data.LastKey);
            $('#LastKeyAPK').val(data.LastKeyAPK);
            $('#FormStatus').val(isStatus);
            $('#TypeName').val("DXP");
            apk = data.apk;
            idFields = data.ID;
        });

        var grid = window.parent.$('#GridOOT9000').data('kendoGrid');
        if (grid) {
            grid.dataSource.read();
        }
        if (action == 1) {
            sendMail();
            var grid = $("#GridEditOOT2010").data("kendoGrid");
            grid.dataSource.data([]);
            grid.addRow();
            //grid.dataSource.add({ EmployeeID: "" });
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
                table: 'OOT2010',
                type: 'DXP',
                id: idFields
            };

            ASOFT.helper.post(url, data, function (data) {
                $('#ID').val(data.ID);
                $('#LastKey').val(data.LastKey);
                $('#LastKeyAPK').val(data.LastKeyAPK);
                $('#FormStatus').val(isStatus);
                $('#TypeName').val("DXP");
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

// fix css khi click vào nút chọn giờ của datetimepicker trên grid
function Openview() {
    $('#LeaveFromDate_timeview').css({ "overflow": "scroll", "height": "150px" })
    $('#LeaveToDate_timeview').css({ "overflow": "scroll", "height": "150px" })
}


////load data for combo Shift
//function openCboShiftID(e) {
//    var index = e.sender.wrapper.parent().parent().children()[0].textContent;
//    var grid = $('#GridEditOOT2010').data('kendoGrid');
//    var selectitem = grid.dataItem(grid.select(index - 1));

//    var url = "/HRM/OOF2010/LoadDataShift";
//    var data = {
//        EmployeeID: selectitem.EmployeeID,
//        fromDate: selectitem.LeaveFromDate,
//        toDate: selectitem.LeaveToDate
//    }
//    ASOFT.helper.post(url, data, function (data) {
//        if (data)
//            e.sender.setDataSource(data);
//    });

//}

function formatDecimal(value, num) {
    var format = null;
    switch (num) {
        case 1:
            format = ASOFTEnvironment.NumberFormat.KendoAbsentDecimalsFormatString;
            break;
    }
    return kendo.toString(value, format);

}

function CustomerConfirm() {
    if (ASOFTEnvironment.CustomerIndex.MEIKO == "True") {
        var grid = $('#GridEditOOT2010').data('kendoGrid');
        var isShiftID = true;
        grid.dataSource._data.forEach(function (e) {
            if (!e.ShiftID) {
                isShiftID = false;
                return;
            }
        });

        var msgDebts = {
            Status: isShiftID ? 0 : 1,
            Message: 'OOFML000048'
        }
        return msgDebts;
    } else {
        var msgDebts = {
            Status: 0,
            Message: ''
        }
        return msgDebts;
    }
}

function onCheckGridEdit(grid, key) {
    var chkbox = $(grid.select()).find("input#CbGridEdit_" + key + "[type='checkbox']");
    var data = grid.dataItem(grid.select());
    if (key == 'IsValid') {
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

function format_date(date) {
    var year = date.getFullYear();
    var month = (1 + date.getMonth()).toString();
    month = month.length > 1 ? month : '0' + month;
    var day = date.getDate().toString();
    day = day.length > 1 ? day : '0' + day;
    var hours = date.getHours().toString();
    hours = hours.length > 1 ? hours : '0' + hours;
    var minutes = date.getMinutes().toString();
    minutes = minutes.length > 1 ? minutes : '0' + minutes;

    return day + '/' + month + '/' + year + ' ' + hours + ":" + minutes;
}