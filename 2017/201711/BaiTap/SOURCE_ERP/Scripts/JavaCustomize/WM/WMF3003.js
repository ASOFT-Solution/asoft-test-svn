﻿//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     14/02/2017      Văn Tài          Tạo mới
//####################################################################

var txtObjectName = "txtObjectName";
var txtWareHouseName = "txtWareHouseName";
var txtFromInventoryName = "txtFromInventoryName";
var txtToInventoryName = "txtToInventoryName";

$(document).ready(function () {
    var id = $("#sysScreenID").val();

    var OrtherInfo = "<fieldset id='HRM'><legend><label>" + $("#GroupTitle1").val() + "</label></legend></fieldset>";
    var tableOO = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO'> </table> </div> </div>";
    var tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    var filter = "<fieldset id='HRMfilter'><legend><label>" + $("#GroupTitle2").val() + "</label></legend></fieldset>";

    var mainReportTab = $("#MainReportTab");
    mainReportTab.prepend(filter);
    mainReportTab.prepend(OrtherInfo);

    //$("#FormReportFilter").prepend(filter);
    //$("#FormReportFilter").prepend(OrtherInfo);
    $("#HRM").prepend(tableOO);
    $("#HRMfilter").append(tableOO1);
    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));
    $("#TableOO1").append($(".ObjectID"));
    $("#TableOO1").append($(".WareHouseID"));
    $("#TableOO1").append($(".FromInventoryID"));
    $("#TableOO1").append($(".ToInventoryID"));

    $("#HRMfilter").append($("#PeriodFilter1"));
    $("#HRMfilter").append($("#PeriodFilter2"));

    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");
    $("#ObjectID").attr("readonly", "readonly");

    $('#btnExport').css('display', 'none');
    $('#btnPrintBD').css('display', 'none');

    AppendSubTextBox();

    WMF3003.SettingObjectDetails();

    $("#popupInnerIframe").kendoWindow({
        activate: function () {

            WMF3003.cboWareHouse = $("#" + WMF3003.WAREHOUSEID).data("kendoComboBox");
            $("#" + WMF3003.WAREHOUSEID).on('change', warehouse_cbo_onchange);

            WMF3003.cboFromInventory = $("#" + WMF3003.FROMINVENTORYID).data("kendoComboBox");
            $("#" + WMF3003.FROMINVENTORYID).on('change', frominventory_cbo_onchange);

            WMF3003.cboToInventory = $("#" + WMF3003.TOINVENTORYID).data("kendoComboBox");
            $("#" + WMF3003.TOINVENTORYID).on('change', toinventory_cbo_onchange);

            WMF3003.cboFromAna01 = $("#FromAna01ID").data("kendoComboBox");
            WMF3003.cboFromAna02 = $("#FromAna02ID").data("kendoComboBox");
            WMF3003.cboFromAna03 = $("#FromAna03ID").data("kendoComboBox");
            WMF3003.cboFromAna04 = $("#FromAna04ID").data("kendoComboBox");
            WMF3003.cboFromAna05 = $("#FromAna05ID").data("kendoComboBox");
            WMF3003.cboFromAna06 = $("#FromAna06ID").data("kendoComboBox");
            WMF3003.cboFromAna07 = $("#FromAna07ID").data("kendoComboBox");
            WMF3003.cboFromAna08 = $("#FromAna08ID").data("kendoComboBox");
            WMF3003.cboFromAna09 = $("#FromAna09ID").data("kendoComboBox");
            WMF3003.cboFromAna10 = $("#FromAna10ID").data("kendoComboBox");

            WMF3003.cboToAna01 = $("#ToAna01ID").data("kendoComboBox");
            WMF3003.cboToAna02 = $("#ToAna02ID").data("kendoComboBox");
            WMF3003.cboToAna03 = $("#ToAna03ID").data("kendoComboBox");
            WMF3003.cboToAna04 = $("#ToAna04ID").data("kendoComboBox");
            WMF3003.cboToAna05 = $("#ToAna05ID").data("kendoComboBox");
            WMF3003.cboToAna06 = $("#ToAna06ID").data("kendoComboBox");
            WMF3003.cboToAna07 = $("#ToAna07ID").data("kendoComboBox");
            WMF3003.cboToAna08 = $("#ToAna08ID").data("kendoComboBox");
            WMF3003.cboToAna09 = $("#ToAna09ID").data("kendoComboBox");
            WMF3003.cboToAna10 = $("#ToAna10ID").data("kendoComboBox");


            WMF3003.SettingAnalystCombos();
            WMF3003.SettingInit();
        }
    });
})

