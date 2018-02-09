﻿//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     23/12/2015      Quang Hoàng         Tạo mới
//####################################################################

var isClose = 0; //Toàn Thiện cập nhật, kiểm soát tình trạng close
var id = $("#sysScreenID").val();
var module = $("#module").val();
var url = null;
var urlupdate = null;
var unique = null;
var action = 0;
var checkunique = 0;
var defaultViewModel = {};
var tbPopup = $("#table").val();
var isUpdate = false;
var updateSuccess = 0;
var fileUploaded = {};
var noClear = null;
var rowNumber = {};
var tableName = [];
var listAdd = {};
var checkInListGrid = {};

function ReadGridEdit() {
    var datamaster = {};
    var keyData = [];
    var valueData = [];
    var tbch = this.url.split('?')[1].split('=')[1];
    //var isUpdate = $("#isUpdate").val();
    //if (isUpdate == "True") {
    //    var key = Array();
    //    var value = Array();


    //    datamaster["args.key"] = key;
    //    datamaster["args.value"] = value;

    //    if (pkch != null) {
    //        key.push(pkch, tbch);
    //        value.push(pk);
    //        datamaster["args.key"] = key;
    //        datamaster["args.value"] = value;
    //    }
    //}
    //var systemInfo = Array();
    //systemInfo.push(module);
    //systemInfo.push(tbch);
    //systemInfo.push(tbch);
    var data = ASOFT.helper.dataFormToJSON(id);
    datamaster["Module_Popup"] = module;
    datamaster["Table_Popup"] = tbch;
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

    var isUpdate = $("#isUpdate").val();
    if (isUpdate == "True") {
        $.each(data, function (key, value) {
            if (key != "item.Data" && key != "item.TypeCheckBox" && key != "Unique" && key.indexOf("_input") == -1) {
                if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList" && key.indexOf("listRequired") == -1 && key.indexOf("tableNameEdit") == -1) {
                    var vl = Array();
                    if (value == "false")
                        value = "0";
                    if (value == "true")
                        value = "1";
                    keyData.push(key);
                    valueData.push(value);
                }
            }
        })

        datamaster["args.keyData"] = keyData;
        datamaster["args.valueData"] = valueData;
    }

    var systemInfo = Array();
    systemInfo.push(module);
    systemInfo.push(tbch);
    datamaster["args.systemInfo"] = systemInfo;

    if (typeof CustomRead === 'function') {
        datamaster["args.custormer"] = CustomRead(tbch);
    }

    return datamaster;
}

$(document).ready(function () {
    var urlPopup = window.location.href;
    var para = urlPopup.split('?')[1];
    var vlPara = para != null ? para.split('&') : "";
    for (var h = 0; h < vlPara.length; h++) {
        if (vlPara[h].toUpperCase().indexOf('NOUPDATE') != -1) {
            var noUpdate = vlPara[h].split('=')[1];
            if (noUpdate == "1") {
                $("#Save").data("kendoButton").enable(false);
                $("#Close").unbind();
                $("#Close").kendoButton({
                    "click": ASOFT.asoftPopup.hideIframe
                });
            }
        }
    }

    var isNumberic = $(":input[type='text'][isnumberic='True']");
    $(isNumberic).each(function () {
        $("#" + this.id).val(formatConvertCommon(kendo.parseFloat($("#" + this.id).val())));
        $("#" + this.id).keydown(function (e) { keydowCommon(e, this) });
        $("#" + this.id).focusout(function (e) {
            var value = $(this).val();
            value = formatConvertCommon(kendo.parseFloat(value));
            $(this).val(value);
        });
    })

    var iprequaird = $(":input[type='text'][requaird='0']");
    $(iprequaird).each(function () {
        $(this).attr("data-val-required", "The field is required.");
    })

    var requairdSelect = $("select[requaird='0']");
    $(requairdSelect).each(function () {
        $(this).attr("data-val-required", "The field is required.");
    })

    var ip = $(":input[type='text']");
    $(ip).each(function () {
        $(this).attr("name", this.id);

        regular = $(this).attr("regular");
        message = $(this).attr("message");

        $(this).attr("data-val-regex-pattern", regular);
        $(this).attr("data-val-regex", message);
    })

    var multiSelect = $("select[data-role='multiselect']");
    $(multiSelect).each(function () {
        $(this).attr("name", this.id);

        regular = $(this).attr("regular");
        message = $(this).attr("message");

        $(this).attr("data-val-regex-pattern", regular);
        $(this).attr("data-val-regex", message);
    })

    var rdo = $(":input[type='radio']");
    $(rdo).each(function () {
        $(this).attr("name", this.id);
    })

    var tArea = $(".asf-textarea");
    $(tArea).each(function () {
        $(this).attr("name", this.id);

        regular = $(this).attr("regular");
        message = $(this).attr("message");

        $(this).attr("data-val-regex-pattern", regular);
        $(this).attr("data-val-regex", message);
    })

    var data = ASOFT.helper.dataFormToJSON(id);
    var listCombobox = [];
    if (data["CheckInList"] != undefined) {
        if (jQuery.type(data["CheckInList"]) === "string") {
            listCombobox.push(data["CheckInList"]);
        }
        else {
            listCombobox = data["CheckInList"];
        }
    }
    for (var i = 0; i < listCombobox.length; i++) {
        var isR = $("#" + listCombobox[i]).data("kendoComboBox").element.attr("readOL");
        if (isR == "True") {
            $("#" + listCombobox[i]).data("kendoComboBox").readonly(true);
        }
    }

    url = $("#urladd").val();
    urlupdate = $("#urlupdate").val();

    var dt = ASOFT.helper.dataFormToJSON(id);

    if (dt.Unique !== undefined) {
        unique = {};
        if (jQuery.type(dt.Unique) === "string") {
            unique[dt.Unique] = dt[dt.Unique];
        }
        else {
            $.each(dt.Unique, function (index, value) {
                unique[value] = dt[value];
            });
        }
    }
    refreshModel();

    $(".btnOpenSearch").bind("focusin", btnOpenSearchFocus);

    //Lưới 1 bảng
    if (dt["tableNameEdit"]) {
        if (jQuery.type(dt["tableNameEdit"]) === "string") {
            tableName.push(dt["tableNameEdit"]);
        }
        else {
            tableName = dt["tableNameEdit"];
        }

        if (tableName.length > 1) {
            $.each(tableName, function (index, value) {
                rowNumber[value] = 0;
                var idgrid = "#GridEdit" + value;
                var grid = $(idgrid).data('kendoGrid');
                if (grid) {
                    grid.bind('dataBound', function (e) {
                        rowNumber[value] = 0;
                        //if (temprs != tablevalueName.length) {
                        //    refreshGrid1(value);
                        //    temprs++;
                        //}
                        if (listAdd[value] == undefined) {
                            listAdd[value] = grid.dataSource._data[0];
                        }

                        $(grid.tbody).find('td').on("keyup", function (e) {
                            if (e.keyCode == 118) {
                                if (typeof parent.GetCheckConfirm === "function") {
                                    if (parent.GetCheckConfirm() == 0) {
                                        var maxRows = grid.dataSource.data().length;
                                        grid.addRow();
                                        var prevrow = grid.tbody.find('tr').eq(maxRows);
                                        grid.select(prevrow);
                                    }
                                }
                                else {
                                    var maxRows = grid.dataSource.data().length;
                                    grid.addRow();
                                    var prevrow = grid.tbody.find('tr').eq(maxRows);
                                    grid.select(prevrow);
                                }
                            }
                        });
                    });
                }
            })
        }
        else {
            var idgrid = "#GridEdit" + tableName[0];
            var grid = $(idgrid).data('kendoGrid');
            rowNumber[tableName[0]] = 0;
            if (grid) {
                grid.bind('dataBound', function (e) {
                    rowNumber[tableName[0]] = 0;
                    //if (temprs < 1) {
                    //    refreshGrid1(tableName[0]);
                    //    temprs++;
                    //}
                    if (listAdd[tableName[0]] == undefined && grid.dataSource._data.length > 0) {
                        var dataItem = grid.dataSource._data[0];
                        $.each(dataItem, function (key, value) {
                            listAdd[key] = value;
                        })
                    }
                })
                $(grid.tbody).on("keyup", "td", function (e) {
                    if (e.keyCode == 118) {
                        if (typeof parent.GetCheckConfirm === "function") {
                            if (parent.GetCheckConfirm() == 0) {
                                var maxRows = grid.dataSource.data().length;
                                grid.addRow();
                                var prevrow = grid.tbody.find('tr').eq(maxRows);
                                grid.select(prevrow);
                            }
                        }
                        else {
                            var maxRows = grid.dataSource.data().length;
                            grid.addRow();
                            var prevrow = grid.tbody.find('tr').eq(maxRows);
                            grid.select(prevrow);
                        }
                    }
                });
            }
        }
    }
})


