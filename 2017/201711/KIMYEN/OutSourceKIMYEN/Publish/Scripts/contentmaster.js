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
var countSearch = 1;
var isSearchDynamic = false;
var strWhereDynamic = null;


$(document).ready(function () {
    var ip = $(":input[type='text']");
    $(ip).each(function () {
        $(this).attr("name", this.id);
    })

    //Xử lí cho trường hợp search động
    $("#SpinSearch1").attr("name", "SpinSearch1");
    $("#SpinSearchFrom1").attr("name", "SpinSearchFrom1");
    $("#SpinSearchTo1").attr("name", "SpinSearchTo1");

    var iprequaird = $(":input[type='text'][requaird='true']");
    $(iprequaird).each(function () {
        $(this).attr("data-val-required", "The field is required.");
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
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList" && key.indexOf("CBSearch") == -1 && key.indexOf("CBCompare") == -1 && key.indexOf("DateSearch") == -1 && key.indexOf("DateTimeSearch") == -1 && key.indexOf("CBCheck") == -1 && key.indexOf("SpinSearch") == -1 && key.indexOf("TxtSearch") == -1) {
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
    if (strWhereDynamic) {
        systemInfo.push(strWhereDynamic ? strWhereDynamic : "");
    }
    datamaster["args.systemInfo"] = systemInfo;

    return datamaster;
};

function valueSearchDynamic(type, dtType, index, typeCompare) {
    if (dtType == 9) {
        var strParse = "yyyy-MM-dd";
        var str = "'" + kendo.toString($("#DateSearch" + index).data("kendoDatePicker").value(), strParse) + "'";
        return str;
    }

    if (dtType == 13) {
        var strParse = "yyyy-MM-dd HH:mm:ss";
        var str = "'" + kendo.toString($("#DateTimeSearch" + index).data("kendoDateTimePicker").value(), strParse) + "'";
        return str;
    }

    if (type == 2) {
        return $("#CBCheck" + index).data("kendoComboBox").value();
    }

    if (dtType == 5 || dtType == 8 || (dtType == 6 && type != 2)) {
        return $("#SpinSearch" + index).data("kendoNumericTextBox").value();
    }

    if (typeCompare == "<>" || typeCompare == "=")
    {
        return "N'" + $("#TxtSearch" + index).val().replace(/\'/g, "''") + "'";
    }

    return $("#TxtSearch" + index).val().replace(/\'/g, "''");
}

function valueSearchFromToDynamic(type, dtType, index) {
    if (dtType == 9) {
        var To = $("#DateSearchTo" + index).data("kendoDatePicker").value();
        var From = $("#DateSearchFrom" + index).data("kendoDatePicker").value();
        var strParse = "yyyy-MM-dd";
        To = kendo.toString(To, strParse) ? "'" + kendo.toString(To, strParse) + "'" : "null";
        From = kendo.toString(From, strParse) ? "'" + kendo.toString(From, strParse) + "'" : "null";
        return [From, To];
    }

    if (dtType == 13) {
        var To = $("#DateTimeSearchTo" + index).data("kendoDateTimePicker").value();
        var From = $("#DateTimeSearchFrom" + index).data("kendoDateTimePicker").value();
        var strParse = "yyyy-MM-dd HH:mm:ss";
        To = kendo.toString(To, strParse) ? "'" + kendo.toString(To, strParse) + "'" : "null";
        From = kendo.toString(From, strParse) ? "'" + kendo.toString(From, strParse) + "'" : "null";
        return [From, To];
    }

    if (dtType == 5 || dtType == 8 || (dtType == 6 && type != 2)) {
        var To = $("#SpinSearchTo" + index).data("kendoNumericTextBox").value() != null ? $("#SpinSearchTo" + index).data("kendoNumericTextBox").value() : "null";
        var From = $("#SpinSearchFrom" + index).data("kendoNumericTextBox").value() != null ? $("#SpinSearchFrom" + index).data("kendoNumericTextBox").value() : "null";
        return [From, To];
    }

    return ["N'" + $("#TxtSearchFrom" + index).val().replace(/\'/g, "''") + "'", "N'" + $("#TxtSearchTo" + index).val().replace(/\'/g, "''") + "'"];
}


function ParseStrWhere() {
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    var cbbCompare1 = $("#CBCompare1").data("kendoComboBox");
    var vlCompare1 = cbbCompare1.dataItem(cbbCompare1.select());
    var cbbSearch1 = $("#CBSearch1").data("kendoComboBox");
    var vlSearch1 = cbbSearch1.dataItem(cbbSearch1.select());
    var strW = "";
    var fieldPara = datamaster["CBSearch1"];
    if (vlSearch1.DataType == 3 || vlSearch1.DataType == 7 || vlSearch1.DataType == 12) {
        fieldPara = "IsNull(" + fieldPara + ",'')"
    }

    if (cbbCompare1.value() != "[]" && cbbCompare1.value() != "][") {
        strW = valueSearchDynamic(vlSearch1.Type, vlSearch1.DataType, 1, cbbCompare1.value());
        strWhereDynamic = " where " + fieldPara + kendo.format(vlCompare1.Para, strW);
    }
    else {
            var toFrom1 = valueSearchFromToDynamic(vlSearch1.Type, vlSearch1.DataType, 1);
            strWhereDynamic = " where " + fieldPara + kendo.format(vlCompare1.Para, toFrom1[0], toFrom1[1]);
        }

    $.each(datamaster, function (key, value) {
        if (key.indexOf("CBSearch") != -1 && key != "CBSearch1" && key != "TxtSearch1" && key.indexOf("_input") == -1) {
            var index = key.replace('CBSearch', '');
            var cbbCompare = $("#CBCompare" + index).data("kendoComboBox");
            var vlCompare = cbbCompare.dataItem(cbbCompare.select());
            var cbbSearch = $("#" + key).data("kendoComboBox");
            var vlSearch = cbbSearch.dataItem(cbbSearch.select());

            var andOr = $("#idAnd" + index).length > 0 ? " and " : ($("#idOr" + index).length > 0 ? " or " : null);
            if (andOr) {
                strWhereDynamic += andOr;

                fieldPara = value;
                if (vlSearch.DataType == 3 || vlSearch.DataType == 7 || vlSearch.DataType == 12) {
                    fieldPara = "IsNull(" + fieldPara + ",'')"
                }

                if (cbbCompare.value() != "[]" && cbbCompare.value() != "][") {
                    strWhereDynamic += fieldPara + kendo.format(vlCompare.Para, valueSearchDynamic(vlSearch.Type, vlSearch.DataType, index, cbbCompare.value()));
                }
                else {
                    var toFrom = valueSearchFromToDynamic(vlSearch.Type, vlSearch.DataType, index);
                    strWhereDynamic += fieldPara + kendo.format(vlCompare.Para, toFrom[0], toFrom[1]);
                }
            }
        }
    })
}

function BtnFilter_Click() {
    strWhereDynamic = null;
    ASOFT.form.clearMessageBox();
    isSearch = 1;

    if (isSearchDynamic)
    {
        if (ASOFT.form.checkRequiredAndInList("FormFilter", [])) {
            ASOFT.form.clearMessageBox();
            var msg = ASOFT.helper.getMessage("00ML000128");
            ASOFT.form.displayError('#FormFilter', msg);
            return;
        }
        ParseStrWhere();
    }

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

    key.push(tablecontent, pk);
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

    //key.push(tablecontent, pk);
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
                    if ($("#" + $(this).attr("id")).data("kendoNumericTextBox") != null) {
                        $("#" + $(this).attr("id")).data("kendoNumericTextBox").value("");
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
    ASOFT.helper.postTypeJson1(urlenable, key, args, disable_enableSuccess);
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
    ASOFT.helper.postTypeJson1(urldisable, key, args, disable_enableSuccess);
}

function disable_enableSuccess(result) {
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
                Lkey.push(key);
                Lvalue.push(value);
            }
        }
    });
    if (typeof customDataReport === "function") {
        var dataCus = {};
        dataCus = customDataReport();
        $.each(dataCus, function (key, value) {
            Lkey.push(key);
            Lvalue.push(value);
        })
    }

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

function BtnExport_Click(e) {
    if (typeof ExportClick === "function") {
        ExportClick(e);
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

function parseDate(data, typeCL) {
    if (data != "" && data != null && Date.parse(data) != NaN) {
        if (typeof (data) == "string") {
            if (data.indexOf("Date") != -1) {
                var strParse = typeCL == 13 ? "dd/MM/yyyy HH:mm:ss" : "dd/MM/yyyy";
                var str = kendo.toString(kendo.parseDate(data), strParse);
                return str;
            }
            else
                return data;
        }
        else {
            var strParse = typeCL == 13 ? "dd/MM/yyyy HH:mm:ss" : "dd/MM/yyyy";
            var str = kendo.toString(kendo.parseDate(data), strParse);
            return str;
        }
    }
    return "";
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

function btnAddSearch_Click(e) {
    var id = e.sender.wrapper[0].id;
    var OrAnd = id.split('_')[0] == "BtnAnd";
    var para = {};
    para.orand = OrAnd;
    para.index = countSearch + 1;
    para.module = $("#Module" + screen).val();
    para.scr = screen;
    para.table = tablecontent;
    ASOFT.helper.postTypeJson("/ContentMaster/CloneSearch/", para, function (result) {
        $("#" + id.split('_')[1]).after(result);
    });
    countSearch++;
    var ip = $(":input[type='text']");
    $(ip).each(function () {
        $(this).attr("name", this.id);
    })

    var iprequaird = $(":input[type='text'][requaird='true']");
    $(iprequaird).each(function () {
        $(this).attr("data-val-required", "The field is required.");
    })

}

function deleteSearch_Click(e) {
    $("#" + e).remove();
}

function BtnFilterDynamic_Click() {
    if ($("#DynamicSearch")[0].style.display == "none") {
        $("#DynamicSearch").show();
        $("#FilterArea").hide();
        isSearchDynamic = true
        $("#BtnFilterDynamic").find(".asf-button-text").text(ASOFT.helper.getLanguageStringA00("A00.RegularSearch"));
    }
    else {
        $("#FilterArea").show();
        $("#DynamicSearch").hide();
        isSearchDynamic = false;
        $("#BtnFilterDynamic").find(".asf-button-text").text(ASOFT.helper.getLanguageStringA00("A00.DynamicSearch"));
    }
}

function cbSearch_Change(e) {
    var id = e.sender.element[0].id;
    var index = id.replace('CBSearch', '');
    var cbCompare = $("#CBCompare" + index).data("kendoComboBox");
    var cbSeacrh = e.sender;
    if (cbCompare)
    {
        cbCompare.value("");
        cbCompare.dataSource.read();
    }

    if (cbSeacrh)
    {
        hideShowSearch(index, cbSeacrh);
        hideShowSearchBetween(index, cbSeacrh, true);
    }
}

function hideShowSearch(index, cbSeacrh) {
    var value = cbSeacrh.dataItem(cbSeacrh.select());

    $("#DateSearch" + index).data("kendoDatePicker").wrapper.addClass("asf-hidden");
    $("#TxtSearch" + index).show();
    $("#DateTimeSearch" + index).data("kendoDateTimePicker").wrapper.addClass("asf-hidden");
    $("#CBCheck" + index).data("kendoComboBox").wrapper.addClass("asf-hidden");
    $("#SpinSearch" + index).data("kendoNumericTextBox").wrapper.addClass("asf-hidden");

    $("#DateSearch" + index).data("kendoDatePicker").element.removeClass("asf-hidden");
    $("#DateTimeSearch" + index).data("kendoDateTimePicker").element.removeClass("asf-hidden");
    $($("#CBCheck" + index).data("kendoComboBox").wrapper.find('input')).removeClass("asf-hidden");
    $($("#SpinSearch" + index).data("kendoNumericTextBox").wrapper.find('input')).removeClass("asf-hidden");

    if (value && (value.DataType == 9)) {
        $("#DateSearch" + index).data("kendoDatePicker").wrapper.removeClass("asf-hidden");
        $("#TxtSearch" + index).hide();
        $("#DateTimeSearch" + index).data("kendoDateTimePicker").wrapper.addClass("asf-hidden");
        $("#CBCheck" + index).data("kendoComboBox").wrapper.addClass("asf-hidden");
        $("#SpinSearch" + index).data("kendoNumericTextBox").wrapper.addClass("asf-hidden");
    }
    if (value && value.DataType == 13) {
        $("#DateSearch" + index).data("kendoDatePicker").wrapper.addClass("asf-hidden");
        $("#TxtSearch" + index).hide();
        $("#DateTimeSearch" + index).data("kendoDateTimePicker").wrapper.removeClass("asf-hidden");
        $("#CBCheck" + index).data("kendoComboBox").wrapper.addClass("asf-hidden");
        $("#SpinSearch" + index).data("kendoNumericTextBox").wrapper.addClass("asf-hidden");
    }
    if (value && value.Type == 2) {
        $("#DateSearch" + index).data("kendoDatePicker").wrapper.addClass("asf-hidden");
        $("#TxtSearch" + index).hide();
        $("#DateTimeSearch" + index).data("kendoDateTimePicker").wrapper.addClass("asf-hidden");
        $("#CBCheck" + index).data("kendoComboBox").wrapper.removeClass("asf-hidden");
        $("#SpinSearch" + index).data("kendoNumericTextBox").wrapper.addClass("asf-hidden");
    }

    if (value && (value.DataType == 5 || value.DataType == 8 || (value.DataType == 6 && value.Type != 2))) {
        $("#DateSearch" + index).data("kendoDatePicker").wrapper.addClass("asf-hidden");
        $("#TxtSearch" + index).hide();
        $("#DateTimeSearch" + index).data("kendoDateTimePicker").wrapper.addClass("asf-hidden");
        $("#CBCheck" + index).data("kendoComboBox").wrapper.addClass("asf-hidden");
        $("#SpinSearch" + index).data("kendoNumericTextBox").wrapper.removeClass("asf-hidden");
    }
}


function hideShowSearchBetween(index, cbSeacrh, hideAll) {
    var value = cbSeacrh.dataItem(cbSeacrh.select());


    $("#TxtSearchFrom" + index).removeClass("asf-hidden");
    $("#TxtSearchTo" + index).removeClass("asf-hidden");

    $("#DateSearchFrom" + index).data("kendoDatePicker").wrapper.addClass("asf-hidden");
    $("#DateSearchTo" + index).data("kendoDatePicker").wrapper.addClass("asf-hidden");
    $("#DateTimeSearchFrom" + index).data("kendoDateTimePicker").wrapper.addClass("asf-hidden");
    $("#DateTimeSearchTo" + index).data("kendoDateTimePicker").wrapper.addClass("asf-hidden");
    $("#SpinSearchFrom" + index).data("kendoNumericTextBox").wrapper.addClass("asf-hidden");
    $("#SpinSearchTo" + index).data("kendoNumericTextBox").wrapper.addClass("asf-hidden");

    $("#DateSearchFrom" + index).data("kendoDatePicker").element.removeClass("asf-hidden");
    $("#DateSearchTo" + index).data("kendoDatePicker").element.removeClass("asf-hidden");
    $("#DateTimeSearchFrom" + index).data("kendoDateTimePicker").element.removeClass("asf-hidden");
    $("#DateTimeSearchTo" + index).data("kendoDateTimePicker").element.removeClass("asf-hidden");
    $($("#SpinSearchFrom" + index).data("kendoNumericTextBox").wrapper.find('input')).removeClass("asf-hidden");
    $($("#SpinSearchTo" + index).data("kendoNumericTextBox").wrapper.find('input')).removeClass("asf-hidden");


    if (hideAll)
    {
        $("#DateSearchFrom" + index).data("kendoDatePicker").element.removeClass("asf-hidden");
        $("#DateSearchTo" + index).data("kendoDatePicker").element.removeClass("asf-hidden");
        $("#TxtSearchFrom" + index).addClass("asf-hidden");
        $("#TxtSearchTo" + index).addClass("asf-hidden");
        $("#DateTimeSearchFrom" + index).data("kendoDateTimePicker").wrapper.addClass("asf-hidden");
        $("#DateTimeSearchTo" + index).data("kendoDateTimePicker").wrapper.addClass("asf-hidden");
        $("#SpinSearchFrom" + index).data("kendoNumericTextBox").wrapper.addClass("asf-hidden");
        $("#SpinSearchTo" + index).data("kendoNumericTextBox").wrapper.addClass("asf-hidden");
        return;
    }

    if (value && (value.DataType == 9)) {
        $("#DateSearchFrom" + index).data("kendoDatePicker").wrapper.removeClass("asf-hidden");
        $("#DateSearchTo" + index).data("kendoDatePicker").wrapper.removeClass("asf-hidden");
        
        $("#TxtSearchFrom" + index).addClass("asf-hidden");
        $("#TxtSearchTo" + index).addClass("asf-hidden");
        $("#DateTimeSearchFrom" + index).data("kendoDateTimePicker").wrapper.addClass("asf-hidden");
        $("#DateTimeSearchTo" + index).data("kendoDateTimePicker").wrapper.addClass("asf-hidden");
        $("#SpinSearchFrom" + index).data("kendoNumericTextBox").wrapper.addClass("asf-hidden");
        $("#SpinSearchTo" + index).data("kendoNumericTextBox").wrapper.addClass("asf-hidden");
    }
    if (value && value.DataType == 13) {
        $("#DateTimeSearchFrom" + index).data("kendoDateTimePicker").wrapper.removeClass("asf-hidden");
        $("#DateTimeSearchTo" + index).data("kendoDateTimePicker").wrapper.removeClass("asf-hidden");

        $("#TxtSearchFrom" + index).addClass("asf-hidden");
        $("#TxtSearchTo" + index).addClass("asf-hidden");
        $("#DateSearchFrom" + index).data("kendoDatePicker").element.removeClass("asf-hidden");
        $("#DateSearchTo" + index).data("kendoDatePicker").element.removeClass("asf-hidden");
        $($("#SpinSearchFrom" + index).data("kendoNumericTextBox").wrapper.find('input')).removeClass("asf-hidden");
        $($("#SpinSearchTo" + index).data("kendoNumericTextBox").wrapper.find('input')).removeClass("asf-hidden");
    }

    if (value && (value.DataType == 5 || value.DataType == 8 || (value.DataType == 6 && value.Type != 2))) {
        $("#SpinSearchFrom" + index).data("kendoNumericTextBox").wrapper.removeClass("asf-hidden");
        $("#SpinSearchTo" + index).data("kendoNumericTextBox").wrapper.removeClass("asf-hidden");

        $("#TxtSearchFrom" + index).addClass("asf-hidden");
        $("#TxtSearchTo" + index).addClass("asf-hidden");
        $("#DateSearchFrom" + index).data("kendoDatePicker").element.removeClass("asf-hidden");
        $("#DateSearchTo" + index).data("kendoDatePicker").element.removeClass("asf-hidden");
        $("#DateTimeSearchFrom" + index).data("kendoDateTimePicker").element.removeClass("asf-hidden");
        $("#DateTimeSearchTo" + index).data("kendoDateTimePicker").element.removeClass("asf-hidden");
    }
}

function cbCompare_Change(e) {
    var item = e.sender.value();
    var id = e.sender.element[0].id;
    var index = id.replace('CBCompare', '');
    var CBSearch = $("#CBSearch" + index).data("kendoComboBox");

    if (item == "[]" || item == "][") {
        $("#DateSearch" + index).data("kendoDatePicker").wrapper.addClass("asf-hidden");
        $("#TxtSearch" + index).hide();
        $("#DateTimeSearch" + index).data("kendoDateTimePicker").wrapper.addClass("asf-hidden");
        $("#CBCheck" + index).data("kendoComboBox").wrapper.addClass("asf-hidden");
        $("#SpinSearch" + index).data("kendoNumericTextBox").wrapper.addClass("asf-hidden");

        if (CBSearch) {
            hideShowSearchBetween(index, CBSearch, false);
        }
    }
    else {
        if (CBSearch) {
            hideShowSearch(index, CBSearch)
            hideShowSearchBetween(index, CBSearch, true);
        }
    }
}

function getCompareSearch() {
    var index = this.url.split('?')[1].split('=')[1];
    var cbb = $("#CBSearch" + index).data("kendoComboBox");
    var type = 1;
    var typeControl = 1;
    if (cbb)
    {
        var vlCbb = cbb.dataItem(cbb.select());
        if (vlCbb)
        {
            type = vlCbb.DataType;
            typeControl = vlCbb.Type;
        }
    }

    return { type: type, typeControl : typeControl };
}