function AppendSubTextBox() {
    var object_current = $("#" + WMF3003.OBJECTID);
    var warehouse_parent = $("#" + WMF3003.WAREHOUSEID).parent();
    var frominventory_parent = $("#" + WMF3003.FROMINVENTORYID).parent();
    var toinventory_parent = $("#" + WMF3003.TOINVENTORYID).parent();

    var textbox_width = "62%";
    var combo_width = "35%";
    // object textbox
    if (object_current) {
        object_current.css("width", combo_width);
        var object_textbox = $('<input id="' + txtObjectName + '" class="asf-textbox" readonly initvalue="" maxlength="" message="" name="' + txtObjectName + '" regular="" style=" width: ' + textbox_width + '; height:22px; margin-left: 3%" type="text" value="" data-val-regex-pattern="" data-val-regex="">');

        object_textbox.insertAfter(object_current);
    }
    // warehouseid combobox
    if (warehouse_parent) {
        warehouse_parent.css("width", combo_width);
        var warehouse_textbox = $('<input id="' + txtWareHouseName + '" class="asf-textbox" readonly initvalue="" maxlength="" message="" name="' + txtWareHouseName + '" regular="" style=" width: ' + textbox_width + '; height:22px; margin-left: 3%" type="text" value="" data-val-regex-pattern="" data-val-regex="">');
        warehouse_textbox.insertAfter(warehouse_parent);
    }
    // frominventoryid combobox
    if (frominventory_parent) {
        frominventory_parent.css("width", combo_width);
        var frominventory_textbox = $('<input id="' + txtFromInventoryName + '" class="asf-textbox" readonly initvalue="" maxlength="" message="" name="' + txtFromInventoryName + '" regular="" style=" width: ' + textbox_width + '; height:22px; margin-left: 3%" type="text" value="" data-val-regex-pattern="" data-val-regex="">');
        frominventory_textbox.insertAfter(frominventory_parent);
    }
    // toinventoryid combobox
    if (toinventory_parent) {
        toinventory_parent.css("width", combo_width);
        var toinventory_textbox = $('<input id="' + txtToInventoryName + '" class="asf-textbox" readonly initvalue="" maxlength="" message="" name="' + txtToInventoryName + '" regular="" style=" width: ' + textbox_width + '; height:22px; margin-left: 3%" type="text" value="" data-val-regex-pattern="" data-val-regex="">');
        toinventory_textbox.insertAfter(toinventory_parent);
    }
}

function warehouse_cbo_onchange() {
    var selected_item = WMF3003.cboWareHouse.dataItem(WMF3003.cboWareHouse.select());
    if (selected_item) {
        var WareHouseName = selected_item.WareHouseName;
        $("#" + txtWareHouseName).val(WareHouseName);
    }
    else {
        $("#" + txtWarehouseName).val("");
    }
}

function frominventory_cbo_onchange() {
    var selected_item = WMF3003.cboFromInventory.dataItem(WMF3003.cboFromInventory.select());
    if (selected_item) {
        var InventoryName = selected_item.InventoryName;
        $("#" + txtFromInventoryName).val(InventoryName);
    }
    else {
        $("#" + txtFromInventoryName).val(InventoryName);
    }
}

function toinventory_cbo_onchange() {
    var selected_item = WMF3003.cboToInventory.dataItem(WMF3003.cboToInventory.select());
    if (selected_item) {
        var InventoryName = selected_item.InventoryName;
        $("#" + txtToInventoryName).val(InventoryName);
    }
    else {
        $("#" + txtToInventoryName).val(InventoryName);
    }
}

