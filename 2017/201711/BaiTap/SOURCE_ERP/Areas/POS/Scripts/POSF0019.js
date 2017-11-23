//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     21/04/2014      Chánh Thi         Tạo mới
//####################################################################
var posGrid = null;
var posViewModel = null;
var rowNumber = 0;
var rowNumber = 0;
var formStatus = null; // loại form
var isPrint = false;
$(document).ready(function () {
    // Load lưới tại màn hình POSF0019
    posGrid = $('#POSF0019Grid').data('kendoGrid');
    //viewmode
    createViewModel();

    installPeriod(true);

});

/**
* Xử lý sự kiện click vào nút kế thừa
*/
function voucherDetail_Click(apk) {
    var url = ''; // Chuỗi đường dẫn.
    // If APK exist
    if (apk != null) {
        url = kendo.format('/POS/POSF0019/POSF00191/{0}', apk);
    }
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(url, {});
    return false;
}

/**
* Đóng popup
*/
function popupClose(event) {
    ASOFT.asoftPopup.hideIframe();
}

/**
* Send data to with grid
*/
function sendDataFilter() {
    // If Viewmodel of POSF0019 is not null 
    if (posViewModel != null) {
        return posViewModel.dataFilter();
    }
    return null;
}

/**
* Tạo viewmodel
*/
function createViewModel() {

    posViewModel = kendo.observable({
        fromMonth: null,
        fromYear: null,
        toMonth: null,
        toYear: null,
        isDate: true,
        isSearch: false,
        defaultFromDate: $('#FromDateFilter').data('kendoDatePicker').value(),
        defaultToDate: $('#ToDateFilter').data('kendoDatePicker').value(),
        fromPeriodFilter: $('#FromPeriodFilter').data('kendoDropDownList').value(),
        //toPeriodFilter: $('#ToPeriodFilter').data('kendoComboBox').value(),
        search: function (e) {
            ASOFT.form.clearMessageBox();
            posGrid.dataSource.page(0);
        },
        dataFilter: function (e) {
            var dataFilter = ASOFT.helper.dataFormToJSON('FormFilter');
            dataFilter.fromMonth = this.fromMonth;
            dataFilter.fromYear = this.fromYear;
            dataFilter.toMonth = this.toMonth;
            dataFilter.toYear = this.toYear;

            return dataFilter;
        },
        reset: function (e) {
            $('#FormFilter input').val('');
            this.set('FromDateFilter', this.defaultFromDate);
            this.set('ToDateFilter', this.defaultToDate);
            this.set('FromPeriodFilter', this.fromPeriodFilter);
            this.set('ToPeriodFilter', this.toPeriodFilter);

            var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
            resetDropDown(multiComboBox);

            this.fromMonth = null;
            this.fromYear = null;
            this.toMonth = null;
            this.toYear = null;

            resetPeriod();
            this.isSearch = false;
            ASOFT.form.clearMessageBox();
            //posGrid.dataSource.page(0);
        },
        //Xóa trên dòng
        deleteMany: function (e) {
            var that = this;
            var args = [];
            var data = {};
            var records = ASOFT.asoftGrid.selectedRecords(posGrid);
            if (records.length == 0) {
                return false;
            };
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
                if (posGrid) { // Get all row select
                    for (var i = 0; i < records.length; i++) {
                        args.push(records[i].APK);
                    }
                }
                data['args'] = args;
                ASOFT.helper.postTypeJson('/POS/POSF0019/DeleteMany', data, function (result) {
                    if (result && result.Status == 0) { // Can not delete data
                        if (result.Message) { // Message isn't null
                            ASOFT.form.displayInfo('#FormFilter', ASOFT.helper.getMessage(result.Message));
                        }
                    } else {
                        //TODO: delete sussess
                        var errors = result.Data;
                        var msgs = [];
                        for (var j = 0; j < errors.length; j++) {
                            var error = errors[j];
                            var msg = ASOFT.helper.getMessage(result.Message);
                            if (error.Param) { // Nếu có param trong errors
                                msg = kendo.format(msg, error.Param);
                            }
                            msgs.push(msg);
                        }
                        //show message
                        if (msgs.length > 0) {
                            ASOFT.form.displayWarning('#FormFilter', msgs);
                        }
                    }
                    posGrid.dataSource.page(0);
                });
            });
        }

    });
    kendo.bind($('#FormFilter'), posViewModel);
}

/**
* Refresh grid
*/
function refreshGrid(event) {
    posGrid.dataSource.page(0);
}

/**
* delete many apk
*/
function btnDelete_Click(e) {
    posViewModel.deleteMany(e);
    return false;
}

/**
* add detail popup
*/
function addVoucher_Click(apk) {
    formStatus = 1;
    var data = {};
    data['args'] = {
        'FormStatus': formStatus,
    };
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe('/POS/POSF0019/POSF00191?FormStatus={0}'
       .format(formStatus, apk), data);
    return false;
}

/**
* Filter Data Search
*/
function search() {
    posViewModel.search(this);
}

/**
* Reset data
*/
function reset() {
    posViewModel.reset(this);
}

function btnExport_Click() {
    isSearch = false;
    var data = {};
    var args = sendData();
    var postUrl = $("#UrlPreExportData").val();
    data['args'] = args;


    ASOFT.helper.postTypeJson(postUrl, data, preExportSuccess);
}
function preExportSuccess(data) {
    if (data) {
        var urlExcel = $('#UrlExportReport').val();
        var urlPost = isPrint ? urlPrint : urlExcel;

        // Tạo path full
        var fullPath = urlPost + "?id=" + data.apk;
        window.location = fullPath;
    }
}

function sendData() {
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    datamaster['IsSearch'] = isSearch;
    return datamaster;
}