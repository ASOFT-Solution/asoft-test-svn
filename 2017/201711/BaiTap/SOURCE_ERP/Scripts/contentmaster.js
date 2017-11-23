//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     23/12/2015     Quang Hoàng         Tạo mới
//####################################################################


var GridKendo = null;
var screen = null;
var tablecontent = null;
var pk = null;
var urladd = null;
var urldelete = null;
var urlcontent = null;
var urlenable = "/GridCommon/Enable";
var urldisable = "/GridCommon/Disable";
var isSearch = 0;
var isPrint = false;


$(document).ready(function () {
    var ip = $(":input[type='text']");
    $(ip).each(function () {
        $(this).attr("name", this.id);
    })
    screen = $("#sysScreenID").val();
    tablecontent = $("#sysTable" + screen).val();
    pk = $("#PK" + tablecontent).val();
    urladd = $('#AddNew' + screen).val();
    urldelete = $('#Delete' + screen).val();
    urlcontent = $('Content' + screen).val();
    urldisable = urldisable + "/" + $("#Module" + $("#sysScreenID").val()).val() + "/" + $("#sysScreenID").val();
    urlenable = urlenable + "/" + $("#Module" + $("#sysScreenID").val()).val() + "/" + $("#sysScreenID").val();
});

function ShowEditorFrame() {
    ASOFT.form.clearMessageBox();
    if (typeof onShowEditorFrame !== 'undefined' && $.isFunction(onShowEditorFrame)) {
        onShowEditorFrame();
    }
    ASOFT.asoftPopup.showIframe(urladd, {});

};

function ShowUpdateFrame() {
    ASOFT.form.clearMessageBox();
    if (typeof onShowUpdateFrame !== 'undefined' && $.isFunction(onShowUpdateFrame)) {
        onShowUpdateFrame();
    }
    ASOFT.asoftPopup.showIframe(urladd, {});
};

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
};

function ReadTK() {
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    var key1 = Array();
    var value1 = Array();
    var datatype = Array();
    var fieldtype = Array();
    $.each(datamaster, function (key, value) {
        if (key.indexOf("_input") == -1) {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                if (datamaster[key.split('_')[0] + "_Type_Fields"] == 2) {
                    if (value == "Có") {
                        value1.push(1);
                    }
                    else {
                        if (value == "Không") {
                            value1.push(0);
                        }
                        else {
                            if (value == "%") {
                                value1.push("");
                            }
                            else {
                                value1.push(value);
                            }
                        }
                    }
                }
                else {
                    value1.push(value);
                }
                key1.push(key.split('_')[0]);
                datatype.push(datamaster[key.split('_')[0] + "_Content_DataType"]);
                fieldtype.push(datamaster[key.split('_')[0] + "_Type_Fields"]);
            }
        }
    });
    //var cb = $(".asf-dynamic-cb").find("input[type='checkbox']");
    //$(cb).each(function () {
    //    var temp = $(this).attr("checked");
    //    var id = $(this).attr("id");
    //    if (temp == "checked") {
    //        key1.push(id);
    //        value1.push("1");
    //    }
    //    else {
    //        key1.push(id);
    //        value1.push("0");
    //    }
    //});
    tablecontent = $("#sysTable" + screen).val();
    key1.push(tablecontent);
    datamaster["args.ftype"] = fieldtype;
    datamaster["args.dttype"] = datatype;
    datamaster["args.key"] = key1;
    datamaster["args.value"] = value1;

    var systemInfo = Array();
    systemInfo.push($("#sysScreenID").val());
    systemInfo.push($("#Module" + $("#sysScreenID").val()).val());
    systemInfo.push($("#sysTable" + $("#sysScreenID").val()).val());
    datamaster["args.systemInfo"] = systemInfo;

    return datamaster;
};

function BtnFilter_Click() {
    ASOFT.form.clearMessageBox();
    isSearch = 1;

    if (typeof onAfterFilter !== 'undefined' && $.isFunction(onAfterFilter)) {
        onAfterFilter();
    }
    refreshGrid();
};

function refreshGrid() {
    GridKendo = $('#Grid' + tablecontent).data('kendoGrid');

    if (typeof onRefreshGrid !== 'undefined' && $.isFunction(onRefreshGrid)) {
        onRefreshGrid();
    } else {
        GridKendo.dataSource.page(1);
    }
};


//Xử lý cho combobox
function onComboSuccess(result, combo) {
    combo.sender.dataSource.data(result);
};

function OpenComboDynamic(combo) {
    SendFromCombo(combo, "/combobox/ASOFTComboBoxDynamicLoadData")
};

function OpenMultiCheckListDynamic(combo) {
    SendFromCombo(combo, "/combobox/ASOFTMultiCheckListDynamicLoadData")
};