function AppendSubTextBox() {
    var object_current = $("#" + WMF3003.OBJECTID);
    var warehouse_parent = $("#" + WMF3003.WAREHOUSEID).parent();
    var frominventory_parent = $("#" + WMF3003.FROMINVENTORYID).parent();
    var toinventory_parent = $("#" + WMF3003.TOINVENTORYID).parent();

    var textbox_width = "62%";
    var combo_width = "35%";
    // object textbox
    if (object_current) {
        object_current.css("width", combo_width);
        var object_textbox = $('<input id="' + txtObjectName + '" class="asf-textbox" readonly initvalue="" maxlength="" message="" name="' + txtObjectName + '" regular="" style=" width: ' + textbox_width + '; height:22px; margin-left: 3%" type="text" value="" data-val-regex-pattern="" data-val-regex="">');

        object_textbox.insertAfter(object_current);
    }
    // warehouseid combobox
    if (warehouse_parent) {
        warehouse_parent.css("width", combo_width);
        var warehouse_textbox = $('<input id="' + txtWareHouseName + '" class="asf-textbox" readonly initvalue="" maxlength="" message="" name="' + txtWareHouseName + '" regular="" style=" width: ' + textbox_width + '; height:22px; margin-left: 3%" type="text" value="" data-val-regex-pattern="" data-val-regex="">');
        warehouse_textbox.insertAfter(warehouse_parent);
    }
    // frominventoryid combobox
    if (frominventory_parent) {
        frominventory_parent.css("width", combo_width);
        var frominventory_textbox = $('<input id="' + txtFromInventoryName + '" class="asf-textbox" readonly initvalue="" maxlength="" message="" name="' + txtFromInventoryName + '" regular="" style=" width: ' + textbox_width + '; height:22px; margin-left: 3%" type="text" value="" data-val-regex-pattern="" data-val-regex="">');
        frominventory_textbox.insertAfter(frominventory_parent);
    }
    // toinventoryid combobox
    if (toinventory_parent) {
        toinventory_parent.css("width", combo_width);
        var toinventory_textbox = $('<input id="' + txtToInventoryName + '" class="asf-textbox" readonly initvalue="" maxlength="" message="" name="' + txtToInventoryName + '" regular="" style=" width: ' + textbox_width + '; height:22px; margin-left: 3%" type="text" value="" data-val-regex-pattern="" data-val-regex="">');
        toinventory_textbox.insertAfter(toinventory_parent);
    }
}