function refreshModel() {
    defaultViewModel = ASOFT.helper.dataFormToJSON(id);

    var cb = $("input[type='checkbox']");
    $(cb).each(function () {
        var temp = $(this).is(':checked');
        var id = $(this).attr("id");
        if (temp) {
            defaultViewModel[id] = "1";
        }
        else {
            defaultViewModel[id] = "0";
        }
    })
}

//Mở chức năng mở rộng
function ShowMoreFrame(e) {
    $('.sub-MenuMore').toggleClass('asf-disabled-visibility');
    ASOFT.form.clearMessageBox();
    var url = $(e).children().attr('id');
    url = '/plugin/' + url.replace('Controller', '') + '/index';

    var datamaster = ASOFT.helper.dataFormToJSON(id);
    var list = new Array();
    $.each(datamaster, function (key, value) {
        if (key.indexOf("_input") == -1) {
            var item = new Object();
            list.push(AddList(key, value));
        }
    });

    ASOFT.asoftPopup.showIframeHttpPost(url, list);
};
function popupPluginClose() {
    ASOFT.asoftPopup.hideIframe();
};
$("#MoreMenu").click(function () {
    $('.sub-MenuMore').toggleClass('asf-disabled-visibility');
})
//Kết thúc chức năng mở rộng

//function popupClose_Click(event) {
//    parent.popupClose();
//}

function SaveCopy_Click() {
    isUpdate = false;
    action = 2;
    save(url);
}

function SaveNew_Click() {
    isUpdate = false;
    action = 1;
    save(url);
}

function SaveUpdate_Click() {
    isUpdate = true;
    action = 3;
    checkunique = 1;
    save(urlupdate);
}

function isInvalidGrid(data) {
    var isError = false;
    $.each(tableName, function (index, value) {
        var grid = $("#GridEdit" + value).data('kendoGrid');
        if (grid) {
            $("#GridEdit" + value).removeClass('asf-focus-input-error');
            ASOFT.asoftGrid.editGridRemmoveValidate(grid);

            var listRequired = [];
            listRequired = data["listRequired" + value];

            if (grid._group) {
                if (ASOFT.asoftGrid.editGridValidateNoEditGroup(grid, listRequired)) {
                    var msg = ASOFT.helper.getMessage("00ML000060");
                    ASOFT.form.displayError("#" + id, msg);
                    isError = true;
                }
            }
            else {
                if (ASOFT.asoftGrid.editGridValidateNoEdit(grid, listRequired)) {
                    var msg = ASOFT.helper.getMessage("00ML000060");
                    ASOFT.form.displayError("#" + id, msg);
                    isError = true;
                }
            }
        }
    })
    return isError;
}

