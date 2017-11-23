//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     14/02/2017      Văn Tài          Tạo mới
//####################################################################

var txtObjectName = "txtObjectName";

$(document).ready(function () {
    var id = $("#sysScreenID").val();

    var OrtherInfo = "<fieldset id='HRM'><legend><label>" + $("#GroupTitle1").val() + "</label></legend></fieldset>";
    var tableOO = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO'> </table> </div> </div>";
    var tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    var filter = "<fieldset id='HRMfilter'><legend><label>" + $("#GroupTitle2").val() + "</label></legend></fieldset>";
    $("#FormReportFilter").prepend(filter);
    $("#FormReportFilter").prepend(OrtherInfo);
    $("#HRM").prepend(tableOO);
    $("#HRMfilter").append(tableOO1);
    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));
    $("#TableOO1").append($(".ObjectID"));
    $("#TableOO1").append($(".ContractID"));

    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");

    $('#btnExport').css('display', 'none');
    $('#btnPrintBD').css('display', 'none');

    $("#ObjectID").attr("readonly", "readonly");

    AppendSubTextBox();

    WMF3001.SettingObjectDetails();

    $("#popupInnerIframe").kendoWindow({
        activate: function () {
            WMF3001.cboContractID = $("#" + WMF3001.CONTRACTID).data("kendoComboBox");
            WMF3001.SettingInit();
        }
    });
})

function AppendSubTextBox() {
    var object_current = $("#" + WMF3001.OBJECTID);

    var textbox_width = "62%";
    var combo_width = "35%";
    // object
    if (object_current) {
        object_current.css("width", combo_width);
        var object_textbox = $('<input id="' + txtObjectName + '" class="asf-textbox" readonly initvalue="" maxlength="" message="" name="' + txtObjectName + '" regular="" style=" width: ' + textbox_width + '; height:22px; margin-left: 3%" type="text" value="" data-val-regex-pattern="" data-val-regex="">');

        object_textbox.insertAfter(object_current);
    }
}

WMF3001 = new function () {

    this.OBJECTID = "ObjectID";
    this.OBJECTNAME = "ObjectName";
    this.CONTRACTID = "ContractID";

    this.cboContractID = null;

    // Setting Init
    this.SettingInit = function () {
        // Xử lý combo hợp đồng
        var contract_data = this.cboContractID.dataSource._data;
        if (contract_data.length > 0) {
            this.cboContractID.select(0);
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

    this.SettingObjectDetails = function () {
        var url = "/WM/WMF3000/GetObjectDetails";

        var data = [];

        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (typeof (result) != "undefined") {
                WMF3001.SetTextValue(WMF3001.OBJECTID, result[WMF3001.OBJECTID]);
                WMF3001.SetTextValue(txtObjectName, result[WMF3001.OBJECTNAME]);
            }
        });
    }

    this.GetContractID = function () {
        var selected_item = this.cboContractID.dataItem(this.cboContractID.select());
        if (selected_item) {
            return selected_item.ContractID;
        }
        return "";
    }

    this.AddContractIDError = function () {
        var Contract = $("#" + this.CONTRACTID);
        if (!Contract.parent().hasClass('asf-focus-input-error')) {
            Contract.parent().addClass('asf-focus-input-error');
        }
    }

    this.ClearContractIDError = function () {
        var Contract = $("#" + this.CONTRACTID);
        if (Contract) {
            if (Contract.parent().hasClass('asf-focus-input-error')) {
                Contract.parent().removeClass('asf-focus-input-error');
            }
        }
    }

    this.AddTextBoxError = function (field_name) {
        var target = $("#" + field_name);
        if (target) {
            if (!target.hasClass('asf-focus-input-error')) {
                target.addClass('asf-focus-input-error');
            }
        }
    }

    this.ClearTextBoxError = function (field_name) {
        var target = $("#" + field_name);
        if (target) {
            if (target.hasClass('asf-focus-input-error')) {
                target.removeClass('asf-focus-input-error');
            }
        }
    }
}

function CustomerCheck() {
    ASOFT.form.clearMessageBox();

    var Invalid_Data = false;

    // Không chọn hợp đồng
    var null_contract = false;
    // Không có dữ liệu đối tượng
    var no_objectdetails = false;

    if (WMF3001.GetTextValue(WMF3001.OBJECTID) == "") {
        no_objectdetails = true;
        WMF3001.AddTextBoxError(WMF3001.OBJECTID);
    }
    else {
        WMF3001.ClearTextBoxError(WMF3001.OBJECTID);
    }

    if (WMF3001.GetContractID() == "") {
        null_contract = true;
        WMF3001.AddContractIDError();
    }
    else {
        WMF3001.ClearContractIDError();
    }

    var message_array = [];
    if (no_objectdetails) {
        Invalid_Data = true;
        message_array.push(ASOFT.helper.getMessage("WFML000217"));
    }

    if (null_contract) {
        Invalid_Data = true;
        message_array.push(ASOFT.helper.getMessage("WFML000216"));
    }

    if (Invalid_Data) {
        WMF3001.ShowMessageErrors(message_array);
    }

    return Invalid_Data;
}