WMF3003 = new function () {
    // Properties
    this.OBJECTID = "ObjectID";
    this.OBJECTNAME = "ObjectName";
    this.WAREHOUSEID = "WareHouseID";
    this.FROMINVENTORYID = "FromInventoryID";
    this.TOINVENTORYID = "ToInventoryID";

    this.ANACOMBO_VALUEFIELD = "AnaID";

    this.AnalystCheck = [];

    this.cboWareHouse = null;
    this.cboFromInventory = null;
    this.cboToInventory = null;

    this.cboFromAna01 = null;
    this.cboFromAna02 = null;
    this.cboFromAna03 = null;
    this.cboFromAna04 = null;
    this.cboFromAna05 = null;
    this.cboFromAna06 = null;
    this.cboFromAna07 = null;
    this.cboFromAna08 = null;
    this.cboFromAna09 = null;
    this.cboFromAna10 = null;

    this.cboToAna01 = null;
    this.cboToAna02 = null;
    this.cboToAna03 = null;
    this.cboToAna04 = null;
    this.cboToAna05 = null;
    this.cboToAna06 = null;
    this.cboToAna07 = null;
    this.cboToAna08 = null;
    this.cboToAna09 = null;
    this.cboToAna10 = null;

    this.ERROR_CLASS = "asf-focus-input-error";
    // Properties - END

    // Setting Init
    this.SettingInit = function () {
        // Xử lý combo Kho hàng
        var warehouse_data = this.cboWareHouse.dataSource._data;
        if (warehouse_data.length > 0) {
            this.cboWareHouse.select(0);
            var selected_item = this.cboWareHouse.dataItem(this.cboWareHouse.select());
            if (selected_item) {
                $("#" + txtWareHouseName).val(selected_item.WareHouseName);
            }
        }

        // Xử lý combo Từ mặt hàng
        var frominvent_data = this.cboFromInventory.dataSource._data;
        if (frominvent_data.length > 0) {
            this.cboFromInventory.select(0);
            var selected_item = this.cboFromInventory.dataItem(this.cboFromInventory.select());
            if (selected_item) {
                $("#" + txtFromInventoryName).val(selected_item.InventoryName);
            }
        }

        // Xử lý combo Đến mặt hàng
        var toinvent_data = this.cboToInventory.dataSource._data;
        if (toinvent_data.length > 0) {
            var last_index = toinvent_data.length - 1;
            this.cboToInventory.select(last_index);
            var selected_item = this.cboToInventory.dataItem(this.cboToInventory.select());
            if (selected_item) {
                $("#" + txtToInventoryName).val(selected_item.InventoryName);
            }
        }
    }
    // Setting Init - END

    // Show Message
    this.ShowMessageError = function (message_id) {
        ASOFT.form.displayMessageBox('#FormReportFilter', [ASOFT.helper.getMessage(message_id)], null);
    }

    this.ShowMessageErrors = function (message_array) {
        ASOFT.form.displayMessageBox('#FormReportFilter', message_array, null);
    }
    // Show Message - END    

    // General Methods
    this.SetTextValue = function (field_name, value) {
        var TextBox = $("#" + field_name);
        if (TextBox) {
            TextBox.val(value);
        }
    }

    this.GetTextValue = function (field_name) {
        var TextBox = $("#" + field_name);
        if (TextBox) {
            return TextBox.val();
        }
        return "";
    }

    this.GetWareHouseID = function () {
        var selected_item = WMF3003.cboWareHouse.dataItem(WMF3003.cboWareHouse.select());
        if (selected_item)
            return (selected_item.WareHouseID) ? selected_item.WareHouseID : "";
        else
            return "";
    }

    this.GetFromInventID = function () {
        var selected_item = WMF3003.cboFromInventory.dataItem(WMF3003.cboFromInventory.select());
        if (selected_item)
            return (selected_item.InventoryID) ? selected_item.InventoryID : "";
        else
            return "";
    }

    this.GetToInventID = function () {
        var selected_item = WMF3003.cboToInventory.dataItem(WMF3003.cboToInventory.select());
        if (selected_item)
            return (selected_item.InventoryID) ? selected_item.InventoryID : "";
        else
            return "";
    }

    this.SettingObjectDetails = function () {
        var url = "/WM/WMF3000/GetObjectDetails";
        var data = [];

        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (typeof (result) != "undefined") {
                WMF3003.SetTextValue(WMF3003.OBJECTID, result[WMF3003.OBJECTID]);
                WMF3003.SetTextValue(txtObjectName, result[WMF3003.OBJECTNAME]);
            }
        });
    }

    this.SettingAnalystCombos = function () {
        var url = "/WM/WMF3000/GetAnalystList";

        var data = [];
        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (typeof (result) != "undefined") {
                if (result.length > 0) {
                    WMF3003.AnalystCheck = [];
                    WMF3003.AnalystCheck = result;
                    for (var i = 0; i < result.length; i++) {
                        var TypeID = result[i].TypeID;
                        var isUsed = result[i].IsUsed;
                        var readonly = (isUsed == 0) ? true : false;
                        WMF3003.SetReadOnlyComboBox(TypeID, readonly);
                    }
                }
            }
        });
    }

    this.SetReadOnlyComboBox = function (combo_name, readonly) {
        switch (combo_name) {
            case "A01":
                {
                    if (readonly) {
                        WMF3003.cboFromAna01.readonly();
                        WMF3003.cboToAna01.readonly();
                    }
                }
                break;
            case "A02":
                {
                    if (readonly) {
                        WMF3003.cboFromAna02.readonly();
                        WMF3003.cboToAna02.readonly();
                    }
                }
                break;
            case "A03":
                {
                    if (readonly) {
                        WMF3003.cboFromAna03.readonly();
                        WMF3003.cboToAna03.readonly();
                    }
                }
                break;
            case "A04":
                {
                    if (readonly) {
                        WMF3003.cboFromAna04.readonly();
                        WMF3003.cboToAna04.readonly();
                    }
                }
                break;
            case "A05":
                {
                    if (readonly) {
                        WMF3003.cboFromAna05.readonly();
                        WMF3003.cboToAna05.readonly();
                    }
                }
                break;
            case "A06":
                {
                    if (readonly) {
                        WMF3003.cboFromAna06.readonly();
                        WMF3003.cboToAna06.readonly();
                    }
                }
                break;
            case "A07":
                {
                    if (readonly) {
                        WMF3003.cboFromAna07.readonly();
                        WMF3003.cboToAna07.readonly();
                    }
                }
                break;
            case "A08":
                {
                    if (readonly) {
                        WMF3003.cboFromAna08.readonly();
                        WMF3003.cboToAna08.readonly();
                    }
                }
                break;
            case "A09":
                {
                    if (readonly) {
                        WMF3003.cboFromAna09.readonly();
                        WMF3003.cboToAna09.readonly();
                    }
                }
                break;
            case "A10":
                {
                    if (readonly) {
                        WMF3003.cboFromAna10.readonly();
                        WMF3003.cboToAna10.readonly();
                    }
                }
                break;
        }
    }
    // General Methods - END

    // Error Processing
    this.AddTextBoxError = function (field_name) {
        var target = $("#" + field_name);
        if (target) {
            if (!target.hasClass(this.ERROR_CLASS)) {
                target.addClass(this.ERROR_CLASS);
            }
        }
    }

    this.ClearTextBoxError = function (field_name) {
        var target = $("#" + field_name);
        if (target) {
            if (target.hasClass(this.ERROR_CLASS)) {
                target.removeClass(this.ERROR_CLASS);
            }
        }
    }

    this.AddWareHouseIDError = function () {
        var WareHouse = $("#" + this.WAREHOUSEID);
        if (!WareHouse.parent().hasClass('asf-focus-input-error')) {
            WareHouse.parent().addClass('asf-focus-input-error');
        }
    }

    this.ClearWareHouseIDError = function () {
        var WareHouse = $("#" + this.WAREHOUSEID);
        if (WareHouse) {
            if (WareHouse.parent().hasClass('asf-focus-input-error')) {
                WareHouse.parent().removeClass('asf-focus-input-error');
            }
        }
    }

    this.AddFromInventIDError = function () {
        var FromInvent = $("#" + this.FROMINVENTORYID);
        if (!FromInvent.parent().hasClass('asf-focus-input-error')) {
            FromInvent.parent().addClass('asf-focus-input-error');
        }
    }

    this.ClearFromInventIDError = function () {
        var FromInvent = $("#" + this.FROMINVENTORYID);
        if (FromInvent) {
            if (FromInvent.parent().hasClass('asf-focus-input-error')) {
                FromInvent.parent().removeClass('asf-focus-input-error');
            }
        }
    }

    this.AddToInventIDError = function () {
        var ToInvent = $("#" + this.TOINVENTORYID);
        if (!ToInvent.parent().hasClass('asf-focus-input-error')) {
            ToInvent.parent().addClass('asf-focus-input-error');
        }
    }

    this.ClearToInventIDError = function () {
        var ToInvent = $("#" + this.TOINVENTORYID);
        if (ToInvent) {
            if (ToInvent.parent().hasClass('asf-focus-input-error')) {
                ToInvent.parent().removeClass('asf-focus-input-error');
            }
        }
    }
    // Error Processing - END
}