function isInlistGrid(data) {
    var iLgrid = false;
    var listtable = tableName;
    var message = [];
    $('#' + id + ' .asf-focus-input-error').removeClass('asf-focus-input-error');
    $('#' + id + ' .asf-focus-combobox-input-error').removeClass('asf-focus-combobox-input-error');

    $.each(listtable, function (index, value) {
        var grid = $("#GridEdit" + value).data('kendoGrid');
        if (grid) {
            $("#GridEdit" + value).removeClass('asf-focus-input-error');
            ASOFT.asoftGrid.editGridRemmoveValidate(grid);

            for (i = 0; i < grid.dataSource.data().length; i++) {
                var itemGrid = grid.dataSource.at(i);
                $.each(checkInListGrid, function (key, value) {
                    var listchar = key.split(',');
                    if (listchar[0] == itemGrid.uid) {
                        if (value == 1) {
                            var tr = grid.tbody.find('tr')[i];
                            $($(tr).find('td')[parseInt(listchar[1])]).addClass('asf-focus-input-error');
                            iLgrid = true;
                            message.push(ASOFT.helper.getMessage('00ML000064').f($($(grid.thead).find('th')[parseInt(listchar[1])]).attr("data-title")));
                        }
                    }
                })
            }
        }
    })
    if (message.length > 0) {
        ASOFT.form.displayMessageBox("form#" + id, message);
    }
    return iLgrid;
}

function save(url) {
    //if (ASOFT.form.checkRequired(id)) {
    //    return;
    //}
    var data = ASOFT.helper.dataFormToJSON(id);
    var CheckInList = [];
    if (data["CheckInList"] != undefined) {
        if (jQuery.type(data["CheckInList"]) === "string") {
            CheckInList.push(data["CheckInList"]);
        }
        else {
            CheckInList = data["CheckInList"];
        }
    }
    if (ASOFT.form.checkRequiredAndInList(id, CheckInList)) {
        return;
    }

    if (tableName.length > 0) {
        if (isInvalidGrid(data)) {
            return false;
        }

        if (isInlistGrid(data)) {
            return false;
        }
    }

    if (typeof CustomerCheck === "function") {
        Check = CustomerCheck();
        if (Check) {
            return false;
        }
    }

    var Confirm;

    if (typeof CustomerConfirm === "function") {
        Confirm = CustomerConfirm();
        if (Confirm.Status != 0) {
            ASOFT.dialog.confirmDialog(Confirm.Message,
                function () {
                    save1(url);
                },
                function () {
                    return false;
                });
        }
        else {
            save1(url);
        }
    }
    else {
        save1(url);
    }
}


function save1(url1) {
    var data = ASOFT.helper.dataFormToJSON(id);
    url1 = tableName.length == 0 ? url1 : "/GridCommon/InsertOneTable/" + module + "/" + id + "?isUpdate=" + ($("#isUpdate").val() == "True")

    if (checkunique == 1) {
        if (unique == null) {
            url1 = url1 + "?mode=1";
        }
        else {
            var un = 0;
            var unn = 0;
            $.each(unique, function (key, value) {
                if (unique[key] == data[key]) {
                    unn++;
                }
                un++;
            })
            if (un == unn) {
                url1 = url1 + (tableName.length == 0 ? "?mode=1" : "&mode=1");
            }
            checkunique = 0;
        }
    }


    if (tableName.length == 0) {
        var key1 = Array();
        var value1 = Array();

        if (typeof CustomSavePopupLayout === "function") {
            var customdata = [];
            customdata = CustomSavePopupLayout();
            key1 = customdata[0];
            value1 = customdata[1];
        }
        else {
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
                    if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                        key1.push(key);
                        var vl = Array();
                        if (value == "false")
                            value = "0";
                        if (value == "true")
                            value = "1";
                        vl.push(data[key + "_Content_DataType"], value);
                        value1.push(vl);
                    }
                }
            })
        }


        //TRuyền biến để lưu lịch sử
        var history = [];

        if (typeof parent.GetTableParent === "function") {
            var ParentList = parent.GetTableParent();

            if (ParentList.TBParent != tbPopup) {
                if ($("#isUpdate").val() == "False") {
                    url1 = url1 + "?TBParent=" + ParentList.TBParent + "&ValueParent=" + ParentList.VLParent;
                }
                if ($("#isUpdate").val() == "True") {
                    url1 = url1 + "&TBParent=" + ParentList.TBParent + "&ValueParent=" + ParentList.VLParent;
                    history = getHistoryChange(defaultViewModel, data);
                }
            }
            else {
                if ($("#isUpdate").val() == "True") {
                    history = getHistoryChange(defaultViewModel, data);
                }
            }
        }
        ASOFT.helper.postTypeJson3(url1, { cl: key1, dt: value1, historyChange: history }, onInsertSuccess);
    }
    else {
        var datagridGrid = getDataInsert(data);
        ASOFT.helper.postTypeJson(url1, datagridGrid, onInsertSuccess);
    }

    if (action == 3 && updateSuccess == 1) {
        if (typeof onAfterSave === "function") {
            onAfterSave();
        } else {
            window.parent.location.reload();
        }
    }
}

function getDataInsert(data) {
    var datagrid = [];
    if (typeof CustomInsertPopupMaster === 'function') {
        datagrid = CustomInsertPopupMaster(data);
    }
    else {
        var value1 = {};
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

        //var tableNameCh = [];
        //if (jQuery.type(data["tableNameEdit"]) === "string") {
        //    tableNameCh.push(data["tableNameEdit"]);
        //}
        //else {
        //    tableNameCh = data["tableNameEdit"];
        //}


        $.each(data, function (key, value) {
            if (key != "item.TypeCheckBox" && key != "Unique" && data[key + "_Content_DataType"] != undefined) {
                if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("tableNameEdit") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key.indexOf("CbGridEdit_") == -1) {
                    if (value == "false")
                        value = "0";
                    if (value == "true")
                        value = "1";
                    value1[key] = value;
                }
            }
        })
    }

    if (typeof CustomInsertPopupDetail === 'function') {
        datagrid = CustomInsertPopupDetail(datagrid);
    }
    else {
        $.each(tableName, function (key, value) {
            getListDetail(value, value1, datagrid);
        })
    }
    return datagrid;
}

function getListDetail(tb, master, datagrid) {
    //var data = [];
    getDetail(tb, master, datagrid);
    //var Grid = $('#GridEdit' + tb).data('kendoGrid');
    //if (Grid) {
    //    for (i = 0; i < dt.length; i++) {
    //        if ($("#isUpdate").val() == "True") {
    //            if (dt[i].dirty && dt[i][$("#PKChild" + tb).val()] != null && dt[i][$("#PKChild" + tb).val()] != "")
    //                dt[i].HistoryChange = 1;
    //            else {
    //                if (dt[i][$("#PKChild" + tb).val()] == null || dt[i][$("#PKChild" + tb).val()] == "")
    //                    dt[i].HistoryChange = 0;
    //                else
    //                    dt[i].HistoryChange = 2;
    //            }

    //        }
    //        data.push(dt[i]);
    //    }
    //}
}


