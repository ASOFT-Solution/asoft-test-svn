//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     27/12/2015     Quang Hoàng         Tạo mới
//####################################################################



var rowNumber = {};

var pkchild = null;
var id = $("#sysScreenID").val();
var tbchild = null;
var scrchild = $("#ScrIndex").val();
var module = $("#Module").val();
var table = null;
var tableName = null;
var key = $("#Key").val();
var pk = $("#PK").val();
var refresh = Array();
var grid = $('#GridEdit' + table).data('kendoGrid');
var temprs = 0; // Cờ, lưới reset lại 1 lần duy nhất
var unique = null;
var action = 0;
var checkunique = 0;
var defaultViewModel = {};
var defaultValue = null;
var updateSuccess = 0;
var checkInListGrid = {};


function ReadGridEdit() {
    var datamaster = {};
    var tbch = this.url.split('?')[1].split('=')[1];
    var pkch = $("#Edit" + tbch).val();
    var isUpdate = $("#isUpdate").val();
    if (isUpdate == "True") {
        var key = Array();
        var value = Array();


        datamaster["args.key"] = key;
        datamaster["args.value"] = value;

        if (pkch != null) {
            key.push(pkch, tbch);
            value.push(pk);
            datamaster["args.key"] = key;
            datamaster["args.value"] = value;
        }
    }
    var systemInfo = Array();
    systemInfo.push(module);
    systemInfo.push(id);
    systemInfo.push(tbch);
    datamaster["args.systemInfo"] = systemInfo;
    if (typeof CustomRead === 'function') {
        datamaster["args.custormer"] = CustomRead(tbch);
    }
    return datamaster;
}

function refreshGrid1(tb) {
    //pkchild = $("#Edit" + tb).val();
    //tbchild = tb;
    Grid = $('#GridEdit' + tb).data('kendoGrid');
    Grid.dataSource.page(1);
};

function tabSelect_Click(e) {
    tbchild = $(e.contentElement).find("#tableNameEdit").val();
    pkchild = $("#Edit" + tbchild).val();
}

