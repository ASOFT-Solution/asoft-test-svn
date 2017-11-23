//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/05/2014      Chánh Thi     Tạo mới
//####################################################################

var posGrid = null;
var posViewModel = null;
var rowNumber = 0;

$(document).ready(function () {
    var elementIDs = [
        'POSF0021BtnFilter',
        'POSF0021BtnClearFilter',
        'btnSave',
        'btnDelete',
        'btnExport',
        'btnInActive',
        'btnActive',
        'chkAll',
        'btnFilter'
    ];
    initAutoClearMessageBox(elementIDs);

    posGrid = $("#POSF0021Grid").data("kendoGrid");
    //viewmode
    createViewModel();

    installPeriod(true);
});

function initAutoClearMessageBox(elementIDs) {
    // Gán sự kiện cho các nút truyền vào
    if (elementIDs && typeof elementIDs == 'object') {
        elementIDs.forEach(function (id) {
            var element = $('#' + id);
            if (element) {
                element.on('click', function () {
                    ASOFT.form.clearMessageBox();
                });
            }
        });
    }

    // Gán sự kiện cho các nút của thanh phân trang
    var tagAnchors = $('div[data-role="pager"] a');
    console.log(tagAnchors[0]);
    $.each(tagAnchors, function (i, anchor) {
        console.log(i + '  ' + $(anchor).attr('class'));
        $(anchor).on('click', function () {
            if ($(anchor).attr('class').indexOf('k-state-disabled') == -1) {
                ASOFT.form.clearMessageBox();
            }

        });
    });

    // Gán sự kiện cho các link trên grid
    var gridLinks = $('#POSF0021Grid.k-widget div.k-grid-content table.k-selectable tbody tr td a');

    $.each(gridLinks, function (i, link) {
        var element = $(link);
        if (element) {
            element.on('click', function () {
                ASOFT.form.clearMessageBox();
            });
        }
    });
    // Gán sự kiện cho các checkbox trên grid
    var gridCheckBoxs = $('#POSF0021Grid.k-widget div.k-grid-content table.k-selectable tbody tr td input.asoftcheckbox');
    $.each(gridCheckBoxs, function (i, checkbox) {
        var element = $(checkbox);
        if (element) {
            element.on('click', function () {
                ASOFT.form.clearMessageBox();
            });
        }
    });
}

/**
* detail popup
*/
function voucherDetail_Click(apk) {
    var url = "";
    if (apk != null) {
        url = kendo.format("/POS/POSF0021/POSF0022/{0}", apk);
    }
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(url, {});
    return false;
}

/**
* add detail popup
*/
function addVoucher_Click(apk) {
    var url = "/POS/POSF0021/POSF0022";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(url, {});
    //location.reload();
}


/**
* Send data to with grid
*/
function sendDataFilter() {
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
        status: null,
        defaultFromDate: $("#FromDateFilter").data("kendoDatePicker").value(),
        defaultToDate: $("#ToDateFilter").data("kendoDatePicker").value(),
        fromPeriodFilter: $("#FromPeriodFilter").data("kendoDropDownList").value(),
        //toPeriodFilter: $("#ToPeriodFilter").data("kendoComboBox").value(),
        search: function (e) {
            ASOFT.form.clearMessageBox();
            posGrid.dataSource.page(0);
            //location.reload();
        },
        dataFilter: function (e) {
            var dataFilter = ASOFT.helper.dataFormToJSON("FormFilter");
            dataFilter.fromMonth = this.fromMonth;
            dataFilter.fromYear = this.fromYear;
            dataFilter.toMonth = this.toMonth;
            dataFilter.toYear = this.toYear;

            return dataFilter;
        },
        reset: function (e) {
            this.set('FromDateFilter', this.defaultFromDate);
            this.set('ToDateFilter', this.defaultToDate);
            this.set('FromPeriodFilter', this.fromPeriodFilter);
            this.set('ToPeriodFilter', this.toPeriodFilter);
            this.set('DivisionIDFilter', '');
            this.set('ShopIDFilter', '');
            this.set('VoucherNoFilter', '');
            this.set('VoucherDateFilter', '');
            this.set('EmployeeIDFilter', '');
            this.set('EmployeeNameFilter', '');
            this.set('RecipientNameFilter', '');
            this.set('StatusFilter', '');

            var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
            resetDropDown(multiComboBox);

            $('#StatusFilter').data('kendoComboBox').text('');
            $('#IsRefundFilter').data('kendoComboBox').text('');
            //resetComboBox(multiComboBox2);

            this.fromMonth = null;
            this.fromYear = null;
            this.toMonth = null;
            this.toYear = null;

            resetPeriod();
            //this.isSearch = false;
            ASOFT.form.clearMessageBox(); // dùng clear Message Box
            posGrid.dataSource.page(0);
            //location.reload();
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
                ASOFT.helper.postTypeJson('/POS/POSF0021/DeleteMany', data, function (result) {
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
                            var msg = ASOFT.helper.getMessage(result.Data[j].MessageID);
                            if (error.Params) { // Nếu có param trong errors
                                msg = kendo.format(msg, error.Params);
                            }
                            msgs.push(msg);
                        }
                        //show message
                        if (msgs.length > 0) {
                            //msg = kendo.format(msg, error.Params);
                            ASOFT.form.displayWarning('#FormFilter', msgs);
                        }
                    }
                    //that.search();
                    posGrid.dataSource.page(0);
                });
            });
        }

    });
    kendo.bind($("#FormFilter"), posViewModel);
}

/**
* Đóng popup
*/
function popupClose(event) {
    ASOFT.asoftPopup.hideIframe();
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