function getDetail(tb, master, datagrid) {
    //var dataPost = ASOFT.helper.dataFormToJSON(id);
    Grid = $('#GridEdit' + tb).data('kendoGrid');
    var detail = [];
    if (Grid) {
        if (Grid._group) {
            var dataGroup = Grid.dataSource._data;
            for (var i = 0; i < dataGroup.length; i++) {
                if (dataGroup[i].items) {
                    for (var j = 0; j < dataGroup[i].items.length; j++) {
                        detail.push(dataGroup[i].items[j]);
                    }
                }
            };
        }
        else {
            detail = Grid.dataSource._data;
        }
        for (var i = 0; i < detail.length; i++)
        {
            $.each(master, function (key, value) {
                 detail[i][key] = value;
            })
            datagrid.push(detail[i]);
        }
    }
}

function getHistoryChange(defaultDt, data) {
    var returnDataChange = [];
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox" && key != "Unique") {
            if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList" && key.indexOf("listRequired") == -1 && key.indexOf("tableNameEdit") == -1) {
                var change = null;
                defaultDt[key] = defaultDt[key] != undefined ? defaultDt[key] : "";
                if (value.toString() !== defaultDt[key].toString()) {
                    change = "- '" + id + "." + key + "." + module + "': " + defaultDt[key] + " -> " + value;
                    returnDataChange.push(change);
                }
            }
        }
    })
    return returnDataChange;
}

function AddList(key, value) {
    var item = new Object();
    item.key = key;
    item.value = value;
    return item;
};

function onInsertSuccess(result) {

    if (result.Status == 0) {
        refreshModel();
        if (typeof parent.AddValueCombobox === "function") {
            if (typeof AddValueComboboxCustom === "function") {
                AddValueComboboxCustom(); // set value custom cho thêm nhanh combobox
            }
            else if (localStorage.getItem("IDCommbox") != null) { // nếu k có thì set value mặc định
                localStorage.setItem("ValueCombobox", $("#" + localStorage.getItem("IDCommbox")).val());
            }
            parent.AddValueCombobox();
        }

        switch (action) {
            case 1://save new
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid(tbPopup);
                }
                if (typeof clearfieldsCustomer === "function") {
                    clearfieldsCustomer();
                }
                else
                    clearfields();

                if (tableName.length > 0) {
                    $.each(tableName, function (index, value) {
                        var idgrid = "#GridEdit" + value;
                        var grid = $(idgrid).data('kendoGrid');
                        grid.dataSource.data([]);
                        grid.dataSource.add(listAdd[value]);
                    })
                }
                break;
            case 2://save new
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid(tbPopup);
                }
                break;
            case 3://save copy
                updateSuccess = 1;
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                //refreshModel();
                break;
            case 4:
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid(tbPopup);
                }
                parent.popupClose();
            case 0://save close, Lưu xong và đóng lại  
                window.parent.BtnFilter_Click();
                parent.popupClose();
        }
    }
    else {
        if (result.Message != 'Validation') {
            var msg = ASOFT.helper.getMessage(result.Message);
            if (result.Data) {
                if (typeof result.Data == "object" && result.Data.length > 1) {
                    var s = msg;
                    for (var i = 0; i < result.Data.length ; i++) {
                        var reg = new RegExp("\\{" + i + "\\}", "gm");
                        s = s.replace(reg, result.Data[i]);
                    }
                    msg = s;
                }
                else {
                    msg = kendo.format(msg, result.Data);
                }
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
    if (isClose != 0 && result.Status == 0) {
        parent.popupClose();
    }
    //Kiểm tra có function mở rộng
    if (typeof onAfterInsertSuccess !== 'undefined' && $.isFunction(onAfterInsertSuccess)) {
        onAfterInsertSuccess(result, action);
    }
}

function clearfields() {
    var data = ASOFT.helper.dataFormToJSON(id);
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key.indexOf(noClear) == -1) {
                if ($("#" + key).data("kendoComboBox") != null) {
                    $("#" + key).data("kendoComboBox").value("");
                }
                if ($("#" + key).data("kendoDropDownList") != null) {
                    $("#" + key).data("kendoDropDownList").value("");
                    $("#" + key).data("kendoDropDownList").text("");
                }
                if ($("#" + key).data('kendoNumericTextBox') != null) {
                    $("#" + key).data('kendoNumericTextBox').value('');
                }
                if ($("#" + key).attr("type") != "radio") {
                    $("#" + key).val('');
                }
                $("input[type='text'][disabled='disabled']").val("");
            }
        }
    })
}


//Script combobox
$(document).ready(function () {
    var ListParentChild = {};
    $.each($("input"), function () {
        var TempValue = $("#" + $(this).attr("id") + "_Type_Fields").attr("value");
        if (TempValue == 3 && $(this).data("kendoComboBox") != null && $(this).data("kendoComboBox").element.attr("ParentCombo") != null) {
            OpenComboDynamic($(this).data("kendoComboBox"));//Sự kiện load lần đầu
            var ParentCombo = $(this).data("kendoComboBox").element.attr("ParentCombo");
            var Listparent = ParentCombo.split(',');
            for (i = 0; i < Listparent.length; i++) {
                if (ListParentChild[Listparent[i]] != null) {
                    ListParentChild[Listparent[i]] += $(this).data("kendoComboBox").element.attr("id") + ",";
                } else {
                    ListParentChild[Listparent[i]] = $(this).data("kendoComboBox").element.attr("id") + ",";
                }
            };
        }
    });
    setTimeout(function () {
        $.each(ListParentChild, function (key, value) {//key là parent, value là child
            if ($("#" + key).data("kendoComboBox") != null) {
                $("#" + key).data("kendoComboBox").bind("change", function () {
                    var ListChild = value.split(',');
                    for (i = 0; i < ListChild.length - 1; i++) {
                        $("#" + ListChild[i]).data("kendoComboBox").value("");
                        //$("#" + ListChild[i]).trigger('change');
                    };
                });
            }
        });
    }, 500);
});