$(document).ready(function () {
    var urlPopup = window.location.href;
    var para = urlPopup.split('?')[1];
    var vlPara = para != null ? para.split('&') : "";
    for (var h = 0; h < vlPara.length; h++) {
        if (vlPara[h].toUpperCase().indexOf('NOUPDATE') != -1) {
            var noUpdate = vlPara[h].split('=')[1];
            if (noUpdate == "1") {
                $("#BtnSave").data("kendoButton").enable(false);
                $("#Close").unbind();
                $("#Close").kendoButton({
                    "click": ASOFT.asoftPopup.hideIframe
                });
            }
        }
    }

    refreshModel();
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

    var tbdemo = ASOFT.helper.dataFormToJSON(id);
    tableName = []

    if (jQuery.type(tbdemo["tableNameEdit"]) === "string") {
        tableName.push(tbdemo["tableNameEdit"]);
    }
    else
    {
        tableName = tbdemo["tableNameEdit"];
    }

    if (tableName.length > 1) {
        $.each(tableName, function (index, value) {
            rowNumber[value] = 0;
            var idgrid = "#GridEdit" + value;
            var grid = $(idgrid).data('kendoGrid');
            grid.bind('dataBound', function (e) {
                rowNumber[value] = 0;
                //if (temprs != tableName.length) {
                //    refreshGrid1(value);
                //    temprs++;
                //}
            });
            $(grid.tbody).find('td').on("keyup", function (e) {
                if (e.keyCode == 119)
                {
                    if (typeof parent.GetCheckConfirm === "function")
                    {
                        if (parent.GetCheckConfirm() == 0)
                        {
                            var maxRows = grid.dataSource.data().length;
                            grid.addRow();
                            var prevrow = grid.tbody.find('tr').eq(maxRows);
                            grid.select(prevrow);
                        }
                    }
                    else
                    {
                        var maxRows = grid.dataSource.data().length;
                        grid.addRow();
                        var prevrow = grid.tbody.find('tr').eq(maxRows);
                        grid.select(prevrow);
                    }
                }
            });
        })
        tbchild = tbdemo["tableNameEdit"][0];
        pkchild = $("#Edit" + tbchild).val();
    }
    else {
        var idgrid = "#GridEdit" + tableName[0];
        var grid = $(idgrid).data('kendoGrid');
        rowNumber[tableName[0]] = 0;
        grid.bind('dataBound', function (e) {
            rowNumber[tableName[0]] = 0;
            //if (temprs < 1) {
            //    refreshGrid1(tableName[0]);
            //    temprs++;
            //}
        })
        $(grid.tbody).on("keyup", "td", function (e) {
            if (e.keyCode == 119) {
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
        tbchild = tbdemo["tableNameEdit"];
        pkchild = $("#Edit" + tbchild).val();
    }

    $(window).bind('beforeunload', function () {
        for (i = 0; i < refresh.length ; i++) {
            $("#temp" + refresh[i]).val('1');
        }
    });

    var dt = ASOFT.helper.dataFormToJSON(id);

    unique = {};
    if (jQuery.type(dt.Unique) === "string") {
        unique[dt.Unique] = dt[dt.Unique];
    }
    else {
        var uniquetest = [];
        uniquetest.push(dt.Unique);
        $.each(uniquetest, function (index, value) {
            unique[value] = dt[value];
        });
    }
    //Grid = $('#GridEdit' + table).data('kendoGrid');
    //var data = Grid.dataSource._data;
    //table = $("#sysTable").val(); 
    defaultValue = getDataInsert(data); //Lay du lieu ban dau;
})


function refreshModel() {
    defaultViewModel = ASOFT.helper.dataFormToJSON(id);
}

function renderNumber(data, tbRowNum) {
    return ++rowNumber[tbRowNum];
}

function getDetail(tb) {
    var dataPost = ASOFT.helper.dataFormToJSON(id);
    Grid = $('#GridEdit' + tb).data('kendoGrid');
    dataPost.Detail = Grid.dataSource._data;
    dataPost.IsDataChanged = Grid.dataSource.hasChanges()
    return dataPost;
}

function getListDetail(tb) {
    var data = [];
    var dt = getDetail(tb).Detail;
    for (i = 0; i < dt.length; i++) {
        if ($("#isUpdate").val() == "True") {
            if (dt[i].dirty && dt[i][$("#PKChild" + tb).val()] != null)
                dt[i].HistoryChange = 1;
            else
            {
                if (dt[i][$("#PKChild" + tb).val()] == null)
                    dt[i].HistoryChange = 0;
                else
                    dt[i].HistoryChange = 2;
            }

        }
        data.push(dt[i]);
    }
    return data;
}

function isInvalid(data) {
    var CheckInList = [];
    if (data["CheckInList"] !== undefined) {
        if (jQuery.type(data["CheckInList"]) === "string") {
            CheckInList.push(data["CheckInList"]);
        }
        else {
            CheckInList = data["CheckInList"];
        }
    }
    var isError = ASOFT.form.checkRequiredAndInList(id, CheckInList);
    if (!isError) {
        $.each(tableName, function (index, value) {
            var grid = $("#GridEdit" + value).data('kendoGrid');
            $("#GridEdit" + value).removeClass('asf-focus-input-error');
            ASOFT.asoftGrid.editGridRemmoveValidate(grid);

            var listRequired = [];
            listRequired = data["listRequired" + value];

            if (ASOFT.asoftGrid.editGridValidateNoEdit(grid, listRequired)) {
                var msg = ASOFT.helper.getMessage("00ML000060");
                ASOFT.form.displayError("#" + id, msg);
                isError = true;
            }
        })
    }
    return isError;
}

function isInlistGrid(data) {
    var iLgrid = false;
    var listtable = [];
    var message = [];
    listtable.push(data["tableNameEdit"]);
    $('#' + id + ' .asf-focus-input-error').removeClass('asf-focus-input-error');
    $('#' + id + ' .asf-focus-combobox-input-error').removeClass('asf-focus-combobox-input-error');

    $.each(listtable, function (index, value) {
        var grid = $("#GridEdit" + value).data('kendoGrid');
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
    })
    if (message.length > 0) {
        ASOFT.form.displayMessageBox("form#" + id, message);
    }
    return iLgrid;
}

function save(url) {
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
                    save1(url, data);
                },
                function () {
                    return false;
                });
        }
        else {
            save1(url, data);
        }
    }
    else {
        save1(url, data);
    }
}