function SendFromCombo(combo, url) {
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    if (typeof CustomerChangedData === "function") {
        datamaster = CustomerChangedData();
    }
    var list = new Array();
    list.push(AddList("sysComboBoxID", combo.sender.element.attr("sysComboBoxID")));
    list.push(AddList("ScreenID", combo.sender.element.attr("ScreenID")));
    list.push(AddList("Module", combo.sender.element.attr("Module")));
    $.each(datamaster, function (key, value) {
        if (key.indexOf("_input") == -1) {
            var item = new Object();
            if (key.indexOf(screen) != -1) {
                list.push(AddList(key.split('_')[0], value));
            }
            else {
                list.push(AddList(key, value));
            }
        }
    });
    var cb = $(".asf-dynamic-cb").find("input[type='checkbox']");
    $(cb).each(function () {
        var temp = $(this).attr("checked");
        var id = $(this).attr("id");
        if (temp == "checked") {
            list.push(AddList(id, "1"));
        }
        else {
            list.push(AddList(id, "0"));
        }
    });
    ASOFT.helper.postTypeJsonComboBox(url, list, combo, onComboSuccess);
};
function AddList(key, value) {
    var item = new Object();
    item.key = key;
    item.value = value;
    return item;
};

//Xử lý delete
function BtnDelete_Click() {
    var args = [];
    var key = [];
    GridKendo = $('#Grid' + tablecontent).data('kendoGrid');
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;

    for (var i = 0; i < records.length; i++) {
        var valuepk = records[i][pk] + ",";
        if (records[i]["DivisionID"] !== undefined) {
            var diviS = records[i]["DivisionID"] == "" ? "@@@" : records[i]["DivisionID"];
            valuepk = valuepk + diviS;
        }

        args.push(valuepk);
    }

    //Test checkbox lưu lại biến vào apkOfGrid( trong common.js) để lấy thêm các record ngoài trang hiện tại
    //if (apkOfGrid.length > 0) {
    //    var isCheck = $(sector + "#chkAll").is(':checked');
    //    for (var j = 0; j < apkOfGrid.length; j++) {
    //        if (args.indexOf(apkOfGrid[j]) == -1) {
    //            if (isCheck) {
    //                args.splice(args.indexOf(apkOfGrid[j]), 1);
    //            } else {
    //                args.push(apkOfGrid[j]);
    //            }               
    //        }
    //    }
    //}

    key.push(tablecontent, pk);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldelete, key, args, deleteSuccess);
    });
}

//Kết quả server trả về sau khi xóa
function deleteSuccess(result) {
    GridKendo = $('#Grid' + tablecontent).data('kendoGrid');
    ASOFT.helper.showErrorSeverOption(1, result, "FormFilter", function () {

        //Chuyển hướng hoặc refresh data
        if (urlcontent) {
            window.location.href = urlcontent; // redirect index
        }
    }, null, null, true, false, "FormFilter");
    if (GridKendo) {
        if (typeof onAfterDeleteSuccess !== 'undefined' && $.isFunction(onAfterDeleteSuccess)) {
            onAfterDeleteSuccess();
        } else {
            GridKendo.dataSource.page(1); // Refresh grid 
        }
    }
}

function BtnClearFilter_Click() {
    ASOFT.form.clearMessageBox();
    ClearFilter();
    //var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
    //resetDropDown(multiComboBox);
    if (typeof onAfterClearFilter !== 'undefined' && $.isFunction(onAfterClearFilter)) {
        onAfterClearFilter();
    }
    refreshGrid();
}

function ClearFilter() {
    var args = $('#FormFilter input');
    $.each(args, function () {

        if ($(this).attr("id") != "undefined" && typeof ($(this).attr("id")) != "undefined") {
            if ($(this).attr("id").indexOf("_input") == -1) {
                if ($(this).attr("id") != "item.TypeCheckBox" && $(this).attr("id").indexOf("_Content_DataType") == -1 && $(this).attr("id").indexOf("_Type_Fields") == -1) {
                    if ($("#" + $(this).attr("id")).data("kendoComboBox") != null) {
                        $("#" + $(this).attr("id")).data("kendoComboBox").value("");
                    }
                    if ($("#" + $(this).attr("id")).data("kendoDropDownList") != null) {
                        $("#" + $(this).attr("id")).data("kendoDropDownList").value("");
                        $("#" + $(this).attr("id")).data("kendoDropDownList").text("");
                    }
                    $("#" + $(this).attr("id")).val('');
                }
            }
        }
    });
}

function BtnEnable_Click() {
    var args = [];
    var key = [];
    GridKendo = $('#Grid' + tablecontent).data('kendoGrid');
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        args.push(records[i][pk]);
    }
    key.push(tablecontent, pk);
    ASOFT.helper.postTypeJson1(urlenable, key, args, function (result) {
        GridKendo = $('#Grid' + tablecontent).data('kendoGrid');
        ASOFT.helper.showErrorSeverOption(0, result, "FormFilter", function () {

            //Chuyển hướng hoặc refresh data
            if (urlcontent) {
                window.location.href = urlcontent; // redirect index
            }
        }, null, null, true, false, "FormFilter");
        if (GridKendo) {
            GridKendo.dataSource.page(1); // Refresh grid 
        }
    });
}