function onComboSuccess(result, combo) {
    combo.dataSource.data(result);
    if (result.length == 0) {
        combo.value("");
    }
    if (combo.select() == 0 && combo.element.attr("isGrid") == 1) {
        combo.value("");
    }
};

function onComboSuccessMulti(result, combo) {
    combo.setDataSource([]);
    combo.setDataSource(result);
}

function OpenComboDynamic(combo) {
    if (combo.sender != null) {
        SendFromCombo(combo.sender, "/combobox/ASOFTComboBoxDynamicLoadData");
    }
    else {
        SendFromCombo(combo, "/combobox/ASOFTComboBoxDynamicLoadData");
    }
};

function OpenMultiCheckListDynamic(combo) {
    SendFromCombo(combo, "/combobox/ASOFTMultiCheckListDynamicLoadData")
};

function OpenMultiSelectDynamic(combo) {
    if (combo.sender != null) {
        SendFromCombo(combo.sender, "/combobox/ASOFTComboBoxDynamicLoadData", 1)
    }
    else {
        SendFromCombo(combo, "/combobox/ASOFTComboBoxDynamicLoadData", 1)
    }
};


function SendFromCombo(combo, url, type) {
    var datamaster = ASOFT.helper.dataFormToJSON(id);
    var list = new Array();
    list.push(AddList("sysComboBoxID", combo.element.attr("sysComboBoxID")));
    list.push(AddList("ScreenID", combo.element.attr("ScreenID")));
    list.push(AddList("Module", combo.element.attr("Module")));
    $.each(datamaster, function (key, value) {
        if (key.indexOf("_input") == -1) {
            var item = new Object();
            list.push(AddList(key, value));
        }
    });

    if (combo.element.attr("isGrid") == 1) {
        var tbGridComboBox = combo.element.attr("tableGrid");
        var kendoGrid = $('#GridEdit' + tbGridComboBox).data('kendoGrid');
        var thgrid = $('#GridEdit' + tbGridComboBox).find('th');
        for (i = 0; i < thgrid.length; i++) {
            var columnName = $(thgrid[i]).attr("data-field")
            if (columnName != "" && $(thgrid[i]).attr("data-field") != undefined) {
                var selectitem = kendoGrid.dataItem(kendoGrid.select());
                var dataColumn = selectitem[columnName];
                if (dataColumn == undefined)
                    dataColumn = "";
                list.push(AddList(columnName + "_Grid_Type_Fields", $(kendoGrid.select().find('td')[i]).attr("type_fields")))
                list.push(AddList(columnName + "_Grid_Content_DataType", $(kendoGrid.select().find('td')[i]).attr("content_datatype")))
                list.push(AddList(columnName + "_Grid", dataColumn));
            }
        }
    }


    ASOFT.helper.postTypeJsonComboBox(url, list, combo, type == 1 ? onComboSuccessMulti : onComboSuccess);
};

function AddList(key, value) {
    var item = new Object();
    item.key = key;
    item.value = value;
    return item;
};

function popupClose_Click(event) {
    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                action = 4;
                isClose = 1;
                save(url);
            },
            function () {
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
}

function popupClose_ClickA(event) {
    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                action = 3
                checkunique = 1;
                save(urlupdate);
                //parent.popupClose();
            },
            function () {
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
}


var isDataChanged = function () {
    var dataPost = getFormData();
    var cb = $("input[type='checkbox']");
    $(cb).each(function () {
        var temp = $(this).is(':checked');
        var id = $(this).attr("id");
        if (temp) {
            dataPost[id] = "1";
        }
        else {
            dataPost[id] = "0";
        }
    })
    var equal = isRelativeEqual(dataPost, defaultViewModel);
    return !equal;
};
var getFormData = function () {
    var dataPost = ASOFT.helper.dataFormToJSON(id);
    return dataPost;
};

var KENDO_INPUT_SUFFIX = '_input';
var KENDO_CHECKBOXINLIST = 'CheckInList'
var KENDO_CHECKBOX = 'TypeCheckBox'
// Kiểm tra bằng nhau giữa hai trạng thái của form
var isRelativeEqual = function (data1, data2) {
    if (data1 && data2
        && typeof data1 === "object"
        && typeof data2 === "object") {
        for (var prop in data1) {
            // So sánh thuộc tính của 2 data
            if (!data2.hasOwnProperty(prop)) {
                return false;
            }
            else {
                if (prop.indexOf(KENDO_INPUT_SUFFIX) != -1 || prop.indexOf(KENDO_CHECKBOX) != -1 || prop.indexOf(KENDO_CHECKBOXINLIST) != -1 || typeof data2[prop].valueOf() === "object") {
                    continue;
                }
                // Nếu giá trị hai thuộc tính không bằng nhau, thì data có khác biệt
                if (data1[prop].valueOf() != data2[prop].valueOf()) {
                    return false;
                }
            }
        }
        return true;
    }
    return undefined;
};

function LongDateTime(e) {
    $("#" + e.sender._form.context.id + "_timeview").css("overflow", "scroll");
    $("#" + e.sender._form.context.id + "_timeview").css("height", "300px");
}

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
};


function onImageSuccess(data) {
    //if (data && data.response.counter > 0) {

    //    DRF1001.fieldName = data.response.array[0];
    //}
    var url = $('#UrlAvatar').val() + "?id='" + data.response.ImageLogo + "'&Column=" + data.sender.element[0].id;
    urlImage = url;
    $('#' + id + ' .' + data.sender.element[0].id.split('_')[0] + ' img').attr('src', url);
    $("." + data.sender.element[0].id.split('_')[0] + " .k-progress").css("top", "50px");
}