function getDataInsert(data) {
    var datagrid = [];
    if (typeof CustomInsertPopupMaster === 'function') {
        datagrid = CustomInsertPopupMaster(data);
    }
    else {
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
            if (key != "item.TypeCheckBox" && key != "Unique" && data[key + "_Content_DataType"] != undefined) {
                if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("tableNameEdit") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key.indexOf("CbGridEdit_") == -1) {
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
    }

    if (typeof CustomInsertPopupDetail === 'function') {
        datagrid = CustomInsertPopupDetail(datagrid);
    }
    else {
        $.each(tableName, function (key, value) {
            datagrid.push(getListDetail(value));
        })
    }
    return datagrid;
}


function save1(url, data) {

    var datagrid = getDataInsert(data);


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

    if (typeof parent.GetTableParent === "function") {
        var ParentList = parent.GetTableParent();

        if (ParentList.TBParent != $("#sysTable").val()) {
            if ($("#isUpdate").val() == "False") {
                url = url + "?TBParent=" + ParentList.TBParent + "&ValueParent=" + ParentList.VLParent;
            }
            if ($("#isUpdate").val() == "True") {
                url = url + "&TBParent=" + ParentList.TBParent + "&ValueParent=" + ParentList.VLParent;
            }
        }
    }

    if ($("#isUpdate").val() == "True")
    {
        datagrid[0][0].HistoryChangeMaster = getHistoryChange(defaultValue, datagrid);
    }

    ASOFT.helper.postTypeJson(url, datagrid, onInsertSuccess);
    if (action == 4 && updateSuccess == 1) {
        window.parent.location.reload();
    }
    if (typeof afterSave === "function") {
        afterSave(action);
    }
}

function getHistoryChange(df, dtChange)
{
    var change = "";
    $.each(dtChange[0][0], function (key, value) {
        if (key != "item.TypeCheckBox" && key != "Unique") {
            if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                var dfChange = getBykey(value);
                var dfValue = getBykey(df[0][0][key]);
                if (dfChange !== dfValue) {
                    change = change + "- '" + id + "." + key + "." + module + "': " + dfValue + " -> " + dfChange + "</br>";
                }
            }
        }
    })
    return change;
}

function getBykey(value) {
    if (value.split(',').length > 2) {
        var data = "";
        for (var j = 1; j < value.split(',').length - 1; j++) {
            data = data + value.split(',')[j] + ",";
        }
        data = data + value.split(',')[value.split(',').length - 1];
        return data;
    }
    else {
        return value.split(',')[1];
    }
}

function onInsertSuccess(result) {

    if (result.Status == 0) {
        switch (action) {
            case 1://save new                
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                //
                refreshModel();
                if (typeof clearfieldsCustomer === "function") {
                    clearfieldsCustomer();
                }
                else
                    clearfields();
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid();
                }
                break;
            case 2://save copy
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                refreshModel();
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid();
                }
                //refreshModel();
                break;
            case 3:
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                refreshModel();
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid();
                }
                parent.popupClose();
                //refreshModel();
            case 4:
                updateSuccess = 1;
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                break;
        }
    }
    else {
        updateSuccess = 0;
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

    //Kiểm tra có function mở rộng
    if (typeof onAfterInsertSuccess !== 'undefined' && $.isFunction(onAfterInsertSuccess)) {
        onAfterInsertSuccess(result, action);
    }
}

function clearfields() {
    var data = ASOFT.helper.dataFormToJSON(id);
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit") {
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
                $("#" + key).val('');
            }
        }
    })
    //var args = $('#' + id +' input');
    //for (i = 0; i < args.length; i++) {
    //    if (args[i].id != "item.TypeCheckBox" && args[i].id.indexOf("_Content_DataType") == -1 && args[i].id.indexOf("_Type_Fields") == -1 && args[i].id.indexOf("listRequired") == -1 && args[i].id != "tableNameEdit" && args[i].id != "CheckInList") {
    //        $("#" + args[i].id).val('');
    //    }
    //}
}