function CustomerCheck() {
    ASOFT.form.clearMessageBox();

    var Invalid_Data = false;

    // Không có dữ liệu đối tượng
    var no_objectdetails = false;
    // Không chọn kho hàng
    var null_warehouse = false;
    // Không chọn Từ mặt hàng
    var null_frominvent = false;
    // Không chọn Đến mặt hàng
    var null_toinvent = false;
    // Không cho các analyst combo chọn sai
    var wrong_selection = false;

    //if (WMF3003.GetTextValue(WMF3003.OBJECTID) == "") {
    //    no_objectdetails = true;
    //    WMF3003.AddTextBoxError(WMF3003.OBJECTID);
    //}
    //else {
    //    WMF3003.ClearTextBoxError(WMF3003.OBJECTID);
    //}

    if (WMF3003.GetWareHouseID() == "") {
        null_warehouse = true;
        WMF3003.AddWareHouseIDError();
    } else {
        WMF3003.ClearWareHouseIDError();
    }

    if (WMF3003.GetFromInventID() == "") {
        null_frominvent = true;
        WMF3003.AddFromInventIDError();
    }
    else {
        WMF3003.ClearFromInventIDError();
    }

    if (WMF3003.GetToInventID() == "") {
        null_toinvent = true;
        WMF3003.AddToInventIDError();
    }
    else {
        WMF3003.ClearToInventIDError();
    }

    // Kiểm tra các analyst combo 
    for (var i = 0; i < WMF3003.AnalystCheck.length; i++) {
        var typeID = WMF3003.AnalystCheck[i].TypeID;
        var isUsed = WMF3003.AnalystCheck[i].IsUsed;
        if (isUsed == 1) {
            switch (typeID) {
                case "A01":
                    {
                        var FromSelected = WMF3003.cboFromAna01.select();
                        var ToSelected = WMF3003.cboToAna01.select();
                        var FromCurrentText = WMF3003.cboFromAna01.value();
                        var ToCurrentText = WMF3003.cboToAna01.value();
                        var FromCB = $("#FromAna01ID");
                        var ToCB = $("#ToAna01ID");

                        if (FromSelected == -1 && FromCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().addClass('asf-focus-input-error');
                            }
                        }
                        else {
                            if (FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().removeClass('asf-focus-input-error');
                            }
                        }

                        if (ToSelected == -1 && ToCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().addClass('asf-focus-input-error');
                            }
                        } else {
                            if (ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().removeClass('asf-focus-input-error');
                            }
                        }
                    }
                    break;
                case "A02":
                    {
                        var FromSelected = WMF3003.cboFromAna02.select();
                        var ToSelected = WMF3003.cboToAna02.select();
                        var FromCurrentText = WMF3003.cboFromAna02.value();
                        var ToCurrentText = WMF3003.cboToAna02.value();
                        var FromCB = $("#FromAna02ID");
                        var ToCB = $("#ToAna02ID");

                        if (FromSelected == -1 && FromCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().addClass('asf-focus-input-error');
                            }
                        }
                        else {
                            if (FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().removeClass('asf-focus-input-error');
                            }
                        }

                        if (ToSelected == -1 && ToCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().addClass('asf-focus-input-error');
                            }
                        } else {
                            if (ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().removeClass('asf-focus-input-error');
                            }
                        }
                    }
                    break;
                case "A03":
                    {
                        var FromSelected = WMF3003.cboFromAna03.select();
                        var ToSelected = WMF3003.cboToAna03.select();
                        var FromCurrentText = WMF3003.cboFromAna03.value();
                        var ToCurrentText = WMF3003.cboToAna03.value();
                        var FromCB = $("#FromAna03ID");
                        var ToCB = $("#ToAna03ID");

                        if (FromSelected == -1 && FromCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().addClass('asf-focus-input-error');
                            }
                        }
                        else {
                            if (FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().removeClass('asf-focus-input-error');
                            }
                        }

                        if (ToSelected == -1 && ToCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().addClass('asf-focus-input-error');
                            }
                        } else {
                            if (ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().removeClass('asf-focus-input-error');
                            }
                        }
                    }
                    break;
                case "A04":
                    {
                        var FromSelected = WMF3003.cboFromAna04.select();
                        var ToSelected = WMF3003.cboToAna04.select();
                        var FromCurrentText = WMF3003.cboFromAna04.value();
                        var ToCurrentText = WMF3003.cboToAna04.value();
                        var FromCB = $("#FromAna04ID");
                        var ToCB = $("#ToAna04ID");

                        if (FromSelected == -1 && FromCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().addClass('asf-focus-input-error');
                            }
                        }
                        else {
                            if (FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().removeClass('asf-focus-input-error');
                            }
                        }

                        if (ToSelected == -1 && ToCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().addClass('asf-focus-input-error');
                            }
                        } else {
                            if (ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().removeClass('asf-focus-input-error');
                            }
                        }
                    }
                    break;
                case "A05":
                    {
                        var FromSelected = WMF3003.cboFromAna05.select();
                        var ToSelected = WMF3003.cboToAna05.select();
                        var FromCurrentText = WMF3003.cboFromAna05.value();
                        var ToCurrentText = WMF3003.cboToAna05.value();
                        var FromCB = $("#FromAna05ID");
                        var ToCB = $("#ToAna05ID");

                        if (FromSelected == -1 && FromCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().addClass('asf-focus-input-error');
                            }
                        }
                        else {
                            if (FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().removeClass('asf-focus-input-error');
                            }
                        }

                        if (ToSelected == -1 && ToCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().addClass('asf-focus-input-error');
                            }
                        } else {
                            if (ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().removeClass('asf-focus-input-error');
                            }
                        }
                    }
                    break;
                case "A06":
                    {
                        var FromSelected = WMF3003.cboFromAna06.select();
                        var ToSelected = WMF3003.cboToAna06.select();
                        var FromCurrentText = WMF3003.cboFromAna06.value();
                        var ToCurrentText = WMF3003.cboToAna06.value();
                        var FromCB = $("#FromAna06ID");
                        var ToCB = $("#ToAna06ID");

                        if (FromSelected == -1 && FromCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().addClass('asf-focus-input-error');
                            }
                        }
                        else {
                            if (FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().removeClass('asf-focus-input-error');
                            }
                        }

                        if (ToSelected == -1 && ToCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().addClass('asf-focus-input-error');
                            }
                        } else {
                            if (ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().removeClass('asf-focus-input-error');
                            }
                        }
                    }
                    break;
                case "A07":
                    {
                        var FromSelected = WMF3003.cboFromAna07.select();
                        var ToSelected = WMF3003.cboToAna07.select();
                        var FromCurrentText = WMF3003.cboFromAna07.value();
                        var ToCurrentText = WMF3003.cboToAna07.value();
                        var FromCB = $("#FromAna07ID");
                        var ToCB = $("#ToAna07ID");

                        if (FromSelected == -1 && FromCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().addClass('asf-focus-input-error');
                            }
                        }
                        else {
                            if (FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().removeClass('asf-focus-input-error');
                            }
                        }

                        if (ToSelected == -1 && ToCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().addClass('asf-focus-input-error');
                            }
                        } else {
                            if (ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().removeClass('asf-focus-input-error');
                            }
                        }
                    }
                    break;
                case "A08":
                    {
                        var FromSelected = WMF3003.cboFromAna08.select();
                        var ToSelected = WMF3003.cboToAna08.select();
                        var FromCurrentText = WMF3003.cboFromAna08.value();
                        var ToCurrentText = WMF3003.cboToAna08.value();
                        var FromCB = $("#FromAna08ID");
                        var ToCB = $("#ToAna08ID");

                        if (FromSelected == -1 && FromCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().addClass('asf-focus-input-error');
                            }
                        }
                        else {
                            if (FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().removeClass('asf-focus-input-error');
                            }
                        }

                        if (ToSelected == -1 && ToCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().addClass('asf-focus-input-error');
                            }
                        } else {
                            if (ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().removeClass('asf-focus-input-error');
                            }
                        }
                    }
                    break;
                case "A09":
                    {
                        var FromSelected = WMF3003.cboFromAna09.select();
                        var ToSelected = WMF3003.cboToAna09.select();
                        var FromCurrentText = WMF3003.cboFromAna09.value();
                        var ToCurrentText = WMF3003.cboToAna09.value();
                        var FromCB = $("#FromAna09ID");
                        var ToCB = $("#ToAna09ID");

                        if (FromSelected == -1 && FromCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().addClass('asf-focus-input-error');
                            }
                        }
                        else {
                            if (FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().removeClass('asf-focus-input-error');
                            }
                        }

                        if (ToSelected == -1 && ToCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().addClass('asf-focus-input-error');
                            }
                        } else {
                            if (ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().removeClass('asf-focus-input-error');
                            }
                        }
                    }
                    break;
                case "A10":
                    {
                        var FromSelected = WMF3003.cboFromAna10.select();
                        var ToSelected = WMF3003.cboToAna10.select();
                        var FromCurrentText = WMF3003.cboFromAna10.value();
                        var ToCurrentText = WMF3003.cboToAna10.value();
                        var FromCB = $("#FromAna10ID");
                        var ToCB = $("#ToAna10ID");

                        if (FromSelected == -1 && FromCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().addClass('asf-focus-input-error');
                            }
                        }
                        else {
                            if (FromCB.parent().hasClass('asf-focus-input-error')) {
                                FromCB.parent().removeClass('asf-focus-input-error');
                            }
                        }

                        if (ToSelected == -1 && ToCurrentText.length > 0) {
                            wrong_selection = true;
                            if (!ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().addClass('asf-focus-input-error');
                            }
                        } else {
                            if (ToCB.parent().hasClass('asf-focus-input-error')) {
                                ToCB.parent().removeClass('asf-focus-input-error');
                            }
                        }
                    }
                    break;
                default:
                    break;
            }
        }
    }

    var message_array = [];
    //if (no_objectdetails) {
    //    Invalid_Data = true;
    //    message_array.push(ASOFT.helper.getMessage("WFML000217"));
    //}
    if (null_warehouse) {
        Invalid_Data = true;
        message_array.push(ASOFT.helper.getMessage("WFML000005"));
    }
    if (null_frominvent) {
        Invalid_Data = true;
        message_array.push(ASOFT.helper.getMessage("WFML000003"));
    }
    if (null_toinvent) {
        Invalid_Data = true;
        message_array.push(ASOFT.helper.getMessage("WFML000004"));
    }
    if (wrong_selection) {
        Invalid_Data = true;
        message_array.push(ASOFT.helper.getMessage("WFML000222"));
    }

    if (Invalid_Data) {
        WMF3003.ShowMessageErrors(message_array);
    }

    return Invalid_Data;
}