function onImageUpload(data) {
    if (fileUploaded[data.sender.element[0].id] == undefined)
        fileUploaded[data.sender.element[0].id] = 0;

    if (fileUploaded[data.sender.element[0].id] > 0) {
        $('.k-upload-files .k-file:first').remove();
    }

    fileUploaded[data.sender.element[0].id] = fileUploaded[data.sender.element[0].id] + 1;
}

function btnDeleteImages_Click(e) {
    var id = e.sender.element.context.id.split('-')[1];
    var data = [];
    data.push(id);
    ASOFT.helper.postTypeJson("/GridCommon/DeleteImages", data, function () {
        $($("." + id.split('_')[0]).find('td img')).attr("src", "/Content/Images/noimages.png")
    });
}


function setReload() //hỗ trợ không cho reload lại trang
{
    updateSuccess = 0;
}


function Auto_Change(e) {
    if (typeof Auto_ChangeDynamic === "function") {
        var item = this.dataItem(e.item.index());
        Auto_ChangeDynamic(item);
    }
}


function OpenSearchClick(auto) {
    var autoComplete = $("#" + auto).data("kendoAutoComplete");
    OpenComboDynamic(autoComplete);
    autoComplete.search($("#" + auto).val());
}

function btnOpenSearchFocus() {
    var id = this.id.split('_')[1];
    var autoComplete = $("#" + id).data("kendoAutoComplete");
    OpenComboDynamic(autoComplete);
    autoComplete.search($("#" + id).val());
}

function Priority_Click(idCL, vl) {
    $("#" + idCL).val(vl);
    for (var i = 1; i <= 4; i++) {
        var imgSt = "/Content/Images/";
        imgSt = imgSt + (vl >= i ? "star.png" : "starnone.png");
        $(".st" + idCL + i).attr("src", imgSt);
    }
}

function GetKeyAutomatic(TableID, IDKey) {
    var data = {};
    data.TableID = TableID;
    ASOFT.helper.postTypeJson("/PopupLayout/GetKeyAutomatic", data, function (result) {
        $("#" + IDKey).val(result);
    });
}

function UpdateKeyAutomatic(TableID, Key) {
    var data = {};
    data.TableID = TableID;
    data.Key = Key;
    ASOFT.helper.postTypeJson("/PopupLayout/UpdateLastKeyAccount", data, function () { });
}

function OpenAdd(Src, area, type, e, typeCB) {
    var urlAdd = "/PopupLayout/Index/" + area + "/" + Src;
    if (type == "2") {
        urlAdd = "/PopupMasterDetail/Index/" + area + "/" + Src;
    }

    var idElm = typeCB == 1 ? $(e.parentElement.parentElement).attr("id") : $(e.parentElement.parentElement.parentElement.parentElement.parentElement).attr("id");
    localStorage.setItem("IDCommbox", idElm.split('-')[0]);

    ASOFT.asoftPopup.showIframe(urlAdd, {});
}

function AddValueCombobox() {
    if (localStorage.getItem("IDCommbox") != null) {
        var idComboBox = localStorage.getItem("IDCommbox");
        var cbb = $("#" + idComboBox).data("kendoComboBox");

        if (cbb != null) {
            OpenComboDynamic(cbb);
            $("#" + idComboBox).data("kendoComboBox").value(localStorage.getItem("ValueCombobox"));
        }
        else {
            var cbb = $("#" + idComboBox).data("kendoMultiSelect");
            if (cbb != null)
            {
                OpenMultiSelectDynamic(cbb);
                $("#" + idComboBox).data('kendoMultiSelect').open();
                $("#" + idComboBox).data('kendoMultiSelect').close();
                var vlMulti = $("#" + idComboBox).data('kendoMultiSelect').value();
                var vlMultiAdd = [];
                for (var i = 0; i < vlMulti.length; i++)
                {
                    vlMultiAdd.push(vlMulti[i]);
                }
                vlMultiAdd.push(localStorage.getItem("ValueCombobox"));
                $("#" + idComboBox).data('kendoMultiSelect').value([]);
                $("#" + idComboBox).data('kendoMultiSelect').value(vlMultiAdd);
            }
        }
    }
}


function renderNumber(data, tbRowNum) {
    return ++rowNumber[tbRowNum];
}


function CheckGridEdit(tb, key, tag) {
    posGrid = $('#GridEdit' + tb).data('kendoGrid');
    if (typeof onCheckGridEdit !== 'undefined' && $.isFunction(onCheckGridEdit)) {
        onCheckGridEdit(posGrid, key, tag);
    } else {
        var row = $(tag).parent().closest('tr');
        var data = posGrid.dataItem(row);
        data.set(key, $(tag).prop('checked') ? 1 : 0);
    }
}

function genValueCheckGrid(key, data) {
    if (data[key] == undefined) {
        data[key] = 0;
    }
}


function genDeleteBtn(data, tbGridDelete) {
    return "<a style='cursor: pointer' onclick=deleteDetail_Click(this,'" + tbGridDelete + "') class='asf-i-delete-24 asf-icon-24'><span>Del</span></a>";
}

function deleteDetail_Click(e, tbGridDelete) {
    return deleteItems(e, tbGridDelete);
}

function deleteItems(tagA, tbGridDelete) {
    //remove gridEdit
    posGrid = $('#GridEdit' + tbGridDelete).data('kendoGrid');
    ASOFT.asoftGrid.removeEditRow(tagA, posGrid);
    return false;
}

function LongDateTime(e) {
    $("#" + e.sender._form.context.id + "_timeview").css("overflow", "scroll");
    $("#" + e.sender._form.context.id + "_timeview").css("height", "300px");
}

function Grid_Save(e) {
    if (e.values != null && e.value != "") {
        var keyCombo = "";
        keyCombo = $($(e.container).find('input')[1]).attr("id");
        var combo = ASOFT.asoftComboBox.castName(keyCombo);
        if (combo != undefined) {
            var itemValue = combo.input.val();
            if (itemValue && (itemValue != null || itemValue != "")) {
                if ((combo.selectedIndex == -1 && combo.dataSource._data.length > 0 && combo.input.val() != "") // Có data mà chưa chọn
                    || (combo.selectedIndex == -1 && combo.dataSource._data.length == 0 && combo.input.val() != "")) { // Không có data mà nhập value 
                    checkInListGrid[e.model.uid + "," + e.container[0].cellIndex] = 1;
                }
                else {
                    //$(e.container).removeClass('asf-focus-input-error');
                    checkInListGrid[e.model.uid + "," + e.container[0].cellIndex] = 0;
                }
            }
            else {
                checkInListGrid[e.model.uid + "," + e.container[0].cellIndex] = 0;
            }
        }
    }

    if (typeof Grid_SaveCustom === "function") {
        Grid_SaveCustom(e);
    }
}