function Save_Click() {
    var url = "/GridCommon/UpdatePopupMasterDetail/" + module + "/" + id;
    action = 4;
    checkunique = 1;
    save(url);
}

function SaveCopy_Click() {
    var url = "/GridCommon/InsertPopupMasterDetail/" + module + "/" + id;
    action = 2;
    save(url);
}

function SaveNew_Click() {
    var url = "/GridCommon/InsertPopupMasterDetail/" + module + "/" + id;
    action = 1;
    save(url);
}

var isDataChanged = function () {
    var dataPost = getFormData();
    var equal = isRelativeEqual(dataPost, defaultViewModel);
    return !equal;
};
var getFormData = function () {
    var dataPost = ASOFT.helper.dataFormToJSON(id);
    return dataPost;
};

var isRelativeEqual = function (data1, data2) {
    var KENDO_INPUT_SUFFIX = '_input';
    if (data1 && data2
        && typeof data1 === "object"
        && typeof data2 === "object") {
        for (var prop in data1) {
            // So sánh thuộc tính của 2 data
            if (!data2.hasOwnProperty(prop)) {
                return false;
            }
            else {
                if (prop.indexOf(KENDO_INPUT_SUFFIX) != -1) {
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

function popupClose_Click(event) {
    var url;
    var isupdate = $("#isUpdate").val();
    if (isupdate == "True") {
        url = "/GridCommon/UpdatePopupMasterDetail/" + module + "/" + id;
    }
    else {
        url = "/GridCommon/InsertPopupMasterDetail/" + module + "/" + id;
    }

    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                if (isupdate == "True") {
                    action = 4;
                    checkunique = 1;
                }
                else {
                    action = 3;
                }
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
                    };
                });
            }
        });
    }, 100);
});

function onComboSuccess(result, combo) {
    combo.dataSource.data(result);
    if (result.length == 0) {
        combo.value("");
    }
};

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
    SendFromCombo(combo.sender, "/combobox/ASOFTComboBoxDynamicLoadData")
};

function SendFromCombo(combo, url) {
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
        var kendoGrid = $('#GridEdit' + tbchild).data('kendoGrid');
        var thgrid = $('#GridEdit' + tbchild).find('th');
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

    ASOFT.helper.postTypeJsonComboBox(url, list, combo, onComboSuccess);
};
function AddList(key, value) {
    var item = new Object();
    item.key = key;
    item.value = value;
    return item;
};


function genDeleteBtn(data) {
    return "<a href='\\#' onclick='return deleteDetail_Click(this)' class='asf-i-delete-24 asf-icon-24'><span>Del</span></a>";
}

function deleteDetail_Click(e) {
    return deleteItems(e);
}

function deleteItems(tagA) {
    //remove gridEdit
    posGrid = $('#GridEdit' + tbchild).data('kendoGrid');
    ASOFT.asoftGrid.removeEditRow(tagA, posGrid);
    return false;
}

function LongDateTime(e) {
    $("#" + e.sender._form.context.id + "_timeview").css("overflow", "scroll");
    $("#" + e.sender._form.context.id + "_timeview").css("height", "300px");
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
    if(data[key] == undefined)
    {
        data[key] = 0;
    }
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

function Priority_Click(idCL, vl) {
    $("#" + idCL).val(vl);
    for (var i = 1; i <= 4; i++) {
        var imgSt = "/Content/Images/";
        imgSt = imgSt + (vl >= i ? "star.png" : "starnone.png");
        $(".st" + idCL + i).attr("src", imgSt);
    }
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
            if (cbb != null) {
                OpenMultiSelectDynamic(cbb);
                $("#" + idComboBox).data('kendoMultiSelect').open();
                $("#" + idComboBox).data('kendoMultiSelect').close();
                var vlMulti = $("#" + idComboBox).data('kendoMultiSelect').value();
                var vlMultiAdd = [];
                for (var i = 0; i < vlMulti.length; i++) {
                    vlMultiAdd.push(vlMulti[i]);
                }
                vlMultiAdd.push(localStorage.getItem("ValueCombobox"));
                $("#" + idComboBox).data('kendoMultiSelect').value([]);
                $("#" + idComboBox).data('kendoMultiSelect').value(vlMultiAdd);
            }
        }
    }
}

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
};