function BtnDisable_Click() {
    var args = [];
    var key = [];
    GridKendo = $('#Grid' + tablecontent).data('kendoGrid');
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        args.push(records[i][pk]);
    }
    key.push(tablecontent, pk);
    ASOFT.helper.postTypeJson1(urldisable, key, args, function (result) {
        GridKendo = $('#Grid' + tablecontent).data('kendoGrid');
        ASOFT.helper.showErrorSeverOption(0, result, "FormFilter", function () {

            //Chuyển hướng hoặc refresh data
            if (urlcontent) {
                window.location.href = urlcontent; // redirect index
            }
        }, null, null, true, false, "FormFilter");
        if (GridKendo) {
            GridKendo.dataSource.page(1); // Refresh grid 
        }
    });
}

function LongDateTime(e) {
    $("#" + e.sender._form.context.id + "_timeview").css("overflow", "scroll");
    $("#" + e.sender._form.context.id + "_timeview").css("height", "300px");
}


function BtnEventSendDocVPL_Click() {
    if (typeof CustomEventSendDocVPL === "function") {
        CustomEventSendDocVPL();
    }
}

function BtnChangeUnusualType_Click() {
    if (typeof CustomEventChangeUnusualType === "function") {
        CustomEventChangeUnusualType();
    }
}

function GetDataGridParent(table) {
    var gridParent = $('#Grid' + table).data('kendoGrid');
    return gridParent;
}

function GetDataFormFilter() {
    var FormFilter1 = ASOFT.helper.dataFormToJSON("FormFilter");
    return FormFilter1;
}

function GetIsSearch() {
    return isSearch;
}

function GetCheckAll() {
    if ($("#chkAll").is(':checked')) {
        return 1;
    }
    else {
        return 0;
    }
}

function GetUrlContentMaster() {
    return $("#urlParentContent").val();
}

function ReloadPage() {
    location.reload();
}

function getDataPrintExport() {
    var data = ASOFT.helper.dataFormToJSON("FormFilter");
    var dataFilter = {};
    var Lvalue = Array();
    var Lkey = Array();
    $.each(data, function (key, value) {
        if (key.indexOf("_input") == -1) {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                Lkey.push(key.split('_')[0])
                Lvalue.push(value);
            }
            else {
                Lkey.push(key)
                Lvalue.push(value);
            }
        }
    });

    dataFilter["key"] = Lkey;
    dataFilter["value"] = Lvalue;
    return dataFilter;
}

function BtnPrint_Click(e) {
    if (typeof PrintClick === "function") {
        PrintClick(e);
    }
    else {
        var URLDoPrintorExport = '/ContentMaster/DoPrintOrExport?id=' + screen + '&area=' + $("#Module" + $("#sysScreenID").val()).val();
        var dataFilter = getDataPrintExport();
        var url = URLDoPrintorExport;
        isPrint = true;
        ASOFT.helper.postTypeJson(url, dataFilter, ExportSuccess);
    }
}

function BtnExport_Click() {
    if (typeof ExportClick === "function") {
        ExportClick();
    }
    else {
        var URLDoPrintorExport = '/ContentMaster/DoPrintOrExport?id=' + screen + '&area=' + $("#Module" + $("#sysScreenID").val()).val();
        var dataFilter = getDataPrintExport();
        var url = URLDoPrintorExport;
        isPrint = false;
        ASOFT.helper.postTypeJson(url, dataFilter, ExportSuccess);
    }
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/ContentMaster/ReportViewer';
        var urlExcel = '/ContentMaster/ExportReport';
        //var urlPost = isPrint ? urlPrint : urlExcel;
        //var options = isPrint ? '&viewer=pdf' : '';
        var urlPost;
        var options = '';

        if (isPrint) {
            urlPost = !isMobile ? urlPrint : urlExcel;
            options = !isMobile ? '&viewer=pdf' : '&viewer=pdf&mobile=mobile';
        }
        else
            urlPost = urlExcel;

        var RM = '&Module=' + $("#Module" + $("#sysScreenID").val()).val() + '&ScreenID=' + screen;
        // Tạo path full
        var fullPath = urlPost + "?id=" + result.apk + options + RM;

        // Getfile hay in báo cáo
        if (isPrint)
            if (!isMobile)
                window.open(fullPath, "_blank");
            else
                window.location = fullPath;
        else {
            window.location = fullPath;
        }
    }
}


//Duyệt hàng loạt
function BtnConfirmAll_Click() {
    if (typeof CustomConfirmAll === "function") {
        CustomConfirmAll();
    }
}

function parseDate(data) {
    if (data != "" && data != null) {
        if (data.indexOf("Date") != -1) {
            var str = kendo.toString(kendo.parseDate(data), "dd/MM/yyyy hh:mm:ss");
            return str;
        }
        else {
            return data;
        }
    }
    return null;
}

function BtnImport_Click() {
    if ($("#CB" + screen).val() == 1) {
        var Module = $("#Module" + $("#sysScreenID").val()).val();

        var urlImport = "/Import/ImportDynamic?area=" + Module + "&id=" + $("#sysScreenID").val() + "&table=" + tablecontent;
        ASOFT.asoftPopup.showIframe(urlImport);
    }
    else {
        var urlImport = "/Import";
        ASOFT.asoftPopup.showIframe(urlImport);
    }
}