var GRID_AUTOCOMPLETE = function (e) {
    var that = {},
        wrapper,
        kWidget,
        searchButton,
        autoComplete,
        dataSource,
        pseudoInput,
        conf,
        posGrid, log = console.log, selectedRowItem;

    function btnSearch_Click(e) {
        var text;
        text = pseudoInput.val();
        if (text == "")
            return;
        AutoCompelete(autoComplete);
        if (autoComplete.dataSource.data().length == 0)
            return;
        e.preventDefault();
        if (text) {
            autoComplete.search(pseudoInput.val());
        }
        pseudoInput.focus();
    }

    function AutoCompelete(combo) {
        if (combo.sender != null) {
            SendAutoCompelete(combo.sender, "/combobox/ASOFTComboBoxDynamicLoadData");
        }
        else {
            SendAutoCompelete(combo, "/combobox/ASOFTComboBoxDynamicLoadData");
        }
    }

    function SendAutoCompelete(combo, url) {
        var datamaster = ASOFT.helper.dataFormToJSON(id);
        var list = new Array();
        list.push(AddList("sysComboBoxID", combo.element.attr("sysComboBoxID")));
        list.push(AddList("ScreenID", combo.element.attr("ScreenID")));
        list.push(AddList("Module", combo.element.attr("Module")));
        $.each(datamaster, function (key, value) {
            if (key.indexOf("_input") == -1) {
                var item = new Object();
                list.push(AddList(key, value));
            }
        });
        list.push(AddList("TxtSearch", pseudoInput.val()));
        if (typeof CustomAutoComplete === "function") {
            list = CustomAutoComplete(list, conf.NameColumn);
        }
        ASOFT.helper.postTypeJsonComboBox(url, list, combo, onAutoCompelete);
    };

    function onAutoCompelete(result, combo) {
        if (result.length > 0) {
            combo.dataSource.data(result);
            if ($('#Cbo' + conf.NameColumn + '-list .k-state-focused').find('div div')[0] != undefined) {
                $('#Cbo' + conf.NameColumn + '-list .k-state-focused').find('div div')[0].remove();
                $('#Cbo' + conf.NameColumn + '-list .k-state-focused').find('div div')[0].remove();
            }
        }
    };

    function autoComplete_Select(e) {
        var i = 0,
            text = $($(e.item).find('div div')[0]).text(),
            dataItem;
        for (; dataItem = dataSource.at(i++) ;) {
            if (dataItem[conf.NameColumn] === text) {
                ////log(dataItem);
                pseudoInput.val(text)
                if (selectedRowItem) {
                    conf.setDataItem(selectedRowItem, dataItem);
                    index = 0;
                    //$('#CboInventoryName-list').remove();
                    autoComplete.setDataSource(backupDataSource);
                    //conf.grid.refresh();
                    ASOFT.asoftGrid.nextCell($(autoComplete.element).closest('td'), conf.gridName, false);
                    tempreturn = 0;
                }
                break;
            }
        }

    }
    var index = 0;
    var isOpen = false;
    var tempreturn = 0;

    function input_keyUp(e) {
        var li, distance, dataItem, i = 0;

        ////log(e.keyCode);
        if (e.keyCode == 9 || e.keyCode == 39) {
            e.keyCode = 13;
        }

        if (e.keyCode === 13) {
            var li = $('#Cbo' + conf.NameColumn + '-list .k-state-focused').find('div div')[0];
            var text = $(li).text();
            //log(text);
            if (text) {
                //log(2);
                //log(autoComplete.dataSource);
                for (; dataItem = autoComplete.dataSource.data()[i++];) {
                    //log(dataItem.InventoryID);
                    if (dataItem[conf.NameColumn] === text) {
                        pseudoInput.val(text)
                        if (selectedRowItem) {
                            index = 0;
                            conf.setDataItem(selectedRowItem, dataItem);
                            autoComplete.setDataSource(backupDataSource);
                            //$('#CboInventoryName-list').remove();
                            //
                            ASOFT.asoftGrid.nextCell($(autoComplete.element).closest('td'), conf.gridName, false);

                            //
                            //autoComplete.close();
                            //isOpen = false;
                            //conf.grid.refresh();;
                            return false;
                        }
                    }
                }
            }
            else {
                searchButton.trigger('click');
            }
            return false;
        }

        if (e.keyCode === 40) {
            $('.k-state-focused').removeClass('k-state-focused');
            index += 1;

            li = autoComplete.ul.children().eq(index);
            li.addClass('k-state-focused');

            distance = li.height() * index;
            //log(distance);
            if (distance > li.height() * 4) {
                //log('bigger' + (index - 4) * li.height());
                //log($('#CboInventoryName_listbox'));
                $('#Cbo' + conf.NameColumn + '_listbox').animate({
                    scrollTop: (index - 4) * li.height()
                }, 5);
            }

            return false;
        }

        if (e.keyCode === 38) {
            $('.k-state-focused').removeClass('k-state-focused');
            index -= 1;

            li = autoComplete.ul.children().eq(index);
            distance = li.height() * index;
            //log(li.position());
            var pos = li.position();
            if (li && li.position && pos.top < 0) {
                $('#Cbo' + conf.NameColumn + '_listbox').animate({
                    scrollTop: (index) * li.height()
                }, 5);
            }
            li.addClass('k-state-focused');
            return false;
        }
    }

    // Override hàm search
    function search(word) {
        var that = this,
        options = that.options,
        ignoreCase = options.ignoreCase,
        separator = options.separator,
        length;

        word = word || that.value();

        that._current = null;

        clearTimeout(that._typing);

        if (separator) {
            word = wordAtCaret(caretPosition(that.element[0]), word, separator);
        }

        length = word.length;

        if (!length && !length == 0) {
            that.popup.close();
        } else if (length >= that.options.minLength) {
            that._open = true;

            that.dataSource.filter({
                value: ignoreCase ? word.toLowerCase() : word,
                operator: options.filter,
                field: options.dataTextField,
                ignoreCase: ignoreCase
            });
        }
    }

    that.config = function (obj) {
        conf = obj;
        posGrid = conf.grid || $('#' + conf.gridName).data('kendoGrid');

        posGrid.bind('edit', function (e) {
            that.start(e);
            selectedRowItem = e;
        });
    }

    var backupDataSource = new kendo.data.DataSource({ data: [] });
    var count = 0;

    that.start = function (rowItem) {
        if ($('body #Cbo' + conf.NameColumn + '-list').length > 1) {
            $('body #Cbo' + conf.NameColumn + '-list')[0].remove();
        }

        var dataItem,
            i = 0,
            backupDataSource = new kendo.data.DataSource({ data: [] });

        autoComplete = $('#Cbo' + conf.NameColumn).data('kendoAutoComplete');
        selectedRowItem = rowItem;
        if (autoComplete) {
            for (; dataItem = autoComplete.dataSource.data()[i++];) {
                backupDataSource.add(dataItem);
            }
            autoComplete.refresh();
            wrapper = $('#' + conf.inputID);
            kWidget = $(wrapper.find('#kendo-native-widget')[0]);
            searchButton = $(wrapper.find('#control-button')[0]);

            dataSource = autoComplete.dataSource;
            pseudoInput = $('#pseudo-input input');
            pseudoInput.val(rowItem.model[conf.NameColumn]);
            pseudoInput.focus();
            pseudoInput.unbind();

            searchButton.on('click', btnSearch_Click);
            autoComplete.bind('select', autoComplete_Select);
            //pseudoInput.bind('click', AutoCompelete(autoComplete));

            pseudoInput.on('keydown', input_keyUp);
        }
    }

    return that;
}();

function Auto_Change(e) {
    if (typeof Auto_ChangeDynamic === "function") {
        var item = this.dataItem(e.item.index());
        Auto_ChangeDynamic(item);
    }
}

function OpenSearchClick(auto) {
    var autoComplete = $("#" + auto).data("kendoAutoComplete");
    OpenComboDynamic(autoComplete);
    autoComplete.search($("#" + auto).val());
}

function btnOpenSearchFocus() {
    var id = this.id.split('_')[1];
    var autoComplete = $("#" + id).data("kendoAutoComplete");
    OpenComboDynamic(autoComplete);
    autoComplete.search($("#" + id).val());
}

function parseDate(data, cl, typeCL) {
    if (data[cl] != "" && data[cl] != null && Date.parse(data[cl]) != NaN) {
        var strParse = typeCL == 13 ? "dd/MM/yyyy HH:mm:ss" : "dd/MM/yyyy";
        if (typeof (data[cl]) == "string") {
            if (data[cl].indexOf("Date") != -1) {
                var str = kendo.toString(kendo.parseDate(data[cl]), strParse);
                data[cl] = str;
                return str;
            }
            else
                return data[cl];
        }
        else {
            var str = kendo.toString(kendo.parseDate(data[cl]), strParse);
            data[cl] = str;
            return str;
        }
    }
    return "";
}

var columnAttachFile = null;
var templateAttachFile = function (textFileName, templeteClass, textFileID) {
    this.getTemplete = kendo.format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>", templeteClass, textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName, textFileID, textFileName);
    return this;
}

function genHtmlAttach(result, column) {
    if (result && result.length > 0) {
        var $templeteParent = $(".templeteAll" + column),

        templeteAll = result.map(function (obj) {

            var objFileName = obj.AttachName,

                objFileID = obj.AttachID;

            return new templateAttachFile(objFileName, "file-templete", objFileID).getTemplete;
        }),

        parentAttach = $("." + column).find($("#VersionScreen").val() == 2 ? ".asf-filter-input" : ".asf-td-field"),

            templeteAll = templeteAll.join(""),

            $attach = $("#" + column);

        $templeteParent.remove();

        templeteParent = "<div class='templeteAll templeteAll" + column + "'>{0}</div>";

        parentAttach.append(kendo.format(templeteParent, templeteAll));

        $attach.val(result.map(function (obj) {
            return obj.AttachID;
        }).join(","));

        $(".x-close").bind("click", function () {
            deleteFile($(this), column);
        });
    }
    isAttachResult = false;
}

function receiveResult_AttachFile(result) {
    genHtmlAttach(result, columnAttachFile);
}

function btnAttachFileDynamic_click(column) {
    columnAttachFile = column;
    isAttachResult = true;
    var urlPopupAttachFile = "/AttachFile?Type=2&IsDynamic=true";
    ASOFT.asoftPopup.showIframe(urlPopupAttachFile, {});
}

function deleteFile(jqueryObjectClick, column) {

    var $parentXClose = jqueryObjectClick.parent(),

        $templeteAll = $(".templeteAll" + column),

        $apkDelete = $parentXClose.attr("id"),

        $attach = $("#" + column),

        $result = $("#" + column).val().split(','),

        $resultAfterDelete = getResultAfterDelete($result, $apkDelete);

    $attach.val($resultAfterDelete);

    $parentXClose.remove();

    typeof $templeteAll !== "undefined"
        ? ($templeteAll.find(".file-templete").length == 0
            ? ($templeteAll.remove(), $attach.val("").trigger("change"))
            : false)
        : false;
}

function getResultAfterDelete(result, apkDelete) {

    if (result.length == 0)
        return "";

    result = jQuery.grep(result, function (value) {
        return value != apkDelete;
    });

    if (result.length == 0)
        return "";

    var $resultAfterDelete = result.join(",");

    return $resultAfterDelete;
}

function btnDeleteUploadDynamic_click(column) {

    $(".templeteAll" + column).remove();

    $("#" + column).val("");
}

